// openXC7 P&R probe: wraps fpga/rtl/lif_step.v behind the 5-pin blinky IO set
// so nextpnr-xilinx must place/route the real LIF datapath (CARRY4 + DSP48E1)
// instead of failing on 101 unconstrained PADs. Diagnostic only — not a delivery core.
`default_nettype none
module blinky (
    input  wire clk,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);
    reg [23:0]        r_tick = 24'd0;
    reg               r_start = 1'b0;
    reg               r_rst_n = 1'b0;
    reg signed [31:0] r_cur = 32'sd6553;
    reg signed [31:0] r_mem = 32'sd0;

    wire               w_done;
    wire               w_spk;
    wire signed [31:0] w_mem_out;

    lif_step u_lif (
        .clk        (clk),
        .rst_n      (r_rst_n),
        .start      (r_start),
        .cur_q16    (r_cur),
        .mem_in_q16 (r_mem),
        .done       (w_done),
        .spk_out    (w_spk),
        .mem_out_q16(w_mem_out)
    );

    always @(posedge clk) begin
        r_tick  <= r_tick + 24'd1;
        r_rst_n <= 1'b1;
        r_start <= (r_tick == 24'd0);
        if (w_done) begin
            r_mem <= w_mem_out;
            r_cur <= r_cur + 32'sd7;
        end
    end

    assign led0 = w_spk;
    assign led1 = w_done;
    assign led2 = w_mem_out[16];
    assign led3 = r_tick[23];
endmodule
`default_nettype wire
