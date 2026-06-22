// Phase4 path B · LIF single-neuron step (HLS reference for PYNQ-Z2)
// Synthesize with Vitis HLS when toolchain available.
#include <ap_int.h>
#include <ap_fixed.h>

typedef ap_fixed<32, 16> data_t;  // Q16.16
typedef ap_int<64> acc_t;

static const data_t BETA = data_t(0.9);
static const data_t THRESH = data_t(1.0);

extern "C" {
void lif_step(
    data_t cur,
    data_t mem_in,
    ap_uint<1> *spk_out,
    data_t *mem_out)
{
#pragma HLS INTERFACE s_axilite port=cur bundle=CTRL
#pragma HLS INTERFACE s_axilite port=mem_in bundle=CTRL
#pragma HLS INTERFACE s_axilite port=spk_out bundle=CTRL
#pragma HLS INTERFACE s_axilite port=mem_out bundle=CTRL
#pragma HLS INTERFACE s_axilite return bundle=CTRL

    ap_uint<1> reset = (mem_in >= THRESH) ? 1 : 0;
    data_t mem = BETA * mem_in + cur;
    if (reset) {
        mem = mem - THRESH;
    }
    ap_uint<1> spk = (mem >= THRESH) ? 1 : 0;
    *spk_out = spk;
    *mem_out = mem;
}
}
