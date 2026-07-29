// Minimal Zynq PL blinky for open-source xc7z020 try (陈正共)
// PS7 keep: required if loading while PS/Linux runs (PCAP)
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

    reg [27:0] r_count = 28'd0;
    always @(posedge clk)
        r_count <= r_count + 28'd1;

    assign {led3, led2, led1, led0} = r_count[27:24];
endmodule
