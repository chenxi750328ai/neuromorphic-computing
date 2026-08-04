// openXC7 · soft-LIF + PS7 MAXIGP0 @ 0x40000000 — 陈正共
// AXI4 单拍从机：分拍捕获 AW/W（Linux MMIO 常分拍），禁止“READY=1 却丢掉拍”。
`default_nettype none
module blinky (
    input  wire clk,
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);
    wire [3:0] fclk_u;
    wire       aclk;
    BUFG u_bufg (.I(fclk_u[0]), .O(aclk));

    reg [7:0] por = 8'd0;
    wire      rst_n = &por;
    always @(posedge aclk) begin
        if (!rst_n)
            por <= por + 8'd1;
    end

    wire        arvalid, awvalid, wvalid, rready, bready;
    wire [31:0] araddr, awaddr, wdata;
    wire [3:0]  wstrb;
    wire [11:0] arid, awid, wid;

    // handshake regs
    reg        aw_hs, w_hs, ar_hs;
    reg [31:0] awaddr_r, wdata_r, araddr_r;
    reg [11:0] awid_r, arid_r;
    reg        bvalid_r, rvalid_r;
    reg [31:0] rdata_r;

    // READY only when slot free — 关键吞拍
    wire awready = rst_n && !aw_hs && !bvalid_r;
    wire wready  = rst_n && !w_hs  && !bvalid_r;
    wire arready = rst_n && !ar_hs && !rvalid_r;
    wire bvalid  = bvalid_r;
    wire rvalid  = rvalid_r;
    wire [1:0] bresp = 2'b00;
    wire [1:0] rresp = 2'b00;
    wire rlast = 1'b1;
    wire [11:0] bid = awid_r;
    wire [11:0] rid = arid_r;
    wire [31:0] rdata = rdata_r;

    localparam [31:0] BASE = 32'h4000_0000;
    wire aw_hit = (awaddr_r[31:8] == BASE[31:8]);
    wire ar_hit = (araddr_r[31:8] == BASE[31:8]);

    reg signed [31:0] cur_q16, mem_in_q16;
    reg               start_pulse;
    wire              done, spk;
    wire signed [31:0] mem_out_q16;
    reg               done_sticky;

    lif_step u_lif (
        .clk        (aclk),
        .rst_n      (rst_n),
        .start      (start_pulse),
        .cur_q16    (cur_q16),
        .mem_in_q16 (mem_in_q16),
        .done       (done),
        .spk_out    (spk),
        .mem_out_q16(mem_out_q16)
    );

    always @(posedge aclk) begin
        if (!rst_n) begin
            aw_hs <= 1'b0; w_hs <= 1'b0; ar_hs <= 1'b0;
            bvalid_r <= 1'b0; rvalid_r <= 1'b0;
            awaddr_r <= 32'd0; wdata_r <= 32'd0; araddr_r <= 32'd0;
            awid_r <= 12'd0; arid_r <= 12'd0; rdata_r <= 32'd0;
            cur_q16 <= 32'sd0; mem_in_q16 <= 32'sd0;
            start_pulse <= 1'b0; done_sticky <= 1'b0;
        end else begin
            start_pulse <= 1'b0;
            if (done)
                done_sticky <= 1'b1;

            // capture AW / W separately
            if (awvalid && awready) begin
                aw_hs <= 1'b1;
                awaddr_r <= awaddr;
                awid_r <= awid;
            end
            if (wvalid && wready) begin
                w_hs <= 1'b1;
                wdata_r <= wdata;
            end

            // complete write → B
            if (aw_hs && w_hs && !bvalid_r) begin
                if (aw_hit) begin
                    case (awaddr_r[7:0])
                        8'h00: if (wdata_r[0]) start_pulse <= 1'b1;
                        8'h04: cur_q16 <= wdata_r;
                        8'h08: mem_in_q16 <= wdata_r;
                        default: ;
                    endcase
                end
                bvalid_r <= 1'b1;
            end
            if (bvalid_r && bready) begin
                bvalid_r <= 1'b0;
                aw_hs <= 1'b0;
                w_hs <= 1'b0;
            end

            // capture AR → R
            if (arvalid && arready) begin
                ar_hs <= 1'b1;
                araddr_r <= araddr;
                arid_r <= arid;
            end
            if (ar_hs && !rvalid_r) begin
                if (ar_hit) begin
                    case (araddr_r[7:0])
                        8'h00: rdata_r <= {30'd0, done_sticky, 1'b0};
                        8'h04: rdata_r <= cur_q16;
                        8'h08: rdata_r <= mem_in_q16;
                        8'h0C: begin
                            rdata_r <= {30'd0, spk, done_sticky};
                            done_sticky <= 1'b0;
                        end
                        8'h10: rdata_r <= mem_out_q16;
                        default: rdata_r <= 32'd0;
                    endcase
                end else begin
                    rdata_r <= 32'd0;
                end
                rvalid_r <= 1'b1;
                ar_hs <= 1'b0;
            end
            if (rvalid_r && rready)
                rvalid_r <= 1'b0;
        end
    end

    reg [23:0] tick;
    always @(posedge aclk) tick <= tick + 24'd1;
    assign led0 = done_sticky;
    assign led1 = bvalid_r;
    assign led2 = rst_n;
    assign led3 = tick[23];

    (* keep *) PS7 ps7_i (
        .FCLKCLK       (fclk_u),
        .MAXIGP0ACLK   (aclk),
        .MAXIGP0ARVALID(arvalid),
        .MAXIGP0AWVALID(awvalid),
        .MAXIGP0WVALID (wvalid),
        .MAXIGP0RREADY (rready),
        .MAXIGP0BREADY (bready),
        .MAXIGP0ARADDR (araddr),
        .MAXIGP0AWADDR (awaddr),
        .MAXIGP0WDATA  (wdata),
        .MAXIGP0WSTRB  (wstrb),
        .MAXIGP0ARID   (arid),
        .MAXIGP0AWID   (awid),
        .MAXIGP0WID    (wid),
        .MAXIGP0ARREADY(arready),
        .MAXIGP0AWREADY(awready),
        .MAXIGP0WREADY (wready),
        .MAXIGP0RVALID (rvalid),
        .MAXIGP0BVALID (bvalid),
        .MAXIGP0RDATA  (rdata),
        .MAXIGP0RRESP  (rresp),
        .MAXIGP0BRESP  (bresp),
        .MAXIGP0RLAST  (rlast),
        .MAXIGP0RID    (rid),
        .MAXIGP0BID    (bid)
    );
endmodule
`default_nettype wire
