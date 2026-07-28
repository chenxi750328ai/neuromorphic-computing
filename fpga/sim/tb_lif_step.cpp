// Verilator C++ TB for lif_step.v — open-source sim gate (陈正共 / F6 S0)
// Compare against Q16.16 golden (same as scripts/fpga_lif_rtl_sim.py)
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include "Vlif_step.h"
#include "verilated.h"

static const int32_t SCALE = 65536;
static const int32_t BETA_FP = 58982;  // round(0.9 * 65536)
static const int32_t TH_FP = 65536;

static void golden(int32_t cur, int32_t mem_in, int32_t* spk, int32_t* mem_out) {
    int reset = (mem_in >= TH_FP) ? 1 : 0;
    int64_t prod = (int64_t)BETA_FP * (int64_t)mem_in;
    int32_t mem_tmp = (int32_t)(prod >> 16) + cur - (reset ? TH_FP : 0);
    *spk = (mem_tmp >= TH_FP) ? 1 : 0;
    *mem_out = mem_tmp;
}

static void tick(Vlif_step* top) {
    top->clk = 0;
    top->eval();
    top->clk = 1;
    top->eval();
}

static int run_one(Vlif_step* top, int32_t cur, int32_t mem_in, int32_t* spk, int32_t* mem_out) {
    top->start = 0;
    top->cur_q16 = cur;
    top->mem_in_q16 = mem_in;
    tick(top);
    top->start = 1;
    tick(top);
    top->start = 0;
    // FSM: start sample -> st1 -> st2 done (need a few cycles)
    for (int i = 0; i < 8; i++) {
        tick(top);
        if (top->done) {
            *spk = top->spk_out ? 1 : 0;
            *mem_out = (int32_t)top->mem_out_q16;
            return 0;
        }
    }
    return 1;  // timeout
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    Vlif_step* top = new Vlif_step;

    top->rst_n = 0;
    top->start = 0;
    top->cur_q16 = 0;
    top->mem_in_q16 = 0;
    for (int i = 0; i < 4; i++) tick(top);
    top->rst_n = 1;
    tick(top);

    const double currents[] = {0.0, 0.0, 1.2, 0.0, 0.0, 1.1, 1.1, 0.0, 0.0, 1.05, 0.5, 2.0, -0.1};
    const int n = (int)(sizeof(currents) / sizeof(currents[0]));
    int32_t mem_g = 0, mem_r = 0;
    int mismatches = 0;

    for (int i = 0; i < n; i++) {
        int32_t cur_fp = (int32_t)llround(currents[i] * (double)SCALE);
        int32_t sg, mg, sr, mr;
        golden(cur_fp, mem_g, &sg, &mg);
        mem_g = mg;
        if (run_one(top, cur_fp, mem_r, &sr, &mr) != 0) {
            std::fprintf(stderr, "TIMEOUT i=%d\n", i);
            mismatches++;
            continue;
        }
        mem_r = mr;
        if (sg != sr || mg != mr) {
            std::fprintf(stderr, "MISMATCH i=%d cur=%g gold_spk=%d rtl_spk=%d gold_mem=%d rtl_mem=%d\n",
                         i, currents[i], sg, sr, mg, mr);
            mismatches++;
        }
    }

    delete top;
    if (mismatches) {
        std::printf("FAIL mismatches=%d\n", mismatches);
        return 1;
    }
    std::printf("PASS verilator lif_step n=%d mismatches=0\n", n);
    return 0;
}
