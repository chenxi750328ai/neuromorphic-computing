// openXC7-friendly LIF (Q16.16) — 陈正共
// Same math as lif_step.v / FixedPointLIF:
// - soft multiply (shift-add) → no DSP48 / CARRY alumacc
// - sync reset only + always-assign → avoid CEUSEDMUX/SRUSEDMUX nextpnr bugs
`timescale 1ns / 1ps
module lif_step (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               start,
    input  wire signed [31:0] cur_q16,
    input  wire signed [31:0] mem_in_q16,
    output reg                done,
    output reg                spk_out,
    output reg  signed [31:0] mem_out_q16
);
    localparam signed [31:0] BETA_Q16   = 32'sd58982;
    localparam signed [31:0] THRESH_Q16 = 32'sd65536;

    reg [5:0]          st;
    reg signed [63:0]  acc;
    reg signed [63:0]  mem_ext;
    reg [31:0]         beta_sh;
    reg signed [31:0]  cur_r;
    reg                reset_b;
    reg [4:0]          bit_i;
    reg signed [31:0]  mem_tmp;

    reg [5:0]          st_n;
    reg signed [63:0]  acc_n;
    reg signed [63:0]  mem_ext_n;
    reg [31:0]         beta_sh_n;
    reg signed [31:0]  cur_r_n;
    reg                reset_b_n;
    reg [4:0]          bit_i_n;
    reg signed [31:0]  mem_tmp_n;
    reg                done_n;
    reg                spk_n;
    reg signed [31:0]  mem_out_n;

    always @* begin
        st_n      = st;
        acc_n     = acc;
        mem_ext_n = mem_ext;
        beta_sh_n = beta_sh;
        cur_r_n   = cur_r;
        reset_b_n = reset_b;
        bit_i_n   = bit_i;
        mem_tmp_n = mem_tmp;
        done_n    = 1'b0;
        spk_n     = spk_out;
        mem_out_n = mem_out_q16;

        case (st)
            6'd0: begin
                if (start) begin
                    reset_b_n = (mem_in_q16 >= THRESH_Q16);
                    cur_r_n   = cur_q16;
                    beta_sh_n = BETA_Q16;
                    mem_ext_n = {{32{mem_in_q16[31]}}, mem_in_q16};
                    acc_n     = 64'sd0;
                    bit_i_n   = 5'd0;
                    st_n      = 6'd1;
                end
            end
            6'd1: begin
                if (beta_sh[0])
                    acc_n = acc + mem_ext;
                beta_sh_n = beta_sh >> 1;
                mem_ext_n = mem_ext <<< 1;
                if (bit_i == 5'd31)
                    st_n = 6'd2;
                else
                    bit_i_n = bit_i + 5'd1;
            end
            6'd2: begin
                mem_tmp_n = acc[47:16] + cur_r - (reset_b ? THRESH_Q16 : 32'sd0);
                st_n = 6'd3;
            end
            6'd3: begin
                spk_n     = (mem_tmp >= THRESH_Q16);
                mem_out_n = mem_tmp;
                done_n    = 1'b1;
                st_n      = 6'd0;
            end
            default: st_n = 6'd0;
        endcase
    end

    // sync reset only (no async) for openXC7 nextpnr
    always @(posedge clk) begin
        if (!rst_n) begin
            st <= 6'd0;
            done <= 1'b0;
            spk_out <= 1'b0;
            mem_out_q16 <= 32'sd0;
            acc <= 64'sd0;
            mem_ext <= 64'sd0;
            beta_sh <= 32'd0;
            cur_r <= 32'sd0;
            reset_b <= 1'b0;
            bit_i <= 5'd0;
            mem_tmp <= 32'sd0;
        end else begin
            st <= st_n;
            acc <= acc_n;
            mem_ext <= mem_ext_n;
            beta_sh <= beta_sh_n;
            cur_r <= cur_r_n;
            reset_b <= reset_b_n;
            bit_i <= bit_i_n;
            mem_tmp <= mem_tmp_n;
            done <= done_n;
            spk_out <= spk_n;
            mem_out_q16 <= mem_out_n;
        end
    end
endmodule
