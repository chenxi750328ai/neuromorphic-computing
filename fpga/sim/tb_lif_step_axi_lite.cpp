// Verilator TB: minimal AXI-Lite write → start → poll STATUS — 陈正共 / F6 S0
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include "Vlif_step_axi_lite.h"
#include "verilated.h"

static void tick(Vlif_step_axi_lite* top) {
    top->s_axi_aclk = 0;
    top->eval();
    top->s_axi_aclk = 1;
    top->eval();
}

static void idle_bus(Vlif_step_axi_lite* top) {
    top->s_axi_awvalid = 0;
    top->s_axi_wvalid = 0;
    top->s_axi_arvalid = 0;
    top->s_axi_bready = 1;
    top->s_axi_rready = 1;
}

static void axi_write(Vlif_step_axi_lite* top, uint8_t addr, uint32_t data) {
    idle_bus(top);
    top->s_axi_awaddr = addr;
    top->s_axi_wdata = data;
    top->s_axi_wstrb = 0xF;
    top->s_axi_awvalid = 1;
    top->s_axi_wvalid = 1;
    // wait until ready asserted (next cycle after both valids)
    for (int i = 0; i < 32; i++) {
        tick(top);
        if (top->s_axi_awready && top->s_axi_wready) break;
    }
    // one more cycle with valids held: write commits (RTL samples when *ready & *valid)
    tick(top);
    top->s_axi_awvalid = 0;
    top->s_axi_wvalid = 0;
    for (int i = 0; i < 16; i++) {
        tick(top);
        if (top->s_axi_bvalid) break;
    }
    tick(top);
}

static uint32_t axi_read(Vlif_step_axi_lite* top, uint8_t addr) {
    idle_bus(top);
    top->s_axi_araddr = addr;
    top->s_axi_arvalid = 1;
    uint32_t data = 0;
    int got = 0;
    for (int i = 0; i < 32; i++) {
        tick(top);
        // RTL sets arready+rvalid+rdata in same cycle
        if (top->s_axi_rvalid) {
            data = top->s_axi_rdata;
            got = 1;
            break;
        }
    }
    top->s_axi_arvalid = 0;
    for (int i = 0; i < 8; i++) tick(top);
    if (!got) {
        std::fprintf(stderr, "axi_read timeout addr=0x%02x\n", addr);
    }
    return data;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    auto* top = new Vlif_step_axi_lite;

    top->s_axi_aresetn = 0;
    idle_bus(top);
    for (int i = 0; i < 4; i++) tick(top);
    top->s_axi_aresetn = 1;
    tick(top);

    // cur = 1.2 Q16.16 ≈ 78643, mem_in = 0 → after step mem≈1.2 → spk=1
    axi_write(top, 0x04, 78643u);
    axi_write(top, 0x08, 0u);
    axi_write(top, 0x00, 1u);  // start

    int done = 0, spk = 0;
    uint32_t mem_out = 0;
    for (int i = 0; i < 32; i++) {
        // free-run clocks for LIF FSM between polls
        for (int j = 0; j < 4; j++) tick(top);
        uint32_t st = axi_read(top, 0x0C);
        if (st & 1u) {
            done = 1;
            spk = (int)((st >> 1) & 1u);
            mem_out = axi_read(top, 0x10);
            break;
        }
    }

    delete top;
    if (!done) {
        std::printf("FAIL axi timeout waiting done\n");
        return 1;
    }
    if (spk != 1) {
        std::printf("FAIL expected spk=1 got %d mem_out=%u\n", spk, mem_out);
        return 1;
    }
    std::printf("PASS verilator lif_step_axi_lite spk=1 mem_out=%u\n", mem_out);
    return 0;
}
