// Phase4.2 F7 · PL 内 tick 调度器（设计草案 · 待 overlay 集成）
// 目标：单 kick / tick → fc1×256 + LIF×256 + fc2×10 + LIF×10，PS 零 MMIO 细粒度踢门
// 依赖：权重/激活经 AXI HP DMA 流式喂入；BRAM 双缓冲
`timescale 1ns / 1ps
module fullnet_tick_scheduler #(
    parameter HIDDEN = 256,
    parameter N_OUT  = 10,
    parameter IN_DIM = 784
) (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        tick_start,
    output reg         tick_done,
    // DMA weight stream (Q16.16)
    input  wire signed [31:0] dma_w_data,
    input  wire               dma_w_valid,
    output reg                dma_w_ready,
    // DMA activation in / spike out (future)
    input  wire signed [31:0] dma_x_data,
    input  wire               dma_x_valid,
    output reg                dma_x_ready
);
    // Placeholder FSM — synthesis target for feature/phase4.2-f7-perf-lat100 overlay v2
    localparam ST_IDLE = 2'd0;
    localparam ST_FC1  = 2'd1;
    localparam ST_FC2  = 2'd2;
    localparam ST_DONE = 2'd3;

    reg [1:0] st;
    reg [15:0] neuron_idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st <= ST_IDLE;
            tick_done <= 1'b0;
            neuron_idx <= 16'd0;
            dma_w_ready <= 1'b0;
            dma_x_ready <= 1'b0;
        end else begin
            tick_done <= 1'b0;
            dma_w_ready <= (st == ST_FC1 || st == ST_FC2);
            dma_x_ready <= (st == ST_FC1 || st == ST_FC2);
            case (st)
                ST_IDLE: if (tick_start) begin
                    neuron_idx <= 16'd0;
                    st <= ST_FC1;
                end
                ST_FC1: if (neuron_idx + 16'd1 >= HIDDEN) st <= ST_FC2;
                else neuron_idx <= neuron_idx + 16'd1;
                ST_FC2: if (neuron_idx + 16'd1 >= N_OUT) st <= ST_DONE;
                else neuron_idx <= neuron_idx + 16'd1;
                ST_DONE: begin
                    tick_done <= 1'b1;
                    st <= ST_IDLE;
                end
                default: st <= ST_IDLE;
            endcase
        end
    end
endmodule
