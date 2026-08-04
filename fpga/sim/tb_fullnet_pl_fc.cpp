// Verilator TB: F7 fullnet time-mux fc+LIF on PL (sim gold path)
#include <verilated.h>
#include "Vlinear_mac.h"
#include "Vlif_step.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>

static constexpr int FRAC = 16;
static constexpr int64_t SCALE = 1LL << FRAC;
static constexpr int64_t BETA_FP = (int64_t)(0.9 * SCALE + 0.5);
static constexpr int64_t TH_FP = SCALE;

static int64_t s32(uint32_t v) {
    v &= 0xFFFFFFFFu;
    return (v >= 0x80000000u) ? (int64_t)v - 0x100000000LL : (int64_t)v;
}

static int lif_pl(Vlif_step* lif, int64_t cur, int64_t mem) {
    lif->cur_q16 = (int32_t)cur;
    lif->mem_in_q16 = (int32_t)mem;
    lif->start = 1;
    lif->eval();
    lif->clk = 0;
    lif->eval();
    lif->clk = 1;
    lif->eval();
    lif->start = 0;
    for (int i = 0; i < 8; ++i) {
        lif->clk = 0;
        lif->eval();
        lif->clk = 1;
        lif->eval();
        if (lif->done) break;
    }
    return lif->spk_out ? 1 : 0;
}

static int64_t mac_pl(Vlinear_mac* mac, int dim, const int64_t* w, const int64_t* x, int64_t bias) {
    mac->dim = dim;
    mac->bias_q16 = (int32_t)bias;
    mac->start = 1;
    mac->w_valid = 0;
    mac->x_valid = 0;
    mac->eval();
    mac->clk = 0;
    mac->eval();
    mac->clk = 1;
    mac->eval();
    mac->start = 0;
    for (int i = 0; i < dim; ++i) {
        mac->w_data = (int32_t)w[i];
        mac->x_data = (int32_t)x[i];
        mac->w_valid = 1;
        mac->x_valid = 1;
        mac->eval();
        mac->clk = 0;
        mac->eval();
        mac->clk = 1;
        mac->eval();
        mac->w_valid = 0;
        mac->x_valid = 0;
    }
    for (int i = 0; i < 16; ++i) {
        mac->clk = 0;
        mac->eval();
        mac->clk = 1;
        mac->eval();
        if (mac->done) break;
    }
    return s32((uint32_t)mac->result_q16);
}

static int64_t linear_fp_host(const int64_t* w, const int64_t* x, int dim, int64_t bias) {
    int64_t acc = 0;
    for (int i = 0; i < dim; ++i) acc += w[i] * x[i];
    return (acc >> FRAC) + bias;
}

static int lif_fp_host(int64_t cur, int64_t mem, int64_t* mem_out) {
    int reset = (mem >= TH_FP) ? 1 : 0;
    mem = ((BETA_FP * mem) >> FRAC) + cur - (reset ? TH_FP : 0);
    int spk = (mem >= TH_FP) ? 1 : 0;
    *mem_out = mem;
    return spk;
}

extern "C" int fullnet_pl_fc_sim(
    int n_samples, int timesteps, int hidden, int n_out,
    const int64_t* w1, const int64_t* b1, int w1_rows, int w1_cols,
    const int64_t* w2, const int64_t* b2,
    const int64_t* xs, int x_dim,
    int* preds_out, int* host_preds_out)
{
    Vlinear_mac mac;
    Vlif_step lif;
    mac.clk = 0; mac.rst_n = 1;
    lif.clk = 0; lif.rst_n = 1;

    int match = 0;
    for (int si = 0; si < n_samples; ++si) {
        const int64_t* x = xs + si * x_dim;
        std::vector<int64_t> mem1(hidden, 0), mem2(n_out, 0);
        std::vector<int64_t> spk_sum(n_out, 0);
        for (int t = 0; t < timesteps; ++t) {
            std::vector<int64_t> cur1(hidden), spk1(hidden);
            for (int j = 0; j < hidden; ++j) {
                const int64_t* wrow = w1 + j * w1_cols;
                cur1[j] = mac_pl(&mac, w1_cols, wrow, x, b1[j]);
                int spk = lif_pl(&lif, cur1[j], mem1[j]);
                spk1[j] = spk * SCALE;
                lif_pl(&lif, cur1[j], mem1[j]); // update mem
                mem1[j] = s32((uint32_t)lif.mem_out_q16);
            }
            for (int k = 0; k < n_out; ++k) {
                const int64_t* wrow = w2 + k * hidden;
                int64_t cur2 = mac_pl(&mac, hidden, wrow, spk1.data(), b2[k]);
                int spk = lif_pl(&lif, cur2, mem2[k]);
                mem2[k] = s32((uint32_t)lif.mem_out_q16);
                spk_sum[k] += spk;
            }
        }
        int pred = 0;
        for (int k = 1; k < n_out; ++k)
            if (spk_sum[k] > spk_sum[pred]) pred = k;
        preds_out[si] = pred;

        // host gold
        mem1.assign(hidden, 0);
        mem2.assign(n_out, 0);
        spk_sum.assign(n_out, 0);
        for (int t = 0; t < timesteps; ++t) {
            std::vector<int64_t> cur1_h(hidden), spk1_h(hidden);
            for (int j = 0; j < hidden; ++j) {
                cur1_h[j] = linear_fp_host(w1 + j * w1_cols, x, w1_cols, b1[j]);
                int spk = lif_fp_host(cur1_h[j], mem1[j], &mem1[j]);
                spk1_h[j] = spk * SCALE;
            }
            for (int k = 0; k < n_out; ++k) {
                int64_t cur2 = linear_fp_host(w2 + k * hidden, spk1_h.data(), hidden, b2[k]);
                int spk = lif_fp_host(cur2, mem2[k], &mem2[k]);
                spk_sum[k] += spk;
            }
        }
        int hp = 0;
        for (int k = 1; k < n_out; ++k)
            if (spk_sum[k] > spk_sum[hp]) hp = k;
        host_preds_out[si] = hp;
        if (pred == hp) match++;
    }
    printf("FULLNET_PL_FC_SIM match=%d/%d\n", match, n_samples);
    return match;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    if (argc < 2) {
        fprintf(stderr, "usage: %s <n_samples>\n", argv[0]);
        return 1;
    }
    int n = atoi(argv[1]);
    // minimal self-test vectors (2x2 toy net)
    int64_t w1[] = {SCALE, 0, 0, SCALE};
    int64_t b1[] = {0, 0};
    int64_t w2[] = {SCALE, 0, 0, SCALE};
    int64_t b2[] = {0, 0};
    int64_t xs[] = {SCALE, SCALE, SCALE, SCALE};
    int preds[4], hpreds[4];
    int match = fullnet_pl_fc_sim(n > 4 ? 4 : n, 1, 2, 2, w1, b1, 2, 2, w2, b2, xs, 2, preds, hpreds);
    return (match >= n) ? 0 : 1;
}
