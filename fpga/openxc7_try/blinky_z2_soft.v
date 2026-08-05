// Soft-logic blinky: no adder/CARRY4 — isolate nextpnr route bugs (陈正共)
`default_nettype none
module blinky (
    input  wire clk,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);
    // LFSR-ish shift so synth stays in LUTs/FFs
    reg [31:0] r_s = 32'h1;
    always @(posedge clk)
        r_s <= {r_s[30:0], r_s[31] ^ r_s[21] ^ r_s[1] ^ r_s[0]};

    assign led0 = r_s[28];
    assign led1 = r_s[29];
    assign led2 = r_s[30];
    assign led3 = r_s[31];
endmodule
