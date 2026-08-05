// Phase4.1 F7 · Q16.16 dot-product MAC (single output neuron)
// Matches scripts/phase4_fpga_snn_fixedpoint.linear_fp
`timescale 1ns / 1ps
module linear_mac (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               start,
    input  wire [15:0]        dim,
    input  wire signed [31:0] w_data,
    input  wire signed [31:0] x_data,
    input  wire signed [31:0] bias_q16,
    input  wire               w_valid,
    input  wire               x_valid,
    output reg                done,
    output reg  signed [31:0] result_q16
);
    reg [15:0] idx;
    reg [15:0] dim_latch;
    reg signed [63:0] acc;
    reg [1:0] st;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st <= 2'd0;
            done <= 1'b0;
            idx <= 16'd0;
            dim_latch <= 16'd0;
            acc <= 64'sd0;
            result_q16 <= 32'sd0;
        end else begin
            done <= 1'b0;
            case (st)
                2'd0: if (start) begin
                    dim_latch <= dim;
                    acc <= 64'sd0;
                    idx <= 16'd0;
                    st <= 2'd1;
                end
                2'd1: if (w_valid && x_valid) begin
                    acc <= acc + ($signed(w_data) * $signed(x_data));
                    if (idx + 16'd1 >= dim_latch) st <= 2'd2;
                    else idx <= idx + 16'd1;
                end
                2'd2: begin
                    result_q16 <= acc[47:16] + bias_q16;
                    done <= 1'b1;
                    st <= 2'd0;
                end
                default: st <= 2'd0;
            endcase
        end
    end
endmodule
