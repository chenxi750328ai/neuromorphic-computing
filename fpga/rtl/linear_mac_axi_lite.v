// AXI4-Lite wrapper for linear_mac (F7 fc on PL)
// Reg map (byte addr):
//  0x00 CTRL   : [0]=start (W1P)
//  0x04 DIM    : vector dimension
//  0x08 W_DATA : weight element
//  0x0C X_DATA : input element
//  0x10 BIAS   : bias Q16.16
//  0x14 STATUS : [0]=done
//  0x18 RESULT : output Q16.16
`timescale 1ns / 1ps
module linear_mac_axi_lite (
    input  wire        s_axi_aclk,
    input  wire        s_axi_aresetn,
    input  wire [7:0]  s_axi_awaddr,
    input  wire        s_axi_awvalid,
    output reg         s_axi_awready,
    input  wire [31:0] s_axi_wdata,
    input  wire [3:0]  s_axi_wstrb,
    input  wire        s_axi_wvalid,
    output reg         s_axi_wready,
    output reg  [1:0]  s_axi_bresp,
    output reg         s_axi_bvalid,
    input  wire        s_axi_bready,
    input  wire [7:0]  s_axi_araddr,
    input  wire        s_axi_arvalid,
    output reg         s_axi_arready,
    output reg  [31:0] s_axi_rdata,
    output reg  [1:0]  s_axi_rresp,
    output reg         s_axi_rvalid,
    input  wire        s_axi_rready
);
    reg [15:0] dim;
    reg signed [31:0] w_data, x_data, bias_q16;
    reg start_pulse;
    reg w_valid, x_valid;
    wire done;
    wire signed [31:0] result_q16;
    reg done_sticky;

    linear_mac u_mac (
        .clk(s_axi_aclk),
        .rst_n(s_axi_aresetn),
        .start(start_pulse),
        .dim(dim),
        .w_data(w_data),
        .x_data(x_data),
        .bias_q16(bias_q16),
        .w_valid(w_valid),
        .x_valid(x_valid),
        .done(done),
        .result_q16(result_q16)
    );

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) done_sticky <= 1'b0;
        else if (done) done_sticky <= 1'b1;
        else if (s_axi_arvalid && s_axi_arready && s_axi_araddr[7:0] == 8'h14)
            done_sticky <= 1'b0;
    end

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_awready <= 1'b0; s_axi_wready <= 1'b0;
            s_axi_bvalid <= 1'b0; s_axi_bresp <= 2'b00;
            s_axi_arready <= 1'b0; s_axi_rvalid <= 1'b0;
            s_axi_rresp <= 2'b00; s_axi_rdata <= 32'd0;
            dim <= 16'd0; w_data <= 32'sd0; x_data <= 32'sd0; bias_q16 <= 32'sd0;
            start_pulse <= 1'b0; w_valid <= 1'b0; x_valid <= 1'b0;
        end else begin
            start_pulse <= 1'b0;
            w_valid <= 1'b0;
            x_valid <= 1'b0;
            if (!s_axi_awready && s_axi_awvalid && s_axi_wvalid) begin
                s_axi_awready <= 1'b1; s_axi_wready <= 1'b1;
            end else begin
                s_axi_awready <= 1'b0; s_axi_wready <= 1'b0;
            end
            if (s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid) begin
                case (s_axi_awaddr[7:0])
                    8'h00: if (s_axi_wdata[0]) start_pulse <= 1'b1;
                    8'h04: dim <= s_axi_wdata[15:0];
                    8'h08: begin w_data <= s_axi_wdata; w_valid <= 1'b1; end
                    8'h0C: begin x_data <= s_axi_wdata; x_valid <= 1'b1; end
                    8'h10: bias_q16 <= s_axi_wdata;
                    default: ;
                endcase
                s_axi_bvalid <= 1'b1; s_axi_bresp <= 2'b00;
            end else if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 1'b0;

            if (!s_axi_arready && s_axi_arvalid) begin
                s_axi_arready <= 1'b1;
                s_axi_rvalid <= 1'b1; s_axi_rresp <= 2'b00;
                case (s_axi_araddr[7:0])
                    8'h00: s_axi_rdata <= {31'd0, start_pulse};
                    8'h04: s_axi_rdata <= {16'd0, dim};
                    8'h08: s_axi_rdata <= w_data;
                    8'h0C: s_axi_rdata <= x_data;
                    8'h10: s_axi_rdata <= bias_q16;
                    8'h14: s_axi_rdata <= {31'd0, done_sticky};
                    8'h18: s_axi_rdata <= result_q16;
                    default: s_axi_rdata <= 32'd0;
                endcase
            end else begin
                s_axi_arready <= 1'b0;
                if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 1'b0;
            end
        end
    end
endmodule
