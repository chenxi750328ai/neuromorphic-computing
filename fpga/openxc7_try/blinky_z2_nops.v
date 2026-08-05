// Minimal PL-only blinky for openXC7 smoke (no PS7) — 陈正共
`default_nettype none
module blinky (
    input  wire clk,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);
    reg [27:0] r_count = 28'd0;
    always @(posedge clk)
        r_count <= r_count + 28'd1;

    assign {led3, led2, led1, led0} = r_count[27:24];
endmodule
