// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
// Date        : Thu Jul 23 10:15:12 2026
// Host        : CXS1 running 64-bit Ubuntu 24.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_lif_step_0_0_sim_netlist.v
// Design      : design_1_lif_step_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_lif_step_0_0,lif_step_axi_lite,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "lif_step_axi_lite,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awaddr,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rvalid,
    s_axi_rready);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axi_aclk CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axi_aresetn RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWADDR" *) input [7:0]s_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWVALID" *) input s_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi AWREADY" *) output s_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WDATA" *) input [31:0]s_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WSTRB" *) input [3:0]s_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WVALID" *) input s_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi WREADY" *) output s_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BRESP" *) output [1:0]s_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BVALID" *) output s_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi BREADY" *) input s_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARADDR" *) input [7:0]s_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARVALID" *) input s_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi ARREADY" *) output s_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RDATA" *) output [31:0]s_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RRESP" *) output [1:0]s_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RVALID" *) output s_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 s_axi RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input s_axi_rready;

  wire \<const0> ;
  wire s_axi_aclk;
  wire [7:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [7:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wvalid;

  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_wready = s_axi_awready;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lif_step_axi_lite inst
       (.s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_awready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lif_step
   (s_axi_aresetn_0,
    D,
    s_axi_araddr_5_sp_1,
    s_axi_aclk,
    Q,
    \s_axi_rdata_reg[0] ,
    s_axi_araddr,
    \s_axi_rdata_reg[0]_0 ,
    \mem_tmp_reg[31]_0 ,
    data0,
    done_sticky_reg,
    done_sticky_reg_0,
    s_axi_aresetn,
    start_pulse);
  output s_axi_aresetn_0;
  output [31:0]D;
  output s_axi_araddr_5_sp_1;
  input s_axi_aclk;
  input [31:0]Q;
  input \s_axi_rdata_reg[0] ;
  input [7:0]s_axi_araddr;
  input \s_axi_rdata_reg[0]_0 ;
  input [31:0]\mem_tmp_reg[31]_0 ;
  input [0:0]data0;
  input done_sticky_reg;
  input done_sticky_reg_0;
  input s_axi_aresetn;
  input start_pulse;

  wire [31:0]D;
  wire \FSM_onehot_st[0]_i_1_n_0 ;
  wire \FSM_onehot_st[1]_i_1_n_0 ;
  wire \FSM_onehot_st_reg_n_0_[0] ;
  wire \FSM_onehot_st_reg_n_0_[2] ;
  wire [31:0]Q;
  wire [0:0]data0;
  wire done;
  wire done_sticky_reg;
  wire done_sticky_reg_0;
  wire [31:0]mem_out_q16;
  wire [31:0]mem_tmp;
  wire [31:0]mem_tmp0;
  wire mem_tmp0_carry__0_i_1_n_0;
  wire mem_tmp0_carry__0_i_2_n_0;
  wire mem_tmp0_carry__0_i_3_n_0;
  wire mem_tmp0_carry__0_i_4_n_0;
  wire mem_tmp0_carry__0_n_0;
  wire mem_tmp0_carry__0_n_1;
  wire mem_tmp0_carry__0_n_2;
  wire mem_tmp0_carry__0_n_3;
  wire mem_tmp0_carry__1_i_1_n_0;
  wire mem_tmp0_carry__1_i_2_n_0;
  wire mem_tmp0_carry__1_i_3_n_0;
  wire mem_tmp0_carry__1_i_4_n_0;
  wire mem_tmp0_carry__1_n_0;
  wire mem_tmp0_carry__1_n_1;
  wire mem_tmp0_carry__1_n_2;
  wire mem_tmp0_carry__1_n_3;
  wire mem_tmp0_carry__2_i_1_n_0;
  wire mem_tmp0_carry__2_i_2_n_0;
  wire mem_tmp0_carry__2_i_3_n_0;
  wire mem_tmp0_carry__2_i_4_n_0;
  wire mem_tmp0_carry__2_n_0;
  wire mem_tmp0_carry__2_n_1;
  wire mem_tmp0_carry__2_n_2;
  wire mem_tmp0_carry__2_n_3;
  wire mem_tmp0_carry__3_i_1_n_0;
  wire mem_tmp0_carry__3_i_2_n_0;
  wire mem_tmp0_carry__3_i_3_n_0;
  wire mem_tmp0_carry__3_i_4_n_0;
  wire mem_tmp0_carry__3_i_5_n_0;
  wire mem_tmp0_carry__3_i_6_n_0;
  wire mem_tmp0_carry__3_i_7_n_0;
  wire mem_tmp0_carry__3_n_0;
  wire mem_tmp0_carry__3_n_1;
  wire mem_tmp0_carry__3_n_2;
  wire mem_tmp0_carry__3_n_3;
  wire mem_tmp0_carry__4_i_1_n_0;
  wire mem_tmp0_carry__4_i_2_n_0;
  wire mem_tmp0_carry__4_i_3_n_0;
  wire mem_tmp0_carry__4_i_4_n_0;
  wire mem_tmp0_carry__4_i_5_n_0;
  wire mem_tmp0_carry__4_i_6_n_0;
  wire mem_tmp0_carry__4_i_7_n_0;
  wire mem_tmp0_carry__4_i_8_n_0;
  wire mem_tmp0_carry__4_n_0;
  wire mem_tmp0_carry__4_n_1;
  wire mem_tmp0_carry__4_n_2;
  wire mem_tmp0_carry__4_n_3;
  wire mem_tmp0_carry__5_i_1_n_0;
  wire mem_tmp0_carry__5_i_2_n_0;
  wire mem_tmp0_carry__5_i_3_n_0;
  wire mem_tmp0_carry__5_i_4_n_0;
  wire mem_tmp0_carry__5_i_5_n_0;
  wire mem_tmp0_carry__5_i_6_n_0;
  wire mem_tmp0_carry__5_i_7_n_0;
  wire mem_tmp0_carry__5_i_8_n_0;
  wire mem_tmp0_carry__5_n_0;
  wire mem_tmp0_carry__5_n_1;
  wire mem_tmp0_carry__5_n_2;
  wire mem_tmp0_carry__5_n_3;
  wire mem_tmp0_carry__6_i_1_n_0;
  wire mem_tmp0_carry__6_i_2_n_0;
  wire mem_tmp0_carry__6_i_3_n_0;
  wire mem_tmp0_carry__6_i_4_n_0;
  wire mem_tmp0_carry__6_i_5_n_0;
  wire mem_tmp0_carry__6_i_6_n_0;
  wire mem_tmp0_carry__6_i_7_n_0;
  wire mem_tmp0_carry__6_n_1;
  wire mem_tmp0_carry__6_n_2;
  wire mem_tmp0_carry__6_n_3;
  wire mem_tmp0_carry_i_1_n_0;
  wire mem_tmp0_carry_i_2_n_0;
  wire mem_tmp0_carry_i_3_n_0;
  wire mem_tmp0_carry_i_4_n_0;
  wire mem_tmp0_carry_n_0;
  wire mem_tmp0_carry_n_1;
  wire mem_tmp0_carry_n_2;
  wire mem_tmp0_carry_n_3;
  wire mem_tmp_0;
  wire [31:0]\mem_tmp_reg[31]_0 ;
  wire p_0_in;
  wire [31:0]p_0_in1_in;
  wire prod;
  wire prod0__179_carry__0_i_1_n_0;
  wire prod0__179_carry__0_i_2_n_0;
  wire prod0__179_carry__0_i_3_n_0;
  wire prod0__179_carry__0_i_4_n_0;
  wire prod0__179_carry__0_n_0;
  wire prod0__179_carry__0_n_1;
  wire prod0__179_carry__0_n_2;
  wire prod0__179_carry__0_n_3;
  wire prod0__179_carry__0_n_4;
  wire prod0__179_carry__0_n_5;
  wire prod0__179_carry__0_n_6;
  wire prod0__179_carry__0_n_7;
  wire prod0__179_carry__1_i_1_n_0;
  wire prod0__179_carry__1_i_2_n_0;
  wire prod0__179_carry__1_i_3_n_0;
  wire prod0__179_carry__1_i_4_n_0;
  wire prod0__179_carry__1_n_0;
  wire prod0__179_carry__1_n_1;
  wire prod0__179_carry__1_n_2;
  wire prod0__179_carry__1_n_3;
  wire prod0__179_carry__1_n_4;
  wire prod0__179_carry__1_n_5;
  wire prod0__179_carry__1_n_6;
  wire prod0__179_carry__1_n_7;
  wire prod0__179_carry__2_i_1_n_0;
  wire prod0__179_carry__2_i_2_n_0;
  wire prod0__179_carry__2_i_3_n_0;
  wire prod0__179_carry__2_i_4_n_0;
  wire prod0__179_carry__2_n_0;
  wire prod0__179_carry__2_n_1;
  wire prod0__179_carry__2_n_2;
  wire prod0__179_carry__2_n_3;
  wire prod0__179_carry__2_n_4;
  wire prod0__179_carry__2_n_5;
  wire prod0__179_carry__2_n_6;
  wire prod0__179_carry__2_n_7;
  wire prod0__179_carry__3_i_1_n_0;
  wire prod0__179_carry__3_i_2_n_0;
  wire prod0__179_carry__3_i_3_n_0;
  wire prod0__179_carry__3_i_4_n_0;
  wire prod0__179_carry__3_n_0;
  wire prod0__179_carry__3_n_1;
  wire prod0__179_carry__3_n_2;
  wire prod0__179_carry__3_n_3;
  wire prod0__179_carry__3_n_4;
  wire prod0__179_carry__3_n_5;
  wire prod0__179_carry__3_n_6;
  wire prod0__179_carry__3_n_7;
  wire prod0__179_carry__4_i_1_n_0;
  wire prod0__179_carry__4_i_2_n_0;
  wire prod0__179_carry__4_i_3_n_0;
  wire prod0__179_carry__4_i_4_n_0;
  wire prod0__179_carry__4_n_0;
  wire prod0__179_carry__4_n_1;
  wire prod0__179_carry__4_n_2;
  wire prod0__179_carry__4_n_3;
  wire prod0__179_carry__4_n_4;
  wire prod0__179_carry__4_n_5;
  wire prod0__179_carry__4_n_6;
  wire prod0__179_carry__4_n_7;
  wire prod0__179_carry__5_i_1_n_0;
  wire prod0__179_carry__5_i_2_n_0;
  wire prod0__179_carry__5_i_3_n_0;
  wire prod0__179_carry__5_i_4_n_0;
  wire prod0__179_carry__5_n_0;
  wire prod0__179_carry__5_n_1;
  wire prod0__179_carry__5_n_2;
  wire prod0__179_carry__5_n_3;
  wire prod0__179_carry__5_n_4;
  wire prod0__179_carry__5_n_5;
  wire prod0__179_carry__5_n_6;
  wire prod0__179_carry__5_n_7;
  wire prod0__179_carry__6_i_1_n_0;
  wire prod0__179_carry__6_i_2_n_0;
  wire prod0__179_carry__6_i_3_n_0;
  wire prod0__179_carry__6_i_4_n_0;
  wire prod0__179_carry__6_i_5_n_0;
  wire prod0__179_carry__6_n_0;
  wire prod0__179_carry__6_n_1;
  wire prod0__179_carry__6_n_2;
  wire prod0__179_carry__6_n_3;
  wire prod0__179_carry__6_n_4;
  wire prod0__179_carry__6_n_5;
  wire prod0__179_carry__6_n_6;
  wire prod0__179_carry__6_n_7;
  wire prod0__179_carry__7_i_1_n_0;
  wire prod0__179_carry__7_i_2_n_0;
  wire prod0__179_carry__7_i_3_n_0;
  wire prod0__179_carry__7_n_2;
  wire prod0__179_carry__7_n_3;
  wire prod0__179_carry__7_n_5;
  wire prod0__179_carry__7_n_6;
  wire prod0__179_carry__7_n_7;
  wire prod0__179_carry_i_1_n_0;
  wire prod0__179_carry_i_2_n_0;
  wire prod0__179_carry_i_3_n_0;
  wire prod0__179_carry_n_0;
  wire prod0__179_carry_n_1;
  wire prod0__179_carry_n_2;
  wire prod0__179_carry_n_3;
  wire prod0__179_carry_n_4;
  wire prod0__179_carry_n_5;
  wire prod0__179_carry_n_6;
  wire prod0__249_carry__0_n_0;
  wire prod0__249_carry__0_n_1;
  wire prod0__249_carry__0_n_2;
  wire prod0__249_carry__0_n_3;
  wire prod0__249_carry__0_n_4;
  wire prod0__249_carry__0_n_5;
  wire prod0__249_carry__0_n_6;
  wire prod0__249_carry__0_n_7;
  wire prod0__249_carry__1_n_0;
  wire prod0__249_carry__1_n_1;
  wire prod0__249_carry__1_n_2;
  wire prod0__249_carry__1_n_3;
  wire prod0__249_carry__1_n_4;
  wire prod0__249_carry__1_n_5;
  wire prod0__249_carry__1_n_6;
  wire prod0__249_carry__1_n_7;
  wire prod0__249_carry__2_n_0;
  wire prod0__249_carry__2_n_1;
  wire prod0__249_carry__2_n_2;
  wire prod0__249_carry__2_n_3;
  wire prod0__249_carry__2_n_4;
  wire prod0__249_carry__2_n_5;
  wire prod0__249_carry__2_n_6;
  wire prod0__249_carry__2_n_7;
  wire prod0__249_carry__3_i_1_n_0;
  wire prod0__249_carry__3_n_2;
  wire prod0__249_carry__3_n_7;
  wire prod0__249_carry_i_1_n_0;
  wire prod0__249_carry_n_0;
  wire prod0__249_carry_n_1;
  wire prod0__249_carry_n_2;
  wire prod0__249_carry_n_3;
  wire prod0__249_carry_n_4;
  wire prod0__249_carry_n_5;
  wire prod0__249_carry_n_6;
  wire prod0__249_carry_n_7;
  wire prod0__283_carry__0_i_1_n_0;
  wire prod0__283_carry__0_i_2_n_0;
  wire prod0__283_carry__0_i_3_n_0;
  wire prod0__283_carry__0_i_4_n_0;
  wire prod0__283_carry__0_i_5_n_0;
  wire prod0__283_carry__0_i_6_n_0;
  wire prod0__283_carry__0_i_7_n_0;
  wire prod0__283_carry__0_i_8_n_0;
  wire prod0__283_carry__0_n_0;
  wire prod0__283_carry__0_n_1;
  wire prod0__283_carry__0_n_2;
  wire prod0__283_carry__0_n_3;
  wire prod0__283_carry__0_n_4;
  wire prod0__283_carry__0_n_5;
  wire prod0__283_carry__0_n_6;
  wire prod0__283_carry__0_n_7;
  wire prod0__283_carry__1_i_1_n_0;
  wire prod0__283_carry__1_i_2_n_0;
  wire prod0__283_carry__1_i_3_n_0;
  wire prod0__283_carry__1_i_4_n_0;
  wire prod0__283_carry__1_i_5_n_0;
  wire prod0__283_carry__1_i_6_n_0;
  wire prod0__283_carry__1_i_7_n_0;
  wire prod0__283_carry__1_i_8_n_0;
  wire prod0__283_carry__1_n_0;
  wire prod0__283_carry__1_n_1;
  wire prod0__283_carry__1_n_2;
  wire prod0__283_carry__1_n_3;
  wire prod0__283_carry__1_n_4;
  wire prod0__283_carry__1_n_5;
  wire prod0__283_carry__1_n_6;
  wire prod0__283_carry__1_n_7;
  wire prod0__283_carry__2_i_1_n_0;
  wire prod0__283_carry__2_i_2_n_0;
  wire prod0__283_carry__2_i_3_n_0;
  wire prod0__283_carry__2_i_4_n_0;
  wire prod0__283_carry__2_i_5_n_0;
  wire prod0__283_carry__2_i_6_n_0;
  wire prod0__283_carry__2_i_7_n_0;
  wire prod0__283_carry__2_i_8_n_0;
  wire prod0__283_carry__2_n_0;
  wire prod0__283_carry__2_n_1;
  wire prod0__283_carry__2_n_2;
  wire prod0__283_carry__2_n_3;
  wire prod0__283_carry__2_n_4;
  wire prod0__283_carry__2_n_5;
  wire prod0__283_carry__2_n_6;
  wire prod0__283_carry__2_n_7;
  wire prod0__283_carry__3_i_1_n_0;
  wire prod0__283_carry__3_i_2_n_0;
  wire prod0__283_carry__3_i_3_n_0;
  wire prod0__283_carry__3_i_4_n_0;
  wire prod0__283_carry__3_i_5_n_0;
  wire prod0__283_carry__3_i_6_n_0;
  wire prod0__283_carry__3_i_7_n_0;
  wire prod0__283_carry__3_i_8_n_0;
  wire prod0__283_carry__3_n_0;
  wire prod0__283_carry__3_n_1;
  wire prod0__283_carry__3_n_2;
  wire prod0__283_carry__3_n_3;
  wire prod0__283_carry__3_n_4;
  wire prod0__283_carry__3_n_5;
  wire prod0__283_carry__3_n_6;
  wire prod0__283_carry__3_n_7;
  wire prod0__283_carry__4_i_1_n_0;
  wire prod0__283_carry__4_i_2_n_0;
  wire prod0__283_carry__4_i_3_n_0;
  wire prod0__283_carry__4_i_4_n_0;
  wire prod0__283_carry__4_i_5_n_0;
  wire prod0__283_carry__4_i_6_n_0;
  wire prod0__283_carry__4_i_7_n_0;
  wire prod0__283_carry__4_i_8_n_0;
  wire prod0__283_carry__4_n_0;
  wire prod0__283_carry__4_n_1;
  wire prod0__283_carry__4_n_2;
  wire prod0__283_carry__4_n_3;
  wire prod0__283_carry__4_n_4;
  wire prod0__283_carry__4_n_5;
  wire prod0__283_carry__4_n_6;
  wire prod0__283_carry__4_n_7;
  wire prod0__283_carry__5_i_1_n_0;
  wire prod0__283_carry__5_i_2_n_0;
  wire prod0__283_carry__5_i_3_n_0;
  wire prod0__283_carry__5_i_4_n_0;
  wire prod0__283_carry__5_i_5_n_0;
  wire prod0__283_carry__5_i_6_n_0;
  wire prod0__283_carry__5_i_7_n_0;
  wire prod0__283_carry__5_i_8_n_0;
  wire prod0__283_carry__5_n_0;
  wire prod0__283_carry__5_n_1;
  wire prod0__283_carry__5_n_2;
  wire prod0__283_carry__5_n_3;
  wire prod0__283_carry__5_n_4;
  wire prod0__283_carry__5_n_5;
  wire prod0__283_carry__5_n_6;
  wire prod0__283_carry__5_n_7;
  wire prod0__283_carry__6_i_1_n_0;
  wire prod0__283_carry__6_i_2_n_0;
  wire prod0__283_carry__6_i_3_n_0;
  wire prod0__283_carry__6_i_4_n_0;
  wire prod0__283_carry__6_i_5_n_0;
  wire prod0__283_carry__6_i_6_n_0;
  wire prod0__283_carry__6_i_7_n_0;
  wire prod0__283_carry__6_i_8_n_0;
  wire prod0__283_carry__6_i_9_n_3;
  wire prod0__283_carry__6_n_0;
  wire prod0__283_carry__6_n_1;
  wire prod0__283_carry__6_n_2;
  wire prod0__283_carry__6_n_3;
  wire prod0__283_carry__6_n_4;
  wire prod0__283_carry__6_n_5;
  wire prod0__283_carry__6_n_6;
  wire prod0__283_carry__6_n_7;
  wire prod0__283_carry__7_i_1_n_0;
  wire prod0__283_carry__7_n_2;
  wire prod0__283_carry__7_n_7;
  wire prod0__283_carry_i_1_n_0;
  wire prod0__283_carry_i_2_n_0;
  wire prod0__283_carry_i_3_n_0;
  wire prod0__283_carry_i_4_n_0;
  wire prod0__283_carry_i_5_n_0;
  wire prod0__283_carry_i_6_n_0;
  wire prod0__283_carry_i_7_n_0;
  wire prod0__283_carry_i_8_n_0;
  wire prod0__283_carry_n_0;
  wire prod0__283_carry_n_1;
  wire prod0__283_carry_n_2;
  wire prod0__283_carry_n_3;
  wire prod0__283_carry_n_4;
  wire prod0__379_carry__0_i_10_n_0;
  wire prod0__379_carry__0_i_11_n_0;
  wire prod0__379_carry__0_i_1_n_0;
  wire prod0__379_carry__0_i_2_n_0;
  wire prod0__379_carry__0_i_3_n_0;
  wire prod0__379_carry__0_i_4_n_0;
  wire prod0__379_carry__0_i_5_n_0;
  wire prod0__379_carry__0_i_6_n_0;
  wire prod0__379_carry__0_i_7_n_0;
  wire prod0__379_carry__0_i_8_n_0;
  wire prod0__379_carry__0_i_9_n_0;
  wire prod0__379_carry__0_n_0;
  wire prod0__379_carry__0_n_1;
  wire prod0__379_carry__0_n_2;
  wire prod0__379_carry__0_n_3;
  wire prod0__379_carry__0_n_4;
  wire prod0__379_carry__0_n_5;
  wire prod0__379_carry__1_i_10_n_0;
  wire prod0__379_carry__1_i_11_n_0;
  wire prod0__379_carry__1_i_12_n_0;
  wire prod0__379_carry__1_i_1_n_0;
  wire prod0__379_carry__1_i_2_n_0;
  wire prod0__379_carry__1_i_3_n_0;
  wire prod0__379_carry__1_i_4_n_0;
  wire prod0__379_carry__1_i_5_n_0;
  wire prod0__379_carry__1_i_6_n_0;
  wire prod0__379_carry__1_i_7_n_0;
  wire prod0__379_carry__1_i_8_n_0;
  wire prod0__379_carry__1_i_9_n_0;
  wire prod0__379_carry__1_n_0;
  wire prod0__379_carry__1_n_1;
  wire prod0__379_carry__1_n_2;
  wire prod0__379_carry__1_n_3;
  wire prod0__379_carry__1_n_4;
  wire prod0__379_carry__1_n_5;
  wire prod0__379_carry__1_n_6;
  wire prod0__379_carry__1_n_7;
  wire prod0__379_carry__2_i_10_n_0;
  wire prod0__379_carry__2_i_11_n_0;
  wire prod0__379_carry__2_i_12_n_0;
  wire prod0__379_carry__2_i_1_n_0;
  wire prod0__379_carry__2_i_2_n_0;
  wire prod0__379_carry__2_i_3_n_0;
  wire prod0__379_carry__2_i_4_n_0;
  wire prod0__379_carry__2_i_5_n_0;
  wire prod0__379_carry__2_i_6_n_0;
  wire prod0__379_carry__2_i_7_n_0;
  wire prod0__379_carry__2_i_8_n_0;
  wire prod0__379_carry__2_i_9_n_0;
  wire prod0__379_carry__2_n_0;
  wire prod0__379_carry__2_n_1;
  wire prod0__379_carry__2_n_2;
  wire prod0__379_carry__2_n_3;
  wire prod0__379_carry__2_n_4;
  wire prod0__379_carry__2_n_5;
  wire prod0__379_carry__2_n_6;
  wire prod0__379_carry__2_n_7;
  wire prod0__379_carry__3_i_10_n_0;
  wire prod0__379_carry__3_i_11_n_0;
  wire prod0__379_carry__3_i_12_n_0;
  wire prod0__379_carry__3_i_1_n_0;
  wire prod0__379_carry__3_i_2_n_0;
  wire prod0__379_carry__3_i_3_n_0;
  wire prod0__379_carry__3_i_4_n_0;
  wire prod0__379_carry__3_i_5_n_0;
  wire prod0__379_carry__3_i_6_n_0;
  wire prod0__379_carry__3_i_7_n_0;
  wire prod0__379_carry__3_i_8_n_0;
  wire prod0__379_carry__3_i_9_n_0;
  wire prod0__379_carry__3_n_0;
  wire prod0__379_carry__3_n_1;
  wire prod0__379_carry__3_n_2;
  wire prod0__379_carry__3_n_3;
  wire prod0__379_carry__3_n_4;
  wire prod0__379_carry__3_n_5;
  wire prod0__379_carry__3_n_6;
  wire prod0__379_carry__3_n_7;
  wire prod0__379_carry__4_i_10_n_0;
  wire prod0__379_carry__4_i_11_n_0;
  wire prod0__379_carry__4_i_12_n_0;
  wire prod0__379_carry__4_i_1_n_0;
  wire prod0__379_carry__4_i_2_n_0;
  wire prod0__379_carry__4_i_3_n_0;
  wire prod0__379_carry__4_i_4_n_0;
  wire prod0__379_carry__4_i_5_n_0;
  wire prod0__379_carry__4_i_6_n_0;
  wire prod0__379_carry__4_i_7_n_0;
  wire prod0__379_carry__4_i_8_n_0;
  wire prod0__379_carry__4_i_9_n_0;
  wire prod0__379_carry__4_n_0;
  wire prod0__379_carry__4_n_1;
  wire prod0__379_carry__4_n_2;
  wire prod0__379_carry__4_n_3;
  wire prod0__379_carry__4_n_4;
  wire prod0__379_carry__4_n_5;
  wire prod0__379_carry__4_n_6;
  wire prod0__379_carry__4_n_7;
  wire prod0__379_carry__5_i_10_n_0;
  wire prod0__379_carry__5_i_11_n_0;
  wire prod0__379_carry__5_i_12_n_0;
  wire prod0__379_carry__5_i_1_n_0;
  wire prod0__379_carry__5_i_2_n_0;
  wire prod0__379_carry__5_i_3_n_0;
  wire prod0__379_carry__5_i_4_n_0;
  wire prod0__379_carry__5_i_5_n_0;
  wire prod0__379_carry__5_i_6_n_0;
  wire prod0__379_carry__5_i_7_n_0;
  wire prod0__379_carry__5_i_8_n_0;
  wire prod0__379_carry__5_i_9_n_0;
  wire prod0__379_carry__5_n_0;
  wire prod0__379_carry__5_n_1;
  wire prod0__379_carry__5_n_2;
  wire prod0__379_carry__5_n_3;
  wire prod0__379_carry__5_n_4;
  wire prod0__379_carry__5_n_5;
  wire prod0__379_carry__5_n_6;
  wire prod0__379_carry__5_n_7;
  wire prod0__379_carry__6_i_10_n_0;
  wire prod0__379_carry__6_i_11_n_0;
  wire prod0__379_carry__6_i_12_n_0;
  wire prod0__379_carry__6_i_1_n_0;
  wire prod0__379_carry__6_i_2_n_0;
  wire prod0__379_carry__6_i_3_n_0;
  wire prod0__379_carry__6_i_4_n_0;
  wire prod0__379_carry__6_i_5_n_0;
  wire prod0__379_carry__6_i_6_n_0;
  wire prod0__379_carry__6_i_7_n_0;
  wire prod0__379_carry__6_i_8_n_0;
  wire prod0__379_carry__6_i_9_n_0;
  wire prod0__379_carry__6_n_0;
  wire prod0__379_carry__6_n_1;
  wire prod0__379_carry__6_n_2;
  wire prod0__379_carry__6_n_3;
  wire prod0__379_carry__6_n_4;
  wire prod0__379_carry__6_n_5;
  wire prod0__379_carry__6_n_6;
  wire prod0__379_carry__6_n_7;
  wire prod0__379_carry__7_i_1_n_0;
  wire prod0__379_carry__7_i_2_n_0;
  wire prod0__379_carry__7_i_3_n_0;
  wire prod0__379_carry__7_i_4_n_0;
  wire prod0__379_carry__7_i_5_n_0;
  wire prod0__379_carry__7_i_6_n_0;
  wire prod0__379_carry__7_i_7_n_0;
  wire prod0__379_carry__7_i_8_n_0;
  wire prod0__379_carry__7_n_0;
  wire prod0__379_carry__7_n_1;
  wire prod0__379_carry__7_n_2;
  wire prod0__379_carry__7_n_3;
  wire prod0__379_carry__7_n_4;
  wire prod0__379_carry__7_n_5;
  wire prod0__379_carry__7_n_6;
  wire prod0__379_carry__7_n_7;
  wire prod0__379_carry__8_i_1_n_0;
  wire prod0__379_carry__8_i_2_n_0;
  wire prod0__379_carry__8_i_3_n_0;
  wire prod0__379_carry__8_n_3;
  wire prod0__379_carry__8_n_6;
  wire prod0__379_carry__8_n_7;
  wire prod0__379_carry_i_1_n_0;
  wire prod0__379_carry_i_2_n_0;
  wire prod0__379_carry_i_3_n_0;
  wire prod0__379_carry_i_4_n_0;
  wire prod0__379_carry_i_5_n_0;
  wire prod0__379_carry_i_6_n_0;
  wire prod0__379_carry_i_7_n_0;
  wire prod0__379_carry_i_8_n_0;
  wire prod0__379_carry_n_0;
  wire prod0__379_carry_n_1;
  wire prod0__379_carry_n_2;
  wire prod0__379_carry_n_3;
  wire prod0__70_carry_i_1_n_0;
  wire prod0__70_carry_i_2_n_0;
  wire prod0__70_carry_i_3_n_0;
  wire prod0__70_carry_n_0;
  wire prod0__70_carry_n_1;
  wire prod0__70_carry_n_2;
  wire prod0__70_carry_n_3;
  wire prod0__70_carry_n_4;
  wire prod0__70_carry_n_5;
  wire prod0__70_carry_n_6;
  wire prod0__70_carry_n_7;
  wire prod0__81_carry__0_i_1_n_0;
  wire prod0__81_carry__0_i_2_n_0;
  wire prod0__81_carry__0_i_3_n_0;
  wire prod0__81_carry__0_i_4_n_0;
  wire prod0__81_carry__0_n_0;
  wire prod0__81_carry__0_n_1;
  wire prod0__81_carry__0_n_2;
  wire prod0__81_carry__0_n_3;
  wire prod0__81_carry__0_n_4;
  wire prod0__81_carry__0_n_5;
  wire prod0__81_carry__0_n_6;
  wire prod0__81_carry__0_n_7;
  wire prod0__81_carry__1_i_1_n_0;
  wire prod0__81_carry__1_i_2_n_0;
  wire prod0__81_carry__1_i_3_n_0;
  wire prod0__81_carry__1_i_4_n_0;
  wire prod0__81_carry__1_n_0;
  wire prod0__81_carry__1_n_1;
  wire prod0__81_carry__1_n_2;
  wire prod0__81_carry__1_n_3;
  wire prod0__81_carry__1_n_4;
  wire prod0__81_carry__1_n_5;
  wire prod0__81_carry__1_n_6;
  wire prod0__81_carry__1_n_7;
  wire prod0__81_carry__2_i_1_n_0;
  wire prod0__81_carry__2_i_2_n_0;
  wire prod0__81_carry__2_i_3_n_0;
  wire prod0__81_carry__2_i_4_n_0;
  wire prod0__81_carry__2_n_0;
  wire prod0__81_carry__2_n_1;
  wire prod0__81_carry__2_n_2;
  wire prod0__81_carry__2_n_3;
  wire prod0__81_carry__2_n_4;
  wire prod0__81_carry__2_n_5;
  wire prod0__81_carry__2_n_6;
  wire prod0__81_carry__2_n_7;
  wire prod0__81_carry__3_i_1_n_0;
  wire prod0__81_carry__3_i_2_n_0;
  wire prod0__81_carry__3_i_3_n_0;
  wire prod0__81_carry__3_i_4_n_0;
  wire prod0__81_carry__3_n_0;
  wire prod0__81_carry__3_n_1;
  wire prod0__81_carry__3_n_2;
  wire prod0__81_carry__3_n_3;
  wire prod0__81_carry__3_n_4;
  wire prod0__81_carry__3_n_5;
  wire prod0__81_carry__3_n_6;
  wire prod0__81_carry__3_n_7;
  wire prod0__81_carry__4_i_1_n_0;
  wire prod0__81_carry__4_i_2_n_0;
  wire prod0__81_carry__4_i_3_n_0;
  wire prod0__81_carry__4_i_4_n_0;
  wire prod0__81_carry__4_n_0;
  wire prod0__81_carry__4_n_1;
  wire prod0__81_carry__4_n_2;
  wire prod0__81_carry__4_n_3;
  wire prod0__81_carry__4_n_4;
  wire prod0__81_carry__4_n_5;
  wire prod0__81_carry__4_n_6;
  wire prod0__81_carry__4_n_7;
  wire prod0__81_carry__5_i_1_n_0;
  wire prod0__81_carry__5_i_2_n_0;
  wire prod0__81_carry__5_i_3_n_0;
  wire prod0__81_carry__5_i_4_n_0;
  wire prod0__81_carry__5_n_0;
  wire prod0__81_carry__5_n_1;
  wire prod0__81_carry__5_n_2;
  wire prod0__81_carry__5_n_3;
  wire prod0__81_carry__5_n_4;
  wire prod0__81_carry__5_n_5;
  wire prod0__81_carry__5_n_6;
  wire prod0__81_carry__5_n_7;
  wire prod0__81_carry__6_i_1_n_0;
  wire prod0__81_carry__6_i_2_n_0;
  wire prod0__81_carry__6_i_3_n_0;
  wire prod0__81_carry__6_i_4_n_0;
  wire prod0__81_carry__6_n_0;
  wire prod0__81_carry__6_n_1;
  wire prod0__81_carry__6_n_2;
  wire prod0__81_carry__6_n_3;
  wire prod0__81_carry__6_n_4;
  wire prod0__81_carry__6_n_5;
  wire prod0__81_carry__6_n_6;
  wire prod0__81_carry__6_n_7;
  wire prod0__81_carry__7_i_1_n_0;
  wire prod0__81_carry__7_i_2_n_0;
  wire prod0__81_carry__7_n_1;
  wire prod0__81_carry__7_n_3;
  wire prod0__81_carry__7_n_6;
  wire prod0__81_carry__7_n_7;
  wire prod0__81_carry_i_1_n_0;
  wire prod0__81_carry_i_2_n_0;
  wire prod0__81_carry_i_3_n_0;
  wire prod0__81_carry_n_0;
  wire prod0__81_carry_n_1;
  wire prod0__81_carry_n_2;
  wire prod0__81_carry_n_3;
  wire prod0__81_carry_n_4;
  wire prod0__81_carry_n_5;
  wire prod0__81_carry_n_6;
  wire prod0_carry__0_i_1_n_0;
  wire prod0_carry__0_i_2_n_0;
  wire prod0_carry__0_i_3_n_0;
  wire prod0_carry__0_i_4_n_0;
  wire prod0_carry__0_n_0;
  wire prod0_carry__0_n_1;
  wire prod0_carry__0_n_2;
  wire prod0_carry__0_n_3;
  wire prod0_carry__0_n_4;
  wire prod0_carry__0_n_5;
  wire prod0_carry__0_n_6;
  wire prod0_carry__0_n_7;
  wire prod0_carry__1_i_1_n_0;
  wire prod0_carry__1_i_2_n_0;
  wire prod0_carry__1_i_3_n_0;
  wire prod0_carry__1_i_4_n_0;
  wire prod0_carry__1_n_0;
  wire prod0_carry__1_n_1;
  wire prod0_carry__1_n_2;
  wire prod0_carry__1_n_3;
  wire prod0_carry__1_n_4;
  wire prod0_carry__1_n_5;
  wire prod0_carry__1_n_6;
  wire prod0_carry__1_n_7;
  wire prod0_carry__2_i_1_n_0;
  wire prod0_carry__2_i_2_n_0;
  wire prod0_carry__2_i_3_n_0;
  wire prod0_carry__2_i_4_n_0;
  wire prod0_carry__2_n_0;
  wire prod0_carry__2_n_1;
  wire prod0_carry__2_n_2;
  wire prod0_carry__2_n_3;
  wire prod0_carry__2_n_4;
  wire prod0_carry__2_n_5;
  wire prod0_carry__2_n_6;
  wire prod0_carry__2_n_7;
  wire prod0_carry__3_i_1_n_0;
  wire prod0_carry__3_i_2_n_0;
  wire prod0_carry__3_i_3_n_0;
  wire prod0_carry__3_i_4_n_0;
  wire prod0_carry__3_n_0;
  wire prod0_carry__3_n_1;
  wire prod0_carry__3_n_2;
  wire prod0_carry__3_n_3;
  wire prod0_carry__3_n_4;
  wire prod0_carry__3_n_5;
  wire prod0_carry__3_n_6;
  wire prod0_carry__3_n_7;
  wire prod0_carry__4_i_1_n_0;
  wire prod0_carry__4_i_2_n_0;
  wire prod0_carry__4_i_3_n_0;
  wire prod0_carry__4_i_4_n_0;
  wire prod0_carry__4_n_0;
  wire prod0_carry__4_n_1;
  wire prod0_carry__4_n_2;
  wire prod0_carry__4_n_3;
  wire prod0_carry__4_n_4;
  wire prod0_carry__4_n_5;
  wire prod0_carry__4_n_6;
  wire prod0_carry__4_n_7;
  wire prod0_carry__5_i_1_n_0;
  wire prod0_carry__5_i_2_n_0;
  wire prod0_carry__5_i_3_n_0;
  wire prod0_carry__5_i_4_n_0;
  wire prod0_carry__5_n_0;
  wire prod0_carry__5_n_1;
  wire prod0_carry__5_n_2;
  wire prod0_carry__5_n_3;
  wire prod0_carry__5_n_4;
  wire prod0_carry__5_n_5;
  wire prod0_carry__5_n_6;
  wire prod0_carry__5_n_7;
  wire prod0_carry__6_i_1_n_0;
  wire prod0_carry__6_i_2_n_0;
  wire prod0_carry__6_i_3_n_0;
  wire prod0_carry__6_i_4_n_0;
  wire prod0_carry__6_i_5_n_0;
  wire prod0_carry__6_n_0;
  wire prod0_carry__6_n_1;
  wire prod0_carry__6_n_2;
  wire prod0_carry__6_n_3;
  wire prod0_carry__6_n_4;
  wire prod0_carry__6_n_5;
  wire prod0_carry__6_n_6;
  wire prod0_carry__6_n_7;
  wire prod0_carry__7_i_1_n_0;
  wire prod0_carry__7_i_2_n_0;
  wire prod0_carry__7_i_3_n_0;
  wire prod0_carry__7_i_4_n_0;
  wire prod0_carry__7_n_0;
  wire prod0_carry__7_n_2;
  wire prod0_carry__7_n_3;
  wire prod0_carry__7_n_5;
  wire prod0_carry__7_n_6;
  wire prod0_carry__7_n_7;
  wire prod0_carry_i_1_n_0;
  wire prod0_carry_i_2_n_0;
  wire prod0_carry_i_3_n_0;
  wire prod0_carry_n_0;
  wire prod0_carry_n_1;
  wire prod0_carry_n_2;
  wire prod0_carry_n_3;
  wire prod0_carry_n_7;
  wire reset_b;
  wire reset_b0_carry__0_i_1_n_0;
  wire reset_b0_carry__0_i_2_n_0;
  wire reset_b0_carry__0_i_3_n_0;
  wire reset_b0_carry__0_i_4_n_0;
  wire reset_b0_carry__0_i_5_n_0;
  wire reset_b0_carry__0_i_6_n_0;
  wire reset_b0_carry__0_i_7_n_0;
  wire reset_b0_carry__0_i_8_n_0;
  wire reset_b0_carry__0_n_0;
  wire reset_b0_carry__0_n_1;
  wire reset_b0_carry__0_n_2;
  wire reset_b0_carry__0_n_3;
  wire reset_b0_carry__1_i_1_n_0;
  wire reset_b0_carry__1_i_2_n_0;
  wire reset_b0_carry__1_i_3_n_0;
  wire reset_b0_carry__1_i_4_n_0;
  wire reset_b0_carry__1_i_5_n_0;
  wire reset_b0_carry__1_i_6_n_0;
  wire reset_b0_carry__1_i_7_n_0;
  wire reset_b0_carry__1_n_0;
  wire reset_b0_carry__1_n_1;
  wire reset_b0_carry__1_n_2;
  wire reset_b0_carry__1_n_3;
  wire reset_b0_carry__2_i_1_n_0;
  wire reset_b0_carry__2_i_2_n_0;
  wire reset_b0_carry__2_i_3_n_0;
  wire reset_b0_carry__2_i_4_n_0;
  wire reset_b0_carry__2_i_5_n_0;
  wire reset_b0_carry__2_i_6_n_0;
  wire reset_b0_carry__2_i_7_n_0;
  wire reset_b0_carry__2_i_8_n_0;
  wire reset_b0_carry__2_n_1;
  wire reset_b0_carry__2_n_2;
  wire reset_b0_carry__2_n_3;
  wire reset_b0_carry_i_1_n_0;
  wire reset_b0_carry_i_2_n_0;
  wire reset_b0_carry_i_3_n_0;
  wire reset_b0_carry_i_4_n_0;
  wire reset_b0_carry_i_5_n_0;
  wire reset_b0_carry_i_6_n_0;
  wire reset_b0_carry_i_7_n_0;
  wire reset_b0_carry_n_0;
  wire reset_b0_carry_n_1;
  wire reset_b0_carry_n_2;
  wire reset_b0_carry_n_3;
  wire s_axi_aclk;
  wire [7:0]s_axi_araddr;
  wire s_axi_araddr_5_sn_1;
  wire s_axi_aresetn;
  wire s_axi_aresetn_0;
  wire \s_axi_rdata[10]_i_2_n_0 ;
  wire \s_axi_rdata[11]_i_2_n_0 ;
  wire \s_axi_rdata[12]_i_2_n_0 ;
  wire \s_axi_rdata[13]_i_2_n_0 ;
  wire \s_axi_rdata[14]_i_2_n_0 ;
  wire \s_axi_rdata[15]_i_2_n_0 ;
  wire \s_axi_rdata[16]_i_2_n_0 ;
  wire \s_axi_rdata[17]_i_2_n_0 ;
  wire \s_axi_rdata[18]_i_2_n_0 ;
  wire \s_axi_rdata[19]_i_2_n_0 ;
  wire \s_axi_rdata[1]_i_2_n_0 ;
  wire \s_axi_rdata[20]_i_2_n_0 ;
  wire \s_axi_rdata[21]_i_2_n_0 ;
  wire \s_axi_rdata[22]_i_2_n_0 ;
  wire \s_axi_rdata[23]_i_2_n_0 ;
  wire \s_axi_rdata[24]_i_2_n_0 ;
  wire \s_axi_rdata[25]_i_2_n_0 ;
  wire \s_axi_rdata[26]_i_2_n_0 ;
  wire \s_axi_rdata[27]_i_2_n_0 ;
  wire \s_axi_rdata[28]_i_2_n_0 ;
  wire \s_axi_rdata[29]_i_2_n_0 ;
  wire \s_axi_rdata[2]_i_2_n_0 ;
  wire \s_axi_rdata[30]_i_2_n_0 ;
  wire \s_axi_rdata[31]_i_2_n_0 ;
  wire \s_axi_rdata[3]_i_2_n_0 ;
  wire \s_axi_rdata[4]_i_2_n_0 ;
  wire \s_axi_rdata[5]_i_2_n_0 ;
  wire \s_axi_rdata[6]_i_2_n_0 ;
  wire \s_axi_rdata[7]_i_2_n_0 ;
  wire \s_axi_rdata[8]_i_2_n_0 ;
  wire \s_axi_rdata[9]_i_2_n_0 ;
  wire \s_axi_rdata_reg[0] ;
  wire \s_axi_rdata_reg[0]_0 ;
  wire spk_out;
  wire spk_out_i_10_n_0;
  wire spk_out_i_12_n_0;
  wire spk_out_i_13_n_0;
  wire spk_out_i_14_n_0;
  wire spk_out_i_15_n_0;
  wire spk_out_i_16_n_0;
  wire spk_out_i_17_n_0;
  wire spk_out_i_18_n_0;
  wire spk_out_i_20_n_0;
  wire spk_out_i_21_n_0;
  wire spk_out_i_22_n_0;
  wire spk_out_i_23_n_0;
  wire spk_out_i_24_n_0;
  wire spk_out_i_25_n_0;
  wire spk_out_i_26_n_0;
  wire spk_out_i_27_n_0;
  wire spk_out_i_28_n_0;
  wire spk_out_i_29_n_0;
  wire spk_out_i_30_n_0;
  wire spk_out_i_31_n_0;
  wire spk_out_i_32_n_0;
  wire spk_out_i_33_n_0;
  wire spk_out_i_34_n_0;
  wire spk_out_i_35_n_0;
  wire spk_out_i_3_n_0;
  wire spk_out_i_4_n_0;
  wire spk_out_i_5_n_0;
  wire spk_out_i_6_n_0;
  wire spk_out_i_7_n_0;
  wire spk_out_i_8_n_0;
  wire spk_out_i_9_n_0;
  wire spk_out_reg_i_11_n_0;
  wire spk_out_reg_i_11_n_1;
  wire spk_out_reg_i_11_n_2;
  wire spk_out_reg_i_11_n_3;
  wire spk_out_reg_i_19_n_0;
  wire spk_out_reg_i_19_n_1;
  wire spk_out_reg_i_19_n_2;
  wire spk_out_reg_i_19_n_3;
  wire spk_out_reg_i_1_n_0;
  wire spk_out_reg_i_1_n_1;
  wire spk_out_reg_i_1_n_2;
  wire spk_out_reg_i_1_n_3;
  wire spk_out_reg_i_2_n_0;
  wire spk_out_reg_i_2_n_1;
  wire spk_out_reg_i_2_n_2;
  wire spk_out_reg_i_2_n_3;
  wire start_pulse;
  wire [3:3]NLW_mem_tmp0_carry__6_CO_UNCONNECTED;
  wire [0:0]NLW_prod0__179_carry_O_UNCONNECTED;
  wire [3:2]NLW_prod0__179_carry__7_CO_UNCONNECTED;
  wire [3:3]NLW_prod0__179_carry__7_O_UNCONNECTED;
  wire [3:0]NLW_prod0__249_carry__3_CO_UNCONNECTED;
  wire [3:1]NLW_prod0__249_carry__3_O_UNCONNECTED;
  wire [2:0]NLW_prod0__283_carry_O_UNCONNECTED;
  wire [3:1]NLW_prod0__283_carry__6_i_9_CO_UNCONNECTED;
  wire [3:0]NLW_prod0__283_carry__6_i_9_O_UNCONNECTED;
  wire [3:0]NLW_prod0__283_carry__7_CO_UNCONNECTED;
  wire [3:1]NLW_prod0__283_carry__7_O_UNCONNECTED;
  wire [3:0]NLW_prod0__379_carry_O_UNCONNECTED;
  wire [1:0]NLW_prod0__379_carry__0_O_UNCONNECTED;
  wire [3:1]NLW_prod0__379_carry__8_CO_UNCONNECTED;
  wire [3:2]NLW_prod0__379_carry__8_O_UNCONNECTED;
  wire [0:0]NLW_prod0__81_carry_O_UNCONNECTED;
  wire [3:1]NLW_prod0__81_carry__7_CO_UNCONNECTED;
  wire [3:2]NLW_prod0__81_carry__7_O_UNCONNECTED;
  wire [3:1]NLW_prod0_carry_O_UNCONNECTED;
  wire [2:2]NLW_prod0_carry__7_CO_UNCONNECTED;
  wire [3:3]NLW_prod0_carry__7_O_UNCONNECTED;
  wire [3:0]NLW_reset_b0_carry_O_UNCONNECTED;
  wire [3:0]NLW_reset_b0_carry__0_O_UNCONNECTED;
  wire [3:0]NLW_reset_b0_carry__1_O_UNCONNECTED;
  wire [3:0]NLW_reset_b0_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_spk_out_reg_i_1_O_UNCONNECTED;
  wire [3:0]NLW_spk_out_reg_i_11_O_UNCONNECTED;
  wire [3:0]NLW_spk_out_reg_i_19_O_UNCONNECTED;
  wire [3:0]NLW_spk_out_reg_i_2_O_UNCONNECTED;

  assign s_axi_araddr_5_sp_1 = s_axi_araddr_5_sn_1;
  LUT4 #(
    .INIT(16'hAAAE)) 
    \FSM_onehot_st[0]_i_1 
       (.I0(\FSM_onehot_st_reg_n_0_[2] ),
        .I1(\FSM_onehot_st_reg_n_0_[0] ),
        .I2(start_pulse),
        .I3(mem_tmp_0),
        .O(\FSM_onehot_st[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hCCC8)) 
    \FSM_onehot_st[1]_i_1 
       (.I0(\FSM_onehot_st_reg_n_0_[2] ),
        .I1(\FSM_onehot_st_reg_n_0_[0] ),
        .I2(start_pulse),
        .I3(mem_tmp_0),
        .O(\FSM_onehot_st[1]_i_1_n_0 ));
  (* FSM_ENCODED_STATES = "iSTATE:001,iSTATE0:010,iSTATE1:100," *) 
  FDPE #(
    .INIT(1'b1)) 
    \FSM_onehot_st_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_st[0]_i_1_n_0 ),
        .PRE(s_axi_aresetn_0),
        .Q(\FSM_onehot_st_reg_n_0_[0] ));
  (* FSM_ENCODED_STATES = "iSTATE:001,iSTATE0:010,iSTATE1:100," *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_st_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(s_axi_aresetn_0),
        .D(\FSM_onehot_st[1]_i_1_n_0 ),
        .Q(mem_tmp_0));
  (* FSM_ENCODED_STATES = "iSTATE:001,iSTATE0:010,iSTATE1:100," *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_onehot_st_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp_0),
        .Q(\FSM_onehot_st_reg_n_0_[2] ));
  FDCE done_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(s_axi_aresetn_0),
        .D(\FSM_onehot_st_reg_n_0_[2] ),
        .Q(done));
  LUT6 #(
    .INIT(64'hFFFFFDFFFFFF0000)) 
    done_sticky_i_1
       (.I0(done_sticky_reg),
        .I1(s_axi_araddr[5]),
        .I2(s_axi_araddr[4]),
        .I3(done_sticky_reg_0),
        .I4(done),
        .I5(data0),
        .O(s_axi_araddr_5_sn_1));
  FDCE \mem_out_q16_reg[0] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[0]),
        .Q(mem_out_q16[0]));
  FDCE \mem_out_q16_reg[10] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[10]),
        .Q(mem_out_q16[10]));
  FDCE \mem_out_q16_reg[11] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[11]),
        .Q(mem_out_q16[11]));
  FDCE \mem_out_q16_reg[12] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[12]),
        .Q(mem_out_q16[12]));
  FDCE \mem_out_q16_reg[13] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[13]),
        .Q(mem_out_q16[13]));
  FDCE \mem_out_q16_reg[14] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[14]),
        .Q(mem_out_q16[14]));
  FDCE \mem_out_q16_reg[15] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[15]),
        .Q(mem_out_q16[15]));
  FDCE \mem_out_q16_reg[16] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[16]),
        .Q(mem_out_q16[16]));
  FDCE \mem_out_q16_reg[17] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[17]),
        .Q(mem_out_q16[17]));
  FDCE \mem_out_q16_reg[18] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[18]),
        .Q(mem_out_q16[18]));
  FDCE \mem_out_q16_reg[19] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[19]),
        .Q(mem_out_q16[19]));
  FDCE \mem_out_q16_reg[1] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[1]),
        .Q(mem_out_q16[1]));
  FDCE \mem_out_q16_reg[20] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[20]),
        .Q(mem_out_q16[20]));
  FDCE \mem_out_q16_reg[21] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[21]),
        .Q(mem_out_q16[21]));
  FDCE \mem_out_q16_reg[22] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[22]),
        .Q(mem_out_q16[22]));
  FDCE \mem_out_q16_reg[23] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[23]),
        .Q(mem_out_q16[23]));
  FDCE \mem_out_q16_reg[24] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[24]),
        .Q(mem_out_q16[24]));
  FDCE \mem_out_q16_reg[25] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[25]),
        .Q(mem_out_q16[25]));
  FDCE \mem_out_q16_reg[26] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[26]),
        .Q(mem_out_q16[26]));
  FDCE \mem_out_q16_reg[27] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[27]),
        .Q(mem_out_q16[27]));
  FDCE \mem_out_q16_reg[28] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[28]),
        .Q(mem_out_q16[28]));
  FDCE \mem_out_q16_reg[29] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[29]),
        .Q(mem_out_q16[29]));
  FDCE \mem_out_q16_reg[2] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[2]),
        .Q(mem_out_q16[2]));
  FDCE \mem_out_q16_reg[30] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[30]),
        .Q(mem_out_q16[30]));
  FDCE \mem_out_q16_reg[31] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[31]),
        .Q(mem_out_q16[31]));
  FDCE \mem_out_q16_reg[3] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[3]),
        .Q(mem_out_q16[3]));
  FDCE \mem_out_q16_reg[4] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[4]),
        .Q(mem_out_q16[4]));
  FDCE \mem_out_q16_reg[5] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[5]),
        .Q(mem_out_q16[5]));
  FDCE \mem_out_q16_reg[6] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[6]),
        .Q(mem_out_q16[6]));
  FDCE \mem_out_q16_reg[7] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[7]),
        .Q(mem_out_q16[7]));
  FDCE \mem_out_q16_reg[8] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[8]),
        .Q(mem_out_q16[8]));
  FDCE \mem_out_q16_reg[9] 
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp[9]),
        .Q(mem_out_q16[9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry
       (.CI(1'b0),
        .CO({mem_tmp0_carry_n_0,mem_tmp0_carry_n_1,mem_tmp0_carry_n_2,mem_tmp0_carry_n_3}),
        .CYINIT(1'b0),
        .DI(p_0_in1_in[3:0]),
        .O(mem_tmp0[3:0]),
        .S({mem_tmp0_carry_i_1_n_0,mem_tmp0_carry_i_2_n_0,mem_tmp0_carry_i_3_n_0,mem_tmp0_carry_i_4_n_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__0
       (.CI(mem_tmp0_carry_n_0),
        .CO({mem_tmp0_carry__0_n_0,mem_tmp0_carry__0_n_1,mem_tmp0_carry__0_n_2,mem_tmp0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(p_0_in1_in[7:4]),
        .O(mem_tmp0[7:4]),
        .S({mem_tmp0_carry__0_i_1_n_0,mem_tmp0_carry__0_i_2_n_0,mem_tmp0_carry__0_i_3_n_0,mem_tmp0_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__0_i_1
       (.I0(p_0_in1_in[7]),
        .I1(\mem_tmp_reg[31]_0 [7]),
        .O(mem_tmp0_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__0_i_2
       (.I0(p_0_in1_in[6]),
        .I1(\mem_tmp_reg[31]_0 [6]),
        .O(mem_tmp0_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__0_i_3
       (.I0(p_0_in1_in[5]),
        .I1(\mem_tmp_reg[31]_0 [5]),
        .O(mem_tmp0_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__0_i_4
       (.I0(p_0_in1_in[4]),
        .I1(\mem_tmp_reg[31]_0 [4]),
        .O(mem_tmp0_carry__0_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__1
       (.CI(mem_tmp0_carry__0_n_0),
        .CO({mem_tmp0_carry__1_n_0,mem_tmp0_carry__1_n_1,mem_tmp0_carry__1_n_2,mem_tmp0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(p_0_in1_in[11:8]),
        .O(mem_tmp0[11:8]),
        .S({mem_tmp0_carry__1_i_1_n_0,mem_tmp0_carry__1_i_2_n_0,mem_tmp0_carry__1_i_3_n_0,mem_tmp0_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__1_i_1
       (.I0(p_0_in1_in[11]),
        .I1(\mem_tmp_reg[31]_0 [11]),
        .O(mem_tmp0_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__1_i_2
       (.I0(p_0_in1_in[10]),
        .I1(\mem_tmp_reg[31]_0 [10]),
        .O(mem_tmp0_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__1_i_3
       (.I0(p_0_in1_in[9]),
        .I1(\mem_tmp_reg[31]_0 [9]),
        .O(mem_tmp0_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__1_i_4
       (.I0(p_0_in1_in[8]),
        .I1(\mem_tmp_reg[31]_0 [8]),
        .O(mem_tmp0_carry__1_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__2
       (.CI(mem_tmp0_carry__1_n_0),
        .CO({mem_tmp0_carry__2_n_0,mem_tmp0_carry__2_n_1,mem_tmp0_carry__2_n_2,mem_tmp0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(p_0_in1_in[15:12]),
        .O(mem_tmp0[15:12]),
        .S({mem_tmp0_carry__2_i_1_n_0,mem_tmp0_carry__2_i_2_n_0,mem_tmp0_carry__2_i_3_n_0,mem_tmp0_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__2_i_1
       (.I0(p_0_in1_in[15]),
        .I1(\mem_tmp_reg[31]_0 [15]),
        .O(mem_tmp0_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__2_i_2
       (.I0(p_0_in1_in[14]),
        .I1(\mem_tmp_reg[31]_0 [14]),
        .O(mem_tmp0_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__2_i_3
       (.I0(p_0_in1_in[13]),
        .I1(\mem_tmp_reg[31]_0 [13]),
        .O(mem_tmp0_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry__2_i_4
       (.I0(p_0_in1_in[12]),
        .I1(\mem_tmp_reg[31]_0 [12]),
        .O(mem_tmp0_carry__2_i_4_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__3
       (.CI(mem_tmp0_carry__2_n_0),
        .CO({mem_tmp0_carry__3_n_0,mem_tmp0_carry__3_n_1,mem_tmp0_carry__3_n_2,mem_tmp0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({mem_tmp0_carry__3_i_1_n_0,mem_tmp0_carry__3_i_2_n_0,mem_tmp0_carry__3_i_3_n_0,p_0_in1_in[16]}),
        .O(mem_tmp0[19:16]),
        .S({mem_tmp0_carry__3_i_4_n_0,mem_tmp0_carry__3_i_5_n_0,mem_tmp0_carry__3_i_6_n_0,mem_tmp0_carry__3_i_7_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__3_i_1
       (.I0(p_0_in1_in[18]),
        .I1(\mem_tmp_reg[31]_0 [18]),
        .O(mem_tmp0_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__3_i_2
       (.I0(p_0_in1_in[17]),
        .I1(\mem_tmp_reg[31]_0 [17]),
        .O(mem_tmp0_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'hB)) 
    mem_tmp0_carry__3_i_3
       (.I0(\mem_tmp_reg[31]_0 [16]),
        .I1(reset_b),
        .O(mem_tmp0_carry__3_i_3_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__3_i_4
       (.I0(\mem_tmp_reg[31]_0 [18]),
        .I1(p_0_in1_in[18]),
        .I2(\mem_tmp_reg[31]_0 [19]),
        .I3(p_0_in1_in[19]),
        .O(mem_tmp0_carry__3_i_4_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__3_i_5
       (.I0(\mem_tmp_reg[31]_0 [17]),
        .I1(p_0_in1_in[17]),
        .I2(\mem_tmp_reg[31]_0 [18]),
        .I3(p_0_in1_in[18]),
        .O(mem_tmp0_carry__3_i_5_n_0));
  LUT4 #(
    .INIT(16'h2DD2)) 
    mem_tmp0_carry__3_i_6
       (.I0(reset_b),
        .I1(\mem_tmp_reg[31]_0 [16]),
        .I2(\mem_tmp_reg[31]_0 [17]),
        .I3(p_0_in1_in[17]),
        .O(mem_tmp0_carry__3_i_6_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    mem_tmp0_carry__3_i_7
       (.I0(reset_b),
        .I1(\mem_tmp_reg[31]_0 [16]),
        .I2(p_0_in1_in[16]),
        .O(mem_tmp0_carry__3_i_7_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__4
       (.CI(mem_tmp0_carry__3_n_0),
        .CO({mem_tmp0_carry__4_n_0,mem_tmp0_carry__4_n_1,mem_tmp0_carry__4_n_2,mem_tmp0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({mem_tmp0_carry__4_i_1_n_0,mem_tmp0_carry__4_i_2_n_0,mem_tmp0_carry__4_i_3_n_0,mem_tmp0_carry__4_i_4_n_0}),
        .O(mem_tmp0[23:20]),
        .S({mem_tmp0_carry__4_i_5_n_0,mem_tmp0_carry__4_i_6_n_0,mem_tmp0_carry__4_i_7_n_0,mem_tmp0_carry__4_i_8_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__4_i_1
       (.I0(p_0_in1_in[22]),
        .I1(\mem_tmp_reg[31]_0 [22]),
        .O(mem_tmp0_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__4_i_2
       (.I0(p_0_in1_in[21]),
        .I1(\mem_tmp_reg[31]_0 [21]),
        .O(mem_tmp0_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__4_i_3
       (.I0(p_0_in1_in[20]),
        .I1(\mem_tmp_reg[31]_0 [20]),
        .O(mem_tmp0_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__4_i_4
       (.I0(p_0_in1_in[19]),
        .I1(\mem_tmp_reg[31]_0 [19]),
        .O(mem_tmp0_carry__4_i_4_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__4_i_5
       (.I0(\mem_tmp_reg[31]_0 [22]),
        .I1(p_0_in1_in[22]),
        .I2(\mem_tmp_reg[31]_0 [23]),
        .I3(p_0_in1_in[23]),
        .O(mem_tmp0_carry__4_i_5_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__4_i_6
       (.I0(\mem_tmp_reg[31]_0 [21]),
        .I1(p_0_in1_in[21]),
        .I2(\mem_tmp_reg[31]_0 [22]),
        .I3(p_0_in1_in[22]),
        .O(mem_tmp0_carry__4_i_6_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__4_i_7
       (.I0(\mem_tmp_reg[31]_0 [20]),
        .I1(p_0_in1_in[20]),
        .I2(\mem_tmp_reg[31]_0 [21]),
        .I3(p_0_in1_in[21]),
        .O(mem_tmp0_carry__4_i_7_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__4_i_8
       (.I0(\mem_tmp_reg[31]_0 [19]),
        .I1(p_0_in1_in[19]),
        .I2(\mem_tmp_reg[31]_0 [20]),
        .I3(p_0_in1_in[20]),
        .O(mem_tmp0_carry__4_i_8_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__5
       (.CI(mem_tmp0_carry__4_n_0),
        .CO({mem_tmp0_carry__5_n_0,mem_tmp0_carry__5_n_1,mem_tmp0_carry__5_n_2,mem_tmp0_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({mem_tmp0_carry__5_i_1_n_0,mem_tmp0_carry__5_i_2_n_0,mem_tmp0_carry__5_i_3_n_0,mem_tmp0_carry__5_i_4_n_0}),
        .O(mem_tmp0[27:24]),
        .S({mem_tmp0_carry__5_i_5_n_0,mem_tmp0_carry__5_i_6_n_0,mem_tmp0_carry__5_i_7_n_0,mem_tmp0_carry__5_i_8_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__5_i_1
       (.I0(p_0_in1_in[26]),
        .I1(\mem_tmp_reg[31]_0 [26]),
        .O(mem_tmp0_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__5_i_2
       (.I0(p_0_in1_in[25]),
        .I1(\mem_tmp_reg[31]_0 [25]),
        .O(mem_tmp0_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__5_i_3
       (.I0(p_0_in1_in[24]),
        .I1(\mem_tmp_reg[31]_0 [24]),
        .O(mem_tmp0_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__5_i_4
       (.I0(p_0_in1_in[23]),
        .I1(\mem_tmp_reg[31]_0 [23]),
        .O(mem_tmp0_carry__5_i_4_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__5_i_5
       (.I0(\mem_tmp_reg[31]_0 [26]),
        .I1(p_0_in1_in[26]),
        .I2(\mem_tmp_reg[31]_0 [27]),
        .I3(p_0_in1_in[27]),
        .O(mem_tmp0_carry__5_i_5_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__5_i_6
       (.I0(\mem_tmp_reg[31]_0 [25]),
        .I1(p_0_in1_in[25]),
        .I2(\mem_tmp_reg[31]_0 [26]),
        .I3(p_0_in1_in[26]),
        .O(mem_tmp0_carry__5_i_6_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__5_i_7
       (.I0(\mem_tmp_reg[31]_0 [24]),
        .I1(p_0_in1_in[24]),
        .I2(\mem_tmp_reg[31]_0 [25]),
        .I3(p_0_in1_in[25]),
        .O(mem_tmp0_carry__5_i_7_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__5_i_8
       (.I0(\mem_tmp_reg[31]_0 [23]),
        .I1(p_0_in1_in[23]),
        .I2(\mem_tmp_reg[31]_0 [24]),
        .I3(p_0_in1_in[24]),
        .O(mem_tmp0_carry__5_i_8_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 mem_tmp0_carry__6
       (.CI(mem_tmp0_carry__5_n_0),
        .CO({NLW_mem_tmp0_carry__6_CO_UNCONNECTED[3],mem_tmp0_carry__6_n_1,mem_tmp0_carry__6_n_2,mem_tmp0_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,mem_tmp0_carry__6_i_1_n_0,mem_tmp0_carry__6_i_2_n_0,mem_tmp0_carry__6_i_3_n_0}),
        .O(mem_tmp0[31:28]),
        .S({mem_tmp0_carry__6_i_4_n_0,mem_tmp0_carry__6_i_5_n_0,mem_tmp0_carry__6_i_6_n_0,mem_tmp0_carry__6_i_7_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__6_i_1
       (.I0(p_0_in1_in[29]),
        .I1(\mem_tmp_reg[31]_0 [29]),
        .O(mem_tmp0_carry__6_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__6_i_2
       (.I0(p_0_in1_in[28]),
        .I1(\mem_tmp_reg[31]_0 [28]),
        .O(mem_tmp0_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    mem_tmp0_carry__6_i_3
       (.I0(p_0_in1_in[27]),
        .I1(\mem_tmp_reg[31]_0 [27]),
        .O(mem_tmp0_carry__6_i_3_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__6_i_4
       (.I0(\mem_tmp_reg[31]_0 [30]),
        .I1(p_0_in1_in[30]),
        .I2(\mem_tmp_reg[31]_0 [31]),
        .I3(p_0_in1_in[31]),
        .O(mem_tmp0_carry__6_i_4_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__6_i_5
       (.I0(\mem_tmp_reg[31]_0 [29]),
        .I1(p_0_in1_in[29]),
        .I2(\mem_tmp_reg[31]_0 [30]),
        .I3(p_0_in1_in[30]),
        .O(mem_tmp0_carry__6_i_5_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__6_i_6
       (.I0(\mem_tmp_reg[31]_0 [28]),
        .I1(p_0_in1_in[28]),
        .I2(\mem_tmp_reg[31]_0 [29]),
        .I3(p_0_in1_in[29]),
        .O(mem_tmp0_carry__6_i_6_n_0));
  LUT4 #(
    .INIT(16'h1EE1)) 
    mem_tmp0_carry__6_i_7
       (.I0(\mem_tmp_reg[31]_0 [27]),
        .I1(p_0_in1_in[27]),
        .I2(\mem_tmp_reg[31]_0 [28]),
        .I3(p_0_in1_in[28]),
        .O(mem_tmp0_carry__6_i_7_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry_i_1
       (.I0(p_0_in1_in[3]),
        .I1(\mem_tmp_reg[31]_0 [3]),
        .O(mem_tmp0_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry_i_2
       (.I0(p_0_in1_in[2]),
        .I1(\mem_tmp_reg[31]_0 [2]),
        .O(mem_tmp0_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry_i_3
       (.I0(p_0_in1_in[1]),
        .I1(\mem_tmp_reg[31]_0 [1]),
        .O(mem_tmp0_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    mem_tmp0_carry_i_4
       (.I0(p_0_in1_in[0]),
        .I1(\mem_tmp_reg[31]_0 [0]),
        .O(mem_tmp0_carry_i_4_n_0));
  FDCE \mem_tmp_reg[0] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[0]),
        .Q(mem_tmp[0]));
  FDCE \mem_tmp_reg[10] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[10]),
        .Q(mem_tmp[10]));
  FDCE \mem_tmp_reg[11] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[11]),
        .Q(mem_tmp[11]));
  FDCE \mem_tmp_reg[12] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[12]),
        .Q(mem_tmp[12]));
  FDCE \mem_tmp_reg[13] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[13]),
        .Q(mem_tmp[13]));
  FDCE \mem_tmp_reg[14] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[14]),
        .Q(mem_tmp[14]));
  FDCE \mem_tmp_reg[15] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[15]),
        .Q(mem_tmp[15]));
  FDCE \mem_tmp_reg[16] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[16]),
        .Q(mem_tmp[16]));
  FDCE \mem_tmp_reg[17] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[17]),
        .Q(mem_tmp[17]));
  FDCE \mem_tmp_reg[18] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[18]),
        .Q(mem_tmp[18]));
  FDCE \mem_tmp_reg[19] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[19]),
        .Q(mem_tmp[19]));
  FDCE \mem_tmp_reg[1] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[1]),
        .Q(mem_tmp[1]));
  FDCE \mem_tmp_reg[20] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[20]),
        .Q(mem_tmp[20]));
  FDCE \mem_tmp_reg[21] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[21]),
        .Q(mem_tmp[21]));
  FDCE \mem_tmp_reg[22] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[22]),
        .Q(mem_tmp[22]));
  FDCE \mem_tmp_reg[23] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[23]),
        .Q(mem_tmp[23]));
  FDCE \mem_tmp_reg[24] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[24]),
        .Q(mem_tmp[24]));
  FDCE \mem_tmp_reg[25] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[25]),
        .Q(mem_tmp[25]));
  FDCE \mem_tmp_reg[26] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[26]),
        .Q(mem_tmp[26]));
  FDCE \mem_tmp_reg[27] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[27]),
        .Q(mem_tmp[27]));
  FDCE \mem_tmp_reg[28] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[28]),
        .Q(mem_tmp[28]));
  FDCE \mem_tmp_reg[29] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[29]),
        .Q(mem_tmp[29]));
  FDCE \mem_tmp_reg[2] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[2]),
        .Q(mem_tmp[2]));
  FDCE \mem_tmp_reg[30] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[30]),
        .Q(mem_tmp[30]));
  FDCE \mem_tmp_reg[31] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[31]),
        .Q(mem_tmp[31]));
  FDCE \mem_tmp_reg[3] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[3]),
        .Q(mem_tmp[3]));
  FDCE \mem_tmp_reg[4] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[4]),
        .Q(mem_tmp[4]));
  FDCE \mem_tmp_reg[5] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[5]),
        .Q(mem_tmp[5]));
  FDCE \mem_tmp_reg[6] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[6]),
        .Q(mem_tmp[6]));
  FDCE \mem_tmp_reg[7] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[7]),
        .Q(mem_tmp[7]));
  FDCE \mem_tmp_reg[8] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[8]),
        .Q(mem_tmp[8]));
  FDCE \mem_tmp_reg[9] 
       (.C(s_axi_aclk),
        .CE(mem_tmp_0),
        .CLR(s_axi_aresetn_0),
        .D(mem_tmp0[9]),
        .Q(mem_tmp[9]));
  CARRY4 prod0__179_carry
       (.CI(1'b0),
        .CO({prod0__179_carry_n_0,prod0__179_carry_n_1,prod0__179_carry_n_2,prod0__179_carry_n_3}),
        .CYINIT(1'b0),
        .DI({Q[1:0],1'b0,1'b1}),
        .O({prod0__179_carry_n_4,prod0__179_carry_n_5,prod0__179_carry_n_6,NLW_prod0__179_carry_O_UNCONNECTED[0]}),
        .S({prod0__179_carry_i_1_n_0,prod0__179_carry_i_2_n_0,prod0__179_carry_i_3_n_0,Q[0]}));
  CARRY4 prod0__179_carry__0
       (.CI(prod0__179_carry_n_0),
        .CO({prod0__179_carry__0_n_0,prod0__179_carry__0_n_1,prod0__179_carry__0_n_2,prod0__179_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(Q[5:2]),
        .O({prod0__179_carry__0_n_4,prod0__179_carry__0_n_5,prod0__179_carry__0_n_6,prod0__179_carry__0_n_7}),
        .S({prod0__179_carry__0_i_1_n_0,prod0__179_carry__0_i_2_n_0,prod0__179_carry__0_i_3_n_0,prod0__179_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__0_i_1
       (.I0(Q[5]),
        .I1(Q[7]),
        .O(prod0__179_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__0_i_2
       (.I0(Q[4]),
        .I1(Q[6]),
        .O(prod0__179_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__0_i_3
       (.I0(Q[3]),
        .I1(Q[5]),
        .O(prod0__179_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__0_i_4
       (.I0(Q[2]),
        .I1(Q[4]),
        .O(prod0__179_carry__0_i_4_n_0));
  CARRY4 prod0__179_carry__1
       (.CI(prod0__179_carry__0_n_0),
        .CO({prod0__179_carry__1_n_0,prod0__179_carry__1_n_1,prod0__179_carry__1_n_2,prod0__179_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(Q[9:6]),
        .O({prod0__179_carry__1_n_4,prod0__179_carry__1_n_5,prod0__179_carry__1_n_6,prod0__179_carry__1_n_7}),
        .S({prod0__179_carry__1_i_1_n_0,prod0__179_carry__1_i_2_n_0,prod0__179_carry__1_i_3_n_0,prod0__179_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__1_i_1
       (.I0(Q[9]),
        .I1(Q[11]),
        .O(prod0__179_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__1_i_2
       (.I0(Q[8]),
        .I1(Q[10]),
        .O(prod0__179_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__1_i_3
       (.I0(Q[7]),
        .I1(Q[9]),
        .O(prod0__179_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__1_i_4
       (.I0(Q[6]),
        .I1(Q[8]),
        .O(prod0__179_carry__1_i_4_n_0));
  CARRY4 prod0__179_carry__2
       (.CI(prod0__179_carry__1_n_0),
        .CO({prod0__179_carry__2_n_0,prod0__179_carry__2_n_1,prod0__179_carry__2_n_2,prod0__179_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(Q[13:10]),
        .O({prod0__179_carry__2_n_4,prod0__179_carry__2_n_5,prod0__179_carry__2_n_6,prod0__179_carry__2_n_7}),
        .S({prod0__179_carry__2_i_1_n_0,prod0__179_carry__2_i_2_n_0,prod0__179_carry__2_i_3_n_0,prod0__179_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__2_i_1
       (.I0(Q[13]),
        .I1(Q[15]),
        .O(prod0__179_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__2_i_2
       (.I0(Q[12]),
        .I1(Q[14]),
        .O(prod0__179_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__2_i_3
       (.I0(Q[11]),
        .I1(Q[13]),
        .O(prod0__179_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__2_i_4
       (.I0(Q[10]),
        .I1(Q[12]),
        .O(prod0__179_carry__2_i_4_n_0));
  CARRY4 prod0__179_carry__3
       (.CI(prod0__179_carry__2_n_0),
        .CO({prod0__179_carry__3_n_0,prod0__179_carry__3_n_1,prod0__179_carry__3_n_2,prod0__179_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(Q[17:14]),
        .O({prod0__179_carry__3_n_4,prod0__179_carry__3_n_5,prod0__179_carry__3_n_6,prod0__179_carry__3_n_7}),
        .S({prod0__179_carry__3_i_1_n_0,prod0__179_carry__3_i_2_n_0,prod0__179_carry__3_i_3_n_0,prod0__179_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__3_i_1
       (.I0(Q[17]),
        .I1(Q[19]),
        .O(prod0__179_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__3_i_2
       (.I0(Q[16]),
        .I1(Q[18]),
        .O(prod0__179_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__3_i_3
       (.I0(Q[15]),
        .I1(Q[17]),
        .O(prod0__179_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__3_i_4
       (.I0(Q[14]),
        .I1(Q[16]),
        .O(prod0__179_carry__3_i_4_n_0));
  CARRY4 prod0__179_carry__4
       (.CI(prod0__179_carry__3_n_0),
        .CO({prod0__179_carry__4_n_0,prod0__179_carry__4_n_1,prod0__179_carry__4_n_2,prod0__179_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(Q[21:18]),
        .O({prod0__179_carry__4_n_4,prod0__179_carry__4_n_5,prod0__179_carry__4_n_6,prod0__179_carry__4_n_7}),
        .S({prod0__179_carry__4_i_1_n_0,prod0__179_carry__4_i_2_n_0,prod0__179_carry__4_i_3_n_0,prod0__179_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__4_i_1
       (.I0(Q[21]),
        .I1(Q[23]),
        .O(prod0__179_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__4_i_2
       (.I0(Q[20]),
        .I1(Q[22]),
        .O(prod0__179_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__4_i_3
       (.I0(Q[19]),
        .I1(Q[21]),
        .O(prod0__179_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__4_i_4
       (.I0(Q[18]),
        .I1(Q[20]),
        .O(prod0__179_carry__4_i_4_n_0));
  CARRY4 prod0__179_carry__5
       (.CI(prod0__179_carry__4_n_0),
        .CO({prod0__179_carry__5_n_0,prod0__179_carry__5_n_1,prod0__179_carry__5_n_2,prod0__179_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(Q[25:22]),
        .O({prod0__179_carry__5_n_4,prod0__179_carry__5_n_5,prod0__179_carry__5_n_6,prod0__179_carry__5_n_7}),
        .S({prod0__179_carry__5_i_1_n_0,prod0__179_carry__5_i_2_n_0,prod0__179_carry__5_i_3_n_0,prod0__179_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__5_i_1
       (.I0(Q[25]),
        .I1(Q[27]),
        .O(prod0__179_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__5_i_2
       (.I0(Q[24]),
        .I1(Q[26]),
        .O(prod0__179_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__5_i_3
       (.I0(Q[23]),
        .I1(Q[25]),
        .O(prod0__179_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__5_i_4
       (.I0(Q[22]),
        .I1(Q[24]),
        .O(prod0__179_carry__5_i_4_n_0));
  CARRY4 prod0__179_carry__6
       (.CI(prod0__179_carry__5_n_0),
        .CO({prod0__179_carry__6_n_0,prod0__179_carry__6_n_1,prod0__179_carry__6_n_2,prod0__179_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__179_carry__6_i_1_n_0,Q[30],Q[27:26]}),
        .O({prod0__179_carry__6_n_4,prod0__179_carry__6_n_5,prod0__179_carry__6_n_6,prod0__179_carry__6_n_7}),
        .S({prod0__179_carry__6_i_2_n_0,prod0__179_carry__6_i_3_n_0,prod0__179_carry__6_i_4_n_0,prod0__179_carry__6_i_5_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__179_carry__6_i_1
       (.I0(Q[30]),
        .O(prod0__179_carry__6_i_1_n_0));
  LUT3 #(
    .INIT(8'h69)) 
    prod0__179_carry__6_i_2
       (.I0(Q[30]),
        .I1(Q[31]),
        .I2(Q[29]),
        .O(prod0__179_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    prod0__179_carry__6_i_3
       (.I0(Q[30]),
        .I1(Q[28]),
        .O(prod0__179_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__6_i_4
       (.I0(Q[27]),
        .I1(Q[29]),
        .O(prod0__179_carry__6_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry__6_i_5
       (.I0(Q[26]),
        .I1(Q[28]),
        .O(prod0__179_carry__6_i_5_n_0));
  CARRY4 prod0__179_carry__7
       (.CI(prod0__179_carry__6_n_0),
        .CO({NLW_prod0__179_carry__7_CO_UNCONNECTED[3:2],prod0__179_carry__7_n_2,prod0__179_carry__7_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,Q[30],prod0__179_carry__7_i_1_n_0}),
        .O({NLW_prod0__179_carry__7_O_UNCONNECTED[3],prod0__179_carry__7_n_5,prod0__179_carry__7_n_6,prod0__179_carry__7_n_7}),
        .S({1'b0,Q[31],prod0__179_carry__7_i_2_n_0,prod0__179_carry__7_i_3_n_0}));
  LUT2 #(
    .INIT(4'h8)) 
    prod0__179_carry__7_i_1
       (.I0(Q[31]),
        .I1(Q[29]),
        .O(prod0__179_carry__7_i_1_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    prod0__179_carry__7_i_2
       (.I0(Q[30]),
        .I1(Q[31]),
        .O(prod0__179_carry__7_i_2_n_0));
  LUT3 #(
    .INIT(8'h87)) 
    prod0__179_carry__7_i_3
       (.I0(Q[29]),
        .I1(Q[31]),
        .I2(Q[30]),
        .O(prod0__179_carry__7_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry_i_1
       (.I0(Q[1]),
        .I1(Q[3]),
        .O(prod0__179_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__179_carry_i_2
       (.I0(Q[0]),
        .I1(Q[2]),
        .O(prod0__179_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__179_carry_i_3
       (.I0(Q[1]),
        .O(prod0__179_carry_i_3_n_0));
  CARRY4 prod0__249_carry
       (.CI(1'b0),
        .CO({prod0__249_carry_n_0,prod0__249_carry_n_1,prod0__249_carry_n_2,prod0__249_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,Q[16],1'b0}),
        .O({prod0__249_carry_n_4,prod0__249_carry_n_5,prod0__249_carry_n_6,prod0__249_carry_n_7}),
        .S({Q[18:17],prod0__249_carry_i_1_n_0,Q[15]}));
  CARRY4 prod0__249_carry__0
       (.CI(prod0__249_carry_n_0),
        .CO({prod0__249_carry__0_n_0,prod0__249_carry__0_n_1,prod0__249_carry__0_n_2,prod0__249_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({prod0__249_carry__0_n_4,prod0__249_carry__0_n_5,prod0__249_carry__0_n_6,prod0__249_carry__0_n_7}),
        .S(Q[22:19]));
  CARRY4 prod0__249_carry__1
       (.CI(prod0__249_carry__0_n_0),
        .CO({prod0__249_carry__1_n_0,prod0__249_carry__1_n_1,prod0__249_carry__1_n_2,prod0__249_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({prod0__249_carry__1_n_4,prod0__249_carry__1_n_5,prod0__249_carry__1_n_6,prod0__249_carry__1_n_7}),
        .S(Q[26:23]));
  CARRY4 prod0__249_carry__2
       (.CI(prod0__249_carry__1_n_0),
        .CO({prod0__249_carry__2_n_0,prod0__249_carry__2_n_1,prod0__249_carry__2_n_2,prod0__249_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({prod0__249_carry__2_n_4,prod0__249_carry__2_n_5,prod0__249_carry__2_n_6,prod0__249_carry__2_n_7}),
        .S(Q[30:27]));
  CARRY4 prod0__249_carry__3
       (.CI(prod0__249_carry__2_n_0),
        .CO({NLW_prod0__249_carry__3_CO_UNCONNECTED[3:2],prod0__249_carry__3_n_2,NLW_prod0__249_carry__3_CO_UNCONNECTED[0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_prod0__249_carry__3_O_UNCONNECTED[3:1],prod0__249_carry__3_n_7}),
        .S({1'b0,1'b0,1'b1,prod0__249_carry__3_i_1_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__249_carry__3_i_1
       (.I0(Q[31]),
        .O(prod0__249_carry__3_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__249_carry_i_1
       (.I0(Q[16]),
        .O(prod0__249_carry_i_1_n_0));
  CARRY4 prod0__283_carry
       (.CI(1'b0),
        .CO({prod0__283_carry_n_0,prod0__283_carry_n_1,prod0__283_carry_n_2,prod0__283_carry_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry_i_1_n_0,prod0__283_carry_i_2_n_0,prod0__283_carry_i_3_n_0,prod0__283_carry_i_4_n_0}),
        .O({prod0__283_carry_n_4,NLW_prod0__283_carry_O_UNCONNECTED[2:0]}),
        .S({prod0__283_carry_i_5_n_0,prod0__283_carry_i_6_n_0,prod0__283_carry_i_7_n_0,prod0__283_carry_i_8_n_0}));
  CARRY4 prod0__283_carry__0
       (.CI(prod0__283_carry_n_0),
        .CO({prod0__283_carry__0_n_0,prod0__283_carry__0_n_1,prod0__283_carry__0_n_2,prod0__283_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__0_i_1_n_0,prod0__283_carry__0_i_2_n_0,prod0__283_carry__0_i_3_n_0,prod0__283_carry__0_i_4_n_0}),
        .O({prod0__283_carry__0_n_4,prod0__283_carry__0_n_5,prod0__283_carry__0_n_6,prod0__283_carry__0_n_7}),
        .S({prod0__283_carry__0_i_5_n_0,prod0__283_carry__0_i_6_n_0,prod0__283_carry__0_i_7_n_0,prod0__283_carry__0_i_8_n_0}));
  (* HLUTNM = "lutpair6" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__0_i_1
       (.I0(prod0_carry__1_n_4),
        .I1(Q[6]),
        .I2(Q[7]),
        .O(prod0__283_carry__0_i_1_n_0));
  (* HLUTNM = "lutpair5" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__0_i_2
       (.I0(prod0_carry__1_n_5),
        .I1(Q[5]),
        .I2(Q[6]),
        .O(prod0__283_carry__0_i_2_n_0));
  (* HLUTNM = "lutpair4" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__0_i_3
       (.I0(prod0_carry__1_n_6),
        .I1(Q[4]),
        .I2(Q[5]),
        .O(prod0__283_carry__0_i_3_n_0));
  (* HLUTNM = "lutpair3" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__0_i_4
       (.I0(prod0_carry__1_n_7),
        .I1(Q[3]),
        .I2(Q[4]),
        .O(prod0__283_carry__0_i_4_n_0));
  (* HLUTNM = "lutpair7" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__0_i_5
       (.I0(prod0_carry__2_n_7),
        .I1(Q[7]),
        .I2(Q[8]),
        .I3(prod0__283_carry__0_i_1_n_0),
        .O(prod0__283_carry__0_i_5_n_0));
  (* HLUTNM = "lutpair6" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__0_i_6
       (.I0(prod0_carry__1_n_4),
        .I1(Q[6]),
        .I2(Q[7]),
        .I3(prod0__283_carry__0_i_2_n_0),
        .O(prod0__283_carry__0_i_6_n_0));
  (* HLUTNM = "lutpair5" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__0_i_7
       (.I0(prod0_carry__1_n_5),
        .I1(Q[5]),
        .I2(Q[6]),
        .I3(prod0__283_carry__0_i_3_n_0),
        .O(prod0__283_carry__0_i_7_n_0));
  (* HLUTNM = "lutpair4" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__0_i_8
       (.I0(prod0_carry__1_n_6),
        .I1(Q[4]),
        .I2(Q[5]),
        .I3(prod0__283_carry__0_i_4_n_0),
        .O(prod0__283_carry__0_i_8_n_0));
  CARRY4 prod0__283_carry__1
       (.CI(prod0__283_carry__0_n_0),
        .CO({prod0__283_carry__1_n_0,prod0__283_carry__1_n_1,prod0__283_carry__1_n_2,prod0__283_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__1_i_1_n_0,prod0__283_carry__1_i_2_n_0,prod0__283_carry__1_i_3_n_0,prod0__283_carry__1_i_4_n_0}),
        .O({prod0__283_carry__1_n_4,prod0__283_carry__1_n_5,prod0__283_carry__1_n_6,prod0__283_carry__1_n_7}),
        .S({prod0__283_carry__1_i_5_n_0,prod0__283_carry__1_i_6_n_0,prod0__283_carry__1_i_7_n_0,prod0__283_carry__1_i_8_n_0}));
  (* HLUTNM = "lutpair10" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__1_i_1
       (.I0(prod0_carry__2_n_4),
        .I1(Q[10]),
        .I2(Q[11]),
        .O(prod0__283_carry__1_i_1_n_0));
  (* HLUTNM = "lutpair9" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__1_i_2
       (.I0(prod0_carry__2_n_5),
        .I1(Q[9]),
        .I2(Q[10]),
        .O(prod0__283_carry__1_i_2_n_0));
  (* HLUTNM = "lutpair8" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__1_i_3
       (.I0(prod0_carry__2_n_6),
        .I1(Q[8]),
        .I2(Q[9]),
        .O(prod0__283_carry__1_i_3_n_0));
  (* HLUTNM = "lutpair7" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__1_i_4
       (.I0(prod0_carry__2_n_7),
        .I1(Q[7]),
        .I2(Q[8]),
        .O(prod0__283_carry__1_i_4_n_0));
  (* HLUTNM = "lutpair11" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__1_i_5
       (.I0(prod0_carry__3_n_7),
        .I1(Q[11]),
        .I2(Q[12]),
        .I3(prod0__283_carry__1_i_1_n_0),
        .O(prod0__283_carry__1_i_5_n_0));
  (* HLUTNM = "lutpair10" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__1_i_6
       (.I0(prod0_carry__2_n_4),
        .I1(Q[10]),
        .I2(Q[11]),
        .I3(prod0__283_carry__1_i_2_n_0),
        .O(prod0__283_carry__1_i_6_n_0));
  (* HLUTNM = "lutpair9" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__1_i_7
       (.I0(prod0_carry__2_n_5),
        .I1(Q[9]),
        .I2(Q[10]),
        .I3(prod0__283_carry__1_i_3_n_0),
        .O(prod0__283_carry__1_i_7_n_0));
  (* HLUTNM = "lutpair8" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__1_i_8
       (.I0(prod0_carry__2_n_6),
        .I1(Q[8]),
        .I2(Q[9]),
        .I3(prod0__283_carry__1_i_4_n_0),
        .O(prod0__283_carry__1_i_8_n_0));
  CARRY4 prod0__283_carry__2
       (.CI(prod0__283_carry__1_n_0),
        .CO({prod0__283_carry__2_n_0,prod0__283_carry__2_n_1,prod0__283_carry__2_n_2,prod0__283_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__2_i_1_n_0,prod0__283_carry__2_i_2_n_0,prod0__283_carry__2_i_3_n_0,prod0__283_carry__2_i_4_n_0}),
        .O({prod0__283_carry__2_n_4,prod0__283_carry__2_n_5,prod0__283_carry__2_n_6,prod0__283_carry__2_n_7}),
        .S({prod0__283_carry__2_i_5_n_0,prod0__283_carry__2_i_6_n_0,prod0__283_carry__2_i_7_n_0,prod0__283_carry__2_i_8_n_0}));
  (* HLUTNM = "lutpair14" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__2_i_1
       (.I0(prod0_carry__3_n_4),
        .I1(Q[14]),
        .I2(Q[15]),
        .O(prod0__283_carry__2_i_1_n_0));
  (* HLUTNM = "lutpair13" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__2_i_2
       (.I0(prod0_carry__3_n_5),
        .I1(Q[13]),
        .I2(Q[14]),
        .O(prod0__283_carry__2_i_2_n_0));
  (* HLUTNM = "lutpair12" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__2_i_3
       (.I0(prod0_carry__3_n_6),
        .I1(Q[12]),
        .I2(Q[13]),
        .O(prod0__283_carry__2_i_3_n_0));
  (* HLUTNM = "lutpair11" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__2_i_4
       (.I0(prod0_carry__3_n_7),
        .I1(Q[11]),
        .I2(Q[12]),
        .O(prod0__283_carry__2_i_4_n_0));
  (* HLUTNM = "lutpair15" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__2_i_5
       (.I0(prod0_carry__4_n_7),
        .I1(Q[15]),
        .I2(Q[16]),
        .I3(prod0__283_carry__2_i_1_n_0),
        .O(prod0__283_carry__2_i_5_n_0));
  (* HLUTNM = "lutpair14" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__2_i_6
       (.I0(prod0_carry__3_n_4),
        .I1(Q[14]),
        .I2(Q[15]),
        .I3(prod0__283_carry__2_i_2_n_0),
        .O(prod0__283_carry__2_i_6_n_0));
  (* HLUTNM = "lutpair13" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__2_i_7
       (.I0(prod0_carry__3_n_5),
        .I1(Q[13]),
        .I2(Q[14]),
        .I3(prod0__283_carry__2_i_3_n_0),
        .O(prod0__283_carry__2_i_7_n_0));
  (* HLUTNM = "lutpair12" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__2_i_8
       (.I0(prod0_carry__3_n_6),
        .I1(Q[12]),
        .I2(Q[13]),
        .I3(prod0__283_carry__2_i_4_n_0),
        .O(prod0__283_carry__2_i_8_n_0));
  CARRY4 prod0__283_carry__3
       (.CI(prod0__283_carry__2_n_0),
        .CO({prod0__283_carry__3_n_0,prod0__283_carry__3_n_1,prod0__283_carry__3_n_2,prod0__283_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__3_i_1_n_0,prod0__283_carry__3_i_2_n_0,prod0__283_carry__3_i_3_n_0,prod0__283_carry__3_i_4_n_0}),
        .O({prod0__283_carry__3_n_4,prod0__283_carry__3_n_5,prod0__283_carry__3_n_6,prod0__283_carry__3_n_7}),
        .S({prod0__283_carry__3_i_5_n_0,prod0__283_carry__3_i_6_n_0,prod0__283_carry__3_i_7_n_0,prod0__283_carry__3_i_8_n_0}));
  (* HLUTNM = "lutpair18" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__3_i_1
       (.I0(prod0_carry__4_n_4),
        .I1(Q[18]),
        .I2(Q[19]),
        .O(prod0__283_carry__3_i_1_n_0));
  (* HLUTNM = "lutpair17" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__3_i_2
       (.I0(prod0_carry__4_n_5),
        .I1(Q[17]),
        .I2(Q[18]),
        .O(prod0__283_carry__3_i_2_n_0));
  (* HLUTNM = "lutpair16" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__3_i_3
       (.I0(prod0_carry__4_n_6),
        .I1(Q[16]),
        .I2(Q[17]),
        .O(prod0__283_carry__3_i_3_n_0));
  (* HLUTNM = "lutpair15" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__3_i_4
       (.I0(prod0_carry__4_n_7),
        .I1(Q[15]),
        .I2(Q[16]),
        .O(prod0__283_carry__3_i_4_n_0));
  (* HLUTNM = "lutpair19" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__3_i_5
       (.I0(prod0_carry__5_n_7),
        .I1(Q[19]),
        .I2(Q[20]),
        .I3(prod0__283_carry__3_i_1_n_0),
        .O(prod0__283_carry__3_i_5_n_0));
  (* HLUTNM = "lutpair18" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__3_i_6
       (.I0(prod0_carry__4_n_4),
        .I1(Q[18]),
        .I2(Q[19]),
        .I3(prod0__283_carry__3_i_2_n_0),
        .O(prod0__283_carry__3_i_6_n_0));
  (* HLUTNM = "lutpair17" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__3_i_7
       (.I0(prod0_carry__4_n_5),
        .I1(Q[17]),
        .I2(Q[18]),
        .I3(prod0__283_carry__3_i_3_n_0),
        .O(prod0__283_carry__3_i_7_n_0));
  (* HLUTNM = "lutpair16" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__3_i_8
       (.I0(prod0_carry__4_n_6),
        .I1(Q[16]),
        .I2(Q[17]),
        .I3(prod0__283_carry__3_i_4_n_0),
        .O(prod0__283_carry__3_i_8_n_0));
  CARRY4 prod0__283_carry__4
       (.CI(prod0__283_carry__3_n_0),
        .CO({prod0__283_carry__4_n_0,prod0__283_carry__4_n_1,prod0__283_carry__4_n_2,prod0__283_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__4_i_1_n_0,prod0__283_carry__4_i_2_n_0,prod0__283_carry__4_i_3_n_0,prod0__283_carry__4_i_4_n_0}),
        .O({prod0__283_carry__4_n_4,prod0__283_carry__4_n_5,prod0__283_carry__4_n_6,prod0__283_carry__4_n_7}),
        .S({prod0__283_carry__4_i_5_n_0,prod0__283_carry__4_i_6_n_0,prod0__283_carry__4_i_7_n_0,prod0__283_carry__4_i_8_n_0}));
  (* HLUTNM = "lutpair22" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__4_i_1
       (.I0(prod0_carry__5_n_4),
        .I1(Q[22]),
        .I2(Q[23]),
        .O(prod0__283_carry__4_i_1_n_0));
  (* HLUTNM = "lutpair21" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__4_i_2
       (.I0(prod0_carry__5_n_5),
        .I1(Q[21]),
        .I2(Q[22]),
        .O(prod0__283_carry__4_i_2_n_0));
  (* HLUTNM = "lutpair20" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__4_i_3
       (.I0(prod0_carry__5_n_6),
        .I1(Q[20]),
        .I2(Q[21]),
        .O(prod0__283_carry__4_i_3_n_0));
  (* HLUTNM = "lutpair19" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__4_i_4
       (.I0(prod0_carry__5_n_7),
        .I1(Q[19]),
        .I2(Q[20]),
        .O(prod0__283_carry__4_i_4_n_0));
  (* HLUTNM = "lutpair23" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__4_i_5
       (.I0(prod0_carry__6_n_7),
        .I1(Q[23]),
        .I2(Q[24]),
        .I3(prod0__283_carry__4_i_1_n_0),
        .O(prod0__283_carry__4_i_5_n_0));
  (* HLUTNM = "lutpair22" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__4_i_6
       (.I0(prod0_carry__5_n_4),
        .I1(Q[22]),
        .I2(Q[23]),
        .I3(prod0__283_carry__4_i_2_n_0),
        .O(prod0__283_carry__4_i_6_n_0));
  (* HLUTNM = "lutpair21" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__4_i_7
       (.I0(prod0_carry__5_n_5),
        .I1(Q[21]),
        .I2(Q[22]),
        .I3(prod0__283_carry__4_i_3_n_0),
        .O(prod0__283_carry__4_i_7_n_0));
  (* HLUTNM = "lutpair20" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__4_i_8
       (.I0(prod0_carry__5_n_6),
        .I1(Q[20]),
        .I2(Q[21]),
        .I3(prod0__283_carry__4_i_4_n_0),
        .O(prod0__283_carry__4_i_8_n_0));
  CARRY4 prod0__283_carry__5
       (.CI(prod0__283_carry__4_n_0),
        .CO({prod0__283_carry__5_n_0,prod0__283_carry__5_n_1,prod0__283_carry__5_n_2,prod0__283_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__5_i_1_n_0,prod0__283_carry__5_i_2_n_0,prod0__283_carry__5_i_3_n_0,prod0__283_carry__5_i_4_n_0}),
        .O({prod0__283_carry__5_n_4,prod0__283_carry__5_n_5,prod0__283_carry__5_n_6,prod0__283_carry__5_n_7}),
        .S({prod0__283_carry__5_i_5_n_0,prod0__283_carry__5_i_6_n_0,prod0__283_carry__5_i_7_n_0,prod0__283_carry__5_i_8_n_0}));
  (* HLUTNM = "lutpair26" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__5_i_1
       (.I0(prod0_carry__6_n_4),
        .I1(Q[26]),
        .I2(Q[27]),
        .O(prod0__283_carry__5_i_1_n_0));
  (* HLUTNM = "lutpair25" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__5_i_2
       (.I0(prod0_carry__6_n_5),
        .I1(Q[25]),
        .I2(Q[26]),
        .O(prod0__283_carry__5_i_2_n_0));
  (* HLUTNM = "lutpair24" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__5_i_3
       (.I0(prod0_carry__6_n_6),
        .I1(Q[24]),
        .I2(Q[25]),
        .O(prod0__283_carry__5_i_3_n_0));
  (* HLUTNM = "lutpair23" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__5_i_4
       (.I0(prod0_carry__6_n_7),
        .I1(Q[23]),
        .I2(Q[24]),
        .O(prod0__283_carry__5_i_4_n_0));
  (* HLUTNM = "lutpair27" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__5_i_5
       (.I0(prod0_carry__7_n_7),
        .I1(Q[27]),
        .I2(Q[28]),
        .I3(prod0__283_carry__5_i_1_n_0),
        .O(prod0__283_carry__5_i_5_n_0));
  (* HLUTNM = "lutpair26" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__5_i_6
       (.I0(prod0_carry__6_n_4),
        .I1(Q[26]),
        .I2(Q[27]),
        .I3(prod0__283_carry__5_i_2_n_0),
        .O(prod0__283_carry__5_i_6_n_0));
  (* HLUTNM = "lutpair25" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__5_i_7
       (.I0(prod0_carry__6_n_5),
        .I1(Q[25]),
        .I2(Q[26]),
        .I3(prod0__283_carry__5_i_3_n_0),
        .O(prod0__283_carry__5_i_7_n_0));
  (* HLUTNM = "lutpair24" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__5_i_8
       (.I0(prod0_carry__6_n_6),
        .I1(Q[24]),
        .I2(Q[25]),
        .I3(prod0__283_carry__5_i_4_n_0),
        .O(prod0__283_carry__5_i_8_n_0));
  CARRY4 prod0__283_carry__6
       (.CI(prod0__283_carry__5_n_0),
        .CO({prod0__283_carry__6_n_0,prod0__283_carry__6_n_1,prod0__283_carry__6_n_2,prod0__283_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__283_carry__6_i_1_n_0,prod0__283_carry__6_i_2_n_0,prod0__283_carry__6_i_3_n_0,prod0__283_carry__6_i_4_n_0}),
        .O({prod0__283_carry__6_n_4,prod0__283_carry__6_n_5,prod0__283_carry__6_n_6,prod0__283_carry__6_n_7}),
        .S({prod0__283_carry__6_i_5_n_0,prod0__283_carry__6_i_6_n_0,prod0__283_carry__6_i_7_n_0,prod0__283_carry__6_i_8_n_0}));
  LUT3 #(
    .INIT(8'hD4)) 
    prod0__283_carry__6_i_1
       (.I0(prod0_carry__7_n_0),
        .I1(Q[30]),
        .I2(prod0__70_carry_n_4),
        .O(prod0__283_carry__6_i_1_n_0));
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__6_i_2
       (.I0(prod0_carry__7_n_5),
        .I1(Q[29]),
        .I2(prod0__70_carry_n_5),
        .O(prod0__283_carry__6_i_2_n_0));
  (* HLUTNM = "lutpair28" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__6_i_3
       (.I0(prod0_carry__7_n_6),
        .I1(prod0__70_carry_n_7),
        .I2(prod0__70_carry_n_6),
        .O(prod0__283_carry__6_i_3_n_0));
  (* HLUTNM = "lutpair27" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry__6_i_4
       (.I0(prod0_carry__7_n_7),
        .I1(Q[27]),
        .I2(Q[28]),
        .O(prod0__283_carry__6_i_4_n_0));
  LUT5 #(
    .INIT(32'h7E81817E)) 
    prod0__283_carry__6_i_5
       (.I0(prod0__70_carry_n_4),
        .I1(Q[30]),
        .I2(prod0_carry__7_n_0),
        .I3(prod0__283_carry__6_i_9_n_3),
        .I4(Q[31]),
        .O(prod0__283_carry__6_i_5_n_0));
  LUT6 #(
    .INIT(64'hE81717E817E8E817)) 
    prod0__283_carry__6_i_6
       (.I0(prod0__70_carry_n_5),
        .I1(Q[29]),
        .I2(prod0_carry__7_n_5),
        .I3(prod0_carry__7_n_0),
        .I4(prod0__70_carry_n_4),
        .I5(Q[30]),
        .O(prod0__283_carry__6_i_6_n_0));
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__6_i_7
       (.I0(prod0__283_carry__6_i_3_n_0),
        .I1(prod0__70_carry_n_5),
        .I2(Q[29]),
        .I3(prod0_carry__7_n_5),
        .O(prod0__283_carry__6_i_7_n_0));
  (* HLUTNM = "lutpair28" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry__6_i_8
       (.I0(prod0_carry__7_n_6),
        .I1(prod0__70_carry_n_7),
        .I2(prod0__70_carry_n_6),
        .I3(prod0__283_carry__6_i_4_n_0),
        .O(prod0__283_carry__6_i_8_n_0));
  CARRY4 prod0__283_carry__6_i_9
       (.CI(prod0__70_carry_n_0),
        .CO({NLW_prod0__283_carry__6_i_9_CO_UNCONNECTED[3:1],prod0__283_carry__6_i_9_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_prod0__283_carry__6_i_9_O_UNCONNECTED[3:0]),
        .S({1'b0,1'b0,1'b0,1'b1}));
  CARRY4 prod0__283_carry__7
       (.CI(prod0__283_carry__6_n_0),
        .CO({NLW_prod0__283_carry__7_CO_UNCONNECTED[3:2],prod0__283_carry__7_n_2,NLW_prod0__283_carry__7_CO_UNCONNECTED[0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,prod0_carry__7_n_0}),
        .O({NLW_prod0__283_carry__7_O_UNCONNECTED[3:1],prod0__283_carry__7_n_7}),
        .S({1'b0,1'b0,1'b1,prod0__283_carry__7_i_1_n_0}));
  LUT3 #(
    .INIT(8'hDB)) 
    prod0__283_carry__7_i_1
       (.I0(prod0__283_carry__6_i_9_n_3),
        .I1(Q[31]),
        .I2(prod0_carry__7_n_0),
        .O(prod0__283_carry__7_i_1_n_0));
  (* HLUTNM = "lutpair2" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry_i_1
       (.I0(prod0_carry__0_n_4),
        .I1(Q[2]),
        .I2(Q[3]),
        .O(prod0__283_carry_i_1_n_0));
  (* HLUTNM = "lutpair1" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry_i_2
       (.I0(prod0_carry__0_n_5),
        .I1(Q[1]),
        .I2(Q[2]),
        .O(prod0__283_carry_i_2_n_0));
  (* HLUTNM = "lutpair0" *) 
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__283_carry_i_3
       (.I0(prod0_carry__0_n_6),
        .I1(Q[0]),
        .I2(Q[1]),
        .O(prod0__283_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    prod0__283_carry_i_4
       (.I0(Q[0]),
        .I1(prod0_carry__0_n_7),
        .O(prod0__283_carry_i_4_n_0));
  (* HLUTNM = "lutpair3" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry_i_5
       (.I0(prod0_carry__1_n_7),
        .I1(Q[3]),
        .I2(Q[4]),
        .I3(prod0__283_carry_i_1_n_0),
        .O(prod0__283_carry_i_5_n_0));
  (* HLUTNM = "lutpair2" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry_i_6
       (.I0(prod0_carry__0_n_4),
        .I1(Q[2]),
        .I2(Q[3]),
        .I3(prod0__283_carry_i_2_n_0),
        .O(prod0__283_carry_i_6_n_0));
  (* HLUTNM = "lutpair1" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry_i_7
       (.I0(prod0_carry__0_n_5),
        .I1(Q[1]),
        .I2(Q[2]),
        .I3(prod0__283_carry_i_3_n_0),
        .O(prod0__283_carry_i_7_n_0));
  (* HLUTNM = "lutpair0" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__283_carry_i_8
       (.I0(prod0_carry__0_n_6),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(prod0__283_carry_i_4_n_0),
        .O(prod0__283_carry_i_8_n_0));
  CARRY4 prod0__379_carry
       (.CI(1'b0),
        .CO({prod0__379_carry_n_0,prod0__379_carry_n_1,prod0__379_carry_n_2,prod0__379_carry_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry_i_1_n_0,prod0__379_carry_i_2_n_0,prod0__379_carry_i_3_n_0,prod0__379_carry_i_4_n_0}),
        .O(NLW_prod0__379_carry_O_UNCONNECTED[3:0]),
        .S({prod0__379_carry_i_5_n_0,prod0__379_carry_i_6_n_0,prod0__379_carry_i_7_n_0,prod0__379_carry_i_8_n_0}));
  CARRY4 prod0__379_carry__0
       (.CI(prod0__379_carry_n_0),
        .CO({prod0__379_carry__0_n_0,prod0__379_carry__0_n_1,prod0__379_carry__0_n_2,prod0__379_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__0_i_1_n_0,prod0__379_carry__0_i_2_n_0,prod0__379_carry__0_i_3_n_0,prod0__379_carry__0_i_4_n_0}),
        .O({prod0__379_carry__0_n_4,prod0__379_carry__0_n_5,NLW_prod0__379_carry__0_O_UNCONNECTED[1:0]}),
        .S({prod0__379_carry__0_i_5_n_0,prod0__379_carry__0_i_6_n_0,prod0__379_carry__0_i_7_n_0,prod0__379_carry__0_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__0_i_1
       (.I0(Q[0]),
        .I1(prod0__283_carry__1_n_6),
        .I2(prod0__179_carry_n_5),
        .I3(prod0__81_carry__0_n_4),
        .I4(prod0__379_carry__0_i_9_n_0),
        .O(prod0__379_carry__0_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__0_i_10
       (.I0(prod0__179_carry__0_n_7),
        .I1(prod0__283_carry__1_n_4),
        .I2(Q[2]),
        .O(prod0__379_carry__0_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__0_i_11
       (.I0(prod0__179_carry_n_5),
        .I1(prod0__283_carry__1_n_6),
        .I2(Q[0]),
        .O(prod0__379_carry__0_i_11_n_0));
  LUT6 #(
    .INIT(64'hF88080F880F8F880)) 
    prod0__379_carry__0_i_2
       (.I0(prod0__179_carry_n_6),
        .I1(prod0__283_carry__1_n_7),
        .I2(prod0__81_carry__0_n_5),
        .I3(prod0__179_carry_n_5),
        .I4(prod0__283_carry__1_n_6),
        .I5(Q[0]),
        .O(prod0__379_carry__0_i_2_n_0));
  LUT5 #(
    .INIT(32'h80F8F880)) 
    prod0__379_carry__0_i_3
       (.I0(Q[0]),
        .I1(prod0__283_carry__0_n_4),
        .I2(prod0__81_carry__0_n_6),
        .I3(prod0__179_carry_n_6),
        .I4(prod0__283_carry__1_n_7),
        .O(prod0__379_carry__0_i_3_n_0));
  (* HLUTNM = "lutpair30" *) 
  LUT3 #(
    .INIT(8'h28)) 
    prod0__379_carry__0_i_4
       (.I0(prod0__81_carry__0_n_7),
        .I1(prod0__283_carry__0_n_4),
        .I2(Q[0]),
        .O(prod0__379_carry__0_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__0_i_5
       (.I0(prod0__379_carry__0_i_1_n_0),
        .I1(prod0__379_carry__0_i_10_n_0),
        .I2(prod0__81_carry__1_n_7),
        .I3(prod0__179_carry_n_4),
        .I4(prod0__283_carry__1_n_5),
        .I5(Q[1]),
        .O(prod0__379_carry__0_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__0_i_6
       (.I0(prod0__379_carry__0_i_2_n_0),
        .I1(prod0__379_carry__0_i_9_n_0),
        .I2(prod0__81_carry__0_n_4),
        .I3(prod0__179_carry_n_5),
        .I4(prod0__283_carry__1_n_6),
        .I5(Q[0]),
        .O(prod0__379_carry__0_i_6_n_0));
  LUT5 #(
    .INIT(32'h69969696)) 
    prod0__379_carry__0_i_7
       (.I0(prod0__379_carry__0_i_3_n_0),
        .I1(prod0__379_carry__0_i_11_n_0),
        .I2(prod0__81_carry__0_n_5),
        .I3(prod0__283_carry__1_n_7),
        .I4(prod0__179_carry_n_6),
        .O(prod0__379_carry__0_i_7_n_0));
  LUT6 #(
    .INIT(64'h9669699669966996)) 
    prod0__379_carry__0_i_8
       (.I0(prod0__379_carry__0_i_4_n_0),
        .I1(prod0__283_carry__1_n_7),
        .I2(prod0__179_carry_n_6),
        .I3(prod0__81_carry__0_n_6),
        .I4(prod0__283_carry__0_n_4),
        .I5(Q[0]),
        .O(prod0__379_carry__0_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__0_i_9
       (.I0(prod0__179_carry_n_4),
        .I1(prod0__283_carry__1_n_5),
        .I2(Q[1]),
        .O(prod0__379_carry__0_i_9_n_0));
  CARRY4 prod0__379_carry__1
       (.CI(prod0__379_carry__0_n_0),
        .CO({prod0__379_carry__1_n_0,prod0__379_carry__1_n_1,prod0__379_carry__1_n_2,prod0__379_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__1_i_1_n_0,prod0__379_carry__1_i_2_n_0,prod0__379_carry__1_i_3_n_0,prod0__379_carry__1_i_4_n_0}),
        .O({prod0__379_carry__1_n_4,prod0__379_carry__1_n_5,prod0__379_carry__1_n_6,prod0__379_carry__1_n_7}),
        .S({prod0__379_carry__1_i_5_n_0,prod0__379_carry__1_i_6_n_0,prod0__379_carry__1_i_7_n_0,prod0__379_carry__1_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__1_i_1
       (.I0(Q[4]),
        .I1(prod0__283_carry__2_n_6),
        .I2(prod0__179_carry__0_n_5),
        .I3(prod0__81_carry__1_n_4),
        .I4(prod0__379_carry__1_i_9_n_0),
        .O(prod0__379_carry__1_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__1_i_10
       (.I0(prod0__179_carry__0_n_5),
        .I1(prod0__283_carry__2_n_6),
        .I2(Q[4]),
        .O(prod0__379_carry__1_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__1_i_11
       (.I0(prod0__179_carry__0_n_6),
        .I1(prod0__283_carry__2_n_7),
        .I2(Q[3]),
        .O(prod0__379_carry__1_i_11_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__1_i_12
       (.I0(prod0__179_carry__1_n_7),
        .I1(prod0__283_carry__2_n_4),
        .I2(Q[6]),
        .O(prod0__379_carry__1_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__1_i_2
       (.I0(Q[3]),
        .I1(prod0__283_carry__2_n_7),
        .I2(prod0__179_carry__0_n_6),
        .I3(prod0__81_carry__1_n_5),
        .I4(prod0__379_carry__1_i_10_n_0),
        .O(prod0__379_carry__1_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__1_i_3
       (.I0(Q[2]),
        .I1(prod0__283_carry__1_n_4),
        .I2(prod0__179_carry__0_n_7),
        .I3(prod0__81_carry__1_n_6),
        .I4(prod0__379_carry__1_i_11_n_0),
        .O(prod0__379_carry__1_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__1_i_4
       (.I0(Q[1]),
        .I1(prod0__283_carry__1_n_5),
        .I2(prod0__179_carry_n_4),
        .I3(prod0__81_carry__1_n_7),
        .I4(prod0__379_carry__0_i_10_n_0),
        .O(prod0__379_carry__1_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__1_i_5
       (.I0(prod0__379_carry__1_i_1_n_0),
        .I1(prod0__379_carry__1_i_12_n_0),
        .I2(prod0__81_carry__2_n_7),
        .I3(prod0__179_carry__0_n_4),
        .I4(prod0__283_carry__2_n_5),
        .I5(Q[5]),
        .O(prod0__379_carry__1_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__1_i_6
       (.I0(prod0__379_carry__1_i_2_n_0),
        .I1(prod0__379_carry__1_i_9_n_0),
        .I2(prod0__81_carry__1_n_4),
        .I3(prod0__179_carry__0_n_5),
        .I4(prod0__283_carry__2_n_6),
        .I5(Q[4]),
        .O(prod0__379_carry__1_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__1_i_7
       (.I0(prod0__379_carry__1_i_3_n_0),
        .I1(prod0__379_carry__1_i_10_n_0),
        .I2(prod0__81_carry__1_n_5),
        .I3(prod0__179_carry__0_n_6),
        .I4(prod0__283_carry__2_n_7),
        .I5(Q[3]),
        .O(prod0__379_carry__1_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__1_i_8
       (.I0(prod0__379_carry__1_i_4_n_0),
        .I1(prod0__379_carry__1_i_11_n_0),
        .I2(prod0__81_carry__1_n_6),
        .I3(prod0__179_carry__0_n_7),
        .I4(prod0__283_carry__1_n_4),
        .I5(Q[2]),
        .O(prod0__379_carry__1_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__1_i_9
       (.I0(prod0__179_carry__0_n_4),
        .I1(prod0__283_carry__2_n_5),
        .I2(Q[5]),
        .O(prod0__379_carry__1_i_9_n_0));
  CARRY4 prod0__379_carry__2
       (.CI(prod0__379_carry__1_n_0),
        .CO({prod0__379_carry__2_n_0,prod0__379_carry__2_n_1,prod0__379_carry__2_n_2,prod0__379_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__2_i_1_n_0,prod0__379_carry__2_i_2_n_0,prod0__379_carry__2_i_3_n_0,prod0__379_carry__2_i_4_n_0}),
        .O({prod0__379_carry__2_n_4,prod0__379_carry__2_n_5,prod0__379_carry__2_n_6,prod0__379_carry__2_n_7}),
        .S({prod0__379_carry__2_i_5_n_0,prod0__379_carry__2_i_6_n_0,prod0__379_carry__2_i_7_n_0,prod0__379_carry__2_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__2_i_1
       (.I0(Q[8]),
        .I1(prod0__283_carry__3_n_6),
        .I2(prod0__179_carry__1_n_5),
        .I3(prod0__81_carry__2_n_4),
        .I4(prod0__379_carry__2_i_9_n_0),
        .O(prod0__379_carry__2_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__2_i_10
       (.I0(prod0__179_carry__1_n_5),
        .I1(prod0__283_carry__3_n_6),
        .I2(Q[8]),
        .O(prod0__379_carry__2_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__2_i_11
       (.I0(prod0__179_carry__1_n_6),
        .I1(prod0__283_carry__3_n_7),
        .I2(Q[7]),
        .O(prod0__379_carry__2_i_11_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__2_i_12
       (.I0(prod0__179_carry__2_n_7),
        .I1(prod0__283_carry__3_n_4),
        .I2(Q[10]),
        .O(prod0__379_carry__2_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__2_i_2
       (.I0(Q[7]),
        .I1(prod0__283_carry__3_n_7),
        .I2(prod0__179_carry__1_n_6),
        .I3(prod0__81_carry__2_n_5),
        .I4(prod0__379_carry__2_i_10_n_0),
        .O(prod0__379_carry__2_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__2_i_3
       (.I0(Q[6]),
        .I1(prod0__283_carry__2_n_4),
        .I2(prod0__179_carry__1_n_7),
        .I3(prod0__81_carry__2_n_6),
        .I4(prod0__379_carry__2_i_11_n_0),
        .O(prod0__379_carry__2_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__2_i_4
       (.I0(Q[5]),
        .I1(prod0__283_carry__2_n_5),
        .I2(prod0__179_carry__0_n_4),
        .I3(prod0__81_carry__2_n_7),
        .I4(prod0__379_carry__1_i_12_n_0),
        .O(prod0__379_carry__2_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__2_i_5
       (.I0(prod0__379_carry__2_i_1_n_0),
        .I1(prod0__379_carry__2_i_12_n_0),
        .I2(prod0__81_carry__3_n_7),
        .I3(prod0__179_carry__1_n_4),
        .I4(prod0__283_carry__3_n_5),
        .I5(Q[9]),
        .O(prod0__379_carry__2_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__2_i_6
       (.I0(prod0__379_carry__2_i_2_n_0),
        .I1(prod0__379_carry__2_i_9_n_0),
        .I2(prod0__81_carry__2_n_4),
        .I3(prod0__179_carry__1_n_5),
        .I4(prod0__283_carry__3_n_6),
        .I5(Q[8]),
        .O(prod0__379_carry__2_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__2_i_7
       (.I0(prod0__379_carry__2_i_3_n_0),
        .I1(prod0__379_carry__2_i_10_n_0),
        .I2(prod0__81_carry__2_n_5),
        .I3(prod0__179_carry__1_n_6),
        .I4(prod0__283_carry__3_n_7),
        .I5(Q[7]),
        .O(prod0__379_carry__2_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__2_i_8
       (.I0(prod0__379_carry__2_i_4_n_0),
        .I1(prod0__379_carry__2_i_11_n_0),
        .I2(prod0__81_carry__2_n_6),
        .I3(prod0__179_carry__1_n_7),
        .I4(prod0__283_carry__2_n_4),
        .I5(Q[6]),
        .O(prod0__379_carry__2_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__2_i_9
       (.I0(prod0__179_carry__1_n_4),
        .I1(prod0__283_carry__3_n_5),
        .I2(Q[9]),
        .O(prod0__379_carry__2_i_9_n_0));
  CARRY4 prod0__379_carry__3
       (.CI(prod0__379_carry__2_n_0),
        .CO({prod0__379_carry__3_n_0,prod0__379_carry__3_n_1,prod0__379_carry__3_n_2,prod0__379_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__3_i_1_n_0,prod0__379_carry__3_i_2_n_0,prod0__379_carry__3_i_3_n_0,prod0__379_carry__3_i_4_n_0}),
        .O({prod0__379_carry__3_n_4,prod0__379_carry__3_n_5,prod0__379_carry__3_n_6,prod0__379_carry__3_n_7}),
        .S({prod0__379_carry__3_i_5_n_0,prod0__379_carry__3_i_6_n_0,prod0__379_carry__3_i_7_n_0,prod0__379_carry__3_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__3_i_1
       (.I0(Q[12]),
        .I1(prod0__283_carry__4_n_6),
        .I2(prod0__179_carry__2_n_5),
        .I3(prod0__81_carry__3_n_4),
        .I4(prod0__379_carry__3_i_9_n_0),
        .O(prod0__379_carry__3_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__3_i_10
       (.I0(prod0__179_carry__2_n_5),
        .I1(prod0__283_carry__4_n_6),
        .I2(Q[12]),
        .O(prod0__379_carry__3_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__3_i_11
       (.I0(prod0__179_carry__2_n_6),
        .I1(prod0__283_carry__4_n_7),
        .I2(Q[11]),
        .O(prod0__379_carry__3_i_11_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__3_i_12
       (.I0(prod0__179_carry__3_n_7),
        .I1(prod0__283_carry__4_n_4),
        .I2(Q[14]),
        .O(prod0__379_carry__3_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__3_i_2
       (.I0(Q[11]),
        .I1(prod0__283_carry__4_n_7),
        .I2(prod0__179_carry__2_n_6),
        .I3(prod0__81_carry__3_n_5),
        .I4(prod0__379_carry__3_i_10_n_0),
        .O(prod0__379_carry__3_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__3_i_3
       (.I0(Q[10]),
        .I1(prod0__283_carry__3_n_4),
        .I2(prod0__179_carry__2_n_7),
        .I3(prod0__81_carry__3_n_6),
        .I4(prod0__379_carry__3_i_11_n_0),
        .O(prod0__379_carry__3_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__3_i_4
       (.I0(Q[9]),
        .I1(prod0__283_carry__3_n_5),
        .I2(prod0__179_carry__1_n_4),
        .I3(prod0__81_carry__3_n_7),
        .I4(prod0__379_carry__2_i_12_n_0),
        .O(prod0__379_carry__3_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__3_i_5
       (.I0(prod0__379_carry__3_i_1_n_0),
        .I1(prod0__379_carry__3_i_12_n_0),
        .I2(prod0__81_carry__4_n_7),
        .I3(prod0__179_carry__2_n_4),
        .I4(prod0__283_carry__4_n_5),
        .I5(Q[13]),
        .O(prod0__379_carry__3_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__3_i_6
       (.I0(prod0__379_carry__3_i_2_n_0),
        .I1(prod0__379_carry__3_i_9_n_0),
        .I2(prod0__81_carry__3_n_4),
        .I3(prod0__179_carry__2_n_5),
        .I4(prod0__283_carry__4_n_6),
        .I5(Q[12]),
        .O(prod0__379_carry__3_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__3_i_7
       (.I0(prod0__379_carry__3_i_3_n_0),
        .I1(prod0__379_carry__3_i_10_n_0),
        .I2(prod0__81_carry__3_n_5),
        .I3(prod0__179_carry__2_n_6),
        .I4(prod0__283_carry__4_n_7),
        .I5(Q[11]),
        .O(prod0__379_carry__3_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__3_i_8
       (.I0(prod0__379_carry__3_i_4_n_0),
        .I1(prod0__379_carry__3_i_11_n_0),
        .I2(prod0__81_carry__3_n_6),
        .I3(prod0__179_carry__2_n_7),
        .I4(prod0__283_carry__3_n_4),
        .I5(Q[10]),
        .O(prod0__379_carry__3_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__3_i_9
       (.I0(prod0__179_carry__2_n_4),
        .I1(prod0__283_carry__4_n_5),
        .I2(Q[13]),
        .O(prod0__379_carry__3_i_9_n_0));
  CARRY4 prod0__379_carry__4
       (.CI(prod0__379_carry__3_n_0),
        .CO({prod0__379_carry__4_n_0,prod0__379_carry__4_n_1,prod0__379_carry__4_n_2,prod0__379_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__4_i_1_n_0,prod0__379_carry__4_i_2_n_0,prod0__379_carry__4_i_3_n_0,prod0__379_carry__4_i_4_n_0}),
        .O({prod0__379_carry__4_n_4,prod0__379_carry__4_n_5,prod0__379_carry__4_n_6,prod0__379_carry__4_n_7}),
        .S({prod0__379_carry__4_i_5_n_0,prod0__379_carry__4_i_6_n_0,prod0__379_carry__4_i_7_n_0,prod0__379_carry__4_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__4_i_1
       (.I0(prod0__249_carry_n_6),
        .I1(prod0__283_carry__5_n_6),
        .I2(prod0__179_carry__3_n_5),
        .I3(prod0__81_carry__4_n_4),
        .I4(prod0__379_carry__4_i_9_n_0),
        .O(prod0__379_carry__4_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__4_i_10
       (.I0(prod0__179_carry__3_n_5),
        .I1(prod0__283_carry__5_n_6),
        .I2(prod0__249_carry_n_6),
        .O(prod0__379_carry__4_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__4_i_11
       (.I0(prod0__179_carry__3_n_6),
        .I1(prod0__283_carry__5_n_7),
        .I2(prod0__249_carry_n_7),
        .O(prod0__379_carry__4_i_11_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__4_i_12
       (.I0(prod0__179_carry__4_n_7),
        .I1(prod0__283_carry__5_n_4),
        .I2(prod0__249_carry_n_4),
        .O(prod0__379_carry__4_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__4_i_2
       (.I0(prod0__249_carry_n_7),
        .I1(prod0__283_carry__5_n_7),
        .I2(prod0__179_carry__3_n_6),
        .I3(prod0__81_carry__4_n_5),
        .I4(prod0__379_carry__4_i_10_n_0),
        .O(prod0__379_carry__4_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__4_i_3
       (.I0(Q[14]),
        .I1(prod0__283_carry__4_n_4),
        .I2(prod0__179_carry__3_n_7),
        .I3(prod0__81_carry__4_n_6),
        .I4(prod0__379_carry__4_i_11_n_0),
        .O(prod0__379_carry__4_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__4_i_4
       (.I0(Q[13]),
        .I1(prod0__283_carry__4_n_5),
        .I2(prod0__179_carry__2_n_4),
        .I3(prod0__81_carry__4_n_7),
        .I4(prod0__379_carry__3_i_12_n_0),
        .O(prod0__379_carry__4_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__4_i_5
       (.I0(prod0__379_carry__4_i_1_n_0),
        .I1(prod0__379_carry__4_i_12_n_0),
        .I2(prod0__81_carry__5_n_7),
        .I3(prod0__179_carry__3_n_4),
        .I4(prod0__283_carry__5_n_5),
        .I5(prod0__249_carry_n_5),
        .O(prod0__379_carry__4_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__4_i_6
       (.I0(prod0__379_carry__4_i_2_n_0),
        .I1(prod0__379_carry__4_i_9_n_0),
        .I2(prod0__81_carry__4_n_4),
        .I3(prod0__179_carry__3_n_5),
        .I4(prod0__283_carry__5_n_6),
        .I5(prod0__249_carry_n_6),
        .O(prod0__379_carry__4_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__4_i_7
       (.I0(prod0__379_carry__4_i_3_n_0),
        .I1(prod0__379_carry__4_i_10_n_0),
        .I2(prod0__81_carry__4_n_5),
        .I3(prod0__179_carry__3_n_6),
        .I4(prod0__283_carry__5_n_7),
        .I5(prod0__249_carry_n_7),
        .O(prod0__379_carry__4_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__4_i_8
       (.I0(prod0__379_carry__4_i_4_n_0),
        .I1(prod0__379_carry__4_i_11_n_0),
        .I2(prod0__81_carry__4_n_6),
        .I3(prod0__179_carry__3_n_7),
        .I4(prod0__283_carry__4_n_4),
        .I5(Q[14]),
        .O(prod0__379_carry__4_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__4_i_9
       (.I0(prod0__179_carry__3_n_4),
        .I1(prod0__283_carry__5_n_5),
        .I2(prod0__249_carry_n_5),
        .O(prod0__379_carry__4_i_9_n_0));
  CARRY4 prod0__379_carry__5
       (.CI(prod0__379_carry__4_n_0),
        .CO({prod0__379_carry__5_n_0,prod0__379_carry__5_n_1,prod0__379_carry__5_n_2,prod0__379_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__5_i_1_n_0,prod0__379_carry__5_i_2_n_0,prod0__379_carry__5_i_3_n_0,prod0__379_carry__5_i_4_n_0}),
        .O({prod0__379_carry__5_n_4,prod0__379_carry__5_n_5,prod0__379_carry__5_n_6,prod0__379_carry__5_n_7}),
        .S({prod0__379_carry__5_i_5_n_0,prod0__379_carry__5_i_6_n_0,prod0__379_carry__5_i_7_n_0,prod0__379_carry__5_i_8_n_0}));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__5_i_1
       (.I0(prod0__249_carry__0_n_6),
        .I1(prod0__283_carry__6_n_6),
        .I2(prod0__179_carry__4_n_5),
        .I3(prod0__81_carry__5_n_4),
        .I4(prod0__379_carry__5_i_9_n_0),
        .O(prod0__379_carry__5_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__5_i_10
       (.I0(prod0__179_carry__4_n_5),
        .I1(prod0__283_carry__6_n_6),
        .I2(prod0__249_carry__0_n_6),
        .O(prod0__379_carry__5_i_10_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__5_i_11
       (.I0(prod0__179_carry__4_n_6),
        .I1(prod0__283_carry__6_n_7),
        .I2(prod0__249_carry__0_n_7),
        .O(prod0__379_carry__5_i_11_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__5_i_12
       (.I0(prod0__179_carry__5_n_7),
        .I1(prod0__283_carry__6_n_4),
        .I2(prod0__249_carry__0_n_4),
        .O(prod0__379_carry__5_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__5_i_2
       (.I0(prod0__249_carry__0_n_7),
        .I1(prod0__283_carry__6_n_7),
        .I2(prod0__179_carry__4_n_6),
        .I3(prod0__81_carry__5_n_5),
        .I4(prod0__379_carry__5_i_10_n_0),
        .O(prod0__379_carry__5_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__5_i_3
       (.I0(prod0__249_carry_n_4),
        .I1(prod0__283_carry__5_n_4),
        .I2(prod0__179_carry__4_n_7),
        .I3(prod0__81_carry__5_n_6),
        .I4(prod0__379_carry__5_i_11_n_0),
        .O(prod0__379_carry__5_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__5_i_4
       (.I0(prod0__249_carry_n_5),
        .I1(prod0__283_carry__5_n_5),
        .I2(prod0__179_carry__3_n_4),
        .I3(prod0__81_carry__5_n_7),
        .I4(prod0__379_carry__4_i_12_n_0),
        .O(prod0__379_carry__5_i_4_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__5_i_5
       (.I0(prod0__379_carry__5_i_1_n_0),
        .I1(prod0__379_carry__5_i_12_n_0),
        .I2(prod0__81_carry__6_n_7),
        .I3(prod0__179_carry__4_n_4),
        .I4(prod0__283_carry__6_n_5),
        .I5(prod0__249_carry__0_n_5),
        .O(prod0__379_carry__5_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__5_i_6
       (.I0(prod0__379_carry__5_i_2_n_0),
        .I1(prod0__379_carry__5_i_9_n_0),
        .I2(prod0__81_carry__5_n_4),
        .I3(prod0__179_carry__4_n_5),
        .I4(prod0__283_carry__6_n_6),
        .I5(prod0__249_carry__0_n_6),
        .O(prod0__379_carry__5_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__5_i_7
       (.I0(prod0__379_carry__5_i_3_n_0),
        .I1(prod0__379_carry__5_i_10_n_0),
        .I2(prod0__81_carry__5_n_5),
        .I3(prod0__179_carry__4_n_6),
        .I4(prod0__283_carry__6_n_7),
        .I5(prod0__249_carry__0_n_7),
        .O(prod0__379_carry__5_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__5_i_8
       (.I0(prod0__379_carry__5_i_4_n_0),
        .I1(prod0__379_carry__5_i_11_n_0),
        .I2(prod0__81_carry__5_n_6),
        .I3(prod0__179_carry__4_n_7),
        .I4(prod0__283_carry__5_n_4),
        .I5(prod0__249_carry_n_4),
        .O(prod0__379_carry__5_i_8_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__5_i_9
       (.I0(prod0__179_carry__4_n_4),
        .I1(prod0__283_carry__6_n_5),
        .I2(prod0__249_carry__0_n_5),
        .O(prod0__379_carry__5_i_9_n_0));
  CARRY4 prod0__379_carry__6
       (.CI(prod0__379_carry__5_n_0),
        .CO({prod0__379_carry__6_n_0,prod0__379_carry__6_n_1,prod0__379_carry__6_n_2,prod0__379_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__6_i_1_n_0,prod0__379_carry__6_i_2_n_0,prod0__379_carry__6_i_3_n_0,prod0__379_carry__6_i_4_n_0}),
        .O({prod0__379_carry__6_n_4,prod0__379_carry__6_n_5,prod0__379_carry__6_n_6,prod0__379_carry__6_n_7}),
        .S({prod0__379_carry__6_i_5_n_0,prod0__379_carry__6_i_6_n_0,prod0__379_carry__6_i_7_n_0,prod0__379_carry__6_i_8_n_0}));
  LUT6 #(
    .INIT(64'hF880E0FE80F8FEE0)) 
    prod0__379_carry__6_i_1
       (.I0(prod0__249_carry__1_n_6),
        .I1(prod0__179_carry__5_n_5),
        .I2(prod0__81_carry__6_n_4),
        .I3(prod0__179_carry__5_n_4),
        .I4(prod0__283_carry__7_n_2),
        .I5(prod0__249_carry__1_n_5),
        .O(prod0__379_carry__6_i_1_n_0));
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__6_i_10
       (.I0(prod0__179_carry__5_n_6),
        .I1(prod0__283_carry__7_n_7),
        .I2(prod0__249_carry__1_n_7),
        .O(prod0__379_carry__6_i_10_n_0));
  LUT3 #(
    .INIT(8'hE8)) 
    prod0__379_carry__6_i_11
       (.I0(prod0__179_carry__5_n_4),
        .I1(prod0__283_carry__7_n_2),
        .I2(prod0__249_carry__1_n_5),
        .O(prod0__379_carry__6_i_11_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h96)) 
    prod0__379_carry__6_i_12
       (.I0(prod0__179_carry__5_n_4),
        .I1(prod0__283_carry__7_n_2),
        .I2(prod0__249_carry__1_n_5),
        .O(prod0__379_carry__6_i_12_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__6_i_2
       (.I0(prod0__249_carry__1_n_7),
        .I1(prod0__283_carry__7_n_7),
        .I2(prod0__179_carry__5_n_6),
        .I3(prod0__81_carry__6_n_5),
        .I4(prod0__379_carry__6_i_9_n_0),
        .O(prod0__379_carry__6_i_2_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__6_i_3
       (.I0(prod0__249_carry__0_n_4),
        .I1(prod0__283_carry__6_n_4),
        .I2(prod0__179_carry__5_n_7),
        .I3(prod0__81_carry__6_n_6),
        .I4(prod0__379_carry__6_i_10_n_0),
        .O(prod0__379_carry__6_i_3_n_0));
  LUT5 #(
    .INIT(32'hFFE8E800)) 
    prod0__379_carry__6_i_4
       (.I0(prod0__249_carry__0_n_5),
        .I1(prod0__283_carry__6_n_5),
        .I2(prod0__179_carry__4_n_4),
        .I3(prod0__81_carry__6_n_7),
        .I4(prod0__379_carry__5_i_12_n_0),
        .O(prod0__379_carry__6_i_4_n_0));
  LUT5 #(
    .INIT(32'h96696996)) 
    prod0__379_carry__6_i_5
       (.I0(prod0__379_carry__6_i_1_n_0),
        .I1(prod0__249_carry__1_n_4),
        .I2(prod0__179_carry__6_n_7),
        .I3(prod0__81_carry__7_n_7),
        .I4(prod0__379_carry__6_i_11_n_0),
        .O(prod0__379_carry__6_i_5_n_0));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    prod0__379_carry__6_i_6
       (.I0(prod0__379_carry__6_i_2_n_0),
        .I1(prod0__379_carry__6_i_12_n_0),
        .I2(prod0__81_carry__6_n_4),
        .I3(prod0__283_carry__7_n_2),
        .I4(prod0__179_carry__5_n_5),
        .I5(prod0__249_carry__1_n_6),
        .O(prod0__379_carry__6_i_6_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__6_i_7
       (.I0(prod0__379_carry__6_i_3_n_0),
        .I1(prod0__379_carry__6_i_9_n_0),
        .I2(prod0__81_carry__6_n_5),
        .I3(prod0__179_carry__5_n_6),
        .I4(prod0__283_carry__7_n_7),
        .I5(prod0__249_carry__1_n_7),
        .O(prod0__379_carry__6_i_7_n_0));
  LUT6 #(
    .INIT(64'h6969699669969696)) 
    prod0__379_carry__6_i_8
       (.I0(prod0__379_carry__6_i_4_n_0),
        .I1(prod0__379_carry__6_i_10_n_0),
        .I2(prod0__81_carry__6_n_6),
        .I3(prod0__179_carry__5_n_7),
        .I4(prod0__283_carry__6_n_4),
        .I5(prod0__249_carry__0_n_4),
        .O(prod0__379_carry__6_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h69)) 
    prod0__379_carry__6_i_9
       (.I0(prod0__179_carry__5_n_5),
        .I1(prod0__283_carry__7_n_2),
        .I2(prod0__249_carry__1_n_6),
        .O(prod0__379_carry__6_i_9_n_0));
  CARRY4 prod0__379_carry__7
       (.CI(prod0__379_carry__6_n_0),
        .CO({prod0__379_carry__7_n_0,prod0__379_carry__7_n_1,prod0__379_carry__7_n_2,prod0__379_carry__7_n_3}),
        .CYINIT(1'b0),
        .DI({prod0__379_carry__7_i_1_n_0,prod0__379_carry__7_i_2_n_0,prod0__379_carry__7_i_3_n_0,prod0__379_carry__7_i_4_n_0}),
        .O({prod0__379_carry__7_n_4,prod0__379_carry__7_n_5,prod0__379_carry__7_n_6,prod0__379_carry__7_n_7}),
        .S({prod0__379_carry__7_i_5_n_0,prod0__379_carry__7_i_6_n_0,prod0__379_carry__7_i_7_n_0,prod0__379_carry__7_i_8_n_0}));
  (* HLUTNM = "lutpair31" *) 
  LUT4 #(
    .INIT(16'h6000)) 
    prod0__379_carry__7_i_1
       (.I0(prod0__249_carry__2_n_5),
        .I1(prod0__179_carry__6_n_4),
        .I2(prod0__179_carry__6_n_5),
        .I3(prod0__249_carry__2_n_6),
        .O(prod0__379_carry__7_i_1_n_0));
  LUT5 #(
    .INIT(32'h80F8F880)) 
    prod0__379_carry__7_i_2
       (.I0(prod0__179_carry__6_n_6),
        .I1(prod0__249_carry__2_n_7),
        .I2(prod0__81_carry__7_n_1),
        .I3(prod0__179_carry__6_n_5),
        .I4(prod0__249_carry__2_n_6),
        .O(prod0__379_carry__7_i_2_n_0));
  LUT5 #(
    .INIT(32'h80F8F880)) 
    prod0__379_carry__7_i_3
       (.I0(prod0__179_carry__6_n_7),
        .I1(prod0__249_carry__1_n_4),
        .I2(prod0__81_carry__7_n_6),
        .I3(prod0__179_carry__6_n_6),
        .I4(prod0__249_carry__2_n_7),
        .O(prod0__379_carry__7_i_3_n_0));
  LUT6 #(
    .INIT(64'hE800FFE8FFE8E800)) 
    prod0__379_carry__7_i_4
       (.I0(prod0__249_carry__1_n_5),
        .I1(prod0__283_carry__7_n_2),
        .I2(prod0__179_carry__5_n_4),
        .I3(prod0__81_carry__7_n_7),
        .I4(prod0__179_carry__6_n_7),
        .I5(prod0__249_carry__1_n_4),
        .O(prod0__379_carry__7_i_4_n_0));
  (* HLUTNM = "lutpair32" *) 
  LUT5 #(
    .INIT(32'h69999666)) 
    prod0__379_carry__7_i_5
       (.I0(prod0__249_carry__2_n_4),
        .I1(prod0__179_carry__7_n_7),
        .I2(prod0__179_carry__6_n_4),
        .I3(prod0__249_carry__2_n_5),
        .I4(prod0__379_carry__7_i_1_n_0),
        .O(prod0__379_carry__7_i_5_n_0));
  (* HLUTNM = "lutpair31" *) 
  LUT5 #(
    .INIT(32'h69999666)) 
    prod0__379_carry__7_i_6
       (.I0(prod0__249_carry__2_n_5),
        .I1(prod0__179_carry__6_n_4),
        .I2(prod0__179_carry__6_n_5),
        .I3(prod0__249_carry__2_n_6),
        .I4(prod0__379_carry__7_i_2_n_0),
        .O(prod0__379_carry__7_i_6_n_0));
  LUT6 #(
    .INIT(64'h9669699669966996)) 
    prod0__379_carry__7_i_7
       (.I0(prod0__379_carry__7_i_3_n_0),
        .I1(prod0__249_carry__2_n_6),
        .I2(prod0__179_carry__6_n_5),
        .I3(prod0__81_carry__7_n_1),
        .I4(prod0__249_carry__2_n_7),
        .I5(prod0__179_carry__6_n_6),
        .O(prod0__379_carry__7_i_7_n_0));
  LUT6 #(
    .INIT(64'h9669699669966996)) 
    prod0__379_carry__7_i_8
       (.I0(prod0__379_carry__7_i_4_n_0),
        .I1(prod0__249_carry__2_n_7),
        .I2(prod0__179_carry__6_n_6),
        .I3(prod0__81_carry__7_n_6),
        .I4(prod0__249_carry__1_n_4),
        .I5(prod0__179_carry__6_n_7),
        .O(prod0__379_carry__7_i_8_n_0));
  CARRY4 prod0__379_carry__8
       (.CI(prod0__379_carry__7_n_0),
        .CO({NLW_prod0__379_carry__8_CO_UNCONNECTED[3:1],prod0__379_carry__8_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,prod0__379_carry__8_i_1_n_0}),
        .O({NLW_prod0__379_carry__8_O_UNCONNECTED[3:2],prod0__379_carry__8_n_6,prod0__379_carry__8_n_7}),
        .S({1'b0,1'b0,prod0__379_carry__8_i_2_n_0,prod0__379_carry__8_i_3_n_0}));
  (* HLUTNM = "lutpair32" *) 
  LUT4 #(
    .INIT(16'h6000)) 
    prod0__379_carry__8_i_1
       (.I0(prod0__249_carry__2_n_4),
        .I1(prod0__179_carry__7_n_7),
        .I2(prod0__179_carry__6_n_4),
        .I3(prod0__249_carry__2_n_5),
        .O(prod0__379_carry__8_i_1_n_0));
  LUT6 #(
    .INIT(64'h0FF078877887F00F)) 
    prod0__379_carry__8_i_2
       (.I0(prod0__249_carry__2_n_4),
        .I1(prod0__179_carry__7_n_7),
        .I2(prod0__179_carry__7_n_5),
        .I3(prod0__249_carry__3_n_2),
        .I4(prod0__249_carry__3_n_7),
        .I5(prod0__179_carry__7_n_6),
        .O(prod0__379_carry__8_i_2_n_0));
  LUT5 #(
    .INIT(32'h69969696)) 
    prod0__379_carry__8_i_3
       (.I0(prod0__379_carry__8_i_1_n_0),
        .I1(prod0__179_carry__7_n_6),
        .I2(prod0__249_carry__3_n_7),
        .I3(prod0__249_carry__2_n_4),
        .I4(prod0__179_carry__7_n_7),
        .O(prod0__379_carry__8_i_3_n_0));
  (* HLUTNM = "lutpair29" *) 
  LUT2 #(
    .INIT(4'h8)) 
    prod0__379_carry_i_1
       (.I0(prod0__81_carry_n_4),
        .I1(prod0__283_carry__0_n_5),
        .O(prod0__379_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    prod0__379_carry_i_2
       (.I0(prod0__81_carry_n_5),
        .I1(prod0__283_carry__0_n_6),
        .O(prod0__379_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    prod0__379_carry_i_3
       (.I0(prod0__81_carry_n_6),
        .I1(prod0__283_carry__0_n_7),
        .O(prod0__379_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    prod0__379_carry_i_4
       (.I0(prod0_carry_n_7),
        .I1(prod0__283_carry_n_4),
        .O(prod0__379_carry_i_4_n_0));
  (* HLUTNM = "lutpair30" *) 
  LUT4 #(
    .INIT(16'h6996)) 
    prod0__379_carry_i_5
       (.I0(prod0__81_carry__0_n_7),
        .I1(prod0__283_carry__0_n_4),
        .I2(Q[0]),
        .I3(prod0__379_carry_i_1_n_0),
        .O(prod0__379_carry_i_5_n_0));
  (* HLUTNM = "lutpair29" *) 
  LUT4 #(
    .INIT(16'h9666)) 
    prod0__379_carry_i_6
       (.I0(prod0__81_carry_n_4),
        .I1(prod0__283_carry__0_n_5),
        .I2(prod0__283_carry__0_n_6),
        .I3(prod0__81_carry_n_5),
        .O(prod0__379_carry_i_6_n_0));
  LUT4 #(
    .INIT(16'h8778)) 
    prod0__379_carry_i_7
       (.I0(prod0__283_carry__0_n_7),
        .I1(prod0__81_carry_n_6),
        .I2(prod0__81_carry_n_5),
        .I3(prod0__283_carry__0_n_6),
        .O(prod0__379_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h8778)) 
    prod0__379_carry_i_8
       (.I0(prod0__283_carry_n_4),
        .I1(prod0_carry_n_7),
        .I2(prod0__81_carry_n_6),
        .I3(prod0__283_carry__0_n_7),
        .O(prod0__379_carry_i_8_n_0));
  CARRY4 prod0__70_carry
       (.CI(1'b0),
        .CO({prod0__70_carry_n_0,prod0__70_carry_n_1,prod0__70_carry_n_2,prod0__70_carry_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,Q[30:29],1'b0}),
        .O({prod0__70_carry_n_4,prod0__70_carry_n_5,prod0__70_carry_n_6,prod0__70_carry_n_7}),
        .S({prod0__70_carry_i_1_n_0,prod0__70_carry_i_2_n_0,prod0__70_carry_i_3_n_0,Q[28]}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__70_carry_i_1
       (.I0(Q[31]),
        .O(prod0__70_carry_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__70_carry_i_2
       (.I0(Q[30]),
        .O(prod0__70_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__70_carry_i_3
       (.I0(Q[29]),
        .O(prod0__70_carry_i_3_n_0));
  CARRY4 prod0__81_carry
       (.CI(1'b0),
        .CO({prod0__81_carry_n_0,prod0__81_carry_n_1,prod0__81_carry_n_2,prod0__81_carry_n_3}),
        .CYINIT(1'b0),
        .DI({Q[1:0],1'b0,1'b1}),
        .O({prod0__81_carry_n_4,prod0__81_carry_n_5,prod0__81_carry_n_6,NLW_prod0__81_carry_O_UNCONNECTED[0]}),
        .S({prod0__81_carry_i_1_n_0,prod0__81_carry_i_2_n_0,prod0__81_carry_i_3_n_0,Q[0]}));
  CARRY4 prod0__81_carry__0
       (.CI(prod0__81_carry_n_0),
        .CO({prod0__81_carry__0_n_0,prod0__81_carry__0_n_1,prod0__81_carry__0_n_2,prod0__81_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(Q[5:2]),
        .O({prod0__81_carry__0_n_4,prod0__81_carry__0_n_5,prod0__81_carry__0_n_6,prod0__81_carry__0_n_7}),
        .S({prod0__81_carry__0_i_1_n_0,prod0__81_carry__0_i_2_n_0,prod0__81_carry__0_i_3_n_0,prod0__81_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__0_i_1
       (.I0(Q[5]),
        .I1(Q[7]),
        .O(prod0__81_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__0_i_2
       (.I0(Q[4]),
        .I1(Q[6]),
        .O(prod0__81_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__0_i_3
       (.I0(Q[3]),
        .I1(Q[5]),
        .O(prod0__81_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__0_i_4
       (.I0(Q[2]),
        .I1(Q[4]),
        .O(prod0__81_carry__0_i_4_n_0));
  CARRY4 prod0__81_carry__1
       (.CI(prod0__81_carry__0_n_0),
        .CO({prod0__81_carry__1_n_0,prod0__81_carry__1_n_1,prod0__81_carry__1_n_2,prod0__81_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(Q[9:6]),
        .O({prod0__81_carry__1_n_4,prod0__81_carry__1_n_5,prod0__81_carry__1_n_6,prod0__81_carry__1_n_7}),
        .S({prod0__81_carry__1_i_1_n_0,prod0__81_carry__1_i_2_n_0,prod0__81_carry__1_i_3_n_0,prod0__81_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__1_i_1
       (.I0(Q[9]),
        .I1(Q[11]),
        .O(prod0__81_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__1_i_2
       (.I0(Q[8]),
        .I1(Q[10]),
        .O(prod0__81_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__1_i_3
       (.I0(Q[7]),
        .I1(Q[9]),
        .O(prod0__81_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__1_i_4
       (.I0(Q[6]),
        .I1(Q[8]),
        .O(prod0__81_carry__1_i_4_n_0));
  CARRY4 prod0__81_carry__2
       (.CI(prod0__81_carry__1_n_0),
        .CO({prod0__81_carry__2_n_0,prod0__81_carry__2_n_1,prod0__81_carry__2_n_2,prod0__81_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(Q[13:10]),
        .O({prod0__81_carry__2_n_4,prod0__81_carry__2_n_5,prod0__81_carry__2_n_6,prod0__81_carry__2_n_7}),
        .S({prod0__81_carry__2_i_1_n_0,prod0__81_carry__2_i_2_n_0,prod0__81_carry__2_i_3_n_0,prod0__81_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__2_i_1
       (.I0(Q[13]),
        .I1(Q[15]),
        .O(prod0__81_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__2_i_2
       (.I0(Q[12]),
        .I1(Q[14]),
        .O(prod0__81_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__2_i_3
       (.I0(Q[11]),
        .I1(Q[13]),
        .O(prod0__81_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__2_i_4
       (.I0(Q[10]),
        .I1(Q[12]),
        .O(prod0__81_carry__2_i_4_n_0));
  CARRY4 prod0__81_carry__3
       (.CI(prod0__81_carry__2_n_0),
        .CO({prod0__81_carry__3_n_0,prod0__81_carry__3_n_1,prod0__81_carry__3_n_2,prod0__81_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(Q[17:14]),
        .O({prod0__81_carry__3_n_4,prod0__81_carry__3_n_5,prod0__81_carry__3_n_6,prod0__81_carry__3_n_7}),
        .S({prod0__81_carry__3_i_1_n_0,prod0__81_carry__3_i_2_n_0,prod0__81_carry__3_i_3_n_0,prod0__81_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__3_i_1
       (.I0(Q[17]),
        .I1(Q[19]),
        .O(prod0__81_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__3_i_2
       (.I0(Q[16]),
        .I1(Q[18]),
        .O(prod0__81_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__3_i_3
       (.I0(Q[15]),
        .I1(Q[17]),
        .O(prod0__81_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__3_i_4
       (.I0(Q[14]),
        .I1(Q[16]),
        .O(prod0__81_carry__3_i_4_n_0));
  CARRY4 prod0__81_carry__4
       (.CI(prod0__81_carry__3_n_0),
        .CO({prod0__81_carry__4_n_0,prod0__81_carry__4_n_1,prod0__81_carry__4_n_2,prod0__81_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(Q[21:18]),
        .O({prod0__81_carry__4_n_4,prod0__81_carry__4_n_5,prod0__81_carry__4_n_6,prod0__81_carry__4_n_7}),
        .S({prod0__81_carry__4_i_1_n_0,prod0__81_carry__4_i_2_n_0,prod0__81_carry__4_i_3_n_0,prod0__81_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__4_i_1
       (.I0(Q[21]),
        .I1(Q[23]),
        .O(prod0__81_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__4_i_2
       (.I0(Q[20]),
        .I1(Q[22]),
        .O(prod0__81_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__4_i_3
       (.I0(Q[19]),
        .I1(Q[21]),
        .O(prod0__81_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__4_i_4
       (.I0(Q[18]),
        .I1(Q[20]),
        .O(prod0__81_carry__4_i_4_n_0));
  CARRY4 prod0__81_carry__5
       (.CI(prod0__81_carry__4_n_0),
        .CO({prod0__81_carry__5_n_0,prod0__81_carry__5_n_1,prod0__81_carry__5_n_2,prod0__81_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(Q[25:22]),
        .O({prod0__81_carry__5_n_4,prod0__81_carry__5_n_5,prod0__81_carry__5_n_6,prod0__81_carry__5_n_7}),
        .S({prod0__81_carry__5_i_1_n_0,prod0__81_carry__5_i_2_n_0,prod0__81_carry__5_i_3_n_0,prod0__81_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__5_i_1
       (.I0(Q[25]),
        .I1(Q[27]),
        .O(prod0__81_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__5_i_2
       (.I0(Q[24]),
        .I1(Q[26]),
        .O(prod0__81_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__5_i_3
       (.I0(Q[23]),
        .I1(Q[25]),
        .O(prod0__81_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__5_i_4
       (.I0(Q[22]),
        .I1(Q[24]),
        .O(prod0__81_carry__5_i_4_n_0));
  CARRY4 prod0__81_carry__6
       (.CI(prod0__81_carry__5_n_0),
        .CO({prod0__81_carry__6_n_0,prod0__81_carry__6_n_1,prod0__81_carry__6_n_2,prod0__81_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI(Q[29:26]),
        .O({prod0__81_carry__6_n_4,prod0__81_carry__6_n_5,prod0__81_carry__6_n_6,prod0__81_carry__6_n_7}),
        .S({prod0__81_carry__6_i_1_n_0,prod0__81_carry__6_i_2_n_0,prod0__81_carry__6_i_3_n_0,prod0__81_carry__6_i_4_n_0}));
  LUT2 #(
    .INIT(4'h6)) 
    prod0__81_carry__6_i_1
       (.I0(Q[29]),
        .I1(Q[31]),
        .O(prod0__81_carry__6_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__6_i_2
       (.I0(Q[28]),
        .I1(Q[30]),
        .O(prod0__81_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__6_i_3
       (.I0(Q[27]),
        .I1(Q[29]),
        .O(prod0__81_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry__6_i_4
       (.I0(Q[26]),
        .I1(Q[28]),
        .O(prod0__81_carry__6_i_4_n_0));
  CARRY4 prod0__81_carry__7
       (.CI(prod0__81_carry__6_n_0),
        .CO({NLW_prod0__81_carry__7_CO_UNCONNECTED[3],prod0__81_carry__7_n_1,NLW_prod0__81_carry__7_CO_UNCONNECTED[1],prod0__81_carry__7_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,Q[30]}),
        .O({NLW_prod0__81_carry__7_O_UNCONNECTED[3:2],prod0__81_carry__7_n_6,prod0__81_carry__7_n_7}),
        .S({1'b0,1'b1,prod0__81_carry__7_i_1_n_0,prod0__81_carry__7_i_2_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__81_carry__7_i_1
       (.I0(Q[31]),
        .O(prod0__81_carry__7_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__81_carry__7_i_2
       (.I0(Q[30]),
        .O(prod0__81_carry__7_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry_i_1
       (.I0(Q[1]),
        .I1(Q[3]),
        .O(prod0__81_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0__81_carry_i_2
       (.I0(Q[0]),
        .I1(Q[2]),
        .O(prod0__81_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0__81_carry_i_3
       (.I0(Q[1]),
        .O(prod0__81_carry_i_3_n_0));
  CARRY4 prod0_carry
       (.CI(1'b0),
        .CO({prod0_carry_n_0,prod0_carry_n_1,prod0_carry_n_2,prod0_carry_n_3}),
        .CYINIT(1'b0),
        .DI({Q[1:0],1'b0,1'b1}),
        .O({NLW_prod0_carry_O_UNCONNECTED[3:1],prod0_carry_n_7}),
        .S({prod0_carry_i_1_n_0,prod0_carry_i_2_n_0,prod0_carry_i_3_n_0,Q[0]}));
  CARRY4 prod0_carry__0
       (.CI(prod0_carry_n_0),
        .CO({prod0_carry__0_n_0,prod0_carry__0_n_1,prod0_carry__0_n_2,prod0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI(Q[5:2]),
        .O({prod0_carry__0_n_4,prod0_carry__0_n_5,prod0_carry__0_n_6,prod0_carry__0_n_7}),
        .S({prod0_carry__0_i_1_n_0,prod0_carry__0_i_2_n_0,prod0_carry__0_i_3_n_0,prod0_carry__0_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__0_i_1
       (.I0(Q[5]),
        .I1(Q[7]),
        .O(prod0_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__0_i_2
       (.I0(Q[4]),
        .I1(Q[6]),
        .O(prod0_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__0_i_3
       (.I0(Q[3]),
        .I1(Q[5]),
        .O(prod0_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__0_i_4
       (.I0(Q[2]),
        .I1(Q[4]),
        .O(prod0_carry__0_i_4_n_0));
  CARRY4 prod0_carry__1
       (.CI(prod0_carry__0_n_0),
        .CO({prod0_carry__1_n_0,prod0_carry__1_n_1,prod0_carry__1_n_2,prod0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI(Q[9:6]),
        .O({prod0_carry__1_n_4,prod0_carry__1_n_5,prod0_carry__1_n_6,prod0_carry__1_n_7}),
        .S({prod0_carry__1_i_1_n_0,prod0_carry__1_i_2_n_0,prod0_carry__1_i_3_n_0,prod0_carry__1_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__1_i_1
       (.I0(Q[9]),
        .I1(Q[11]),
        .O(prod0_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__1_i_2
       (.I0(Q[8]),
        .I1(Q[10]),
        .O(prod0_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__1_i_3
       (.I0(Q[7]),
        .I1(Q[9]),
        .O(prod0_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__1_i_4
       (.I0(Q[6]),
        .I1(Q[8]),
        .O(prod0_carry__1_i_4_n_0));
  CARRY4 prod0_carry__2
       (.CI(prod0_carry__1_n_0),
        .CO({prod0_carry__2_n_0,prod0_carry__2_n_1,prod0_carry__2_n_2,prod0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI(Q[13:10]),
        .O({prod0_carry__2_n_4,prod0_carry__2_n_5,prod0_carry__2_n_6,prod0_carry__2_n_7}),
        .S({prod0_carry__2_i_1_n_0,prod0_carry__2_i_2_n_0,prod0_carry__2_i_3_n_0,prod0_carry__2_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__2_i_1
       (.I0(Q[13]),
        .I1(Q[15]),
        .O(prod0_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__2_i_2
       (.I0(Q[12]),
        .I1(Q[14]),
        .O(prod0_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__2_i_3
       (.I0(Q[11]),
        .I1(Q[13]),
        .O(prod0_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__2_i_4
       (.I0(Q[10]),
        .I1(Q[12]),
        .O(prod0_carry__2_i_4_n_0));
  CARRY4 prod0_carry__3
       (.CI(prod0_carry__2_n_0),
        .CO({prod0_carry__3_n_0,prod0_carry__3_n_1,prod0_carry__3_n_2,prod0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI(Q[17:14]),
        .O({prod0_carry__3_n_4,prod0_carry__3_n_5,prod0_carry__3_n_6,prod0_carry__3_n_7}),
        .S({prod0_carry__3_i_1_n_0,prod0_carry__3_i_2_n_0,prod0_carry__3_i_3_n_0,prod0_carry__3_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__3_i_1
       (.I0(Q[17]),
        .I1(Q[19]),
        .O(prod0_carry__3_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__3_i_2
       (.I0(Q[16]),
        .I1(Q[18]),
        .O(prod0_carry__3_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__3_i_3
       (.I0(Q[15]),
        .I1(Q[17]),
        .O(prod0_carry__3_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__3_i_4
       (.I0(Q[14]),
        .I1(Q[16]),
        .O(prod0_carry__3_i_4_n_0));
  CARRY4 prod0_carry__4
       (.CI(prod0_carry__3_n_0),
        .CO({prod0_carry__4_n_0,prod0_carry__4_n_1,prod0_carry__4_n_2,prod0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI(Q[21:18]),
        .O({prod0_carry__4_n_4,prod0_carry__4_n_5,prod0_carry__4_n_6,prod0_carry__4_n_7}),
        .S({prod0_carry__4_i_1_n_0,prod0_carry__4_i_2_n_0,prod0_carry__4_i_3_n_0,prod0_carry__4_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__4_i_1
       (.I0(Q[21]),
        .I1(Q[23]),
        .O(prod0_carry__4_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__4_i_2
       (.I0(Q[20]),
        .I1(Q[22]),
        .O(prod0_carry__4_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__4_i_3
       (.I0(Q[19]),
        .I1(Q[21]),
        .O(prod0_carry__4_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__4_i_4
       (.I0(Q[18]),
        .I1(Q[20]),
        .O(prod0_carry__4_i_4_n_0));
  CARRY4 prod0_carry__5
       (.CI(prod0_carry__4_n_0),
        .CO({prod0_carry__5_n_0,prod0_carry__5_n_1,prod0_carry__5_n_2,prod0_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI(Q[25:22]),
        .O({prod0_carry__5_n_4,prod0_carry__5_n_5,prod0_carry__5_n_6,prod0_carry__5_n_7}),
        .S({prod0_carry__5_i_1_n_0,prod0_carry__5_i_2_n_0,prod0_carry__5_i_3_n_0,prod0_carry__5_i_4_n_0}));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__5_i_1
       (.I0(Q[25]),
        .I1(Q[27]),
        .O(prod0_carry__5_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__5_i_2
       (.I0(Q[24]),
        .I1(Q[26]),
        .O(prod0_carry__5_i_2_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__5_i_3
       (.I0(Q[23]),
        .I1(Q[25]),
        .O(prod0_carry__5_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__5_i_4
       (.I0(Q[22]),
        .I1(Q[24]),
        .O(prod0_carry__5_i_4_n_0));
  CARRY4 prod0_carry__6
       (.CI(prod0_carry__5_n_0),
        .CO({prod0_carry__6_n_0,prod0_carry__6_n_1,prod0_carry__6_n_2,prod0_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({prod0_carry__6_i_1_n_0,Q[30],Q[27:26]}),
        .O({prod0_carry__6_n_4,prod0_carry__6_n_5,prod0_carry__6_n_6,prod0_carry__6_n_7}),
        .S({prod0_carry__6_i_2_n_0,prod0_carry__6_i_3_n_0,prod0_carry__6_i_4_n_0,prod0_carry__6_i_5_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0_carry__6_i_1
       (.I0(Q[30]),
        .O(prod0_carry__6_i_1_n_0));
  LUT3 #(
    .INIT(8'h69)) 
    prod0_carry__6_i_2
       (.I0(Q[30]),
        .I1(Q[31]),
        .I2(Q[29]),
        .O(prod0_carry__6_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    prod0_carry__6_i_3
       (.I0(Q[30]),
        .I1(Q[28]),
        .O(prod0_carry__6_i_3_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__6_i_4
       (.I0(Q[27]),
        .I1(Q[29]),
        .O(prod0_carry__6_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry__6_i_5
       (.I0(Q[26]),
        .I1(Q[28]),
        .O(prod0_carry__6_i_5_n_0));
  CARRY4 prod0_carry__7
       (.CI(prod0_carry__6_n_0),
        .CO({prod0_carry__7_n_0,NLW_prod0_carry__7_CO_UNCONNECTED[2],prod0_carry__7_n_2,prod0_carry__7_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,prod0_carry__7_i_1_n_0,Q[30],prod0_carry__7_i_2_n_0}),
        .O({NLW_prod0_carry__7_O_UNCONNECTED[3],prod0_carry__7_n_5,prod0_carry__7_n_6,prod0_carry__7_n_7}),
        .S({1'b1,Q[31],prod0_carry__7_i_3_n_0,prod0_carry__7_i_4_n_0}));
  LUT1 #(
    .INIT(2'h1)) 
    prod0_carry__7_i_1
       (.I0(Q[31]),
        .O(prod0_carry__7_i_1_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    prod0_carry__7_i_2
       (.I0(Q[31]),
        .I1(Q[29]),
        .O(prod0_carry__7_i_2_n_0));
  LUT2 #(
    .INIT(4'h6)) 
    prod0_carry__7_i_3
       (.I0(Q[30]),
        .I1(Q[31]),
        .O(prod0_carry__7_i_3_n_0));
  LUT3 #(
    .INIT(8'h87)) 
    prod0_carry__7_i_4
       (.I0(Q[29]),
        .I1(Q[31]),
        .I2(Q[30]),
        .O(prod0_carry__7_i_4_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry_i_1
       (.I0(Q[1]),
        .I1(Q[3]),
        .O(prod0_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'h9)) 
    prod0_carry_i_2
       (.I0(Q[0]),
        .I1(Q[2]),
        .O(prod0_carry_i_2_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    prod0_carry_i_3
       (.I0(Q[1]),
        .O(prod0_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    \prod[47]_i_1 
       (.I0(\FSM_onehot_st_reg_n_0_[0] ),
        .I1(start_pulse),
        .O(prod));
  FDCE \prod_reg[16] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__0_n_5),
        .Q(p_0_in1_in[0]));
  FDCE \prod_reg[17] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__0_n_4),
        .Q(p_0_in1_in[1]));
  FDCE \prod_reg[18] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__1_n_7),
        .Q(p_0_in1_in[2]));
  FDCE \prod_reg[19] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__1_n_6),
        .Q(p_0_in1_in[3]));
  FDCE \prod_reg[20] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__1_n_5),
        .Q(p_0_in1_in[4]));
  FDCE \prod_reg[21] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__1_n_4),
        .Q(p_0_in1_in[5]));
  FDCE \prod_reg[22] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__2_n_7),
        .Q(p_0_in1_in[6]));
  FDCE \prod_reg[23] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__2_n_6),
        .Q(p_0_in1_in[7]));
  FDCE \prod_reg[24] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__2_n_5),
        .Q(p_0_in1_in[8]));
  FDCE \prod_reg[25] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__2_n_4),
        .Q(p_0_in1_in[9]));
  FDCE \prod_reg[26] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__3_n_7),
        .Q(p_0_in1_in[10]));
  FDCE \prod_reg[27] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__3_n_6),
        .Q(p_0_in1_in[11]));
  FDCE \prod_reg[28] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__3_n_5),
        .Q(p_0_in1_in[12]));
  FDCE \prod_reg[29] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__3_n_4),
        .Q(p_0_in1_in[13]));
  FDCE \prod_reg[30] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__4_n_7),
        .Q(p_0_in1_in[14]));
  FDCE \prod_reg[31] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__4_n_6),
        .Q(p_0_in1_in[15]));
  FDCE \prod_reg[32] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__4_n_5),
        .Q(p_0_in1_in[16]));
  FDCE \prod_reg[33] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__4_n_4),
        .Q(p_0_in1_in[17]));
  FDCE \prod_reg[34] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__5_n_7),
        .Q(p_0_in1_in[18]));
  FDCE \prod_reg[35] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__5_n_6),
        .Q(p_0_in1_in[19]));
  FDCE \prod_reg[36] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__5_n_5),
        .Q(p_0_in1_in[20]));
  FDCE \prod_reg[37] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__5_n_4),
        .Q(p_0_in1_in[21]));
  FDCE \prod_reg[38] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__6_n_7),
        .Q(p_0_in1_in[22]));
  FDCE \prod_reg[39] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__6_n_6),
        .Q(p_0_in1_in[23]));
  FDCE \prod_reg[40] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__6_n_5),
        .Q(p_0_in1_in[24]));
  FDCE \prod_reg[41] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__6_n_4),
        .Q(p_0_in1_in[25]));
  FDCE \prod_reg[42] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__7_n_7),
        .Q(p_0_in1_in[26]));
  FDCE \prod_reg[43] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__7_n_6),
        .Q(p_0_in1_in[27]));
  FDCE \prod_reg[44] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__7_n_5),
        .Q(p_0_in1_in[28]));
  FDCE \prod_reg[45] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__7_n_4),
        .Q(p_0_in1_in[29]));
  FDCE \prod_reg[46] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__8_n_7),
        .Q(p_0_in1_in[30]));
  FDCE \prod_reg[47] 
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(prod0__379_carry__8_n_6),
        .Q(p_0_in1_in[31]));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 reset_b0_carry
       (.CI(1'b0),
        .CO({reset_b0_carry_n_0,reset_b0_carry_n_1,reset_b0_carry_n_2,reset_b0_carry_n_3}),
        .CYINIT(1'b1),
        .DI({reset_b0_carry_i_1_n_0,reset_b0_carry_i_2_n_0,reset_b0_carry_i_3_n_0,1'b1}),
        .O(NLW_reset_b0_carry_O_UNCONNECTED[3:0]),
        .S({reset_b0_carry_i_4_n_0,reset_b0_carry_i_5_n_0,reset_b0_carry_i_6_n_0,reset_b0_carry_i_7_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 reset_b0_carry__0
       (.CI(reset_b0_carry_n_0),
        .CO({reset_b0_carry__0_n_0,reset_b0_carry__0_n_1,reset_b0_carry__0_n_2,reset_b0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({reset_b0_carry__0_i_1_n_0,reset_b0_carry__0_i_2_n_0,reset_b0_carry__0_i_3_n_0,reset_b0_carry__0_i_4_n_0}),
        .O(NLW_reset_b0_carry__0_O_UNCONNECTED[3:0]),
        .S({reset_b0_carry__0_i_5_n_0,reset_b0_carry__0_i_6_n_0,reset_b0_carry__0_i_7_n_0,reset_b0_carry__0_i_8_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__0_i_1
       (.I0(Q[14]),
        .I1(Q[15]),
        .O(reset_b0_carry__0_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__0_i_2
       (.I0(Q[12]),
        .I1(Q[13]),
        .O(reset_b0_carry__0_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__0_i_3
       (.I0(Q[10]),
        .I1(Q[11]),
        .O(reset_b0_carry__0_i_3_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__0_i_4
       (.I0(Q[8]),
        .I1(Q[9]),
        .O(reset_b0_carry__0_i_4_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__0_i_5
       (.I0(Q[15]),
        .I1(Q[14]),
        .O(reset_b0_carry__0_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__0_i_6
       (.I0(Q[13]),
        .I1(Q[12]),
        .O(reset_b0_carry__0_i_6_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__0_i_7
       (.I0(Q[11]),
        .I1(Q[10]),
        .O(reset_b0_carry__0_i_7_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__0_i_8
       (.I0(Q[9]),
        .I1(Q[8]),
        .O(reset_b0_carry__0_i_8_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 reset_b0_carry__1
       (.CI(reset_b0_carry__0_n_0),
        .CO({reset_b0_carry__1_n_0,reset_b0_carry__1_n_1,reset_b0_carry__1_n_2,reset_b0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({reset_b0_carry__1_i_1_n_0,reset_b0_carry__1_i_2_n_0,reset_b0_carry__1_i_3_n_0,Q[17]}),
        .O(NLW_reset_b0_carry__1_O_UNCONNECTED[3:0]),
        .S({reset_b0_carry__1_i_4_n_0,reset_b0_carry__1_i_5_n_0,reset_b0_carry__1_i_6_n_0,reset_b0_carry__1_i_7_n_0}));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__1_i_1
       (.I0(Q[22]),
        .I1(Q[23]),
        .O(reset_b0_carry__1_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__1_i_2
       (.I0(Q[20]),
        .I1(Q[21]),
        .O(reset_b0_carry__1_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__1_i_3
       (.I0(Q[18]),
        .I1(Q[19]),
        .O(reset_b0_carry__1_i_3_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__1_i_4
       (.I0(Q[23]),
        .I1(Q[22]),
        .O(reset_b0_carry__1_i_4_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__1_i_5
       (.I0(Q[21]),
        .I1(Q[20]),
        .O(reset_b0_carry__1_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__1_i_6
       (.I0(Q[19]),
        .I1(Q[18]),
        .O(reset_b0_carry__1_i_6_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    reset_b0_carry__1_i_7
       (.I0(Q[16]),
        .I1(Q[17]),
        .O(reset_b0_carry__1_i_7_n_0));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 reset_b0_carry__2
       (.CI(reset_b0_carry__1_n_0),
        .CO({p_0_in,reset_b0_carry__2_n_1,reset_b0_carry__2_n_2,reset_b0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({reset_b0_carry__2_i_1_n_0,reset_b0_carry__2_i_2_n_0,reset_b0_carry__2_i_3_n_0,reset_b0_carry__2_i_4_n_0}),
        .O(NLW_reset_b0_carry__2_O_UNCONNECTED[3:0]),
        .S({reset_b0_carry__2_i_5_n_0,reset_b0_carry__2_i_6_n_0,reset_b0_carry__2_i_7_n_0,reset_b0_carry__2_i_8_n_0}));
  LUT2 #(
    .INIT(4'h2)) 
    reset_b0_carry__2_i_1
       (.I0(Q[30]),
        .I1(Q[31]),
        .O(reset_b0_carry__2_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__2_i_2
       (.I0(Q[28]),
        .I1(Q[29]),
        .O(reset_b0_carry__2_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__2_i_3
       (.I0(Q[26]),
        .I1(Q[27]),
        .O(reset_b0_carry__2_i_3_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry__2_i_4
       (.I0(Q[24]),
        .I1(Q[25]),
        .O(reset_b0_carry__2_i_4_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__2_i_5
       (.I0(Q[31]),
        .I1(Q[30]),
        .O(reset_b0_carry__2_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__2_i_6
       (.I0(Q[29]),
        .I1(Q[28]),
        .O(reset_b0_carry__2_i_6_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__2_i_7
       (.I0(Q[27]),
        .I1(Q[26]),
        .O(reset_b0_carry__2_i_7_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry__2_i_8
       (.I0(Q[25]),
        .I1(Q[24]),
        .O(reset_b0_carry__2_i_8_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry_i_1
       (.I0(Q[6]),
        .I1(Q[7]),
        .O(reset_b0_carry_i_1_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry_i_2
       (.I0(Q[4]),
        .I1(Q[5]),
        .O(reset_b0_carry_i_2_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    reset_b0_carry_i_3
       (.I0(Q[2]),
        .I1(Q[3]),
        .O(reset_b0_carry_i_3_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry_i_4
       (.I0(Q[7]),
        .I1(Q[6]),
        .O(reset_b0_carry_i_4_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry_i_5
       (.I0(Q[5]),
        .I1(Q[4]),
        .O(reset_b0_carry_i_5_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry_i_6
       (.I0(Q[3]),
        .I1(Q[2]),
        .O(reset_b0_carry_i_6_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    reset_b0_carry_i_7
       (.I0(Q[0]),
        .I1(Q[1]),
        .O(reset_b0_carry_i_7_n_0));
  FDCE reset_b_reg
       (.C(s_axi_aclk),
        .CE(prod),
        .CLR(s_axi_aresetn_0),
        .D(p_0_in),
        .Q(reset_b));
  LUT1 #(
    .INIT(2'h1)) 
    s_axi_awready_i_2
       (.I0(s_axi_aresetn),
        .O(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h222E000022220000)) 
    \s_axi_rdata[0]_i_1 
       (.I0(\s_axi_rdata_reg[0] ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(\s_axi_rdata_reg[0]_0 ),
        .I5(mem_out_q16[0]),
        .O(D[0]));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[10]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[10]_i_2_n_0 ),
        .O(D[10]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[10]_i_2 
       (.I0(mem_out_q16[10]),
        .I1(Q[10]),
        .I2(\mem_tmp_reg[31]_0 [10]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[10]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[11]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[11]_i_2_n_0 ),
        .O(D[11]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[11]_i_2 
       (.I0(mem_out_q16[11]),
        .I1(Q[11]),
        .I2(\mem_tmp_reg[31]_0 [11]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[11]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[12]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[12]_i_2_n_0 ),
        .O(D[12]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[12]_i_2 
       (.I0(mem_out_q16[12]),
        .I1(Q[12]),
        .I2(\mem_tmp_reg[31]_0 [12]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[12]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[13]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[13]_i_2_n_0 ),
        .O(D[13]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[13]_i_2 
       (.I0(mem_out_q16[13]),
        .I1(Q[13]),
        .I2(\mem_tmp_reg[31]_0 [13]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[14]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[14]_i_2_n_0 ),
        .O(D[14]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[14]_i_2 
       (.I0(mem_out_q16[14]),
        .I1(Q[14]),
        .I2(\mem_tmp_reg[31]_0 [14]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[14]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[15]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[15]_i_2_n_0 ),
        .O(D[15]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[15]_i_2 
       (.I0(mem_out_q16[15]),
        .I1(Q[15]),
        .I2(\mem_tmp_reg[31]_0 [15]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[15]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[16]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[16]_i_2_n_0 ),
        .O(D[16]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[16]_i_2 
       (.I0(mem_out_q16[16]),
        .I1(Q[16]),
        .I2(\mem_tmp_reg[31]_0 [16]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[16]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[17]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[17]_i_2_n_0 ),
        .O(D[17]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[17]_i_2 
       (.I0(mem_out_q16[17]),
        .I1(Q[17]),
        .I2(\mem_tmp_reg[31]_0 [17]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[17]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[18]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[18]_i_2_n_0 ),
        .O(D[18]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[18]_i_2 
       (.I0(mem_out_q16[18]),
        .I1(Q[18]),
        .I2(\mem_tmp_reg[31]_0 [18]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[18]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[19]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[19]_i_2_n_0 ),
        .O(D[19]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[19]_i_2 
       (.I0(mem_out_q16[19]),
        .I1(Q[19]),
        .I2(\mem_tmp_reg[31]_0 [19]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[19]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h222E000022220000)) 
    \s_axi_rdata[1]_i_1 
       (.I0(\s_axi_rdata[1]_i_2_n_0 ),
        .I1(s_axi_araddr[4]),
        .I2(s_axi_araddr[2]),
        .I3(s_axi_araddr[3]),
        .I4(\s_axi_rdata_reg[0]_0 ),
        .I5(mem_out_q16[1]),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hCACAFFF0CACA0F00)) 
    \s_axi_rdata[1]_i_2 
       (.I0(\mem_tmp_reg[31]_0 [1]),
        .I1(spk_out),
        .I2(s_axi_araddr[3]),
        .I3(data0),
        .I4(s_axi_araddr[2]),
        .I5(Q[1]),
        .O(\s_axi_rdata[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[20]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[20]_i_2_n_0 ),
        .O(D[20]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[20]_i_2 
       (.I0(mem_out_q16[20]),
        .I1(Q[20]),
        .I2(\mem_tmp_reg[31]_0 [20]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[20]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[21]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[21]_i_2_n_0 ),
        .O(D[21]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[21]_i_2 
       (.I0(mem_out_q16[21]),
        .I1(Q[21]),
        .I2(\mem_tmp_reg[31]_0 [21]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[21]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[22]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[22]_i_2_n_0 ),
        .O(D[22]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[22]_i_2 
       (.I0(mem_out_q16[22]),
        .I1(Q[22]),
        .I2(\mem_tmp_reg[31]_0 [22]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[22]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[23]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[23]_i_2_n_0 ),
        .O(D[23]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[23]_i_2 
       (.I0(mem_out_q16[23]),
        .I1(Q[23]),
        .I2(\mem_tmp_reg[31]_0 [23]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[23]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[24]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[24]_i_2_n_0 ),
        .O(D[24]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[24]_i_2 
       (.I0(mem_out_q16[24]),
        .I1(Q[24]),
        .I2(\mem_tmp_reg[31]_0 [24]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[24]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[25]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[25]_i_2_n_0 ),
        .O(D[25]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[25]_i_2 
       (.I0(mem_out_q16[25]),
        .I1(Q[25]),
        .I2(\mem_tmp_reg[31]_0 [25]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[25]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[26]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[26]_i_2_n_0 ),
        .O(D[26]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[26]_i_2 
       (.I0(mem_out_q16[26]),
        .I1(Q[26]),
        .I2(\mem_tmp_reg[31]_0 [26]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[26]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[27]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[27]_i_2_n_0 ),
        .O(D[27]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[27]_i_2 
       (.I0(mem_out_q16[27]),
        .I1(Q[27]),
        .I2(\mem_tmp_reg[31]_0 [27]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[27]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[28]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[28]_i_2_n_0 ),
        .O(D[28]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[28]_i_2 
       (.I0(mem_out_q16[28]),
        .I1(Q[28]),
        .I2(\mem_tmp_reg[31]_0 [28]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[28]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[29]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[29]_i_2_n_0 ),
        .O(D[29]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[29]_i_2 
       (.I0(mem_out_q16[29]),
        .I1(Q[29]),
        .I2(\mem_tmp_reg[31]_0 [29]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[29]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[2]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[2]_i_2_n_0 ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[2]_i_2 
       (.I0(mem_out_q16[2]),
        .I1(Q[2]),
        .I2(\mem_tmp_reg[31]_0 [2]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[30]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[30]_i_2_n_0 ),
        .O(D[30]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[30]_i_2 
       (.I0(mem_out_q16[30]),
        .I1(Q[30]),
        .I2(\mem_tmp_reg[31]_0 [30]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[30]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[31]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[31]_i_2_n_0 ),
        .O(D[31]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[31]_i_2 
       (.I0(mem_out_q16[31]),
        .I1(Q[31]),
        .I2(\mem_tmp_reg[31]_0 [31]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[3]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[3]_i_2_n_0 ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[3]_i_2 
       (.I0(mem_out_q16[3]),
        .I1(Q[3]),
        .I2(\mem_tmp_reg[31]_0 [3]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[4]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[4]_i_2_n_0 ),
        .O(D[4]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[4]_i_2 
       (.I0(mem_out_q16[4]),
        .I1(Q[4]),
        .I2(\mem_tmp_reg[31]_0 [4]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[5]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[5]_i_2_n_0 ),
        .O(D[5]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[5]_i_2 
       (.I0(mem_out_q16[5]),
        .I1(Q[5]),
        .I2(\mem_tmp_reg[31]_0 [5]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[6]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[6]_i_2_n_0 ),
        .O(D[6]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[6]_i_2 
       (.I0(mem_out_q16[6]),
        .I1(Q[6]),
        .I2(\mem_tmp_reg[31]_0 [6]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[7]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[7]_i_2_n_0 ),
        .O(D[7]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[7]_i_2 
       (.I0(mem_out_q16[7]),
        .I1(Q[7]),
        .I2(\mem_tmp_reg[31]_0 [7]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[8]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[8]_i_2_n_0 ),
        .O(D[8]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[8]_i_2 
       (.I0(mem_out_q16[8]),
        .I1(Q[8]),
        .I2(\mem_tmp_reg[31]_0 [8]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[8]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000100000000)) 
    \s_axi_rdata[9]_i_1 
       (.I0(s_axi_araddr[5]),
        .I1(s_axi_araddr[6]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[1]),
        .I4(s_axi_araddr[0]),
        .I5(\s_axi_rdata[9]_i_2_n_0 ),
        .O(D[9]));
  LUT6 #(
    .INIT(64'h000000AA00F0CC00)) 
    \s_axi_rdata[9]_i_2 
       (.I0(mem_out_q16[9]),
        .I1(Q[9]),
        .I2(\mem_tmp_reg[31]_0 [9]),
        .I3(s_axi_araddr[3]),
        .I4(s_axi_araddr[2]),
        .I5(s_axi_araddr[4]),
        .O(\s_axi_rdata[9]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_10
       (.I0(mem_tmp[24]),
        .I1(mem_tmp[25]),
        .O(spk_out_i_10_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_12
       (.I0(mem_tmp[22]),
        .I1(mem_tmp[23]),
        .O(spk_out_i_12_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_13
       (.I0(mem_tmp[20]),
        .I1(mem_tmp[21]),
        .O(spk_out_i_13_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_14
       (.I0(mem_tmp[18]),
        .I1(mem_tmp[19]),
        .O(spk_out_i_14_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_15
       (.I0(mem_tmp[22]),
        .I1(mem_tmp[23]),
        .O(spk_out_i_15_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_16
       (.I0(mem_tmp[20]),
        .I1(mem_tmp[21]),
        .O(spk_out_i_16_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_17
       (.I0(mem_tmp[18]),
        .I1(mem_tmp[19]),
        .O(spk_out_i_17_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    spk_out_i_18
       (.I0(mem_tmp[16]),
        .I1(mem_tmp[17]),
        .O(spk_out_i_18_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_20
       (.I0(mem_tmp[14]),
        .I1(mem_tmp[15]),
        .O(spk_out_i_20_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_21
       (.I0(mem_tmp[12]),
        .I1(mem_tmp[13]),
        .O(spk_out_i_21_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_22
       (.I0(mem_tmp[10]),
        .I1(mem_tmp[11]),
        .O(spk_out_i_22_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_23
       (.I0(mem_tmp[8]),
        .I1(mem_tmp[9]),
        .O(spk_out_i_23_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_24
       (.I0(mem_tmp[14]),
        .I1(mem_tmp[15]),
        .O(spk_out_i_24_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_25
       (.I0(mem_tmp[12]),
        .I1(mem_tmp[13]),
        .O(spk_out_i_25_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_26
       (.I0(mem_tmp[10]),
        .I1(mem_tmp[11]),
        .O(spk_out_i_26_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_27
       (.I0(mem_tmp[8]),
        .I1(mem_tmp[9]),
        .O(spk_out_i_27_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_28
       (.I0(mem_tmp[6]),
        .I1(mem_tmp[7]),
        .O(spk_out_i_28_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_29
       (.I0(mem_tmp[4]),
        .I1(mem_tmp[5]),
        .O(spk_out_i_29_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    spk_out_i_3
       (.I0(mem_tmp[30]),
        .I1(mem_tmp[31]),
        .O(spk_out_i_3_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_30
       (.I0(mem_tmp[2]),
        .I1(mem_tmp[3]),
        .O(spk_out_i_30_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_31
       (.I0(mem_tmp[0]),
        .I1(mem_tmp[1]),
        .O(spk_out_i_31_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_32
       (.I0(mem_tmp[6]),
        .I1(mem_tmp[7]),
        .O(spk_out_i_32_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_33
       (.I0(mem_tmp[4]),
        .I1(mem_tmp[5]),
        .O(spk_out_i_33_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_34
       (.I0(mem_tmp[2]),
        .I1(mem_tmp[3]),
        .O(spk_out_i_34_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_35
       (.I0(mem_tmp[0]),
        .I1(mem_tmp[1]),
        .O(spk_out_i_35_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_4
       (.I0(mem_tmp[28]),
        .I1(mem_tmp[29]),
        .O(spk_out_i_4_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_5
       (.I0(mem_tmp[26]),
        .I1(mem_tmp[27]),
        .O(spk_out_i_5_n_0));
  LUT2 #(
    .INIT(4'hE)) 
    spk_out_i_6
       (.I0(mem_tmp[24]),
        .I1(mem_tmp[25]),
        .O(spk_out_i_6_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_7
       (.I0(mem_tmp[30]),
        .I1(mem_tmp[31]),
        .O(spk_out_i_7_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_8
       (.I0(mem_tmp[28]),
        .I1(mem_tmp[29]),
        .O(spk_out_i_8_n_0));
  LUT2 #(
    .INIT(4'h1)) 
    spk_out_i_9
       (.I0(mem_tmp[26]),
        .I1(mem_tmp[27]),
        .O(spk_out_i_9_n_0));
  FDCE spk_out_reg
       (.C(s_axi_aclk),
        .CE(\FSM_onehot_st_reg_n_0_[2] ),
        .CLR(s_axi_aresetn_0),
        .D(spk_out_reg_i_1_n_0),
        .Q(spk_out));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 spk_out_reg_i_1
       (.CI(spk_out_reg_i_2_n_0),
        .CO({spk_out_reg_i_1_n_0,spk_out_reg_i_1_n_1,spk_out_reg_i_1_n_2,spk_out_reg_i_1_n_3}),
        .CYINIT(1'b0),
        .DI({spk_out_i_3_n_0,spk_out_i_4_n_0,spk_out_i_5_n_0,spk_out_i_6_n_0}),
        .O(NLW_spk_out_reg_i_1_O_UNCONNECTED[3:0]),
        .S({spk_out_i_7_n_0,spk_out_i_8_n_0,spk_out_i_9_n_0,spk_out_i_10_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 spk_out_reg_i_11
       (.CI(spk_out_reg_i_19_n_0),
        .CO({spk_out_reg_i_11_n_0,spk_out_reg_i_11_n_1,spk_out_reg_i_11_n_2,spk_out_reg_i_11_n_3}),
        .CYINIT(1'b0),
        .DI({spk_out_i_20_n_0,spk_out_i_21_n_0,spk_out_i_22_n_0,spk_out_i_23_n_0}),
        .O(NLW_spk_out_reg_i_11_O_UNCONNECTED[3:0]),
        .S({spk_out_i_24_n_0,spk_out_i_25_n_0,spk_out_i_26_n_0,spk_out_i_27_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 spk_out_reg_i_19
       (.CI(1'b0),
        .CO({spk_out_reg_i_19_n_0,spk_out_reg_i_19_n_1,spk_out_reg_i_19_n_2,spk_out_reg_i_19_n_3}),
        .CYINIT(1'b1),
        .DI({spk_out_i_28_n_0,spk_out_i_29_n_0,spk_out_i_30_n_0,spk_out_i_31_n_0}),
        .O(NLW_spk_out_reg_i_19_O_UNCONNECTED[3:0]),
        .S({spk_out_i_32_n_0,spk_out_i_33_n_0,spk_out_i_34_n_0,spk_out_i_35_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY4 spk_out_reg_i_2
       (.CI(spk_out_reg_i_11_n_0),
        .CO({spk_out_reg_i_2_n_0,spk_out_reg_i_2_n_1,spk_out_reg_i_2_n_2,spk_out_reg_i_2_n_3}),
        .CYINIT(1'b0),
        .DI({spk_out_i_12_n_0,spk_out_i_13_n_0,spk_out_i_14_n_0,mem_tmp[17]}),
        .O(NLW_spk_out_reg_i_2_O_UNCONNECTED[3:0]),
        .S({spk_out_i_15_n_0,spk_out_i_16_n_0,spk_out_i_17_n_0,spk_out_i_18_n_0}));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lif_step_axi_lite
   (s_axi_wready,
    s_axi_arready,
    s_axi_rdata,
    s_axi_bvalid,
    s_axi_rvalid,
    s_axi_aclk,
    s_axi_wdata,
    s_axi_awaddr,
    s_axi_awvalid,
    s_axi_wvalid,
    s_axi_arvalid,
    s_axi_araddr,
    s_axi_bready,
    s_axi_rready,
    s_axi_aresetn);
  output s_axi_wready;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output s_axi_bvalid;
  output s_axi_rvalid;
  input s_axi_aclk;
  input [31:0]s_axi_wdata;
  input [7:0]s_axi_awaddr;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input s_axi_arvalid;
  input [7:0]s_axi_araddr;
  input s_axi_bready;
  input s_axi_rready;
  input s_axi_aresetn;

  wire [31:0]cur_q16;
  wire \cur_q16[31]_i_3_n_0 ;
  wire cur_q16_0;
  wire [1:1]data0;
  wire done_sticky_i_2_n_0;
  wire done_sticky_i_3_n_0;
  wire [31:0]mem_in_q16;
  wire mem_in_q16_1;
  wire s_axi_aclk;
  wire [7:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arready0;
  wire s_axi_arvalid;
  wire [7:0]s_axi_awaddr;
  wire s_axi_awready0;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire s_axi_bvalid02_out;
  wire s_axi_bvalid_i_1_n_0;
  wire [31:0]s_axi_rdata;
  wire \s_axi_rdata[0]_i_2_n_0 ;
  wire \s_axi_rdata[1]_i_3_n_0 ;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire s_axi_rvalid_i_1_n_0;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire start_pulse;
  wire start_pulse1_out;
  wire start_pulse_i_2_n_0;
  wire u_lif_n_0;
  wire u_lif_n_1;
  wire u_lif_n_10;
  wire u_lif_n_11;
  wire u_lif_n_12;
  wire u_lif_n_13;
  wire u_lif_n_14;
  wire u_lif_n_15;
  wire u_lif_n_16;
  wire u_lif_n_17;
  wire u_lif_n_18;
  wire u_lif_n_19;
  wire u_lif_n_2;
  wire u_lif_n_20;
  wire u_lif_n_21;
  wire u_lif_n_22;
  wire u_lif_n_23;
  wire u_lif_n_24;
  wire u_lif_n_25;
  wire u_lif_n_26;
  wire u_lif_n_27;
  wire u_lif_n_28;
  wire u_lif_n_29;
  wire u_lif_n_3;
  wire u_lif_n_30;
  wire u_lif_n_31;
  wire u_lif_n_32;
  wire u_lif_n_33;
  wire u_lif_n_4;
  wire u_lif_n_5;
  wire u_lif_n_6;
  wire u_lif_n_7;
  wire u_lif_n_8;
  wire u_lif_n_9;

  LUT6 #(
    .INIT(64'h0000000000020000)) 
    \cur_q16[31]_i_1 
       (.I0(s_axi_bvalid02_out),
        .I1(\cur_q16[31]_i_3_n_0 ),
        .I2(s_axi_awaddr[3]),
        .I3(s_axi_awaddr[0]),
        .I4(s_axi_awaddr[2]),
        .I5(s_axi_awaddr[1]),
        .O(cur_q16_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \cur_q16[31]_i_2 
       (.I0(s_axi_wready),
        .I1(s_axi_awvalid),
        .I2(s_axi_wvalid),
        .O(s_axi_bvalid02_out));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \cur_q16[31]_i_3 
       (.I0(s_axi_awaddr[6]),
        .I1(s_axi_awaddr[7]),
        .I2(s_axi_awaddr[4]),
        .I3(s_axi_awaddr[5]),
        .O(\cur_q16[31]_i_3_n_0 ));
  FDCE \cur_q16_reg[0] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[0]),
        .Q(cur_q16[0]));
  FDCE \cur_q16_reg[10] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[10]),
        .Q(cur_q16[10]));
  FDCE \cur_q16_reg[11] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[11]),
        .Q(cur_q16[11]));
  FDCE \cur_q16_reg[12] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[12]),
        .Q(cur_q16[12]));
  FDCE \cur_q16_reg[13] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[13]),
        .Q(cur_q16[13]));
  FDCE \cur_q16_reg[14] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[14]),
        .Q(cur_q16[14]));
  FDCE \cur_q16_reg[15] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[15]),
        .Q(cur_q16[15]));
  FDCE \cur_q16_reg[16] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[16]),
        .Q(cur_q16[16]));
  FDCE \cur_q16_reg[17] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[17]),
        .Q(cur_q16[17]));
  FDCE \cur_q16_reg[18] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[18]),
        .Q(cur_q16[18]));
  FDCE \cur_q16_reg[19] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[19]),
        .Q(cur_q16[19]));
  FDCE \cur_q16_reg[1] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[1]),
        .Q(cur_q16[1]));
  FDCE \cur_q16_reg[20] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[20]),
        .Q(cur_q16[20]));
  FDCE \cur_q16_reg[21] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[21]),
        .Q(cur_q16[21]));
  FDCE \cur_q16_reg[22] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[22]),
        .Q(cur_q16[22]));
  FDCE \cur_q16_reg[23] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[23]),
        .Q(cur_q16[23]));
  FDCE \cur_q16_reg[24] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[24]),
        .Q(cur_q16[24]));
  FDCE \cur_q16_reg[25] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[25]),
        .Q(cur_q16[25]));
  FDCE \cur_q16_reg[26] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[26]),
        .Q(cur_q16[26]));
  FDCE \cur_q16_reg[27] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[27]),
        .Q(cur_q16[27]));
  FDCE \cur_q16_reg[28] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[28]),
        .Q(cur_q16[28]));
  FDCE \cur_q16_reg[29] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[29]),
        .Q(cur_q16[29]));
  FDCE \cur_q16_reg[2] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[2]),
        .Q(cur_q16[2]));
  FDCE \cur_q16_reg[30] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[30]),
        .Q(cur_q16[30]));
  FDCE \cur_q16_reg[31] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[31]),
        .Q(cur_q16[31]));
  FDCE \cur_q16_reg[3] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[3]),
        .Q(cur_q16[3]));
  FDCE \cur_q16_reg[4] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[4]),
        .Q(cur_q16[4]));
  FDCE \cur_q16_reg[5] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[5]),
        .Q(cur_q16[5]));
  FDCE \cur_q16_reg[6] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[6]),
        .Q(cur_q16[6]));
  FDCE \cur_q16_reg[7] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[7]),
        .Q(cur_q16[7]));
  FDCE \cur_q16_reg[8] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[8]),
        .Q(cur_q16[8]));
  FDCE \cur_q16_reg[9] 
       (.C(s_axi_aclk),
        .CE(cur_q16_0),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[9]),
        .Q(cur_q16[9]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    done_sticky_i_2
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_araddr[3]),
        .O(done_sticky_i_2_n_0));
  LUT6 #(
    .INIT(64'h0000000000001000)) 
    done_sticky_i_3
       (.I0(s_axi_araddr[6]),
        .I1(s_axi_araddr[7]),
        .I2(s_axi_arvalid),
        .I3(s_axi_arready),
        .I4(s_axi_araddr[0]),
        .I5(s_axi_araddr[1]),
        .O(done_sticky_i_3_n_0));
  FDCE done_sticky_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(u_lif_n_33),
        .Q(data0));
  LUT6 #(
    .INIT(64'h0000000000020000)) 
    \mem_in_q16[31]_i_1 
       (.I0(s_axi_bvalid02_out),
        .I1(\cur_q16[31]_i_3_n_0 ),
        .I2(s_axi_awaddr[0]),
        .I3(s_axi_awaddr[2]),
        .I4(s_axi_awaddr[3]),
        .I5(s_axi_awaddr[1]),
        .O(mem_in_q16_1));
  FDCE \mem_in_q16_reg[0] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[0]),
        .Q(mem_in_q16[0]));
  FDCE \mem_in_q16_reg[10] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[10]),
        .Q(mem_in_q16[10]));
  FDCE \mem_in_q16_reg[11] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[11]),
        .Q(mem_in_q16[11]));
  FDCE \mem_in_q16_reg[12] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[12]),
        .Q(mem_in_q16[12]));
  FDCE \mem_in_q16_reg[13] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[13]),
        .Q(mem_in_q16[13]));
  FDCE \mem_in_q16_reg[14] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[14]),
        .Q(mem_in_q16[14]));
  FDCE \mem_in_q16_reg[15] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[15]),
        .Q(mem_in_q16[15]));
  FDCE \mem_in_q16_reg[16] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[16]),
        .Q(mem_in_q16[16]));
  FDCE \mem_in_q16_reg[17] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[17]),
        .Q(mem_in_q16[17]));
  FDCE \mem_in_q16_reg[18] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[18]),
        .Q(mem_in_q16[18]));
  FDCE \mem_in_q16_reg[19] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[19]),
        .Q(mem_in_q16[19]));
  FDCE \mem_in_q16_reg[1] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[1]),
        .Q(mem_in_q16[1]));
  FDCE \mem_in_q16_reg[20] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[20]),
        .Q(mem_in_q16[20]));
  FDCE \mem_in_q16_reg[21] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[21]),
        .Q(mem_in_q16[21]));
  FDCE \mem_in_q16_reg[22] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[22]),
        .Q(mem_in_q16[22]));
  FDCE \mem_in_q16_reg[23] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[23]),
        .Q(mem_in_q16[23]));
  FDCE \mem_in_q16_reg[24] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[24]),
        .Q(mem_in_q16[24]));
  FDCE \mem_in_q16_reg[25] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[25]),
        .Q(mem_in_q16[25]));
  FDCE \mem_in_q16_reg[26] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[26]),
        .Q(mem_in_q16[26]));
  FDCE \mem_in_q16_reg[27] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[27]),
        .Q(mem_in_q16[27]));
  FDCE \mem_in_q16_reg[28] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[28]),
        .Q(mem_in_q16[28]));
  FDCE \mem_in_q16_reg[29] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[29]),
        .Q(mem_in_q16[29]));
  FDCE \mem_in_q16_reg[2] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[2]),
        .Q(mem_in_q16[2]));
  FDCE \mem_in_q16_reg[30] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[30]),
        .Q(mem_in_q16[30]));
  FDCE \mem_in_q16_reg[31] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[31]),
        .Q(mem_in_q16[31]));
  FDCE \mem_in_q16_reg[3] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[3]),
        .Q(mem_in_q16[3]));
  FDCE \mem_in_q16_reg[4] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[4]),
        .Q(mem_in_q16[4]));
  FDCE \mem_in_q16_reg[5] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[5]),
        .Q(mem_in_q16[5]));
  FDCE \mem_in_q16_reg[6] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[6]),
        .Q(mem_in_q16[6]));
  FDCE \mem_in_q16_reg[7] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[7]),
        .Q(mem_in_q16[7]));
  FDCE \mem_in_q16_reg[8] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[8]),
        .Q(mem_in_q16[8]));
  FDCE \mem_in_q16_reg[9] 
       (.C(s_axi_aclk),
        .CE(mem_in_q16_1),
        .CLR(u_lif_n_0),
        .D(s_axi_wdata[9]),
        .Q(mem_in_q16[9]));
  LUT2 #(
    .INIT(4'h2)) 
    s_axi_arready_i_1
       (.I0(s_axi_arvalid),
        .I1(s_axi_arready),
        .O(s_axi_arready0));
  FDCE s_axi_arready_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(s_axi_arready0),
        .Q(s_axi_arready));
  LUT3 #(
    .INIT(8'h08)) 
    s_axi_awready_i_1
       (.I0(s_axi_awvalid),
        .I1(s_axi_wvalid),
        .I2(s_axi_wready),
        .O(s_axi_awready0));
  FDCE s_axi_awready_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(s_axi_awready0),
        .Q(s_axi_wready));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h80FF8080)) 
    s_axi_bvalid_i_1
       (.I0(s_axi_wvalid),
        .I1(s_axi_awvalid),
        .I2(s_axi_wready),
        .I3(s_axi_bready),
        .I4(s_axi_bvalid),
        .O(s_axi_bvalid_i_1_n_0));
  FDCE s_axi_bvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(s_axi_bvalid_i_1_n_0),
        .Q(s_axi_bvalid));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hF0AACC00)) 
    \s_axi_rdata[0]_i_2 
       (.I0(mem_in_q16[0]),
        .I1(cur_q16[0]),
        .I2(data0),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[3]),
        .O(\s_axi_rdata[0]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \s_axi_rdata[1]_i_3 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_araddr[7]),
        .I3(s_axi_araddr[6]),
        .I4(s_axi_araddr[5]),
        .O(\s_axi_rdata[1]_i_3_n_0 ));
  FDCE \s_axi_rdata_reg[0] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_32),
        .Q(s_axi_rdata[0]));
  FDCE \s_axi_rdata_reg[10] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_22),
        .Q(s_axi_rdata[10]));
  FDCE \s_axi_rdata_reg[11] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_21),
        .Q(s_axi_rdata[11]));
  FDCE \s_axi_rdata_reg[12] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_20),
        .Q(s_axi_rdata[12]));
  FDCE \s_axi_rdata_reg[13] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_19),
        .Q(s_axi_rdata[13]));
  FDCE \s_axi_rdata_reg[14] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_18),
        .Q(s_axi_rdata[14]));
  FDCE \s_axi_rdata_reg[15] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_17),
        .Q(s_axi_rdata[15]));
  FDCE \s_axi_rdata_reg[16] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_16),
        .Q(s_axi_rdata[16]));
  FDCE \s_axi_rdata_reg[17] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_15),
        .Q(s_axi_rdata[17]));
  FDCE \s_axi_rdata_reg[18] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_14),
        .Q(s_axi_rdata[18]));
  FDCE \s_axi_rdata_reg[19] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_13),
        .Q(s_axi_rdata[19]));
  FDCE \s_axi_rdata_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_31),
        .Q(s_axi_rdata[1]));
  FDCE \s_axi_rdata_reg[20] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_12),
        .Q(s_axi_rdata[20]));
  FDCE \s_axi_rdata_reg[21] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_11),
        .Q(s_axi_rdata[21]));
  FDCE \s_axi_rdata_reg[22] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_10),
        .Q(s_axi_rdata[22]));
  FDCE \s_axi_rdata_reg[23] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_9),
        .Q(s_axi_rdata[23]));
  FDCE \s_axi_rdata_reg[24] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_8),
        .Q(s_axi_rdata[24]));
  FDCE \s_axi_rdata_reg[25] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_7),
        .Q(s_axi_rdata[25]));
  FDCE \s_axi_rdata_reg[26] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_6),
        .Q(s_axi_rdata[26]));
  FDCE \s_axi_rdata_reg[27] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_5),
        .Q(s_axi_rdata[27]));
  FDCE \s_axi_rdata_reg[28] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_4),
        .Q(s_axi_rdata[28]));
  FDCE \s_axi_rdata_reg[29] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_3),
        .Q(s_axi_rdata[29]));
  FDCE \s_axi_rdata_reg[2] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_30),
        .Q(s_axi_rdata[2]));
  FDCE \s_axi_rdata_reg[30] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_2),
        .Q(s_axi_rdata[30]));
  FDCE \s_axi_rdata_reg[31] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_1),
        .Q(s_axi_rdata[31]));
  FDCE \s_axi_rdata_reg[3] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_29),
        .Q(s_axi_rdata[3]));
  FDCE \s_axi_rdata_reg[4] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_28),
        .Q(s_axi_rdata[4]));
  FDCE \s_axi_rdata_reg[5] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_27),
        .Q(s_axi_rdata[5]));
  FDCE \s_axi_rdata_reg[6] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_26),
        .Q(s_axi_rdata[6]));
  FDCE \s_axi_rdata_reg[7] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_25),
        .Q(s_axi_rdata[7]));
  FDCE \s_axi_rdata_reg[8] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_24),
        .Q(s_axi_rdata[8]));
  FDCE \s_axi_rdata_reg[9] 
       (.C(s_axi_aclk),
        .CE(s_axi_arready0),
        .CLR(u_lif_n_0),
        .D(u_lif_n_23),
        .Q(s_axi_rdata[9]));
  LUT4 #(
    .INIT(16'h4F44)) 
    s_axi_rvalid_i_1
       (.I0(s_axi_arready),
        .I1(s_axi_arvalid),
        .I2(s_axi_rready),
        .I3(s_axi_rvalid),
        .O(s_axi_rvalid_i_1_n_0));
  FDCE s_axi_rvalid_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(s_axi_rvalid_i_1_n_0),
        .Q(s_axi_rvalid));
  LUT6 #(
    .INIT(64'h0000000200000000)) 
    start_pulse_i_1
       (.I0(s_axi_bvalid02_out),
        .I1(s_axi_awaddr[6]),
        .I2(s_axi_awaddr[7]),
        .I3(s_axi_awaddr[4]),
        .I4(s_axi_awaddr[5]),
        .I5(start_pulse_i_2_n_0),
        .O(start_pulse1_out));
  LUT5 #(
    .INIT(32'h00000002)) 
    start_pulse_i_2
       (.I0(s_axi_wdata[0]),
        .I1(s_axi_awaddr[2]),
        .I2(s_axi_awaddr[1]),
        .I3(s_axi_awaddr[3]),
        .I4(s_axi_awaddr[0]),
        .O(start_pulse_i_2_n_0));
  FDCE start_pulse_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .CLR(u_lif_n_0),
        .D(start_pulse1_out),
        .Q(start_pulse));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_lif_step u_lif
       (.D({u_lif_n_1,u_lif_n_2,u_lif_n_3,u_lif_n_4,u_lif_n_5,u_lif_n_6,u_lif_n_7,u_lif_n_8,u_lif_n_9,u_lif_n_10,u_lif_n_11,u_lif_n_12,u_lif_n_13,u_lif_n_14,u_lif_n_15,u_lif_n_16,u_lif_n_17,u_lif_n_18,u_lif_n_19,u_lif_n_20,u_lif_n_21,u_lif_n_22,u_lif_n_23,u_lif_n_24,u_lif_n_25,u_lif_n_26,u_lif_n_27,u_lif_n_28,u_lif_n_29,u_lif_n_30,u_lif_n_31,u_lif_n_32}),
        .Q(mem_in_q16),
        .data0(data0),
        .done_sticky_reg(done_sticky_i_2_n_0),
        .done_sticky_reg_0(done_sticky_i_3_n_0),
        .\mem_tmp_reg[31]_0 (cur_q16),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_araddr_5_sp_1(u_lif_n_33),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_aresetn_0(u_lif_n_0),
        .\s_axi_rdata_reg[0] (\s_axi_rdata[0]_i_2_n_0 ),
        .\s_axi_rdata_reg[0]_0 (\s_axi_rdata[1]_i_3_n_0 ),
        .start_pulse(start_pulse));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
