// Minimal AXI4-Lite slave wrapping lif_step for PYNQ Overlay
// Reg map (byte addr):
//  0x00 CTRL  : [0]=start (W1P), [1]=done (RO sticky clear on read)
//  0x04 CUR   : Q16.16 current (WO/RW)
//  0x08 MEM_IN: Q16.16 membrane in
//  0x0C STATUS: [0]=done, [1]=spk
//  0x10 MEM_OUT
`timescale 1ns / 1ps
module lif_step_axi_lite (
    input  wire        s_axi_aclk,
    input  wire        s_axi_aresetn,
    // AXI4-Lite write
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
    // AXI4-Lite read
    input  wire [7:0]  s_axi_araddr,
    input  wire        s_axi_arvalid,
    output reg         s_axi_arready,
    output reg  [31:0] s_axi_rdata,
    output reg  [1:0]  s_axi_rresp,
    output reg         s_axi_rvalid,
    input  wire        s_axi_rready
);
    reg signed [31:0] cur_q16, mem_in_q16;
    reg               start_pulse;
    wire              done, spk;
    wire signed [31:0] mem_out_q16;
    reg               done_sticky;

    lif_step u_lif (
        .clk(s_axi_aclk),
        .rst_n(s_axi_aresetn),
        .start(start_pulse),
        .cur_q16(cur_q16),
        .mem_in_q16(mem_in_q16),
        .done(done),
        .spk_out(spk),
        .mem_out_q16(mem_out_q16)
    );

    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) done_sticky <= 1'b0;
        else if (done) done_sticky <= 1'b1;
        else if (s_axi_arvalid && s_axi_arready && s_axi_araddr[7:0] == 8'h0C)
            done_sticky <= 1'b0;
    end

    // simplistic single-beat AXI-Lite
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_awready <= 1'b0; s_axi_wready <= 1'b0;
            s_axi_bvalid <= 1'b0; s_axi_bresp <= 2'b00;
            s_axi_arready <= 1'b0; s_axi_rvalid <= 1'b0;
            s_axi_rresp <= 2'b00; s_axi_rdata <= 32'd0;
            cur_q16 <= 32'sd0; mem_in_q16 <= 32'sd0; start_pulse <= 1'b0;
        end else begin
            start_pulse <= 1'b0;
            // write addr/data
            if (!s_axi_awready && s_axi_awvalid && s_axi_wvalid) begin
                s_axi_awready <= 1'b1; s_axi_wready <= 1'b1;
            end else begin
                s_axi_awready <= 1'b0; s_axi_wready <= 1'b0;
            end
            if (s_axi_awready && s_axi_awvalid && s_axi_wready && s_axi_wvalid) begin
                case (s_axi_awaddr[7:0])
                    8'h00: if (s_axi_wdata[0]) start_pulse <= 1'b1;
                    8'h04: cur_q16 <= s_axi_wdata;
                    8'h08: mem_in_q16 <= s_axi_wdata;
                    default: ;
                endcase
                s_axi_bvalid <= 1'b1; s_axi_bresp <= 2'b00;
            end else if (s_axi_bvalid && s_axi_bready) s_axi_bvalid <= 1'b0;

            // read
            if (!s_axi_arready && s_axi_arvalid) begin
                s_axi_arready <= 1'b1;
                s_axi_rvalid <= 1'b1; s_axi_rresp <= 2'b00;
                case (s_axi_araddr[7:0])
                    8'h00: s_axi_rdata <= {30'd0, done_sticky, 1'b0};
                    8'h04: s_axi_rdata <= cur_q16;
                    8'h08: s_axi_rdata <= mem_in_q16;
                    8'h0C: s_axi_rdata <= {30'd0, spk, done_sticky};
                    8'h10: s_axi_rdata <= mem_out_q16;
                    default: s_axi_rdata <= 32'd0;
                endcase
            end else begin
                s_axi_arready <= 1'b0;
                if (s_axi_rvalid && s_axi_rready) s_axi_rvalid <= 1'b0;
            end
        end
    end
endmodule
