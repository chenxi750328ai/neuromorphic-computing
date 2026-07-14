// Phase4 path B · LIF single-step (Q16.16), synthesizable for xc7z020
// Align with scripts/phase4_fpga_lif_fixedpoint.py and fpga/hls/lif_step.cpp
`timescale 1ns / 1ps
module lif_step (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               start,
    input  wire signed [31:0] cur_q16,   // Q16.16
    input  wire signed [31:0] mem_in_q16,
    output reg                done,
    output reg                spk_out,
    output reg  signed [31:0] mem_out_q16
);
    localparam signed [31:0] BETA_Q16   = 32'sd58982; // round(0.9 * 65536)
    localparam signed [31:0] THRESH_Q16 = 32'sd65536; // 1.0

    reg signed [63:0] prod;
    reg signed [31:0] mem_tmp;
    reg               reset_b;
    reg [1:0]         st;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st <= 2'd0;
            done <= 1'b0;
            spk_out <= 1'b0;
            mem_out_q16 <= 32'sd0;
            prod <= 64'sd0;
            mem_tmp <= 32'sd0;
            reset_b <= 1'b0;
        end else begin
            done <= 1'b0;
            case (st)
                2'd0: if (start) begin
                    reset_b <= (mem_in_q16 >= THRESH_Q16);
                    prod <= $signed(BETA_Q16) * $signed(mem_in_q16);
                    st <= 2'd1;
                end
                2'd1: begin
                    mem_tmp <= prod[47:16] + cur_q16 - (reset_b ? THRESH_Q16 : 32'sd0);
                    st <= 2'd2;
                end
                2'd2: begin
                    spk_out <= (mem_tmp >= THRESH_Q16);
                    mem_out_q16 <= mem_tmp;
                    done <= 1'b1;
                    st <= 2'd0;
                end
                default: st <= 2'd0;
            endcase
        end
    end
endmodule
