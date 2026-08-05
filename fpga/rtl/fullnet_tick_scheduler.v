// Phase4.2 F7 · PL 内 tick 调度器（overlay v2 目标模块）
// 目标：单 tick_start → fc1×HIDDEN + LIF×HIDDEN + fc2×N_OUT + LIF×N_OUT，PS 零 MMIO 细粒度踢门
// 依赖：权重/激活经 AXI HP DMA 流式喂入；BRAM 双缓冲
// Sim entry: tests/test_f7_tick_scheduler_sim.py, fpga/sim/tb_fullnet_tick_scheduler.cpp
`timescale 1ns / 1ps
module fullnet_tick_scheduler #(
    parameter HIDDEN = 256,
    parameter N_OUT  = 10,
    parameter IN_DIM = 784,
    parameter TIMESTEPS = 25
) (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tick_start,
    output reg         tick_done,
    output reg  [15:0] neuron_idx_out,
    output reg  [1:0]  phase_out,   // 0=idle 1=fc1 2=fc2 3=done
    output reg  [7:0]  tick_count_out,
    // DMA weight stream (Q16.16)
    input  wire signed [31:0] dma_w_data,
    input  wire               dma_w_valid,
    output reg                dma_w_ready,
    // DMA activation in
    input  wire signed [31:0] dma_x_data,
    input  wire               dma_x_valid,
    output reg                dma_x_ready,
    // 统计：本轮 tick 消费的 DMA beat 数（仿真 pred≡golden 对照用）
    output reg  [31:0] dma_beats_consumed
);
    localparam ST_IDLE = 3'd0;
    localparam ST_FC1  = 3'd1;
    localparam ST_LIF1 = 3'd2;
    localparam ST_FC2  = 3'd3;
    localparam ST_LIF2 = 3'd4;
    localparam ST_DONE = 3'd5;

    reg [2:0] st;
    reg [15:0] neuron_idx;
    reg [7:0] tick_count;
    reg [31:0] beats;

    wire dma_fire = dma_w_valid && dma_w_ready && dma_x_valid && dma_x_ready;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st <= ST_IDLE;
            tick_done <= 1'b0;
            neuron_idx <= 16'd0;
            neuron_idx_out <= 16'd0;
            tick_count <= 8'd0;
            tick_count_out <= 8'd0;
            phase_out <= 2'd0;
            dma_w_ready <= 1'b0;
            dma_x_ready <= 1'b0;
            dma_beats_consumed <= 32'd0;
            beats <= 32'd0;
        end else begin
            tick_done <= 1'b0;
            dma_w_ready <= (st == ST_FC1 || st == ST_FC2);
            dma_x_ready <= (st == ST_FC1 || st == ST_FC2);

            if (dma_fire)
                beats <= beats + 32'd1;

            case (st)
                ST_IDLE: begin
                    phase_out <= 2'd0;
                    beats <= 32'd0;
                    if (tick_start) begin
                        neuron_idx <= 16'd0;
                        st <= ST_FC1;
                        phase_out <= 2'd1;
                    end
                end
                ST_FC1: begin
                    phase_out <= 2'd1;
                    neuron_idx_out <= neuron_idx;
                    if (dma_fire || !dma_w_valid) begin
                        if (neuron_idx + 16'd1 >= HIDDEN) begin
                            neuron_idx <= 16'd0;
                            st <= ST_LIF1;
                        end else
                            neuron_idx <= neuron_idx + 16'd1;
                    end
                end
                ST_LIF1: begin
                    phase_out <= 2'd1;
                    neuron_idx_out <= neuron_idx;
                    if (neuron_idx + 16'd1 >= HIDDEN) begin
                        neuron_idx <= 16'd0;
                        st <= ST_FC2;
                        phase_out <= 2'd2;
                    end else
                        neuron_idx <= neuron_idx + 16'd1;
                end
                ST_FC2: begin
                    phase_out <= 2'd2;
                    neuron_idx_out <= neuron_idx;
                    if (dma_fire || !dma_w_valid) begin
                        if (neuron_idx + 16'd1 >= N_OUT) begin
                            neuron_idx <= 16'd0;
                            st <= ST_LIF2;
                        end else
                            neuron_idx <= neuron_idx + 16'd1;
                    end
                end
                ST_LIF2: begin
                    phase_out <= 2'd2;
                    neuron_idx_out <= neuron_idx;
                    if (neuron_idx + 16'd1 >= N_OUT) begin
                        st <= ST_DONE;
                        phase_out <= 2'd3;
                    end else
                        neuron_idx <= neuron_idx + 16'd1;
                end
                ST_DONE: begin
                    dma_beats_consumed <= beats;
                    tick_count <= tick_count + 8'd1;
                    tick_count_out <= tick_count + 8'd1;
                    tick_done <= 1'b1;
                    if (tick_count + 8'd1 >= TIMESTEPS)
                        st <= ST_IDLE;
                    else begin
                        neuron_idx <= 16'd0;
                        st <= ST_FC1;
                        phase_out <= 2'd1;
                    end
                end
                default: st <= ST_IDLE;
            endcase
        end
    end
endmodule
