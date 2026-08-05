// Verilator TB: fullnet_tick_scheduler · pred≡golden 路线骨架
// 对照：软件 golden 计数 fc1+LIF1+fc2+LIF2 神经元步 vs RTL tick_done / dma_beats
#include <verilated.h>
#include "Vfullnet_tick_scheduler.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>

static constexpr int HIDDEN = 256;
static constexpr int N_OUT = 10;
static constexpr int TIMESTEPS = 25;

static void tick_clk(Vfullnet_tick_scheduler* dut, int n = 1) {
    for (int i = 0; i < n; ++i) {
        dut->clk = 0;
        dut->eval();
        dut->clk = 1;
        dut->eval();
    }
}

static int run_one_tick(Vfullnet_tick_scheduler* dut, int feed_beats) {
    dut->tick_start = 1;
    tick_clk(dut);
    dut->tick_start = 0;

    int beats = 0;
    int timeout = 500000;
    while (!dut->tick_done && --timeout > 0) {
        if (dut->dma_w_ready && beats < feed_beats) {
            dut->dma_w_data = (int32_t)(beats + 1);
            dut->dma_x_data = (int32_t)(beats + 1);
            dut->dma_w_valid = 1;
            dut->dma_x_valid = 1;
            tick_clk(dut);
            dut->dma_w_valid = 0;
            dut->dma_x_valid = 0;
            beats++;
        } else {
            tick_clk(dut);
        }
    }
    return timeout > 0 ? 1 : 0;
}

extern "C" int fullnet_tick_scheduler_sim(int timesteps, int hidden, int n_out) {
    Vfullnet_tick_scheduler dut;
    dut.clk = 0;
    dut.rst_n = 0;
    dut.tick_start = 0;
    dut.dma_w_valid = 0;
    dut.dma_x_valid = 0;
    tick_clk(&dut, 4);
    dut.rst_n = 1;
    tick_clk(&dut, 2);

    const int golden_neurons_per_tick = hidden * 2 + n_out * 2; // fc1+lif1+fc2+lif2
    int ticks_ok = 0;

    for (int t = 0; t < timesteps; ++t) {
        int feed = hidden + n_out; // fc phases consume DMA beats
        if (!run_one_tick(&dut, feed)) {
            fprintf(stderr, "TIMEOUT tick %d\n", t);
            return 0;
        }
        if (dut.tick_count_out != (uint8_t)(t + 1)) {
            fprintf(stderr, "tick_count mismatch t=%d got=%u\n", t, dut.tick_count_out);
            return 0;
        }
        ticks_ok++;
    }

    // golden：25 tick 后应回 idle（tick_count==TIMESTEPS）
    if (dut.tick_count_out != (uint8_t)timesteps) {
        fprintf(stderr, "final tick_count=%u expect=%d\n", dut.tick_count_out, timesteps);
        return 0;
    }

    printf("TICK_SCHED_SIM ok ticks=%d neurons_per_tick=%d dma_beats_last=%u\n",
           ticks_ok, golden_neurons_per_tick, dut.dma_beats_consumed);
    return ticks_ok == timesteps ? 1 : 0;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    int ts = TIMESTEPS;
    int h = HIDDEN;
    int o = N_OUT;
    if (argc >= 2) ts = atoi(argv[1]);
    if (argc >= 3) h = atoi(argv[2]);
    if (argc >= 4) o = atoi(argv[3]);
    int ok = fullnet_tick_scheduler_sim(ts, h, o);
    return ok ? 0 : 1;
}
