// openXC7 probe wrapping lif_step_open + PS7 keep（上板）— 陈正共
`default_nettype none
module blinky (
    input  wire clk,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);
    wire [3:0] w_fclk_unused;
    (* keep *) PS7 ps7_i (
        .FCLKCLK(w_fclk_unused)
    );

    reg [23:0]        r_tick;
    reg               r_start;
    reg               r_rst_n;
    reg signed [31:0] r_cur;
    reg signed [31:0] r_mem;

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

    reg [23:0]        tick_n;
    reg               start_n;
    reg               rst_n_n;
    reg signed [31:0] cur_n;
    reg signed [31:0] mem_n;

    always @* begin
        tick_n  = r_tick + 24'd1;
        rst_n_n = 1'b1;
        start_n = (r_tick[7:0] == 8'd0) ? 1'b1 : 1'b0;
        mem_n   = w_done ? w_mem_out : r_mem;
        cur_n   = w_done ? (r_cur + 32'sd7) : r_cur;
    end

    always @(posedge clk) begin
        r_tick  <= tick_n;
        r_rst_n <= rst_n_n;
        r_start <= start_n;
        r_mem   <= mem_n;
        r_cur   <= cur_n;
    end

    assign led0 = w_spk;
    assign led1 = w_done;
    assign led2 = w_mem_out[16];
    assign led3 = r_tick[23];
endmodule
`default_nettype wire
