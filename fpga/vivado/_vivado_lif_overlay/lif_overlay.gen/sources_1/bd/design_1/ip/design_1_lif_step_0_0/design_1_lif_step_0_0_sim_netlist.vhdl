-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (lin64) Build 4029153 Fri Oct 13 20:13:54 MDT 2023
-- Date        : Thu Jul 23 10:15:12 2026
-- Host        : CXS1 running 64-bit Ubuntu 24.04.4 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/cx/neuromorphic-computing/fpga/vivado/_vivado_lif_overlay/lif_overlay.gen/sources_1/bd/design_1/ip/design_1_lif_step_0_0/design_1_lif_step_0_0_sim_netlist.vhdl
-- Design      : design_1_lif_step_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_lif_step_0_0_lif_step is
  port (
    s_axi_aresetn_0 : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_araddr_5_sp_1 : out STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 31 downto 0 );
    \s_axi_rdata_reg[0]\ : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \s_axi_rdata_reg[0]_0\ : in STD_LOGIC;
    \mem_tmp_reg[31]_0\ : in STD_LOGIC_VECTOR ( 31 downto 0 );
    data0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    done_sticky_reg : in STD_LOGIC;
    done_sticky_reg_0 : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    start_pulse : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_lif_step_0_0_lif_step : entity is "lif_step";
end design_1_lif_step_0_0_lif_step;

architecture STRUCTURE of design_1_lif_step_0_0_lif_step is
  signal \FSM_onehot_st[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_st[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_onehot_st_reg_n_0_[0]\ : STD_LOGIC;
  signal \FSM_onehot_st_reg_n_0_[2]\ : STD_LOGIC;
  signal done : STD_LOGIC;
  signal mem_out_q16 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal mem_tmp : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal mem_tmp0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \mem_tmp0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__0_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__1_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__2_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_6_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_i_7_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__3_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_5_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_6_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_7_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_i_8_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__4_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_5_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_6_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_7_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_i_8_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__5_n_3\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_5_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_6_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_i_7_n_0\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_n_1\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_n_2\ : STD_LOGIC;
  signal \mem_tmp0_carry__6_n_3\ : STD_LOGIC;
  signal mem_tmp0_carry_i_1_n_0 : STD_LOGIC;
  signal mem_tmp0_carry_i_2_n_0 : STD_LOGIC;
  signal mem_tmp0_carry_i_3_n_0 : STD_LOGIC;
  signal mem_tmp0_carry_i_4_n_0 : STD_LOGIC;
  signal mem_tmp0_carry_n_0 : STD_LOGIC;
  signal mem_tmp0_carry_n_1 : STD_LOGIC;
  signal mem_tmp0_carry_n_2 : STD_LOGIC;
  signal mem_tmp0_carry_n_3 : STD_LOGIC;
  signal mem_tmp_0 : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_in1_in : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal prod : STD_LOGIC;
  signal \prod0__179_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__0_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__1_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__2_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__3_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__4_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__5_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_i_5_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_1\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_4\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__6_n_7\ : STD_LOGIC;
  signal \prod0__179_carry__7_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__7_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__7_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry__7_n_2\ : STD_LOGIC;
  signal \prod0__179_carry__7_n_3\ : STD_LOGIC;
  signal \prod0__179_carry__7_n_5\ : STD_LOGIC;
  signal \prod0__179_carry__7_n_6\ : STD_LOGIC;
  signal \prod0__179_carry__7_n_7\ : STD_LOGIC;
  signal \prod0__179_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__179_carry_i_2_n_0\ : STD_LOGIC;
  signal \prod0__179_carry_i_3_n_0\ : STD_LOGIC;
  signal \prod0__179_carry_n_0\ : STD_LOGIC;
  signal \prod0__179_carry_n_1\ : STD_LOGIC;
  signal \prod0__179_carry_n_2\ : STD_LOGIC;
  signal \prod0__179_carry_n_3\ : STD_LOGIC;
  signal \prod0__179_carry_n_4\ : STD_LOGIC;
  signal \prod0__179_carry_n_5\ : STD_LOGIC;
  signal \prod0__179_carry_n_6\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_0\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_1\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_2\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_3\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_4\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_5\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_6\ : STD_LOGIC;
  signal \prod0__249_carry__0_n_7\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_0\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_1\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_2\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_3\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_4\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_5\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_6\ : STD_LOGIC;
  signal \prod0__249_carry__1_n_7\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_0\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_1\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_2\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_3\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_4\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_5\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_6\ : STD_LOGIC;
  signal \prod0__249_carry__2_n_7\ : STD_LOGIC;
  signal \prod0__249_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0__249_carry__3_n_2\ : STD_LOGIC;
  signal \prod0__249_carry__3_n_7\ : STD_LOGIC;
  signal \prod0__249_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__249_carry_n_0\ : STD_LOGIC;
  signal \prod0__249_carry_n_1\ : STD_LOGIC;
  signal \prod0__249_carry_n_2\ : STD_LOGIC;
  signal \prod0__249_carry_n_3\ : STD_LOGIC;
  signal \prod0__249_carry_n_4\ : STD_LOGIC;
  signal \prod0__249_carry_n_5\ : STD_LOGIC;
  signal \prod0__249_carry_n_6\ : STD_LOGIC;
  signal \prod0__249_carry_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__0_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__1_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__2_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__3_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__4_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__5_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_i_9_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_1\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_3\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_4\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_5\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_6\ : STD_LOGIC;
  signal \prod0__283_carry__6_n_7\ : STD_LOGIC;
  signal \prod0__283_carry__7_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry__7_n_2\ : STD_LOGIC;
  signal \prod0__283_carry__7_n_7\ : STD_LOGIC;
  signal \prod0__283_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_2_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_3_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_4_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_5_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_6_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_7_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_i_8_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_n_0\ : STD_LOGIC;
  signal \prod0__283_carry_n_1\ : STD_LOGIC;
  signal \prod0__283_carry_n_2\ : STD_LOGIC;
  signal \prod0__283_carry_n_3\ : STD_LOGIC;
  signal \prod0__283_carry_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__0_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__1_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__2_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__3_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__4_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__5_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_10_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_11_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_12_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_i_9_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__6_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_1\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_2\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_4\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_5\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__7_n_7\ : STD_LOGIC;
  signal \prod0__379_carry__8_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__8_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__8_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry__8_n_3\ : STD_LOGIC;
  signal \prod0__379_carry__8_n_6\ : STD_LOGIC;
  signal \prod0__379_carry__8_n_7\ : STD_LOGIC;
  signal \prod0__379_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_2_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_3_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_4_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_5_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_6_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_7_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_i_8_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_n_0\ : STD_LOGIC;
  signal \prod0__379_carry_n_1\ : STD_LOGIC;
  signal \prod0__379_carry_n_2\ : STD_LOGIC;
  signal \prod0__379_carry_n_3\ : STD_LOGIC;
  signal \prod0__70_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__70_carry_i_2_n_0\ : STD_LOGIC;
  signal \prod0__70_carry_i_3_n_0\ : STD_LOGIC;
  signal \prod0__70_carry_n_0\ : STD_LOGIC;
  signal \prod0__70_carry_n_1\ : STD_LOGIC;
  signal \prod0__70_carry_n_2\ : STD_LOGIC;
  signal \prod0__70_carry_n_3\ : STD_LOGIC;
  signal \prod0__70_carry_n_4\ : STD_LOGIC;
  signal \prod0__70_carry_n_5\ : STD_LOGIC;
  signal \prod0__70_carry_n_6\ : STD_LOGIC;
  signal \prod0__70_carry_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__0_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__1_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__2_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__3_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__4_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__5_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_2\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_4\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_5\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__6_n_7\ : STD_LOGIC;
  signal \prod0__81_carry__7_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__7_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry__7_n_1\ : STD_LOGIC;
  signal \prod0__81_carry__7_n_3\ : STD_LOGIC;
  signal \prod0__81_carry__7_n_6\ : STD_LOGIC;
  signal \prod0__81_carry__7_n_7\ : STD_LOGIC;
  signal \prod0__81_carry_i_1_n_0\ : STD_LOGIC;
  signal \prod0__81_carry_i_2_n_0\ : STD_LOGIC;
  signal \prod0__81_carry_i_3_n_0\ : STD_LOGIC;
  signal \prod0__81_carry_n_0\ : STD_LOGIC;
  signal \prod0__81_carry_n_1\ : STD_LOGIC;
  signal \prod0__81_carry_n_2\ : STD_LOGIC;
  signal \prod0__81_carry_n_3\ : STD_LOGIC;
  signal \prod0__81_carry_n_4\ : STD_LOGIC;
  signal \prod0__81_carry_n_5\ : STD_LOGIC;
  signal \prod0__81_carry_n_6\ : STD_LOGIC;
  signal \prod0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__0_n_0\ : STD_LOGIC;
  signal \prod0_carry__0_n_1\ : STD_LOGIC;
  signal \prod0_carry__0_n_2\ : STD_LOGIC;
  signal \prod0_carry__0_n_3\ : STD_LOGIC;
  signal \prod0_carry__0_n_4\ : STD_LOGIC;
  signal \prod0_carry__0_n_5\ : STD_LOGIC;
  signal \prod0_carry__0_n_6\ : STD_LOGIC;
  signal \prod0_carry__0_n_7\ : STD_LOGIC;
  signal \prod0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__1_n_0\ : STD_LOGIC;
  signal \prod0_carry__1_n_1\ : STD_LOGIC;
  signal \prod0_carry__1_n_2\ : STD_LOGIC;
  signal \prod0_carry__1_n_3\ : STD_LOGIC;
  signal \prod0_carry__1_n_4\ : STD_LOGIC;
  signal \prod0_carry__1_n_5\ : STD_LOGIC;
  signal \prod0_carry__1_n_6\ : STD_LOGIC;
  signal \prod0_carry__1_n_7\ : STD_LOGIC;
  signal \prod0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__2_n_0\ : STD_LOGIC;
  signal \prod0_carry__2_n_1\ : STD_LOGIC;
  signal \prod0_carry__2_n_2\ : STD_LOGIC;
  signal \prod0_carry__2_n_3\ : STD_LOGIC;
  signal \prod0_carry__2_n_4\ : STD_LOGIC;
  signal \prod0_carry__2_n_5\ : STD_LOGIC;
  signal \prod0_carry__2_n_6\ : STD_LOGIC;
  signal \prod0_carry__2_n_7\ : STD_LOGIC;
  signal \prod0_carry__3_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__3_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__3_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__3_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__3_n_0\ : STD_LOGIC;
  signal \prod0_carry__3_n_1\ : STD_LOGIC;
  signal \prod0_carry__3_n_2\ : STD_LOGIC;
  signal \prod0_carry__3_n_3\ : STD_LOGIC;
  signal \prod0_carry__3_n_4\ : STD_LOGIC;
  signal \prod0_carry__3_n_5\ : STD_LOGIC;
  signal \prod0_carry__3_n_6\ : STD_LOGIC;
  signal \prod0_carry__3_n_7\ : STD_LOGIC;
  signal \prod0_carry__4_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__4_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__4_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__4_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__4_n_0\ : STD_LOGIC;
  signal \prod0_carry__4_n_1\ : STD_LOGIC;
  signal \prod0_carry__4_n_2\ : STD_LOGIC;
  signal \prod0_carry__4_n_3\ : STD_LOGIC;
  signal \prod0_carry__4_n_4\ : STD_LOGIC;
  signal \prod0_carry__4_n_5\ : STD_LOGIC;
  signal \prod0_carry__4_n_6\ : STD_LOGIC;
  signal \prod0_carry__4_n_7\ : STD_LOGIC;
  signal \prod0_carry__5_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__5_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__5_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__5_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__5_n_0\ : STD_LOGIC;
  signal \prod0_carry__5_n_1\ : STD_LOGIC;
  signal \prod0_carry__5_n_2\ : STD_LOGIC;
  signal \prod0_carry__5_n_3\ : STD_LOGIC;
  signal \prod0_carry__5_n_4\ : STD_LOGIC;
  signal \prod0_carry__5_n_5\ : STD_LOGIC;
  signal \prod0_carry__5_n_6\ : STD_LOGIC;
  signal \prod0_carry__5_n_7\ : STD_LOGIC;
  signal \prod0_carry__6_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_i_5_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_n_0\ : STD_LOGIC;
  signal \prod0_carry__6_n_1\ : STD_LOGIC;
  signal \prod0_carry__6_n_2\ : STD_LOGIC;
  signal \prod0_carry__6_n_3\ : STD_LOGIC;
  signal \prod0_carry__6_n_4\ : STD_LOGIC;
  signal \prod0_carry__6_n_5\ : STD_LOGIC;
  signal \prod0_carry__6_n_6\ : STD_LOGIC;
  signal \prod0_carry__6_n_7\ : STD_LOGIC;
  signal \prod0_carry__7_i_1_n_0\ : STD_LOGIC;
  signal \prod0_carry__7_i_2_n_0\ : STD_LOGIC;
  signal \prod0_carry__7_i_3_n_0\ : STD_LOGIC;
  signal \prod0_carry__7_i_4_n_0\ : STD_LOGIC;
  signal \prod0_carry__7_n_0\ : STD_LOGIC;
  signal \prod0_carry__7_n_2\ : STD_LOGIC;
  signal \prod0_carry__7_n_3\ : STD_LOGIC;
  signal \prod0_carry__7_n_5\ : STD_LOGIC;
  signal \prod0_carry__7_n_6\ : STD_LOGIC;
  signal \prod0_carry__7_n_7\ : STD_LOGIC;
  signal prod0_carry_i_1_n_0 : STD_LOGIC;
  signal prod0_carry_i_2_n_0 : STD_LOGIC;
  signal prod0_carry_i_3_n_0 : STD_LOGIC;
  signal prod0_carry_n_0 : STD_LOGIC;
  signal prod0_carry_n_1 : STD_LOGIC;
  signal prod0_carry_n_2 : STD_LOGIC;
  signal prod0_carry_n_3 : STD_LOGIC;
  signal prod0_carry_n_7 : STD_LOGIC;
  signal reset_b : STD_LOGIC;
  signal \reset_b0_carry__0_i_1_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_2_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_5_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_6_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_7_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_i_8_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__0_n_1\ : STD_LOGIC;
  signal \reset_b0_carry__0_n_2\ : STD_LOGIC;
  signal \reset_b0_carry__0_n_3\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_1_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_2_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_3_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_4_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_5_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_6_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_i_7_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__1_n_1\ : STD_LOGIC;
  signal \reset_b0_carry__1_n_2\ : STD_LOGIC;
  signal \reset_b0_carry__1_n_3\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_1_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_2_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_3_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_4_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_5_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_6_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_7_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_i_8_n_0\ : STD_LOGIC;
  signal \reset_b0_carry__2_n_1\ : STD_LOGIC;
  signal \reset_b0_carry__2_n_2\ : STD_LOGIC;
  signal \reset_b0_carry__2_n_3\ : STD_LOGIC;
  signal reset_b0_carry_i_1_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_2_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_3_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_4_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_5_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_6_n_0 : STD_LOGIC;
  signal reset_b0_carry_i_7_n_0 : STD_LOGIC;
  signal reset_b0_carry_n_0 : STD_LOGIC;
  signal reset_b0_carry_n_1 : STD_LOGIC;
  signal reset_b0_carry_n_2 : STD_LOGIC;
  signal reset_b0_carry_n_3 : STD_LOGIC;
  signal s_axi_araddr_5_sn_1 : STD_LOGIC;
  signal \^s_axi_aresetn_0\ : STD_LOGIC;
  signal \s_axi_rdata[10]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[11]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[12]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[13]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[14]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[15]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[16]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[17]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[18]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[19]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[20]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[21]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[22]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[23]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[24]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[25]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[26]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[27]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[28]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[29]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[2]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[30]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[31]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[3]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[4]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[5]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[6]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[7]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[8]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[9]_i_2_n_0\ : STD_LOGIC;
  signal spk_out : STD_LOGIC;
  signal spk_out_i_10_n_0 : STD_LOGIC;
  signal spk_out_i_12_n_0 : STD_LOGIC;
  signal spk_out_i_13_n_0 : STD_LOGIC;
  signal spk_out_i_14_n_0 : STD_LOGIC;
  signal spk_out_i_15_n_0 : STD_LOGIC;
  signal spk_out_i_16_n_0 : STD_LOGIC;
  signal spk_out_i_17_n_0 : STD_LOGIC;
  signal spk_out_i_18_n_0 : STD_LOGIC;
  signal spk_out_i_20_n_0 : STD_LOGIC;
  signal spk_out_i_21_n_0 : STD_LOGIC;
  signal spk_out_i_22_n_0 : STD_LOGIC;
  signal spk_out_i_23_n_0 : STD_LOGIC;
  signal spk_out_i_24_n_0 : STD_LOGIC;
  signal spk_out_i_25_n_0 : STD_LOGIC;
  signal spk_out_i_26_n_0 : STD_LOGIC;
  signal spk_out_i_27_n_0 : STD_LOGIC;
  signal spk_out_i_28_n_0 : STD_LOGIC;
  signal spk_out_i_29_n_0 : STD_LOGIC;
  signal spk_out_i_30_n_0 : STD_LOGIC;
  signal spk_out_i_31_n_0 : STD_LOGIC;
  signal spk_out_i_32_n_0 : STD_LOGIC;
  signal spk_out_i_33_n_0 : STD_LOGIC;
  signal spk_out_i_34_n_0 : STD_LOGIC;
  signal spk_out_i_35_n_0 : STD_LOGIC;
  signal spk_out_i_3_n_0 : STD_LOGIC;
  signal spk_out_i_4_n_0 : STD_LOGIC;
  signal spk_out_i_5_n_0 : STD_LOGIC;
  signal spk_out_i_6_n_0 : STD_LOGIC;
  signal spk_out_i_7_n_0 : STD_LOGIC;
  signal spk_out_i_8_n_0 : STD_LOGIC;
  signal spk_out_i_9_n_0 : STD_LOGIC;
  signal spk_out_reg_i_11_n_0 : STD_LOGIC;
  signal spk_out_reg_i_11_n_1 : STD_LOGIC;
  signal spk_out_reg_i_11_n_2 : STD_LOGIC;
  signal spk_out_reg_i_11_n_3 : STD_LOGIC;
  signal spk_out_reg_i_19_n_0 : STD_LOGIC;
  signal spk_out_reg_i_19_n_1 : STD_LOGIC;
  signal spk_out_reg_i_19_n_2 : STD_LOGIC;
  signal spk_out_reg_i_19_n_3 : STD_LOGIC;
  signal spk_out_reg_i_1_n_0 : STD_LOGIC;
  signal spk_out_reg_i_1_n_1 : STD_LOGIC;
  signal spk_out_reg_i_1_n_2 : STD_LOGIC;
  signal spk_out_reg_i_1_n_3 : STD_LOGIC;
  signal spk_out_reg_i_2_n_0 : STD_LOGIC;
  signal spk_out_reg_i_2_n_1 : STD_LOGIC;
  signal spk_out_reg_i_2_n_2 : STD_LOGIC;
  signal spk_out_reg_i_2_n_3 : STD_LOGIC;
  signal \NLW_mem_tmp0_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_prod0__179_carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_prod0__179_carry__7_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_prod0__179_carry__7_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_prod0__249_carry__3_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_prod0__249_carry__3_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0__283_carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_prod0__283_carry__6_i_9_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0__283_carry__6_i_9_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_prod0__283_carry__7_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_prod0__283_carry__7_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0__379_carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_prod0__379_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \NLW_prod0__379_carry__8_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0__379_carry__8_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_prod0__81_carry_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \NLW_prod0__81_carry__7_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0__81_carry__7_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal NLW_prod0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_prod0_carry__7_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 to 2 );
  signal \NLW_prod0_carry__7_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal NLW_reset_b0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_reset_b0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_reset_b0_carry__1_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_reset_b0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_spk_out_reg_i_1_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_spk_out_reg_i_11_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_spk_out_reg_i_19_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_spk_out_reg_i_2_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_onehot_st_reg[0]\ : label is "iSTATE:001,iSTATE0:010,iSTATE1:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_st_reg[1]\ : label is "iSTATE:001,iSTATE0:010,iSTATE1:100,";
  attribute FSM_ENCODED_STATES of \FSM_onehot_st_reg[2]\ : label is "iSTATE:001,iSTATE0:010,iSTATE1:100,";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of mem_tmp0_carry : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \mem_tmp0_carry__6\ : label is 35;
  attribute HLUTNM : string;
  attribute HLUTNM of \prod0__283_carry__0_i_1\ : label is "lutpair6";
  attribute HLUTNM of \prod0__283_carry__0_i_2\ : label is "lutpair5";
  attribute HLUTNM of \prod0__283_carry__0_i_3\ : label is "lutpair4";
  attribute HLUTNM of \prod0__283_carry__0_i_4\ : label is "lutpair3";
  attribute HLUTNM of \prod0__283_carry__0_i_5\ : label is "lutpair7";
  attribute HLUTNM of \prod0__283_carry__0_i_6\ : label is "lutpair6";
  attribute HLUTNM of \prod0__283_carry__0_i_7\ : label is "lutpair5";
  attribute HLUTNM of \prod0__283_carry__0_i_8\ : label is "lutpair4";
  attribute HLUTNM of \prod0__283_carry__1_i_1\ : label is "lutpair10";
  attribute HLUTNM of \prod0__283_carry__1_i_2\ : label is "lutpair9";
  attribute HLUTNM of \prod0__283_carry__1_i_3\ : label is "lutpair8";
  attribute HLUTNM of \prod0__283_carry__1_i_4\ : label is "lutpair7";
  attribute HLUTNM of \prod0__283_carry__1_i_5\ : label is "lutpair11";
  attribute HLUTNM of \prod0__283_carry__1_i_6\ : label is "lutpair10";
  attribute HLUTNM of \prod0__283_carry__1_i_7\ : label is "lutpair9";
  attribute HLUTNM of \prod0__283_carry__1_i_8\ : label is "lutpair8";
  attribute HLUTNM of \prod0__283_carry__2_i_1\ : label is "lutpair14";
  attribute HLUTNM of \prod0__283_carry__2_i_2\ : label is "lutpair13";
  attribute HLUTNM of \prod0__283_carry__2_i_3\ : label is "lutpair12";
  attribute HLUTNM of \prod0__283_carry__2_i_4\ : label is "lutpair11";
  attribute HLUTNM of \prod0__283_carry__2_i_5\ : label is "lutpair15";
  attribute HLUTNM of \prod0__283_carry__2_i_6\ : label is "lutpair14";
  attribute HLUTNM of \prod0__283_carry__2_i_7\ : label is "lutpair13";
  attribute HLUTNM of \prod0__283_carry__2_i_8\ : label is "lutpair12";
  attribute HLUTNM of \prod0__283_carry__3_i_1\ : label is "lutpair18";
  attribute HLUTNM of \prod0__283_carry__3_i_2\ : label is "lutpair17";
  attribute HLUTNM of \prod0__283_carry__3_i_3\ : label is "lutpair16";
  attribute HLUTNM of \prod0__283_carry__3_i_4\ : label is "lutpair15";
  attribute HLUTNM of \prod0__283_carry__3_i_5\ : label is "lutpair19";
  attribute HLUTNM of \prod0__283_carry__3_i_6\ : label is "lutpair18";
  attribute HLUTNM of \prod0__283_carry__3_i_7\ : label is "lutpair17";
  attribute HLUTNM of \prod0__283_carry__3_i_8\ : label is "lutpair16";
  attribute HLUTNM of \prod0__283_carry__4_i_1\ : label is "lutpair22";
  attribute HLUTNM of \prod0__283_carry__4_i_2\ : label is "lutpair21";
  attribute HLUTNM of \prod0__283_carry__4_i_3\ : label is "lutpair20";
  attribute HLUTNM of \prod0__283_carry__4_i_4\ : label is "lutpair19";
  attribute HLUTNM of \prod0__283_carry__4_i_5\ : label is "lutpair23";
  attribute HLUTNM of \prod0__283_carry__4_i_6\ : label is "lutpair22";
  attribute HLUTNM of \prod0__283_carry__4_i_7\ : label is "lutpair21";
  attribute HLUTNM of \prod0__283_carry__4_i_8\ : label is "lutpair20";
  attribute HLUTNM of \prod0__283_carry__5_i_1\ : label is "lutpair26";
  attribute HLUTNM of \prod0__283_carry__5_i_2\ : label is "lutpair25";
  attribute HLUTNM of \prod0__283_carry__5_i_3\ : label is "lutpair24";
  attribute HLUTNM of \prod0__283_carry__5_i_4\ : label is "lutpair23";
  attribute HLUTNM of \prod0__283_carry__5_i_5\ : label is "lutpair27";
  attribute HLUTNM of \prod0__283_carry__5_i_6\ : label is "lutpair26";
  attribute HLUTNM of \prod0__283_carry__5_i_7\ : label is "lutpair25";
  attribute HLUTNM of \prod0__283_carry__5_i_8\ : label is "lutpair24";
  attribute HLUTNM of \prod0__283_carry__6_i_3\ : label is "lutpair28";
  attribute HLUTNM of \prod0__283_carry__6_i_4\ : label is "lutpair27";
  attribute HLUTNM of \prod0__283_carry__6_i_8\ : label is "lutpair28";
  attribute HLUTNM of \prod0__283_carry_i_1\ : label is "lutpair2";
  attribute HLUTNM of \prod0__283_carry_i_2\ : label is "lutpair1";
  attribute HLUTNM of \prod0__283_carry_i_3\ : label is "lutpair0";
  attribute HLUTNM of \prod0__283_carry_i_5\ : label is "lutpair3";
  attribute HLUTNM of \prod0__283_carry_i_6\ : label is "lutpair2";
  attribute HLUTNM of \prod0__283_carry_i_7\ : label is "lutpair1";
  attribute HLUTNM of \prod0__283_carry_i_8\ : label is "lutpair0";
  attribute HLUTNM of \prod0__379_carry__0_i_4\ : label is "lutpair30";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \prod0__379_carry__6_i_12\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \prod0__379_carry__6_i_9\ : label is "soft_lutpair0";
  attribute HLUTNM of \prod0__379_carry__7_i_1\ : label is "lutpair31";
  attribute HLUTNM of \prod0__379_carry__7_i_5\ : label is "lutpair32";
  attribute HLUTNM of \prod0__379_carry__7_i_6\ : label is "lutpair31";
  attribute HLUTNM of \prod0__379_carry__8_i_1\ : label is "lutpair32";
  attribute HLUTNM of \prod0__379_carry_i_1\ : label is "lutpair29";
  attribute HLUTNM of \prod0__379_carry_i_5\ : label is "lutpair30";
  attribute HLUTNM of \prod0__379_carry_i_6\ : label is "lutpair29";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of reset_b0_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \reset_b0_carry__0\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \reset_b0_carry__1\ : label is 11;
  attribute COMPARATOR_THRESHOLD of \reset_b0_carry__2\ : label is 11;
  attribute COMPARATOR_THRESHOLD of spk_out_reg_i_1 : label is 11;
  attribute COMPARATOR_THRESHOLD of spk_out_reg_i_11 : label is 11;
  attribute COMPARATOR_THRESHOLD of spk_out_reg_i_19 : label is 11;
  attribute COMPARATOR_THRESHOLD of spk_out_reg_i_2 : label is 11;
begin
  s_axi_araddr_5_sp_1 <= s_axi_araddr_5_sn_1;
  s_axi_aresetn_0 <= \^s_axi_aresetn_0\;
\FSM_onehot_st[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AAAE"
    )
        port map (
      I0 => \FSM_onehot_st_reg_n_0_[2]\,
      I1 => \FSM_onehot_st_reg_n_0_[0]\,
      I2 => start_pulse,
      I3 => mem_tmp_0,
      O => \FSM_onehot_st[0]_i_1_n_0\
    );
\FSM_onehot_st[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"CCC8"
    )
        port map (
      I0 => \FSM_onehot_st_reg_n_0_[2]\,
      I1 => \FSM_onehot_st_reg_n_0_[0]\,
      I2 => start_pulse,
      I3 => mem_tmp_0,
      O => \FSM_onehot_st[1]_i_1_n_0\
    );
\FSM_onehot_st_reg[0]\: unisim.vcomponents.FDPE
    generic map(
      INIT => '1'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_onehot_st[0]_i_1_n_0\,
      PRE => \^s_axi_aresetn_0\,
      Q => \FSM_onehot_st_reg_n_0_[0]\
    );
\FSM_onehot_st_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \^s_axi_aresetn_0\,
      D => \FSM_onehot_st[1]_i_1_n_0\,
      Q => mem_tmp_0
    );
\FSM_onehot_st_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp_0,
      Q => \FSM_onehot_st_reg_n_0_[2]\
    );
done_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => \^s_axi_aresetn_0\,
      D => \FSM_onehot_st_reg_n_0_[2]\,
      Q => done
    );
done_sticky_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFDFFFFFF0000"
    )
        port map (
      I0 => done_sticky_reg,
      I1 => s_axi_araddr(5),
      I2 => s_axi_araddr(4),
      I3 => done_sticky_reg_0,
      I4 => done,
      I5 => data0(0),
      O => s_axi_araddr_5_sn_1
    );
\mem_out_q16_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(0),
      Q => mem_out_q16(0)
    );
\mem_out_q16_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(10),
      Q => mem_out_q16(10)
    );
\mem_out_q16_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(11),
      Q => mem_out_q16(11)
    );
\mem_out_q16_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(12),
      Q => mem_out_q16(12)
    );
\mem_out_q16_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(13),
      Q => mem_out_q16(13)
    );
\mem_out_q16_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(14),
      Q => mem_out_q16(14)
    );
\mem_out_q16_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(15),
      Q => mem_out_q16(15)
    );
\mem_out_q16_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(16),
      Q => mem_out_q16(16)
    );
\mem_out_q16_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(17),
      Q => mem_out_q16(17)
    );
\mem_out_q16_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(18),
      Q => mem_out_q16(18)
    );
\mem_out_q16_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(19),
      Q => mem_out_q16(19)
    );
\mem_out_q16_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(1),
      Q => mem_out_q16(1)
    );
\mem_out_q16_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(20),
      Q => mem_out_q16(20)
    );
\mem_out_q16_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(21),
      Q => mem_out_q16(21)
    );
\mem_out_q16_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(22),
      Q => mem_out_q16(22)
    );
\mem_out_q16_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(23),
      Q => mem_out_q16(23)
    );
\mem_out_q16_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(24),
      Q => mem_out_q16(24)
    );
\mem_out_q16_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(25),
      Q => mem_out_q16(25)
    );
\mem_out_q16_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(26),
      Q => mem_out_q16(26)
    );
\mem_out_q16_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(27),
      Q => mem_out_q16(27)
    );
\mem_out_q16_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(28),
      Q => mem_out_q16(28)
    );
\mem_out_q16_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(29),
      Q => mem_out_q16(29)
    );
\mem_out_q16_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(2),
      Q => mem_out_q16(2)
    );
\mem_out_q16_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(30),
      Q => mem_out_q16(30)
    );
\mem_out_q16_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(31),
      Q => mem_out_q16(31)
    );
\mem_out_q16_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(3),
      Q => mem_out_q16(3)
    );
\mem_out_q16_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(4),
      Q => mem_out_q16(4)
    );
\mem_out_q16_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(5),
      Q => mem_out_q16(5)
    );
\mem_out_q16_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(6),
      Q => mem_out_q16(6)
    );
\mem_out_q16_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(7),
      Q => mem_out_q16(7)
    );
\mem_out_q16_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(8),
      Q => mem_out_q16(8)
    );
\mem_out_q16_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp(9),
      Q => mem_out_q16(9)
    );
mem_tmp0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => mem_tmp0_carry_n_0,
      CO(2) => mem_tmp0_carry_n_1,
      CO(1) => mem_tmp0_carry_n_2,
      CO(0) => mem_tmp0_carry_n_3,
      CYINIT => '0',
      DI(3 downto 0) => p_0_in1_in(3 downto 0),
      O(3 downto 0) => mem_tmp0(3 downto 0),
      S(3) => mem_tmp0_carry_i_1_n_0,
      S(2) => mem_tmp0_carry_i_2_n_0,
      S(1) => mem_tmp0_carry_i_3_n_0,
      S(0) => mem_tmp0_carry_i_4_n_0
    );
\mem_tmp0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => mem_tmp0_carry_n_0,
      CO(3) => \mem_tmp0_carry__0_n_0\,
      CO(2) => \mem_tmp0_carry__0_n_1\,
      CO(1) => \mem_tmp0_carry__0_n_2\,
      CO(0) => \mem_tmp0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => p_0_in1_in(7 downto 4),
      O(3 downto 0) => mem_tmp0(7 downto 4),
      S(3) => \mem_tmp0_carry__0_i_1_n_0\,
      S(2) => \mem_tmp0_carry__0_i_2_n_0\,
      S(1) => \mem_tmp0_carry__0_i_3_n_0\,
      S(0) => \mem_tmp0_carry__0_i_4_n_0\
    );
\mem_tmp0_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(7),
      I1 => \mem_tmp_reg[31]_0\(7),
      O => \mem_tmp0_carry__0_i_1_n_0\
    );
\mem_tmp0_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(6),
      I1 => \mem_tmp_reg[31]_0\(6),
      O => \mem_tmp0_carry__0_i_2_n_0\
    );
\mem_tmp0_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(5),
      I1 => \mem_tmp_reg[31]_0\(5),
      O => \mem_tmp0_carry__0_i_3_n_0\
    );
\mem_tmp0_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(4),
      I1 => \mem_tmp_reg[31]_0\(4),
      O => \mem_tmp0_carry__0_i_4_n_0\
    );
\mem_tmp0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__0_n_0\,
      CO(3) => \mem_tmp0_carry__1_n_0\,
      CO(2) => \mem_tmp0_carry__1_n_1\,
      CO(1) => \mem_tmp0_carry__1_n_2\,
      CO(0) => \mem_tmp0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => p_0_in1_in(11 downto 8),
      O(3 downto 0) => mem_tmp0(11 downto 8),
      S(3) => \mem_tmp0_carry__1_i_1_n_0\,
      S(2) => \mem_tmp0_carry__1_i_2_n_0\,
      S(1) => \mem_tmp0_carry__1_i_3_n_0\,
      S(0) => \mem_tmp0_carry__1_i_4_n_0\
    );
\mem_tmp0_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(11),
      I1 => \mem_tmp_reg[31]_0\(11),
      O => \mem_tmp0_carry__1_i_1_n_0\
    );
\mem_tmp0_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(10),
      I1 => \mem_tmp_reg[31]_0\(10),
      O => \mem_tmp0_carry__1_i_2_n_0\
    );
\mem_tmp0_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(9),
      I1 => \mem_tmp_reg[31]_0\(9),
      O => \mem_tmp0_carry__1_i_3_n_0\
    );
\mem_tmp0_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(8),
      I1 => \mem_tmp_reg[31]_0\(8),
      O => \mem_tmp0_carry__1_i_4_n_0\
    );
\mem_tmp0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__1_n_0\,
      CO(3) => \mem_tmp0_carry__2_n_0\,
      CO(2) => \mem_tmp0_carry__2_n_1\,
      CO(1) => \mem_tmp0_carry__2_n_2\,
      CO(0) => \mem_tmp0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => p_0_in1_in(15 downto 12),
      O(3 downto 0) => mem_tmp0(15 downto 12),
      S(3) => \mem_tmp0_carry__2_i_1_n_0\,
      S(2) => \mem_tmp0_carry__2_i_2_n_0\,
      S(1) => \mem_tmp0_carry__2_i_3_n_0\,
      S(0) => \mem_tmp0_carry__2_i_4_n_0\
    );
\mem_tmp0_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(15),
      I1 => \mem_tmp_reg[31]_0\(15),
      O => \mem_tmp0_carry__2_i_1_n_0\
    );
\mem_tmp0_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(14),
      I1 => \mem_tmp_reg[31]_0\(14),
      O => \mem_tmp0_carry__2_i_2_n_0\
    );
\mem_tmp0_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(13),
      I1 => \mem_tmp_reg[31]_0\(13),
      O => \mem_tmp0_carry__2_i_3_n_0\
    );
\mem_tmp0_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(12),
      I1 => \mem_tmp_reg[31]_0\(12),
      O => \mem_tmp0_carry__2_i_4_n_0\
    );
\mem_tmp0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__2_n_0\,
      CO(3) => \mem_tmp0_carry__3_n_0\,
      CO(2) => \mem_tmp0_carry__3_n_1\,
      CO(1) => \mem_tmp0_carry__3_n_2\,
      CO(0) => \mem_tmp0_carry__3_n_3\,
      CYINIT => '0',
      DI(3) => \mem_tmp0_carry__3_i_1_n_0\,
      DI(2) => \mem_tmp0_carry__3_i_2_n_0\,
      DI(1) => \mem_tmp0_carry__3_i_3_n_0\,
      DI(0) => p_0_in1_in(16),
      O(3 downto 0) => mem_tmp0(19 downto 16),
      S(3) => \mem_tmp0_carry__3_i_4_n_0\,
      S(2) => \mem_tmp0_carry__3_i_5_n_0\,
      S(1) => \mem_tmp0_carry__3_i_6_n_0\,
      S(0) => \mem_tmp0_carry__3_i_7_n_0\
    );
\mem_tmp0_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(18),
      I1 => \mem_tmp_reg[31]_0\(18),
      O => \mem_tmp0_carry__3_i_1_n_0\
    );
\mem_tmp0_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(17),
      I1 => \mem_tmp_reg[31]_0\(17),
      O => \mem_tmp0_carry__3_i_2_n_0\
    );
\mem_tmp0_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(16),
      I1 => reset_b,
      O => \mem_tmp0_carry__3_i_3_n_0\
    );
\mem_tmp0_carry__3_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(18),
      I1 => p_0_in1_in(18),
      I2 => \mem_tmp_reg[31]_0\(19),
      I3 => p_0_in1_in(19),
      O => \mem_tmp0_carry__3_i_4_n_0\
    );
\mem_tmp0_carry__3_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(17),
      I1 => p_0_in1_in(17),
      I2 => \mem_tmp_reg[31]_0\(18),
      I3 => p_0_in1_in(18),
      O => \mem_tmp0_carry__3_i_5_n_0\
    );
\mem_tmp0_carry__3_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2DD2"
    )
        port map (
      I0 => reset_b,
      I1 => \mem_tmp_reg[31]_0\(16),
      I2 => \mem_tmp_reg[31]_0\(17),
      I3 => p_0_in1_in(17),
      O => \mem_tmp0_carry__3_i_6_n_0\
    );
\mem_tmp0_carry__3_i_7\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => reset_b,
      I1 => \mem_tmp_reg[31]_0\(16),
      I2 => p_0_in1_in(16),
      O => \mem_tmp0_carry__3_i_7_n_0\
    );
\mem_tmp0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__3_n_0\,
      CO(3) => \mem_tmp0_carry__4_n_0\,
      CO(2) => \mem_tmp0_carry__4_n_1\,
      CO(1) => \mem_tmp0_carry__4_n_2\,
      CO(0) => \mem_tmp0_carry__4_n_3\,
      CYINIT => '0',
      DI(3) => \mem_tmp0_carry__4_i_1_n_0\,
      DI(2) => \mem_tmp0_carry__4_i_2_n_0\,
      DI(1) => \mem_tmp0_carry__4_i_3_n_0\,
      DI(0) => \mem_tmp0_carry__4_i_4_n_0\,
      O(3 downto 0) => mem_tmp0(23 downto 20),
      S(3) => \mem_tmp0_carry__4_i_5_n_0\,
      S(2) => \mem_tmp0_carry__4_i_6_n_0\,
      S(1) => \mem_tmp0_carry__4_i_7_n_0\,
      S(0) => \mem_tmp0_carry__4_i_8_n_0\
    );
\mem_tmp0_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(22),
      I1 => \mem_tmp_reg[31]_0\(22),
      O => \mem_tmp0_carry__4_i_1_n_0\
    );
\mem_tmp0_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(21),
      I1 => \mem_tmp_reg[31]_0\(21),
      O => \mem_tmp0_carry__4_i_2_n_0\
    );
\mem_tmp0_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(20),
      I1 => \mem_tmp_reg[31]_0\(20),
      O => \mem_tmp0_carry__4_i_3_n_0\
    );
\mem_tmp0_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(19),
      I1 => \mem_tmp_reg[31]_0\(19),
      O => \mem_tmp0_carry__4_i_4_n_0\
    );
\mem_tmp0_carry__4_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(22),
      I1 => p_0_in1_in(22),
      I2 => \mem_tmp_reg[31]_0\(23),
      I3 => p_0_in1_in(23),
      O => \mem_tmp0_carry__4_i_5_n_0\
    );
\mem_tmp0_carry__4_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(21),
      I1 => p_0_in1_in(21),
      I2 => \mem_tmp_reg[31]_0\(22),
      I3 => p_0_in1_in(22),
      O => \mem_tmp0_carry__4_i_6_n_0\
    );
\mem_tmp0_carry__4_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(20),
      I1 => p_0_in1_in(20),
      I2 => \mem_tmp_reg[31]_0\(21),
      I3 => p_0_in1_in(21),
      O => \mem_tmp0_carry__4_i_7_n_0\
    );
\mem_tmp0_carry__4_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(19),
      I1 => p_0_in1_in(19),
      I2 => \mem_tmp_reg[31]_0\(20),
      I3 => p_0_in1_in(20),
      O => \mem_tmp0_carry__4_i_8_n_0\
    );
\mem_tmp0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__4_n_0\,
      CO(3) => \mem_tmp0_carry__5_n_0\,
      CO(2) => \mem_tmp0_carry__5_n_1\,
      CO(1) => \mem_tmp0_carry__5_n_2\,
      CO(0) => \mem_tmp0_carry__5_n_3\,
      CYINIT => '0',
      DI(3) => \mem_tmp0_carry__5_i_1_n_0\,
      DI(2) => \mem_tmp0_carry__5_i_2_n_0\,
      DI(1) => \mem_tmp0_carry__5_i_3_n_0\,
      DI(0) => \mem_tmp0_carry__5_i_4_n_0\,
      O(3 downto 0) => mem_tmp0(27 downto 24),
      S(3) => \mem_tmp0_carry__5_i_5_n_0\,
      S(2) => \mem_tmp0_carry__5_i_6_n_0\,
      S(1) => \mem_tmp0_carry__5_i_7_n_0\,
      S(0) => \mem_tmp0_carry__5_i_8_n_0\
    );
\mem_tmp0_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(26),
      I1 => \mem_tmp_reg[31]_0\(26),
      O => \mem_tmp0_carry__5_i_1_n_0\
    );
\mem_tmp0_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(25),
      I1 => \mem_tmp_reg[31]_0\(25),
      O => \mem_tmp0_carry__5_i_2_n_0\
    );
\mem_tmp0_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(24),
      I1 => \mem_tmp_reg[31]_0\(24),
      O => \mem_tmp0_carry__5_i_3_n_0\
    );
\mem_tmp0_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(23),
      I1 => \mem_tmp_reg[31]_0\(23),
      O => \mem_tmp0_carry__5_i_4_n_0\
    );
\mem_tmp0_carry__5_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(26),
      I1 => p_0_in1_in(26),
      I2 => \mem_tmp_reg[31]_0\(27),
      I3 => p_0_in1_in(27),
      O => \mem_tmp0_carry__5_i_5_n_0\
    );
\mem_tmp0_carry__5_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(25),
      I1 => p_0_in1_in(25),
      I2 => \mem_tmp_reg[31]_0\(26),
      I3 => p_0_in1_in(26),
      O => \mem_tmp0_carry__5_i_6_n_0\
    );
\mem_tmp0_carry__5_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(24),
      I1 => p_0_in1_in(24),
      I2 => \mem_tmp_reg[31]_0\(25),
      I3 => p_0_in1_in(25),
      O => \mem_tmp0_carry__5_i_7_n_0\
    );
\mem_tmp0_carry__5_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(23),
      I1 => p_0_in1_in(23),
      I2 => \mem_tmp_reg[31]_0\(24),
      I3 => p_0_in1_in(24),
      O => \mem_tmp0_carry__5_i_8_n_0\
    );
\mem_tmp0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \mem_tmp0_carry__5_n_0\,
      CO(3) => \NLW_mem_tmp0_carry__6_CO_UNCONNECTED\(3),
      CO(2) => \mem_tmp0_carry__6_n_1\,
      CO(1) => \mem_tmp0_carry__6_n_2\,
      CO(0) => \mem_tmp0_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => \mem_tmp0_carry__6_i_1_n_0\,
      DI(1) => \mem_tmp0_carry__6_i_2_n_0\,
      DI(0) => \mem_tmp0_carry__6_i_3_n_0\,
      O(3 downto 0) => mem_tmp0(31 downto 28),
      S(3) => \mem_tmp0_carry__6_i_4_n_0\,
      S(2) => \mem_tmp0_carry__6_i_5_n_0\,
      S(1) => \mem_tmp0_carry__6_i_6_n_0\,
      S(0) => \mem_tmp0_carry__6_i_7_n_0\
    );
\mem_tmp0_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(29),
      I1 => \mem_tmp_reg[31]_0\(29),
      O => \mem_tmp0_carry__6_i_1_n_0\
    );
\mem_tmp0_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(28),
      I1 => \mem_tmp_reg[31]_0\(28),
      O => \mem_tmp0_carry__6_i_2_n_0\
    );
\mem_tmp0_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_0_in1_in(27),
      I1 => \mem_tmp_reg[31]_0\(27),
      O => \mem_tmp0_carry__6_i_3_n_0\
    );
\mem_tmp0_carry__6_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(30),
      I1 => p_0_in1_in(30),
      I2 => \mem_tmp_reg[31]_0\(31),
      I3 => p_0_in1_in(31),
      O => \mem_tmp0_carry__6_i_4_n_0\
    );
\mem_tmp0_carry__6_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(29),
      I1 => p_0_in1_in(29),
      I2 => \mem_tmp_reg[31]_0\(30),
      I3 => p_0_in1_in(30),
      O => \mem_tmp0_carry__6_i_5_n_0\
    );
\mem_tmp0_carry__6_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(28),
      I1 => p_0_in1_in(28),
      I2 => \mem_tmp_reg[31]_0\(29),
      I3 => p_0_in1_in(29),
      O => \mem_tmp0_carry__6_i_6_n_0\
    );
\mem_tmp0_carry__6_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1EE1"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(27),
      I1 => p_0_in1_in(27),
      I2 => \mem_tmp_reg[31]_0\(28),
      I3 => p_0_in1_in(28),
      O => \mem_tmp0_carry__6_i_7_n_0\
    );
mem_tmp0_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(3),
      I1 => \mem_tmp_reg[31]_0\(3),
      O => mem_tmp0_carry_i_1_n_0
    );
mem_tmp0_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(2),
      I1 => \mem_tmp_reg[31]_0\(2),
      O => mem_tmp0_carry_i_2_n_0
    );
mem_tmp0_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(1),
      I1 => \mem_tmp_reg[31]_0\(1),
      O => mem_tmp0_carry_i_3_n_0
    );
mem_tmp0_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => p_0_in1_in(0),
      I1 => \mem_tmp_reg[31]_0\(0),
      O => mem_tmp0_carry_i_4_n_0
    );
\mem_tmp_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(0),
      Q => mem_tmp(0)
    );
\mem_tmp_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(10),
      Q => mem_tmp(10)
    );
\mem_tmp_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(11),
      Q => mem_tmp(11)
    );
\mem_tmp_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(12),
      Q => mem_tmp(12)
    );
\mem_tmp_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(13),
      Q => mem_tmp(13)
    );
\mem_tmp_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(14),
      Q => mem_tmp(14)
    );
\mem_tmp_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(15),
      Q => mem_tmp(15)
    );
\mem_tmp_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(16),
      Q => mem_tmp(16)
    );
\mem_tmp_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(17),
      Q => mem_tmp(17)
    );
\mem_tmp_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(18),
      Q => mem_tmp(18)
    );
\mem_tmp_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(19),
      Q => mem_tmp(19)
    );
\mem_tmp_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(1),
      Q => mem_tmp(1)
    );
\mem_tmp_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(20),
      Q => mem_tmp(20)
    );
\mem_tmp_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(21),
      Q => mem_tmp(21)
    );
\mem_tmp_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(22),
      Q => mem_tmp(22)
    );
\mem_tmp_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(23),
      Q => mem_tmp(23)
    );
\mem_tmp_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(24),
      Q => mem_tmp(24)
    );
\mem_tmp_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(25),
      Q => mem_tmp(25)
    );
\mem_tmp_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(26),
      Q => mem_tmp(26)
    );
\mem_tmp_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(27),
      Q => mem_tmp(27)
    );
\mem_tmp_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(28),
      Q => mem_tmp(28)
    );
\mem_tmp_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(29),
      Q => mem_tmp(29)
    );
\mem_tmp_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(2),
      Q => mem_tmp(2)
    );
\mem_tmp_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(30),
      Q => mem_tmp(30)
    );
\mem_tmp_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(31),
      Q => mem_tmp(31)
    );
\mem_tmp_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(3),
      Q => mem_tmp(3)
    );
\mem_tmp_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(4),
      Q => mem_tmp(4)
    );
\mem_tmp_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(5),
      Q => mem_tmp(5)
    );
\mem_tmp_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(6),
      Q => mem_tmp(6)
    );
\mem_tmp_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(7),
      Q => mem_tmp(7)
    );
\mem_tmp_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(8),
      Q => mem_tmp(8)
    );
\mem_tmp_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_tmp_0,
      CLR => \^s_axi_aresetn_0\,
      D => mem_tmp0(9),
      Q => mem_tmp(9)
    );
\prod0__179_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__179_carry_n_0\,
      CO(2) => \prod0__179_carry_n_1\,
      CO(1) => \prod0__179_carry_n_2\,
      CO(0) => \prod0__179_carry_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => Q(1 downto 0),
      DI(1 downto 0) => B"01",
      O(3) => \prod0__179_carry_n_4\,
      O(2) => \prod0__179_carry_n_5\,
      O(1) => \prod0__179_carry_n_6\,
      O(0) => \NLW_prod0__179_carry_O_UNCONNECTED\(0),
      S(3) => \prod0__179_carry_i_1_n_0\,
      S(2) => \prod0__179_carry_i_2_n_0\,
      S(1) => \prod0__179_carry_i_3_n_0\,
      S(0) => Q(0)
    );
\prod0__179_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry_n_0\,
      CO(3) => \prod0__179_carry__0_n_0\,
      CO(2) => \prod0__179_carry__0_n_1\,
      CO(1) => \prod0__179_carry__0_n_2\,
      CO(0) => \prod0__179_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(5 downto 2),
      O(3) => \prod0__179_carry__0_n_4\,
      O(2) => \prod0__179_carry__0_n_5\,
      O(1) => \prod0__179_carry__0_n_6\,
      O(0) => \prod0__179_carry__0_n_7\,
      S(3) => \prod0__179_carry__0_i_1_n_0\,
      S(2) => \prod0__179_carry__0_i_2_n_0\,
      S(1) => \prod0__179_carry__0_i_3_n_0\,
      S(0) => \prod0__179_carry__0_i_4_n_0\
    );
\prod0__179_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(5),
      I1 => Q(7),
      O => \prod0__179_carry__0_i_1_n_0\
    );
\prod0__179_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(4),
      I1 => Q(6),
      O => \prod0__179_carry__0_i_2_n_0\
    );
\prod0__179_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(3),
      I1 => Q(5),
      O => \prod0__179_carry__0_i_3_n_0\
    );
\prod0__179_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(2),
      I1 => Q(4),
      O => \prod0__179_carry__0_i_4_n_0\
    );
\prod0__179_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__0_n_0\,
      CO(3) => \prod0__179_carry__1_n_0\,
      CO(2) => \prod0__179_carry__1_n_1\,
      CO(1) => \prod0__179_carry__1_n_2\,
      CO(0) => \prod0__179_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(9 downto 6),
      O(3) => \prod0__179_carry__1_n_4\,
      O(2) => \prod0__179_carry__1_n_5\,
      O(1) => \prod0__179_carry__1_n_6\,
      O(0) => \prod0__179_carry__1_n_7\,
      S(3) => \prod0__179_carry__1_i_1_n_0\,
      S(2) => \prod0__179_carry__1_i_2_n_0\,
      S(1) => \prod0__179_carry__1_i_3_n_0\,
      S(0) => \prod0__179_carry__1_i_4_n_0\
    );
\prod0__179_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(9),
      I1 => Q(11),
      O => \prod0__179_carry__1_i_1_n_0\
    );
\prod0__179_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(8),
      I1 => Q(10),
      O => \prod0__179_carry__1_i_2_n_0\
    );
\prod0__179_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(7),
      I1 => Q(9),
      O => \prod0__179_carry__1_i_3_n_0\
    );
\prod0__179_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(6),
      I1 => Q(8),
      O => \prod0__179_carry__1_i_4_n_0\
    );
\prod0__179_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__1_n_0\,
      CO(3) => \prod0__179_carry__2_n_0\,
      CO(2) => \prod0__179_carry__2_n_1\,
      CO(1) => \prod0__179_carry__2_n_2\,
      CO(0) => \prod0__179_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(13 downto 10),
      O(3) => \prod0__179_carry__2_n_4\,
      O(2) => \prod0__179_carry__2_n_5\,
      O(1) => \prod0__179_carry__2_n_6\,
      O(0) => \prod0__179_carry__2_n_7\,
      S(3) => \prod0__179_carry__2_i_1_n_0\,
      S(2) => \prod0__179_carry__2_i_2_n_0\,
      S(1) => \prod0__179_carry__2_i_3_n_0\,
      S(0) => \prod0__179_carry__2_i_4_n_0\
    );
\prod0__179_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(13),
      I1 => Q(15),
      O => \prod0__179_carry__2_i_1_n_0\
    );
\prod0__179_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(12),
      I1 => Q(14),
      O => \prod0__179_carry__2_i_2_n_0\
    );
\prod0__179_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(11),
      I1 => Q(13),
      O => \prod0__179_carry__2_i_3_n_0\
    );
\prod0__179_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(10),
      I1 => Q(12),
      O => \prod0__179_carry__2_i_4_n_0\
    );
\prod0__179_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__2_n_0\,
      CO(3) => \prod0__179_carry__3_n_0\,
      CO(2) => \prod0__179_carry__3_n_1\,
      CO(1) => \prod0__179_carry__3_n_2\,
      CO(0) => \prod0__179_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(17 downto 14),
      O(3) => \prod0__179_carry__3_n_4\,
      O(2) => \prod0__179_carry__3_n_5\,
      O(1) => \prod0__179_carry__3_n_6\,
      O(0) => \prod0__179_carry__3_n_7\,
      S(3) => \prod0__179_carry__3_i_1_n_0\,
      S(2) => \prod0__179_carry__3_i_2_n_0\,
      S(1) => \prod0__179_carry__3_i_3_n_0\,
      S(0) => \prod0__179_carry__3_i_4_n_0\
    );
\prod0__179_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(17),
      I1 => Q(19),
      O => \prod0__179_carry__3_i_1_n_0\
    );
\prod0__179_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(16),
      I1 => Q(18),
      O => \prod0__179_carry__3_i_2_n_0\
    );
\prod0__179_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(15),
      I1 => Q(17),
      O => \prod0__179_carry__3_i_3_n_0\
    );
\prod0__179_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(14),
      I1 => Q(16),
      O => \prod0__179_carry__3_i_4_n_0\
    );
\prod0__179_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__3_n_0\,
      CO(3) => \prod0__179_carry__4_n_0\,
      CO(2) => \prod0__179_carry__4_n_1\,
      CO(1) => \prod0__179_carry__4_n_2\,
      CO(0) => \prod0__179_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(21 downto 18),
      O(3) => \prod0__179_carry__4_n_4\,
      O(2) => \prod0__179_carry__4_n_5\,
      O(1) => \prod0__179_carry__4_n_6\,
      O(0) => \prod0__179_carry__4_n_7\,
      S(3) => \prod0__179_carry__4_i_1_n_0\,
      S(2) => \prod0__179_carry__4_i_2_n_0\,
      S(1) => \prod0__179_carry__4_i_3_n_0\,
      S(0) => \prod0__179_carry__4_i_4_n_0\
    );
\prod0__179_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(21),
      I1 => Q(23),
      O => \prod0__179_carry__4_i_1_n_0\
    );
\prod0__179_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(20),
      I1 => Q(22),
      O => \prod0__179_carry__4_i_2_n_0\
    );
\prod0__179_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(19),
      I1 => Q(21),
      O => \prod0__179_carry__4_i_3_n_0\
    );
\prod0__179_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(18),
      I1 => Q(20),
      O => \prod0__179_carry__4_i_4_n_0\
    );
\prod0__179_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__4_n_0\,
      CO(3) => \prod0__179_carry__5_n_0\,
      CO(2) => \prod0__179_carry__5_n_1\,
      CO(1) => \prod0__179_carry__5_n_2\,
      CO(0) => \prod0__179_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(25 downto 22),
      O(3) => \prod0__179_carry__5_n_4\,
      O(2) => \prod0__179_carry__5_n_5\,
      O(1) => \prod0__179_carry__5_n_6\,
      O(0) => \prod0__179_carry__5_n_7\,
      S(3) => \prod0__179_carry__5_i_1_n_0\,
      S(2) => \prod0__179_carry__5_i_2_n_0\,
      S(1) => \prod0__179_carry__5_i_3_n_0\,
      S(0) => \prod0__179_carry__5_i_4_n_0\
    );
\prod0__179_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(25),
      I1 => Q(27),
      O => \prod0__179_carry__5_i_1_n_0\
    );
\prod0__179_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(24),
      I1 => Q(26),
      O => \prod0__179_carry__5_i_2_n_0\
    );
\prod0__179_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(23),
      I1 => Q(25),
      O => \prod0__179_carry__5_i_3_n_0\
    );
\prod0__179_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(22),
      I1 => Q(24),
      O => \prod0__179_carry__5_i_4_n_0\
    );
\prod0__179_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__5_n_0\,
      CO(3) => \prod0__179_carry__6_n_0\,
      CO(2) => \prod0__179_carry__6_n_1\,
      CO(1) => \prod0__179_carry__6_n_2\,
      CO(0) => \prod0__179_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__179_carry__6_i_1_n_0\,
      DI(2) => Q(30),
      DI(1 downto 0) => Q(27 downto 26),
      O(3) => \prod0__179_carry__6_n_4\,
      O(2) => \prod0__179_carry__6_n_5\,
      O(1) => \prod0__179_carry__6_n_6\,
      O(0) => \prod0__179_carry__6_n_7\,
      S(3) => \prod0__179_carry__6_i_2_n_0\,
      S(2) => \prod0__179_carry__6_i_3_n_0\,
      S(1) => \prod0__179_carry__6_i_4_n_0\,
      S(0) => \prod0__179_carry__6_i_5_n_0\
    );
\prod0__179_carry__6_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(30),
      O => \prod0__179_carry__6_i_1_n_0\
    );
\prod0__179_carry__6_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => Q(30),
      I1 => Q(31),
      I2 => Q(29),
      O => \prod0__179_carry__6_i_2_n_0\
    );
\prod0__179_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => Q(30),
      I1 => Q(28),
      O => \prod0__179_carry__6_i_3_n_0\
    );
\prod0__179_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(27),
      I1 => Q(29),
      O => \prod0__179_carry__6_i_4_n_0\
    );
\prod0__179_carry__6_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(26),
      I1 => Q(28),
      O => \prod0__179_carry__6_i_5_n_0\
    );
\prod0__179_carry__7\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__179_carry__6_n_0\,
      CO(3 downto 2) => \NLW_prod0__179_carry__7_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \prod0__179_carry__7_n_2\,
      CO(0) => \prod0__179_carry__7_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1) => Q(30),
      DI(0) => \prod0__179_carry__7_i_1_n_0\,
      O(3) => \NLW_prod0__179_carry__7_O_UNCONNECTED\(3),
      O(2) => \prod0__179_carry__7_n_5\,
      O(1) => \prod0__179_carry__7_n_6\,
      O(0) => \prod0__179_carry__7_n_7\,
      S(3) => '0',
      S(2) => Q(31),
      S(1) => \prod0__179_carry__7_i_2_n_0\,
      S(0) => \prod0__179_carry__7_i_3_n_0\
    );
\prod0__179_carry__7_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(31),
      I1 => Q(29),
      O => \prod0__179_carry__7_i_1_n_0\
    );
\prod0__179_carry__7_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => Q(30),
      I1 => Q(31),
      O => \prod0__179_carry__7_i_2_n_0\
    );
\prod0__179_carry__7_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => Q(29),
      I1 => Q(31),
      I2 => Q(30),
      O => \prod0__179_carry__7_i_3_n_0\
    );
\prod0__179_carry_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(1),
      I1 => Q(3),
      O => \prod0__179_carry_i_1_n_0\
    );
\prod0__179_carry_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(0),
      I1 => Q(2),
      O => \prod0__179_carry_i_2_n_0\
    );
\prod0__179_carry_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(1),
      O => \prod0__179_carry_i_3_n_0\
    );
\prod0__249_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__249_carry_n_0\,
      CO(2) => \prod0__249_carry_n_1\,
      CO(1) => \prod0__249_carry_n_2\,
      CO(0) => \prod0__249_carry_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => B"00",
      DI(1) => Q(16),
      DI(0) => '0',
      O(3) => \prod0__249_carry_n_4\,
      O(2) => \prod0__249_carry_n_5\,
      O(1) => \prod0__249_carry_n_6\,
      O(0) => \prod0__249_carry_n_7\,
      S(3 downto 2) => Q(18 downto 17),
      S(1) => \prod0__249_carry_i_1_n_0\,
      S(0) => Q(15)
    );
\prod0__249_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__249_carry_n_0\,
      CO(3) => \prod0__249_carry__0_n_0\,
      CO(2) => \prod0__249_carry__0_n_1\,
      CO(1) => \prod0__249_carry__0_n_2\,
      CO(0) => \prod0__249_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \prod0__249_carry__0_n_4\,
      O(2) => \prod0__249_carry__0_n_5\,
      O(1) => \prod0__249_carry__0_n_6\,
      O(0) => \prod0__249_carry__0_n_7\,
      S(3 downto 0) => Q(22 downto 19)
    );
\prod0__249_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__249_carry__0_n_0\,
      CO(3) => \prod0__249_carry__1_n_0\,
      CO(2) => \prod0__249_carry__1_n_1\,
      CO(1) => \prod0__249_carry__1_n_2\,
      CO(0) => \prod0__249_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \prod0__249_carry__1_n_4\,
      O(2) => \prod0__249_carry__1_n_5\,
      O(1) => \prod0__249_carry__1_n_6\,
      O(0) => \prod0__249_carry__1_n_7\,
      S(3 downto 0) => Q(26 downto 23)
    );
\prod0__249_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__249_carry__1_n_0\,
      CO(3) => \prod0__249_carry__2_n_0\,
      CO(2) => \prod0__249_carry__2_n_1\,
      CO(1) => \prod0__249_carry__2_n_2\,
      CO(0) => \prod0__249_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \prod0__249_carry__2_n_4\,
      O(2) => \prod0__249_carry__2_n_5\,
      O(1) => \prod0__249_carry__2_n_6\,
      O(0) => \prod0__249_carry__2_n_7\,
      S(3 downto 0) => Q(30 downto 27)
    );
\prod0__249_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__249_carry__2_n_0\,
      CO(3 downto 2) => \NLW_prod0__249_carry__3_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \prod0__249_carry__3_n_2\,
      CO(0) => \NLW_prod0__249_carry__3_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_prod0__249_carry__3_O_UNCONNECTED\(3 downto 1),
      O(0) => \prod0__249_carry__3_n_7\,
      S(3 downto 1) => B"001",
      S(0) => \prod0__249_carry__3_i_1_n_0\
    );
\prod0__249_carry__3_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(31),
      O => \prod0__249_carry__3_i_1_n_0\
    );
\prod0__249_carry_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(16),
      O => \prod0__249_carry_i_1_n_0\
    );
\prod0__283_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__283_carry_n_0\,
      CO(2) => \prod0__283_carry_n_1\,
      CO(1) => \prod0__283_carry_n_2\,
      CO(0) => \prod0__283_carry_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry_i_1_n_0\,
      DI(2) => \prod0__283_carry_i_2_n_0\,
      DI(1) => \prod0__283_carry_i_3_n_0\,
      DI(0) => \prod0__283_carry_i_4_n_0\,
      O(3) => \prod0__283_carry_n_4\,
      O(2 downto 0) => \NLW_prod0__283_carry_O_UNCONNECTED\(2 downto 0),
      S(3) => \prod0__283_carry_i_5_n_0\,
      S(2) => \prod0__283_carry_i_6_n_0\,
      S(1) => \prod0__283_carry_i_7_n_0\,
      S(0) => \prod0__283_carry_i_8_n_0\
    );
\prod0__283_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry_n_0\,
      CO(3) => \prod0__283_carry__0_n_0\,
      CO(2) => \prod0__283_carry__0_n_1\,
      CO(1) => \prod0__283_carry__0_n_2\,
      CO(0) => \prod0__283_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__0_i_1_n_0\,
      DI(2) => \prod0__283_carry__0_i_2_n_0\,
      DI(1) => \prod0__283_carry__0_i_3_n_0\,
      DI(0) => \prod0__283_carry__0_i_4_n_0\,
      O(3) => \prod0__283_carry__0_n_4\,
      O(2) => \prod0__283_carry__0_n_5\,
      O(1) => \prod0__283_carry__0_n_6\,
      O(0) => \prod0__283_carry__0_n_7\,
      S(3) => \prod0__283_carry__0_i_5_n_0\,
      S(2) => \prod0__283_carry__0_i_6_n_0\,
      S(1) => \prod0__283_carry__0_i_7_n_0\,
      S(0) => \prod0__283_carry__0_i_8_n_0\
    );
\prod0__283_carry__0_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__1_n_4\,
      I1 => Q(6),
      I2 => Q(7),
      O => \prod0__283_carry__0_i_1_n_0\
    );
\prod0__283_carry__0_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__1_n_5\,
      I1 => Q(5),
      I2 => Q(6),
      O => \prod0__283_carry__0_i_2_n_0\
    );
\prod0__283_carry__0_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__1_n_6\,
      I1 => Q(4),
      I2 => Q(5),
      O => \prod0__283_carry__0_i_3_n_0\
    );
\prod0__283_carry__0_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__1_n_7\,
      I1 => Q(3),
      I2 => Q(4),
      O => \prod0__283_carry__0_i_4_n_0\
    );
\prod0__283_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__2_n_7\,
      I1 => Q(7),
      I2 => Q(8),
      I3 => \prod0__283_carry__0_i_1_n_0\,
      O => \prod0__283_carry__0_i_5_n_0\
    );
\prod0__283_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__1_n_4\,
      I1 => Q(6),
      I2 => Q(7),
      I3 => \prod0__283_carry__0_i_2_n_0\,
      O => \prod0__283_carry__0_i_6_n_0\
    );
\prod0__283_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__1_n_5\,
      I1 => Q(5),
      I2 => Q(6),
      I3 => \prod0__283_carry__0_i_3_n_0\,
      O => \prod0__283_carry__0_i_7_n_0\
    );
\prod0__283_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__1_n_6\,
      I1 => Q(4),
      I2 => Q(5),
      I3 => \prod0__283_carry__0_i_4_n_0\,
      O => \prod0__283_carry__0_i_8_n_0\
    );
\prod0__283_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__0_n_0\,
      CO(3) => \prod0__283_carry__1_n_0\,
      CO(2) => \prod0__283_carry__1_n_1\,
      CO(1) => \prod0__283_carry__1_n_2\,
      CO(0) => \prod0__283_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__1_i_1_n_0\,
      DI(2) => \prod0__283_carry__1_i_2_n_0\,
      DI(1) => \prod0__283_carry__1_i_3_n_0\,
      DI(0) => \prod0__283_carry__1_i_4_n_0\,
      O(3) => \prod0__283_carry__1_n_4\,
      O(2) => \prod0__283_carry__1_n_5\,
      O(1) => \prod0__283_carry__1_n_6\,
      O(0) => \prod0__283_carry__1_n_7\,
      S(3) => \prod0__283_carry__1_i_5_n_0\,
      S(2) => \prod0__283_carry__1_i_6_n_0\,
      S(1) => \prod0__283_carry__1_i_7_n_0\,
      S(0) => \prod0__283_carry__1_i_8_n_0\
    );
\prod0__283_carry__1_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__2_n_4\,
      I1 => Q(10),
      I2 => Q(11),
      O => \prod0__283_carry__1_i_1_n_0\
    );
\prod0__283_carry__1_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__2_n_5\,
      I1 => Q(9),
      I2 => Q(10),
      O => \prod0__283_carry__1_i_2_n_0\
    );
\prod0__283_carry__1_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__2_n_6\,
      I1 => Q(8),
      I2 => Q(9),
      O => \prod0__283_carry__1_i_3_n_0\
    );
\prod0__283_carry__1_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__2_n_7\,
      I1 => Q(7),
      I2 => Q(8),
      O => \prod0__283_carry__1_i_4_n_0\
    );
\prod0__283_carry__1_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__3_n_7\,
      I1 => Q(11),
      I2 => Q(12),
      I3 => \prod0__283_carry__1_i_1_n_0\,
      O => \prod0__283_carry__1_i_5_n_0\
    );
\prod0__283_carry__1_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__2_n_4\,
      I1 => Q(10),
      I2 => Q(11),
      I3 => \prod0__283_carry__1_i_2_n_0\,
      O => \prod0__283_carry__1_i_6_n_0\
    );
\prod0__283_carry__1_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__2_n_5\,
      I1 => Q(9),
      I2 => Q(10),
      I3 => \prod0__283_carry__1_i_3_n_0\,
      O => \prod0__283_carry__1_i_7_n_0\
    );
\prod0__283_carry__1_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__2_n_6\,
      I1 => Q(8),
      I2 => Q(9),
      I3 => \prod0__283_carry__1_i_4_n_0\,
      O => \prod0__283_carry__1_i_8_n_0\
    );
\prod0__283_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__1_n_0\,
      CO(3) => \prod0__283_carry__2_n_0\,
      CO(2) => \prod0__283_carry__2_n_1\,
      CO(1) => \prod0__283_carry__2_n_2\,
      CO(0) => \prod0__283_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__2_i_1_n_0\,
      DI(2) => \prod0__283_carry__2_i_2_n_0\,
      DI(1) => \prod0__283_carry__2_i_3_n_0\,
      DI(0) => \prod0__283_carry__2_i_4_n_0\,
      O(3) => \prod0__283_carry__2_n_4\,
      O(2) => \prod0__283_carry__2_n_5\,
      O(1) => \prod0__283_carry__2_n_6\,
      O(0) => \prod0__283_carry__2_n_7\,
      S(3) => \prod0__283_carry__2_i_5_n_0\,
      S(2) => \prod0__283_carry__2_i_6_n_0\,
      S(1) => \prod0__283_carry__2_i_7_n_0\,
      S(0) => \prod0__283_carry__2_i_8_n_0\
    );
\prod0__283_carry__2_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__3_n_4\,
      I1 => Q(14),
      I2 => Q(15),
      O => \prod0__283_carry__2_i_1_n_0\
    );
\prod0__283_carry__2_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__3_n_5\,
      I1 => Q(13),
      I2 => Q(14),
      O => \prod0__283_carry__2_i_2_n_0\
    );
\prod0__283_carry__2_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__3_n_6\,
      I1 => Q(12),
      I2 => Q(13),
      O => \prod0__283_carry__2_i_3_n_0\
    );
\prod0__283_carry__2_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__3_n_7\,
      I1 => Q(11),
      I2 => Q(12),
      O => \prod0__283_carry__2_i_4_n_0\
    );
\prod0__283_carry__2_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__4_n_7\,
      I1 => Q(15),
      I2 => Q(16),
      I3 => \prod0__283_carry__2_i_1_n_0\,
      O => \prod0__283_carry__2_i_5_n_0\
    );
\prod0__283_carry__2_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__3_n_4\,
      I1 => Q(14),
      I2 => Q(15),
      I3 => \prod0__283_carry__2_i_2_n_0\,
      O => \prod0__283_carry__2_i_6_n_0\
    );
\prod0__283_carry__2_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__3_n_5\,
      I1 => Q(13),
      I2 => Q(14),
      I3 => \prod0__283_carry__2_i_3_n_0\,
      O => \prod0__283_carry__2_i_7_n_0\
    );
\prod0__283_carry__2_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__3_n_6\,
      I1 => Q(12),
      I2 => Q(13),
      I3 => \prod0__283_carry__2_i_4_n_0\,
      O => \prod0__283_carry__2_i_8_n_0\
    );
\prod0__283_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__2_n_0\,
      CO(3) => \prod0__283_carry__3_n_0\,
      CO(2) => \prod0__283_carry__3_n_1\,
      CO(1) => \prod0__283_carry__3_n_2\,
      CO(0) => \prod0__283_carry__3_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__3_i_1_n_0\,
      DI(2) => \prod0__283_carry__3_i_2_n_0\,
      DI(1) => \prod0__283_carry__3_i_3_n_0\,
      DI(0) => \prod0__283_carry__3_i_4_n_0\,
      O(3) => \prod0__283_carry__3_n_4\,
      O(2) => \prod0__283_carry__3_n_5\,
      O(1) => \prod0__283_carry__3_n_6\,
      O(0) => \prod0__283_carry__3_n_7\,
      S(3) => \prod0__283_carry__3_i_5_n_0\,
      S(2) => \prod0__283_carry__3_i_6_n_0\,
      S(1) => \prod0__283_carry__3_i_7_n_0\,
      S(0) => \prod0__283_carry__3_i_8_n_0\
    );
\prod0__283_carry__3_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__4_n_4\,
      I1 => Q(18),
      I2 => Q(19),
      O => \prod0__283_carry__3_i_1_n_0\
    );
\prod0__283_carry__3_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__4_n_5\,
      I1 => Q(17),
      I2 => Q(18),
      O => \prod0__283_carry__3_i_2_n_0\
    );
\prod0__283_carry__3_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__4_n_6\,
      I1 => Q(16),
      I2 => Q(17),
      O => \prod0__283_carry__3_i_3_n_0\
    );
\prod0__283_carry__3_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__4_n_7\,
      I1 => Q(15),
      I2 => Q(16),
      O => \prod0__283_carry__3_i_4_n_0\
    );
\prod0__283_carry__3_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__5_n_7\,
      I1 => Q(19),
      I2 => Q(20),
      I3 => \prod0__283_carry__3_i_1_n_0\,
      O => \prod0__283_carry__3_i_5_n_0\
    );
\prod0__283_carry__3_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__4_n_4\,
      I1 => Q(18),
      I2 => Q(19),
      I3 => \prod0__283_carry__3_i_2_n_0\,
      O => \prod0__283_carry__3_i_6_n_0\
    );
\prod0__283_carry__3_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__4_n_5\,
      I1 => Q(17),
      I2 => Q(18),
      I3 => \prod0__283_carry__3_i_3_n_0\,
      O => \prod0__283_carry__3_i_7_n_0\
    );
\prod0__283_carry__3_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__4_n_6\,
      I1 => Q(16),
      I2 => Q(17),
      I3 => \prod0__283_carry__3_i_4_n_0\,
      O => \prod0__283_carry__3_i_8_n_0\
    );
\prod0__283_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__3_n_0\,
      CO(3) => \prod0__283_carry__4_n_0\,
      CO(2) => \prod0__283_carry__4_n_1\,
      CO(1) => \prod0__283_carry__4_n_2\,
      CO(0) => \prod0__283_carry__4_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__4_i_1_n_0\,
      DI(2) => \prod0__283_carry__4_i_2_n_0\,
      DI(1) => \prod0__283_carry__4_i_3_n_0\,
      DI(0) => \prod0__283_carry__4_i_4_n_0\,
      O(3) => \prod0__283_carry__4_n_4\,
      O(2) => \prod0__283_carry__4_n_5\,
      O(1) => \prod0__283_carry__4_n_6\,
      O(0) => \prod0__283_carry__4_n_7\,
      S(3) => \prod0__283_carry__4_i_5_n_0\,
      S(2) => \prod0__283_carry__4_i_6_n_0\,
      S(1) => \prod0__283_carry__4_i_7_n_0\,
      S(0) => \prod0__283_carry__4_i_8_n_0\
    );
\prod0__283_carry__4_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__5_n_4\,
      I1 => Q(22),
      I2 => Q(23),
      O => \prod0__283_carry__4_i_1_n_0\
    );
\prod0__283_carry__4_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__5_n_5\,
      I1 => Q(21),
      I2 => Q(22),
      O => \prod0__283_carry__4_i_2_n_0\
    );
\prod0__283_carry__4_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__5_n_6\,
      I1 => Q(20),
      I2 => Q(21),
      O => \prod0__283_carry__4_i_3_n_0\
    );
\prod0__283_carry__4_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__5_n_7\,
      I1 => Q(19),
      I2 => Q(20),
      O => \prod0__283_carry__4_i_4_n_0\
    );
\prod0__283_carry__4_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__6_n_7\,
      I1 => Q(23),
      I2 => Q(24),
      I3 => \prod0__283_carry__4_i_1_n_0\,
      O => \prod0__283_carry__4_i_5_n_0\
    );
\prod0__283_carry__4_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__5_n_4\,
      I1 => Q(22),
      I2 => Q(23),
      I3 => \prod0__283_carry__4_i_2_n_0\,
      O => \prod0__283_carry__4_i_6_n_0\
    );
\prod0__283_carry__4_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__5_n_5\,
      I1 => Q(21),
      I2 => Q(22),
      I3 => \prod0__283_carry__4_i_3_n_0\,
      O => \prod0__283_carry__4_i_7_n_0\
    );
\prod0__283_carry__4_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__5_n_6\,
      I1 => Q(20),
      I2 => Q(21),
      I3 => \prod0__283_carry__4_i_4_n_0\,
      O => \prod0__283_carry__4_i_8_n_0\
    );
\prod0__283_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__4_n_0\,
      CO(3) => \prod0__283_carry__5_n_0\,
      CO(2) => \prod0__283_carry__5_n_1\,
      CO(1) => \prod0__283_carry__5_n_2\,
      CO(0) => \prod0__283_carry__5_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__5_i_1_n_0\,
      DI(2) => \prod0__283_carry__5_i_2_n_0\,
      DI(1) => \prod0__283_carry__5_i_3_n_0\,
      DI(0) => \prod0__283_carry__5_i_4_n_0\,
      O(3) => \prod0__283_carry__5_n_4\,
      O(2) => \prod0__283_carry__5_n_5\,
      O(1) => \prod0__283_carry__5_n_6\,
      O(0) => \prod0__283_carry__5_n_7\,
      S(3) => \prod0__283_carry__5_i_5_n_0\,
      S(2) => \prod0__283_carry__5_i_6_n_0\,
      S(1) => \prod0__283_carry__5_i_7_n_0\,
      S(0) => \prod0__283_carry__5_i_8_n_0\
    );
\prod0__283_carry__5_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__6_n_4\,
      I1 => Q(26),
      I2 => Q(27),
      O => \prod0__283_carry__5_i_1_n_0\
    );
\prod0__283_carry__5_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__6_n_5\,
      I1 => Q(25),
      I2 => Q(26),
      O => \prod0__283_carry__5_i_2_n_0\
    );
\prod0__283_carry__5_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__6_n_6\,
      I1 => Q(24),
      I2 => Q(25),
      O => \prod0__283_carry__5_i_3_n_0\
    );
\prod0__283_carry__5_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__6_n_7\,
      I1 => Q(23),
      I2 => Q(24),
      O => \prod0__283_carry__5_i_4_n_0\
    );
\prod0__283_carry__5_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__7_n_7\,
      I1 => Q(27),
      I2 => Q(28),
      I3 => \prod0__283_carry__5_i_1_n_0\,
      O => \prod0__283_carry__5_i_5_n_0\
    );
\prod0__283_carry__5_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__6_n_4\,
      I1 => Q(26),
      I2 => Q(27),
      I3 => \prod0__283_carry__5_i_2_n_0\,
      O => \prod0__283_carry__5_i_6_n_0\
    );
\prod0__283_carry__5_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__6_n_5\,
      I1 => Q(25),
      I2 => Q(26),
      I3 => \prod0__283_carry__5_i_3_n_0\,
      O => \prod0__283_carry__5_i_7_n_0\
    );
\prod0__283_carry__5_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__6_n_6\,
      I1 => Q(24),
      I2 => Q(25),
      I3 => \prod0__283_carry__5_i_4_n_0\,
      O => \prod0__283_carry__5_i_8_n_0\
    );
\prod0__283_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__5_n_0\,
      CO(3) => \prod0__283_carry__6_n_0\,
      CO(2) => \prod0__283_carry__6_n_1\,
      CO(1) => \prod0__283_carry__6_n_2\,
      CO(0) => \prod0__283_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__283_carry__6_i_1_n_0\,
      DI(2) => \prod0__283_carry__6_i_2_n_0\,
      DI(1) => \prod0__283_carry__6_i_3_n_0\,
      DI(0) => \prod0__283_carry__6_i_4_n_0\,
      O(3) => \prod0__283_carry__6_n_4\,
      O(2) => \prod0__283_carry__6_n_5\,
      O(1) => \prod0__283_carry__6_n_6\,
      O(0) => \prod0__283_carry__6_n_7\,
      S(3) => \prod0__283_carry__6_i_5_n_0\,
      S(2) => \prod0__283_carry__6_i_6_n_0\,
      S(1) => \prod0__283_carry__6_i_7_n_0\,
      S(0) => \prod0__283_carry__6_i_8_n_0\
    );
\prod0__283_carry__6_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"D4"
    )
        port map (
      I0 => \prod0_carry__7_n_0\,
      I1 => Q(30),
      I2 => \prod0__70_carry_n_4\,
      O => \prod0__283_carry__6_i_1_n_0\
    );
\prod0__283_carry__6_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__7_n_5\,
      I1 => Q(29),
      I2 => \prod0__70_carry_n_5\,
      O => \prod0__283_carry__6_i_2_n_0\
    );
\prod0__283_carry__6_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__7_n_6\,
      I1 => \prod0__70_carry_n_7\,
      I2 => \prod0__70_carry_n_6\,
      O => \prod0__283_carry__6_i_3_n_0\
    );
\prod0__283_carry__6_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__7_n_7\,
      I1 => Q(27),
      I2 => Q(28),
      O => \prod0__283_carry__6_i_4_n_0\
    );
\prod0__283_carry__6_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7E81817E"
    )
        port map (
      I0 => \prod0__70_carry_n_4\,
      I1 => Q(30),
      I2 => \prod0_carry__7_n_0\,
      I3 => \prod0__283_carry__6_i_9_n_3\,
      I4 => Q(31),
      O => \prod0__283_carry__6_i_5_n_0\
    );
\prod0__283_carry__6_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E81717E817E8E817"
    )
        port map (
      I0 => \prod0__70_carry_n_5\,
      I1 => Q(29),
      I2 => \prod0_carry__7_n_5\,
      I3 => \prod0_carry__7_n_0\,
      I4 => \prod0__70_carry_n_4\,
      I5 => Q(30),
      O => \prod0__283_carry__6_i_6_n_0\
    );
\prod0__283_carry__6_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0__283_carry__6_i_3_n_0\,
      I1 => \prod0__70_carry_n_5\,
      I2 => Q(29),
      I3 => \prod0_carry__7_n_5\,
      O => \prod0__283_carry__6_i_7_n_0\
    );
\prod0__283_carry__6_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__7_n_6\,
      I1 => \prod0__70_carry_n_7\,
      I2 => \prod0__70_carry_n_6\,
      I3 => \prod0__283_carry__6_i_4_n_0\,
      O => \prod0__283_carry__6_i_8_n_0\
    );
\prod0__283_carry__6_i_9\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__70_carry_n_0\,
      CO(3 downto 1) => \NLW_prod0__283_carry__6_i_9_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \prod0__283_carry__6_i_9_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_prod0__283_carry__6_i_9_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => B"0001"
    );
\prod0__283_carry__7\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__283_carry__6_n_0\,
      CO(3 downto 2) => \NLW_prod0__283_carry__7_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \prod0__283_carry__7_n_2\,
      CO(0) => \NLW_prod0__283_carry__7_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \prod0_carry__7_n_0\,
      O(3 downto 1) => \NLW_prod0__283_carry__7_O_UNCONNECTED\(3 downto 1),
      O(0) => \prod0__283_carry__7_n_7\,
      S(3 downto 1) => B"001",
      S(0) => \prod0__283_carry__7_i_1_n_0\
    );
\prod0__283_carry__7_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"DB"
    )
        port map (
      I0 => \prod0__283_carry__6_i_9_n_3\,
      I1 => Q(31),
      I2 => \prod0_carry__7_n_0\,
      O => \prod0__283_carry__7_i_1_n_0\
    );
\prod0__283_carry_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__0_n_4\,
      I1 => Q(2),
      I2 => Q(3),
      O => \prod0__283_carry_i_1_n_0\
    );
\prod0__283_carry_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__0_n_5\,
      I1 => Q(1),
      I2 => Q(2),
      O => \prod0__283_carry_i_2_n_0\
    );
\prod0__283_carry_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0_carry__0_n_6\,
      I1 => Q(0),
      I2 => Q(1),
      O => \prod0__283_carry_i_3_n_0\
    );
\prod0__283_carry_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(0),
      I1 => \prod0_carry__0_n_7\,
      O => \prod0__283_carry_i_4_n_0\
    );
\prod0__283_carry_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__1_n_7\,
      I1 => Q(3),
      I2 => Q(4),
      I3 => \prod0__283_carry_i_1_n_0\,
      O => \prod0__283_carry_i_5_n_0\
    );
\prod0__283_carry_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__0_n_4\,
      I1 => Q(2),
      I2 => Q(3),
      I3 => \prod0__283_carry_i_2_n_0\,
      O => \prod0__283_carry_i_6_n_0\
    );
\prod0__283_carry_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__0_n_5\,
      I1 => Q(1),
      I2 => Q(2),
      I3 => \prod0__283_carry_i_3_n_0\,
      O => \prod0__283_carry_i_7_n_0\
    );
\prod0__283_carry_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0_carry__0_n_6\,
      I1 => Q(0),
      I2 => Q(1),
      I3 => \prod0__283_carry_i_4_n_0\,
      O => \prod0__283_carry_i_8_n_0\
    );
\prod0__379_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__379_carry_n_0\,
      CO(2) => \prod0__379_carry_n_1\,
      CO(1) => \prod0__379_carry_n_2\,
      CO(0) => \prod0__379_carry_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry_i_1_n_0\,
      DI(2) => \prod0__379_carry_i_2_n_0\,
      DI(1) => \prod0__379_carry_i_3_n_0\,
      DI(0) => \prod0__379_carry_i_4_n_0\,
      O(3 downto 0) => \NLW_prod0__379_carry_O_UNCONNECTED\(3 downto 0),
      S(3) => \prod0__379_carry_i_5_n_0\,
      S(2) => \prod0__379_carry_i_6_n_0\,
      S(1) => \prod0__379_carry_i_7_n_0\,
      S(0) => \prod0__379_carry_i_8_n_0\
    );
\prod0__379_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry_n_0\,
      CO(3) => \prod0__379_carry__0_n_0\,
      CO(2) => \prod0__379_carry__0_n_1\,
      CO(1) => \prod0__379_carry__0_n_2\,
      CO(0) => \prod0__379_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__0_i_1_n_0\,
      DI(2) => \prod0__379_carry__0_i_2_n_0\,
      DI(1) => \prod0__379_carry__0_i_3_n_0\,
      DI(0) => \prod0__379_carry__0_i_4_n_0\,
      O(3) => \prod0__379_carry__0_n_4\,
      O(2) => \prod0__379_carry__0_n_5\,
      O(1 downto 0) => \NLW_prod0__379_carry__0_O_UNCONNECTED\(1 downto 0),
      S(3) => \prod0__379_carry__0_i_5_n_0\,
      S(2) => \prod0__379_carry__0_i_6_n_0\,
      S(1) => \prod0__379_carry__0_i_7_n_0\,
      S(0) => \prod0__379_carry__0_i_8_n_0\
    );
\prod0__379_carry__0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(0),
      I1 => \prod0__283_carry__1_n_6\,
      I2 => \prod0__179_carry_n_5\,
      I3 => \prod0__81_carry__0_n_4\,
      I4 => \prod0__379_carry__0_i_9_n_0\,
      O => \prod0__379_carry__0_i_1_n_0\
    );
\prod0__379_carry__0_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__0_n_7\,
      I1 => \prod0__283_carry__1_n_4\,
      I2 => Q(2),
      O => \prod0__379_carry__0_i_10_n_0\
    );
\prod0__379_carry__0_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry_n_5\,
      I1 => \prod0__283_carry__1_n_6\,
      I2 => Q(0),
      O => \prod0__379_carry__0_i_11_n_0\
    );
\prod0__379_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F88080F880F8F880"
    )
        port map (
      I0 => \prod0__179_carry_n_6\,
      I1 => \prod0__283_carry__1_n_7\,
      I2 => \prod0__81_carry__0_n_5\,
      I3 => \prod0__179_carry_n_5\,
      I4 => \prod0__283_carry__1_n_6\,
      I5 => Q(0),
      O => \prod0__379_carry__0_i_2_n_0\
    );
\prod0__379_carry__0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80F8F880"
    )
        port map (
      I0 => Q(0),
      I1 => \prod0__283_carry__0_n_4\,
      I2 => \prod0__81_carry__0_n_6\,
      I3 => \prod0__179_carry_n_6\,
      I4 => \prod0__283_carry__1_n_7\,
      O => \prod0__379_carry__0_i_3_n_0\
    );
\prod0__379_carry__0_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"28"
    )
        port map (
      I0 => \prod0__81_carry__0_n_7\,
      I1 => \prod0__283_carry__0_n_4\,
      I2 => Q(0),
      O => \prod0__379_carry__0_i_4_n_0\
    );
\prod0__379_carry__0_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__0_i_1_n_0\,
      I1 => \prod0__379_carry__0_i_10_n_0\,
      I2 => \prod0__81_carry__1_n_7\,
      I3 => \prod0__179_carry_n_4\,
      I4 => \prod0__283_carry__1_n_5\,
      I5 => Q(1),
      O => \prod0__379_carry__0_i_5_n_0\
    );
\prod0__379_carry__0_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__0_i_2_n_0\,
      I1 => \prod0__379_carry__0_i_9_n_0\,
      I2 => \prod0__81_carry__0_n_4\,
      I3 => \prod0__179_carry_n_5\,
      I4 => \prod0__283_carry__1_n_6\,
      I5 => Q(0),
      O => \prod0__379_carry__0_i_6_n_0\
    );
\prod0__379_carry__0_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969696"
    )
        port map (
      I0 => \prod0__379_carry__0_i_3_n_0\,
      I1 => \prod0__379_carry__0_i_11_n_0\,
      I2 => \prod0__81_carry__0_n_5\,
      I3 => \prod0__283_carry__1_n_7\,
      I4 => \prod0__179_carry_n_6\,
      O => \prod0__379_carry__0_i_7_n_0\
    );
\prod0__379_carry__0_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669966996"
    )
        port map (
      I0 => \prod0__379_carry__0_i_4_n_0\,
      I1 => \prod0__283_carry__1_n_7\,
      I2 => \prod0__179_carry_n_6\,
      I3 => \prod0__81_carry__0_n_6\,
      I4 => \prod0__283_carry__0_n_4\,
      I5 => Q(0),
      O => \prod0__379_carry__0_i_8_n_0\
    );
\prod0__379_carry__0_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry_n_4\,
      I1 => \prod0__283_carry__1_n_5\,
      I2 => Q(1),
      O => \prod0__379_carry__0_i_9_n_0\
    );
\prod0__379_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__0_n_0\,
      CO(3) => \prod0__379_carry__1_n_0\,
      CO(2) => \prod0__379_carry__1_n_1\,
      CO(1) => \prod0__379_carry__1_n_2\,
      CO(0) => \prod0__379_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__1_i_1_n_0\,
      DI(2) => \prod0__379_carry__1_i_2_n_0\,
      DI(1) => \prod0__379_carry__1_i_3_n_0\,
      DI(0) => \prod0__379_carry__1_i_4_n_0\,
      O(3) => \prod0__379_carry__1_n_4\,
      O(2) => \prod0__379_carry__1_n_5\,
      O(1) => \prod0__379_carry__1_n_6\,
      O(0) => \prod0__379_carry__1_n_7\,
      S(3) => \prod0__379_carry__1_i_5_n_0\,
      S(2) => \prod0__379_carry__1_i_6_n_0\,
      S(1) => \prod0__379_carry__1_i_7_n_0\,
      S(0) => \prod0__379_carry__1_i_8_n_0\
    );
\prod0__379_carry__1_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(4),
      I1 => \prod0__283_carry__2_n_6\,
      I2 => \prod0__179_carry__0_n_5\,
      I3 => \prod0__81_carry__1_n_4\,
      I4 => \prod0__379_carry__1_i_9_n_0\,
      O => \prod0__379_carry__1_i_1_n_0\
    );
\prod0__379_carry__1_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__0_n_5\,
      I1 => \prod0__283_carry__2_n_6\,
      I2 => Q(4),
      O => \prod0__379_carry__1_i_10_n_0\
    );
\prod0__379_carry__1_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__0_n_6\,
      I1 => \prod0__283_carry__2_n_7\,
      I2 => Q(3),
      O => \prod0__379_carry__1_i_11_n_0\
    );
\prod0__379_carry__1_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__1_n_7\,
      I1 => \prod0__283_carry__2_n_4\,
      I2 => Q(6),
      O => \prod0__379_carry__1_i_12_n_0\
    );
\prod0__379_carry__1_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(3),
      I1 => \prod0__283_carry__2_n_7\,
      I2 => \prod0__179_carry__0_n_6\,
      I3 => \prod0__81_carry__1_n_5\,
      I4 => \prod0__379_carry__1_i_10_n_0\,
      O => \prod0__379_carry__1_i_2_n_0\
    );
\prod0__379_carry__1_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(2),
      I1 => \prod0__283_carry__1_n_4\,
      I2 => \prod0__179_carry__0_n_7\,
      I3 => \prod0__81_carry__1_n_6\,
      I4 => \prod0__379_carry__1_i_11_n_0\,
      O => \prod0__379_carry__1_i_3_n_0\
    );
\prod0__379_carry__1_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(1),
      I1 => \prod0__283_carry__1_n_5\,
      I2 => \prod0__179_carry_n_4\,
      I3 => \prod0__81_carry__1_n_7\,
      I4 => \prod0__379_carry__0_i_10_n_0\,
      O => \prod0__379_carry__1_i_4_n_0\
    );
\prod0__379_carry__1_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__1_i_1_n_0\,
      I1 => \prod0__379_carry__1_i_12_n_0\,
      I2 => \prod0__81_carry__2_n_7\,
      I3 => \prod0__179_carry__0_n_4\,
      I4 => \prod0__283_carry__2_n_5\,
      I5 => Q(5),
      O => \prod0__379_carry__1_i_5_n_0\
    );
\prod0__379_carry__1_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__1_i_2_n_0\,
      I1 => \prod0__379_carry__1_i_9_n_0\,
      I2 => \prod0__81_carry__1_n_4\,
      I3 => \prod0__179_carry__0_n_5\,
      I4 => \prod0__283_carry__2_n_6\,
      I5 => Q(4),
      O => \prod0__379_carry__1_i_6_n_0\
    );
\prod0__379_carry__1_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__1_i_3_n_0\,
      I1 => \prod0__379_carry__1_i_10_n_0\,
      I2 => \prod0__81_carry__1_n_5\,
      I3 => \prod0__179_carry__0_n_6\,
      I4 => \prod0__283_carry__2_n_7\,
      I5 => Q(3),
      O => \prod0__379_carry__1_i_7_n_0\
    );
\prod0__379_carry__1_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__1_i_4_n_0\,
      I1 => \prod0__379_carry__1_i_11_n_0\,
      I2 => \prod0__81_carry__1_n_6\,
      I3 => \prod0__179_carry__0_n_7\,
      I4 => \prod0__283_carry__1_n_4\,
      I5 => Q(2),
      O => \prod0__379_carry__1_i_8_n_0\
    );
\prod0__379_carry__1_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__0_n_4\,
      I1 => \prod0__283_carry__2_n_5\,
      I2 => Q(5),
      O => \prod0__379_carry__1_i_9_n_0\
    );
\prod0__379_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__1_n_0\,
      CO(3) => \prod0__379_carry__2_n_0\,
      CO(2) => \prod0__379_carry__2_n_1\,
      CO(1) => \prod0__379_carry__2_n_2\,
      CO(0) => \prod0__379_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__2_i_1_n_0\,
      DI(2) => \prod0__379_carry__2_i_2_n_0\,
      DI(1) => \prod0__379_carry__2_i_3_n_0\,
      DI(0) => \prod0__379_carry__2_i_4_n_0\,
      O(3) => \prod0__379_carry__2_n_4\,
      O(2) => \prod0__379_carry__2_n_5\,
      O(1) => \prod0__379_carry__2_n_6\,
      O(0) => \prod0__379_carry__2_n_7\,
      S(3) => \prod0__379_carry__2_i_5_n_0\,
      S(2) => \prod0__379_carry__2_i_6_n_0\,
      S(1) => \prod0__379_carry__2_i_7_n_0\,
      S(0) => \prod0__379_carry__2_i_8_n_0\
    );
\prod0__379_carry__2_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(8),
      I1 => \prod0__283_carry__3_n_6\,
      I2 => \prod0__179_carry__1_n_5\,
      I3 => \prod0__81_carry__2_n_4\,
      I4 => \prod0__379_carry__2_i_9_n_0\,
      O => \prod0__379_carry__2_i_1_n_0\
    );
\prod0__379_carry__2_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__1_n_5\,
      I1 => \prod0__283_carry__3_n_6\,
      I2 => Q(8),
      O => \prod0__379_carry__2_i_10_n_0\
    );
\prod0__379_carry__2_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__1_n_6\,
      I1 => \prod0__283_carry__3_n_7\,
      I2 => Q(7),
      O => \prod0__379_carry__2_i_11_n_0\
    );
\prod0__379_carry__2_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__2_n_7\,
      I1 => \prod0__283_carry__3_n_4\,
      I2 => Q(10),
      O => \prod0__379_carry__2_i_12_n_0\
    );
\prod0__379_carry__2_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(7),
      I1 => \prod0__283_carry__3_n_7\,
      I2 => \prod0__179_carry__1_n_6\,
      I3 => \prod0__81_carry__2_n_5\,
      I4 => \prod0__379_carry__2_i_10_n_0\,
      O => \prod0__379_carry__2_i_2_n_0\
    );
\prod0__379_carry__2_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(6),
      I1 => \prod0__283_carry__2_n_4\,
      I2 => \prod0__179_carry__1_n_7\,
      I3 => \prod0__81_carry__2_n_6\,
      I4 => \prod0__379_carry__2_i_11_n_0\,
      O => \prod0__379_carry__2_i_3_n_0\
    );
\prod0__379_carry__2_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(5),
      I1 => \prod0__283_carry__2_n_5\,
      I2 => \prod0__179_carry__0_n_4\,
      I3 => \prod0__81_carry__2_n_7\,
      I4 => \prod0__379_carry__1_i_12_n_0\,
      O => \prod0__379_carry__2_i_4_n_0\
    );
\prod0__379_carry__2_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__2_i_1_n_0\,
      I1 => \prod0__379_carry__2_i_12_n_0\,
      I2 => \prod0__81_carry__3_n_7\,
      I3 => \prod0__179_carry__1_n_4\,
      I4 => \prod0__283_carry__3_n_5\,
      I5 => Q(9),
      O => \prod0__379_carry__2_i_5_n_0\
    );
\prod0__379_carry__2_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__2_i_2_n_0\,
      I1 => \prod0__379_carry__2_i_9_n_0\,
      I2 => \prod0__81_carry__2_n_4\,
      I3 => \prod0__179_carry__1_n_5\,
      I4 => \prod0__283_carry__3_n_6\,
      I5 => Q(8),
      O => \prod0__379_carry__2_i_6_n_0\
    );
\prod0__379_carry__2_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__2_i_3_n_0\,
      I1 => \prod0__379_carry__2_i_10_n_0\,
      I2 => \prod0__81_carry__2_n_5\,
      I3 => \prod0__179_carry__1_n_6\,
      I4 => \prod0__283_carry__3_n_7\,
      I5 => Q(7),
      O => \prod0__379_carry__2_i_7_n_0\
    );
\prod0__379_carry__2_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__2_i_4_n_0\,
      I1 => \prod0__379_carry__2_i_11_n_0\,
      I2 => \prod0__81_carry__2_n_6\,
      I3 => \prod0__179_carry__1_n_7\,
      I4 => \prod0__283_carry__2_n_4\,
      I5 => Q(6),
      O => \prod0__379_carry__2_i_8_n_0\
    );
\prod0__379_carry__2_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__1_n_4\,
      I1 => \prod0__283_carry__3_n_5\,
      I2 => Q(9),
      O => \prod0__379_carry__2_i_9_n_0\
    );
\prod0__379_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__2_n_0\,
      CO(3) => \prod0__379_carry__3_n_0\,
      CO(2) => \prod0__379_carry__3_n_1\,
      CO(1) => \prod0__379_carry__3_n_2\,
      CO(0) => \prod0__379_carry__3_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__3_i_1_n_0\,
      DI(2) => \prod0__379_carry__3_i_2_n_0\,
      DI(1) => \prod0__379_carry__3_i_3_n_0\,
      DI(0) => \prod0__379_carry__3_i_4_n_0\,
      O(3) => \prod0__379_carry__3_n_4\,
      O(2) => \prod0__379_carry__3_n_5\,
      O(1) => \prod0__379_carry__3_n_6\,
      O(0) => \prod0__379_carry__3_n_7\,
      S(3) => \prod0__379_carry__3_i_5_n_0\,
      S(2) => \prod0__379_carry__3_i_6_n_0\,
      S(1) => \prod0__379_carry__3_i_7_n_0\,
      S(0) => \prod0__379_carry__3_i_8_n_0\
    );
\prod0__379_carry__3_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(12),
      I1 => \prod0__283_carry__4_n_6\,
      I2 => \prod0__179_carry__2_n_5\,
      I3 => \prod0__81_carry__3_n_4\,
      I4 => \prod0__379_carry__3_i_9_n_0\,
      O => \prod0__379_carry__3_i_1_n_0\
    );
\prod0__379_carry__3_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__2_n_5\,
      I1 => \prod0__283_carry__4_n_6\,
      I2 => Q(12),
      O => \prod0__379_carry__3_i_10_n_0\
    );
\prod0__379_carry__3_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__2_n_6\,
      I1 => \prod0__283_carry__4_n_7\,
      I2 => Q(11),
      O => \prod0__379_carry__3_i_11_n_0\
    );
\prod0__379_carry__3_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__3_n_7\,
      I1 => \prod0__283_carry__4_n_4\,
      I2 => Q(14),
      O => \prod0__379_carry__3_i_12_n_0\
    );
\prod0__379_carry__3_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(11),
      I1 => \prod0__283_carry__4_n_7\,
      I2 => \prod0__179_carry__2_n_6\,
      I3 => \prod0__81_carry__3_n_5\,
      I4 => \prod0__379_carry__3_i_10_n_0\,
      O => \prod0__379_carry__3_i_2_n_0\
    );
\prod0__379_carry__3_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(10),
      I1 => \prod0__283_carry__3_n_4\,
      I2 => \prod0__179_carry__2_n_7\,
      I3 => \prod0__81_carry__3_n_6\,
      I4 => \prod0__379_carry__3_i_11_n_0\,
      O => \prod0__379_carry__3_i_3_n_0\
    );
\prod0__379_carry__3_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(9),
      I1 => \prod0__283_carry__3_n_5\,
      I2 => \prod0__179_carry__1_n_4\,
      I3 => \prod0__81_carry__3_n_7\,
      I4 => \prod0__379_carry__2_i_12_n_0\,
      O => \prod0__379_carry__3_i_4_n_0\
    );
\prod0__379_carry__3_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__3_i_1_n_0\,
      I1 => \prod0__379_carry__3_i_12_n_0\,
      I2 => \prod0__81_carry__4_n_7\,
      I3 => \prod0__179_carry__2_n_4\,
      I4 => \prod0__283_carry__4_n_5\,
      I5 => Q(13),
      O => \prod0__379_carry__3_i_5_n_0\
    );
\prod0__379_carry__3_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__3_i_2_n_0\,
      I1 => \prod0__379_carry__3_i_9_n_0\,
      I2 => \prod0__81_carry__3_n_4\,
      I3 => \prod0__179_carry__2_n_5\,
      I4 => \prod0__283_carry__4_n_6\,
      I5 => Q(12),
      O => \prod0__379_carry__3_i_6_n_0\
    );
\prod0__379_carry__3_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__3_i_3_n_0\,
      I1 => \prod0__379_carry__3_i_10_n_0\,
      I2 => \prod0__81_carry__3_n_5\,
      I3 => \prod0__179_carry__2_n_6\,
      I4 => \prod0__283_carry__4_n_7\,
      I5 => Q(11),
      O => \prod0__379_carry__3_i_7_n_0\
    );
\prod0__379_carry__3_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__3_i_4_n_0\,
      I1 => \prod0__379_carry__3_i_11_n_0\,
      I2 => \prod0__81_carry__3_n_6\,
      I3 => \prod0__179_carry__2_n_7\,
      I4 => \prod0__283_carry__3_n_4\,
      I5 => Q(10),
      O => \prod0__379_carry__3_i_8_n_0\
    );
\prod0__379_carry__3_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__2_n_4\,
      I1 => \prod0__283_carry__4_n_5\,
      I2 => Q(13),
      O => \prod0__379_carry__3_i_9_n_0\
    );
\prod0__379_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__3_n_0\,
      CO(3) => \prod0__379_carry__4_n_0\,
      CO(2) => \prod0__379_carry__4_n_1\,
      CO(1) => \prod0__379_carry__4_n_2\,
      CO(0) => \prod0__379_carry__4_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__4_i_1_n_0\,
      DI(2) => \prod0__379_carry__4_i_2_n_0\,
      DI(1) => \prod0__379_carry__4_i_3_n_0\,
      DI(0) => \prod0__379_carry__4_i_4_n_0\,
      O(3) => \prod0__379_carry__4_n_4\,
      O(2) => \prod0__379_carry__4_n_5\,
      O(1) => \prod0__379_carry__4_n_6\,
      O(0) => \prod0__379_carry__4_n_7\,
      S(3) => \prod0__379_carry__4_i_5_n_0\,
      S(2) => \prod0__379_carry__4_i_6_n_0\,
      S(1) => \prod0__379_carry__4_i_7_n_0\,
      S(0) => \prod0__379_carry__4_i_8_n_0\
    );
\prod0__379_carry__4_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry_n_6\,
      I1 => \prod0__283_carry__5_n_6\,
      I2 => \prod0__179_carry__3_n_5\,
      I3 => \prod0__81_carry__4_n_4\,
      I4 => \prod0__379_carry__4_i_9_n_0\,
      O => \prod0__379_carry__4_i_1_n_0\
    );
\prod0__379_carry__4_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__3_n_5\,
      I1 => \prod0__283_carry__5_n_6\,
      I2 => \prod0__249_carry_n_6\,
      O => \prod0__379_carry__4_i_10_n_0\
    );
\prod0__379_carry__4_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__3_n_6\,
      I1 => \prod0__283_carry__5_n_7\,
      I2 => \prod0__249_carry_n_7\,
      O => \prod0__379_carry__4_i_11_n_0\
    );
\prod0__379_carry__4_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__4_n_7\,
      I1 => \prod0__283_carry__5_n_4\,
      I2 => \prod0__249_carry_n_4\,
      O => \prod0__379_carry__4_i_12_n_0\
    );
\prod0__379_carry__4_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry_n_7\,
      I1 => \prod0__283_carry__5_n_7\,
      I2 => \prod0__179_carry__3_n_6\,
      I3 => \prod0__81_carry__4_n_5\,
      I4 => \prod0__379_carry__4_i_10_n_0\,
      O => \prod0__379_carry__4_i_2_n_0\
    );
\prod0__379_carry__4_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(14),
      I1 => \prod0__283_carry__4_n_4\,
      I2 => \prod0__179_carry__3_n_7\,
      I3 => \prod0__81_carry__4_n_6\,
      I4 => \prod0__379_carry__4_i_11_n_0\,
      O => \prod0__379_carry__4_i_3_n_0\
    );
\prod0__379_carry__4_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => Q(13),
      I1 => \prod0__283_carry__4_n_5\,
      I2 => \prod0__179_carry__2_n_4\,
      I3 => \prod0__81_carry__4_n_7\,
      I4 => \prod0__379_carry__3_i_12_n_0\,
      O => \prod0__379_carry__4_i_4_n_0\
    );
\prod0__379_carry__4_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__4_i_1_n_0\,
      I1 => \prod0__379_carry__4_i_12_n_0\,
      I2 => \prod0__81_carry__5_n_7\,
      I3 => \prod0__179_carry__3_n_4\,
      I4 => \prod0__283_carry__5_n_5\,
      I5 => \prod0__249_carry_n_5\,
      O => \prod0__379_carry__4_i_5_n_0\
    );
\prod0__379_carry__4_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__4_i_2_n_0\,
      I1 => \prod0__379_carry__4_i_9_n_0\,
      I2 => \prod0__81_carry__4_n_4\,
      I3 => \prod0__179_carry__3_n_5\,
      I4 => \prod0__283_carry__5_n_6\,
      I5 => \prod0__249_carry_n_6\,
      O => \prod0__379_carry__4_i_6_n_0\
    );
\prod0__379_carry__4_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__4_i_3_n_0\,
      I1 => \prod0__379_carry__4_i_10_n_0\,
      I2 => \prod0__81_carry__4_n_5\,
      I3 => \prod0__179_carry__3_n_6\,
      I4 => \prod0__283_carry__5_n_7\,
      I5 => \prod0__249_carry_n_7\,
      O => \prod0__379_carry__4_i_7_n_0\
    );
\prod0__379_carry__4_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__4_i_4_n_0\,
      I1 => \prod0__379_carry__4_i_11_n_0\,
      I2 => \prod0__81_carry__4_n_6\,
      I3 => \prod0__179_carry__3_n_7\,
      I4 => \prod0__283_carry__4_n_4\,
      I5 => Q(14),
      O => \prod0__379_carry__4_i_8_n_0\
    );
\prod0__379_carry__4_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__3_n_4\,
      I1 => \prod0__283_carry__5_n_5\,
      I2 => \prod0__249_carry_n_5\,
      O => \prod0__379_carry__4_i_9_n_0\
    );
\prod0__379_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__4_n_0\,
      CO(3) => \prod0__379_carry__5_n_0\,
      CO(2) => \prod0__379_carry__5_n_1\,
      CO(1) => \prod0__379_carry__5_n_2\,
      CO(0) => \prod0__379_carry__5_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__5_i_1_n_0\,
      DI(2) => \prod0__379_carry__5_i_2_n_0\,
      DI(1) => \prod0__379_carry__5_i_3_n_0\,
      DI(0) => \prod0__379_carry__5_i_4_n_0\,
      O(3) => \prod0__379_carry__5_n_4\,
      O(2) => \prod0__379_carry__5_n_5\,
      O(1) => \prod0__379_carry__5_n_6\,
      O(0) => \prod0__379_carry__5_n_7\,
      S(3) => \prod0__379_carry__5_i_5_n_0\,
      S(2) => \prod0__379_carry__5_i_6_n_0\,
      S(1) => \prod0__379_carry__5_i_7_n_0\,
      S(0) => \prod0__379_carry__5_i_8_n_0\
    );
\prod0__379_carry__5_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__0_n_6\,
      I1 => \prod0__283_carry__6_n_6\,
      I2 => \prod0__179_carry__4_n_5\,
      I3 => \prod0__81_carry__5_n_4\,
      I4 => \prod0__379_carry__5_i_9_n_0\,
      O => \prod0__379_carry__5_i_1_n_0\
    );
\prod0__379_carry__5_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__4_n_5\,
      I1 => \prod0__283_carry__6_n_6\,
      I2 => \prod0__249_carry__0_n_6\,
      O => \prod0__379_carry__5_i_10_n_0\
    );
\prod0__379_carry__5_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__4_n_6\,
      I1 => \prod0__283_carry__6_n_7\,
      I2 => \prod0__249_carry__0_n_7\,
      O => \prod0__379_carry__5_i_11_n_0\
    );
\prod0__379_carry__5_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__5_n_7\,
      I1 => \prod0__283_carry__6_n_4\,
      I2 => \prod0__249_carry__0_n_4\,
      O => \prod0__379_carry__5_i_12_n_0\
    );
\prod0__379_carry__5_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__0_n_7\,
      I1 => \prod0__283_carry__6_n_7\,
      I2 => \prod0__179_carry__4_n_6\,
      I3 => \prod0__81_carry__5_n_5\,
      I4 => \prod0__379_carry__5_i_10_n_0\,
      O => \prod0__379_carry__5_i_2_n_0\
    );
\prod0__379_carry__5_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry_n_4\,
      I1 => \prod0__283_carry__5_n_4\,
      I2 => \prod0__179_carry__4_n_7\,
      I3 => \prod0__81_carry__5_n_6\,
      I4 => \prod0__379_carry__5_i_11_n_0\,
      O => \prod0__379_carry__5_i_3_n_0\
    );
\prod0__379_carry__5_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry_n_5\,
      I1 => \prod0__283_carry__5_n_5\,
      I2 => \prod0__179_carry__3_n_4\,
      I3 => \prod0__81_carry__5_n_7\,
      I4 => \prod0__379_carry__4_i_12_n_0\,
      O => \prod0__379_carry__5_i_4_n_0\
    );
\prod0__379_carry__5_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__5_i_1_n_0\,
      I1 => \prod0__379_carry__5_i_12_n_0\,
      I2 => \prod0__81_carry__6_n_7\,
      I3 => \prod0__179_carry__4_n_4\,
      I4 => \prod0__283_carry__6_n_5\,
      I5 => \prod0__249_carry__0_n_5\,
      O => \prod0__379_carry__5_i_5_n_0\
    );
\prod0__379_carry__5_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__5_i_2_n_0\,
      I1 => \prod0__379_carry__5_i_9_n_0\,
      I2 => \prod0__81_carry__5_n_4\,
      I3 => \prod0__179_carry__4_n_5\,
      I4 => \prod0__283_carry__6_n_6\,
      I5 => \prod0__249_carry__0_n_6\,
      O => \prod0__379_carry__5_i_6_n_0\
    );
\prod0__379_carry__5_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__5_i_3_n_0\,
      I1 => \prod0__379_carry__5_i_10_n_0\,
      I2 => \prod0__81_carry__5_n_5\,
      I3 => \prod0__179_carry__4_n_6\,
      I4 => \prod0__283_carry__6_n_7\,
      I5 => \prod0__249_carry__0_n_7\,
      O => \prod0__379_carry__5_i_7_n_0\
    );
\prod0__379_carry__5_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__5_i_4_n_0\,
      I1 => \prod0__379_carry__5_i_11_n_0\,
      I2 => \prod0__81_carry__5_n_6\,
      I3 => \prod0__179_carry__4_n_7\,
      I4 => \prod0__283_carry__5_n_4\,
      I5 => \prod0__249_carry_n_4\,
      O => \prod0__379_carry__5_i_8_n_0\
    );
\prod0__379_carry__5_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__4_n_4\,
      I1 => \prod0__283_carry__6_n_5\,
      I2 => \prod0__249_carry__0_n_5\,
      O => \prod0__379_carry__5_i_9_n_0\
    );
\prod0__379_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__5_n_0\,
      CO(3) => \prod0__379_carry__6_n_0\,
      CO(2) => \prod0__379_carry__6_n_1\,
      CO(1) => \prod0__379_carry__6_n_2\,
      CO(0) => \prod0__379_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__6_i_1_n_0\,
      DI(2) => \prod0__379_carry__6_i_2_n_0\,
      DI(1) => \prod0__379_carry__6_i_3_n_0\,
      DI(0) => \prod0__379_carry__6_i_4_n_0\,
      O(3) => \prod0__379_carry__6_n_4\,
      O(2) => \prod0__379_carry__6_n_5\,
      O(1) => \prod0__379_carry__6_n_6\,
      O(0) => \prod0__379_carry__6_n_7\,
      S(3) => \prod0__379_carry__6_i_5_n_0\,
      S(2) => \prod0__379_carry__6_i_6_n_0\,
      S(1) => \prod0__379_carry__6_i_7_n_0\,
      S(0) => \prod0__379_carry__6_i_8_n_0\
    );
\prod0__379_carry__6_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F880E0FE80F8FEE0"
    )
        port map (
      I0 => \prod0__249_carry__1_n_6\,
      I1 => \prod0__179_carry__5_n_5\,
      I2 => \prod0__81_carry__6_n_4\,
      I3 => \prod0__179_carry__5_n_4\,
      I4 => \prod0__283_carry__7_n_2\,
      I5 => \prod0__249_carry__1_n_5\,
      O => \prod0__379_carry__6_i_1_n_0\
    );
\prod0__379_carry__6_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__5_n_6\,
      I1 => \prod0__283_carry__7_n_7\,
      I2 => \prod0__249_carry__1_n_7\,
      O => \prod0__379_carry__6_i_10_n_0\
    );
\prod0__379_carry__6_i_11\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => \prod0__179_carry__5_n_4\,
      I1 => \prod0__283_carry__7_n_2\,
      I2 => \prod0__249_carry__1_n_5\,
      O => \prod0__379_carry__6_i_11_n_0\
    );
\prod0__379_carry__6_i_12\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \prod0__179_carry__5_n_4\,
      I1 => \prod0__283_carry__7_n_2\,
      I2 => \prod0__249_carry__1_n_5\,
      O => \prod0__379_carry__6_i_12_n_0\
    );
\prod0__379_carry__6_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__1_n_7\,
      I1 => \prod0__283_carry__7_n_7\,
      I2 => \prod0__179_carry__5_n_6\,
      I3 => \prod0__81_carry__6_n_5\,
      I4 => \prod0__379_carry__6_i_9_n_0\,
      O => \prod0__379_carry__6_i_2_n_0\
    );
\prod0__379_carry__6_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__0_n_4\,
      I1 => \prod0__283_carry__6_n_4\,
      I2 => \prod0__179_carry__5_n_7\,
      I3 => \prod0__81_carry__6_n_6\,
      I4 => \prod0__379_carry__6_i_10_n_0\,
      O => \prod0__379_carry__6_i_3_n_0\
    );
\prod0__379_carry__6_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__0_n_5\,
      I1 => \prod0__283_carry__6_n_5\,
      I2 => \prod0__179_carry__4_n_4\,
      I3 => \prod0__81_carry__6_n_7\,
      I4 => \prod0__379_carry__5_i_12_n_0\,
      O => \prod0__379_carry__6_i_4_n_0\
    );
\prod0__379_carry__6_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => \prod0__379_carry__6_i_1_n_0\,
      I1 => \prod0__249_carry__1_n_4\,
      I2 => \prod0__179_carry__6_n_7\,
      I3 => \prod0__81_carry__7_n_7\,
      I4 => \prod0__379_carry__6_i_11_n_0\,
      O => \prod0__379_carry__6_i_5_n_0\
    );
\prod0__379_carry__6_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969966996699696"
    )
        port map (
      I0 => \prod0__379_carry__6_i_2_n_0\,
      I1 => \prod0__379_carry__6_i_12_n_0\,
      I2 => \prod0__81_carry__6_n_4\,
      I3 => \prod0__283_carry__7_n_2\,
      I4 => \prod0__179_carry__5_n_5\,
      I5 => \prod0__249_carry__1_n_6\,
      O => \prod0__379_carry__6_i_6_n_0\
    );
\prod0__379_carry__6_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__6_i_3_n_0\,
      I1 => \prod0__379_carry__6_i_9_n_0\,
      I2 => \prod0__81_carry__6_n_5\,
      I3 => \prod0__179_carry__5_n_6\,
      I4 => \prod0__283_carry__7_n_7\,
      I5 => \prod0__249_carry__1_n_7\,
      O => \prod0__379_carry__6_i_7_n_0\
    );
\prod0__379_carry__6_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969699669969696"
    )
        port map (
      I0 => \prod0__379_carry__6_i_4_n_0\,
      I1 => \prod0__379_carry__6_i_10_n_0\,
      I2 => \prod0__81_carry__6_n_6\,
      I3 => \prod0__179_carry__5_n_7\,
      I4 => \prod0__283_carry__6_n_4\,
      I5 => \prod0__249_carry__0_n_4\,
      O => \prod0__379_carry__6_i_8_n_0\
    );
\prod0__379_carry__6_i_9\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => \prod0__179_carry__5_n_5\,
      I1 => \prod0__283_carry__7_n_2\,
      I2 => \prod0__249_carry__1_n_6\,
      O => \prod0__379_carry__6_i_9_n_0\
    );
\prod0__379_carry__7\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__6_n_0\,
      CO(3) => \prod0__379_carry__7_n_0\,
      CO(2) => \prod0__379_carry__7_n_1\,
      CO(1) => \prod0__379_carry__7_n_2\,
      CO(0) => \prod0__379_carry__7_n_3\,
      CYINIT => '0',
      DI(3) => \prod0__379_carry__7_i_1_n_0\,
      DI(2) => \prod0__379_carry__7_i_2_n_0\,
      DI(1) => \prod0__379_carry__7_i_3_n_0\,
      DI(0) => \prod0__379_carry__7_i_4_n_0\,
      O(3) => \prod0__379_carry__7_n_4\,
      O(2) => \prod0__379_carry__7_n_5\,
      O(1) => \prod0__379_carry__7_n_6\,
      O(0) => \prod0__379_carry__7_n_7\,
      S(3) => \prod0__379_carry__7_i_5_n_0\,
      S(2) => \prod0__379_carry__7_i_6_n_0\,
      S(1) => \prod0__379_carry__7_i_7_n_0\,
      S(0) => \prod0__379_carry__7_i_8_n_0\
    );
\prod0__379_carry__7_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6000"
    )
        port map (
      I0 => \prod0__249_carry__2_n_5\,
      I1 => \prod0__179_carry__6_n_4\,
      I2 => \prod0__179_carry__6_n_5\,
      I3 => \prod0__249_carry__2_n_6\,
      O => \prod0__379_carry__7_i_1_n_0\
    );
\prod0__379_carry__7_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80F8F880"
    )
        port map (
      I0 => \prod0__179_carry__6_n_6\,
      I1 => \prod0__249_carry__2_n_7\,
      I2 => \prod0__81_carry__7_n_1\,
      I3 => \prod0__179_carry__6_n_5\,
      I4 => \prod0__249_carry__2_n_6\,
      O => \prod0__379_carry__7_i_2_n_0\
    );
\prod0__379_carry__7_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80F8F880"
    )
        port map (
      I0 => \prod0__179_carry__6_n_7\,
      I1 => \prod0__249_carry__1_n_4\,
      I2 => \prod0__81_carry__7_n_6\,
      I3 => \prod0__179_carry__6_n_6\,
      I4 => \prod0__249_carry__2_n_7\,
      O => \prod0__379_carry__7_i_3_n_0\
    );
\prod0__379_carry__7_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E800FFE8FFE8E800"
    )
        port map (
      I0 => \prod0__249_carry__1_n_5\,
      I1 => \prod0__283_carry__7_n_2\,
      I2 => \prod0__179_carry__5_n_4\,
      I3 => \prod0__81_carry__7_n_7\,
      I4 => \prod0__179_carry__6_n_7\,
      I5 => \prod0__249_carry__1_n_4\,
      O => \prod0__379_carry__7_i_4_n_0\
    );
\prod0__379_carry__7_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69999666"
    )
        port map (
      I0 => \prod0__249_carry__2_n_4\,
      I1 => \prod0__179_carry__7_n_7\,
      I2 => \prod0__179_carry__6_n_4\,
      I3 => \prod0__249_carry__2_n_5\,
      I4 => \prod0__379_carry__7_i_1_n_0\,
      O => \prod0__379_carry__7_i_5_n_0\
    );
\prod0__379_carry__7_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69999666"
    )
        port map (
      I0 => \prod0__249_carry__2_n_5\,
      I1 => \prod0__179_carry__6_n_4\,
      I2 => \prod0__179_carry__6_n_5\,
      I3 => \prod0__249_carry__2_n_6\,
      I4 => \prod0__379_carry__7_i_2_n_0\,
      O => \prod0__379_carry__7_i_6_n_0\
    );
\prod0__379_carry__7_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669966996"
    )
        port map (
      I0 => \prod0__379_carry__7_i_3_n_0\,
      I1 => \prod0__249_carry__2_n_6\,
      I2 => \prod0__179_carry__6_n_5\,
      I3 => \prod0__81_carry__7_n_1\,
      I4 => \prod0__249_carry__2_n_7\,
      I5 => \prod0__179_carry__6_n_6\,
      O => \prod0__379_carry__7_i_7_n_0\
    );
\prod0__379_carry__7_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669966996"
    )
        port map (
      I0 => \prod0__379_carry__7_i_4_n_0\,
      I1 => \prod0__249_carry__2_n_7\,
      I2 => \prod0__179_carry__6_n_6\,
      I3 => \prod0__81_carry__7_n_6\,
      I4 => \prod0__249_carry__1_n_4\,
      I5 => \prod0__179_carry__6_n_7\,
      O => \prod0__379_carry__7_i_8_n_0\
    );
\prod0__379_carry__8\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__379_carry__7_n_0\,
      CO(3 downto 1) => \NLW_prod0__379_carry__8_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \prod0__379_carry__8_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => \prod0__379_carry__8_i_1_n_0\,
      O(3 downto 2) => \NLW_prod0__379_carry__8_O_UNCONNECTED\(3 downto 2),
      O(1) => \prod0__379_carry__8_n_6\,
      O(0) => \prod0__379_carry__8_n_7\,
      S(3 downto 2) => B"00",
      S(1) => \prod0__379_carry__8_i_2_n_0\,
      S(0) => \prod0__379_carry__8_i_3_n_0\
    );
\prod0__379_carry__8_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6000"
    )
        port map (
      I0 => \prod0__249_carry__2_n_4\,
      I1 => \prod0__179_carry__7_n_7\,
      I2 => \prod0__179_carry__6_n_4\,
      I3 => \prod0__249_carry__2_n_5\,
      O => \prod0__379_carry__8_i_1_n_0\
    );
\prod0__379_carry__8_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0FF078877887F00F"
    )
        port map (
      I0 => \prod0__249_carry__2_n_4\,
      I1 => \prod0__179_carry__7_n_7\,
      I2 => \prod0__179_carry__7_n_5\,
      I3 => \prod0__249_carry__3_n_2\,
      I4 => \prod0__249_carry__3_n_7\,
      I5 => \prod0__179_carry__7_n_6\,
      O => \prod0__379_carry__8_i_2_n_0\
    );
\prod0__379_carry__8_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969696"
    )
        port map (
      I0 => \prod0__379_carry__8_i_1_n_0\,
      I1 => \prod0__179_carry__7_n_6\,
      I2 => \prod0__249_carry__3_n_7\,
      I3 => \prod0__249_carry__2_n_4\,
      I4 => \prod0__179_carry__7_n_7\,
      O => \prod0__379_carry__8_i_3_n_0\
    );
\prod0__379_carry_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \prod0__81_carry_n_4\,
      I1 => \prod0__283_carry__0_n_5\,
      O => \prod0__379_carry_i_1_n_0\
    );
\prod0__379_carry_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \prod0__81_carry_n_5\,
      I1 => \prod0__283_carry__0_n_6\,
      O => \prod0__379_carry_i_2_n_0\
    );
\prod0__379_carry_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \prod0__81_carry_n_6\,
      I1 => \prod0__283_carry__0_n_7\,
      O => \prod0__379_carry_i_3_n_0\
    );
\prod0__379_carry_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => prod0_carry_n_7,
      I1 => \prod0__283_carry_n_4\,
      O => \prod0__379_carry_i_4_n_0\
    );
\prod0__379_carry_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6996"
    )
        port map (
      I0 => \prod0__81_carry__0_n_7\,
      I1 => \prod0__283_carry__0_n_4\,
      I2 => Q(0),
      I3 => \prod0__379_carry_i_1_n_0\,
      O => \prod0__379_carry_i_5_n_0\
    );
\prod0__379_carry_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9666"
    )
        port map (
      I0 => \prod0__81_carry_n_4\,
      I1 => \prod0__283_carry__0_n_5\,
      I2 => \prod0__283_carry__0_n_6\,
      I3 => \prod0__81_carry_n_5\,
      O => \prod0__379_carry_i_6_n_0\
    );
\prod0__379_carry_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8778"
    )
        port map (
      I0 => \prod0__283_carry__0_n_7\,
      I1 => \prod0__81_carry_n_6\,
      I2 => \prod0__81_carry_n_5\,
      I3 => \prod0__283_carry__0_n_6\,
      O => \prod0__379_carry_i_7_n_0\
    );
\prod0__379_carry_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8778"
    )
        port map (
      I0 => \prod0__283_carry_n_4\,
      I1 => prod0_carry_n_7,
      I2 => \prod0__81_carry_n_6\,
      I3 => \prod0__283_carry__0_n_7\,
      O => \prod0__379_carry_i_8_n_0\
    );
\prod0__70_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__70_carry_n_0\,
      CO(2) => \prod0__70_carry_n_1\,
      CO(1) => \prod0__70_carry_n_2\,
      CO(0) => \prod0__70_carry_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 1) => Q(30 downto 29),
      DI(0) => '0',
      O(3) => \prod0__70_carry_n_4\,
      O(2) => \prod0__70_carry_n_5\,
      O(1) => \prod0__70_carry_n_6\,
      O(0) => \prod0__70_carry_n_7\,
      S(3) => \prod0__70_carry_i_1_n_0\,
      S(2) => \prod0__70_carry_i_2_n_0\,
      S(1) => \prod0__70_carry_i_3_n_0\,
      S(0) => Q(28)
    );
\prod0__70_carry_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(31),
      O => \prod0__70_carry_i_1_n_0\
    );
\prod0__70_carry_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(30),
      O => \prod0__70_carry_i_2_n_0\
    );
\prod0__70_carry_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(29),
      O => \prod0__70_carry_i_3_n_0\
    );
\prod0__81_carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \prod0__81_carry_n_0\,
      CO(2) => \prod0__81_carry_n_1\,
      CO(1) => \prod0__81_carry_n_2\,
      CO(0) => \prod0__81_carry_n_3\,
      CYINIT => '0',
      DI(3 downto 2) => Q(1 downto 0),
      DI(1 downto 0) => B"01",
      O(3) => \prod0__81_carry_n_4\,
      O(2) => \prod0__81_carry_n_5\,
      O(1) => \prod0__81_carry_n_6\,
      O(0) => \NLW_prod0__81_carry_O_UNCONNECTED\(0),
      S(3) => \prod0__81_carry_i_1_n_0\,
      S(2) => \prod0__81_carry_i_2_n_0\,
      S(1) => \prod0__81_carry_i_3_n_0\,
      S(0) => Q(0)
    );
\prod0__81_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry_n_0\,
      CO(3) => \prod0__81_carry__0_n_0\,
      CO(2) => \prod0__81_carry__0_n_1\,
      CO(1) => \prod0__81_carry__0_n_2\,
      CO(0) => \prod0__81_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(5 downto 2),
      O(3) => \prod0__81_carry__0_n_4\,
      O(2) => \prod0__81_carry__0_n_5\,
      O(1) => \prod0__81_carry__0_n_6\,
      O(0) => \prod0__81_carry__0_n_7\,
      S(3) => \prod0__81_carry__0_i_1_n_0\,
      S(2) => \prod0__81_carry__0_i_2_n_0\,
      S(1) => \prod0__81_carry__0_i_3_n_0\,
      S(0) => \prod0__81_carry__0_i_4_n_0\
    );
\prod0__81_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(5),
      I1 => Q(7),
      O => \prod0__81_carry__0_i_1_n_0\
    );
\prod0__81_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(4),
      I1 => Q(6),
      O => \prod0__81_carry__0_i_2_n_0\
    );
\prod0__81_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(3),
      I1 => Q(5),
      O => \prod0__81_carry__0_i_3_n_0\
    );
\prod0__81_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(2),
      I1 => Q(4),
      O => \prod0__81_carry__0_i_4_n_0\
    );
\prod0__81_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__0_n_0\,
      CO(3) => \prod0__81_carry__1_n_0\,
      CO(2) => \prod0__81_carry__1_n_1\,
      CO(1) => \prod0__81_carry__1_n_2\,
      CO(0) => \prod0__81_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(9 downto 6),
      O(3) => \prod0__81_carry__1_n_4\,
      O(2) => \prod0__81_carry__1_n_5\,
      O(1) => \prod0__81_carry__1_n_6\,
      O(0) => \prod0__81_carry__1_n_7\,
      S(3) => \prod0__81_carry__1_i_1_n_0\,
      S(2) => \prod0__81_carry__1_i_2_n_0\,
      S(1) => \prod0__81_carry__1_i_3_n_0\,
      S(0) => \prod0__81_carry__1_i_4_n_0\
    );
\prod0__81_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(9),
      I1 => Q(11),
      O => \prod0__81_carry__1_i_1_n_0\
    );
\prod0__81_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(8),
      I1 => Q(10),
      O => \prod0__81_carry__1_i_2_n_0\
    );
\prod0__81_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(7),
      I1 => Q(9),
      O => \prod0__81_carry__1_i_3_n_0\
    );
\prod0__81_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(6),
      I1 => Q(8),
      O => \prod0__81_carry__1_i_4_n_0\
    );
\prod0__81_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__1_n_0\,
      CO(3) => \prod0__81_carry__2_n_0\,
      CO(2) => \prod0__81_carry__2_n_1\,
      CO(1) => \prod0__81_carry__2_n_2\,
      CO(0) => \prod0__81_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(13 downto 10),
      O(3) => \prod0__81_carry__2_n_4\,
      O(2) => \prod0__81_carry__2_n_5\,
      O(1) => \prod0__81_carry__2_n_6\,
      O(0) => \prod0__81_carry__2_n_7\,
      S(3) => \prod0__81_carry__2_i_1_n_0\,
      S(2) => \prod0__81_carry__2_i_2_n_0\,
      S(1) => \prod0__81_carry__2_i_3_n_0\,
      S(0) => \prod0__81_carry__2_i_4_n_0\
    );
\prod0__81_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(13),
      I1 => Q(15),
      O => \prod0__81_carry__2_i_1_n_0\
    );
\prod0__81_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(12),
      I1 => Q(14),
      O => \prod0__81_carry__2_i_2_n_0\
    );
\prod0__81_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(11),
      I1 => Q(13),
      O => \prod0__81_carry__2_i_3_n_0\
    );
\prod0__81_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(10),
      I1 => Q(12),
      O => \prod0__81_carry__2_i_4_n_0\
    );
\prod0__81_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__2_n_0\,
      CO(3) => \prod0__81_carry__3_n_0\,
      CO(2) => \prod0__81_carry__3_n_1\,
      CO(1) => \prod0__81_carry__3_n_2\,
      CO(0) => \prod0__81_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(17 downto 14),
      O(3) => \prod0__81_carry__3_n_4\,
      O(2) => \prod0__81_carry__3_n_5\,
      O(1) => \prod0__81_carry__3_n_6\,
      O(0) => \prod0__81_carry__3_n_7\,
      S(3) => \prod0__81_carry__3_i_1_n_0\,
      S(2) => \prod0__81_carry__3_i_2_n_0\,
      S(1) => \prod0__81_carry__3_i_3_n_0\,
      S(0) => \prod0__81_carry__3_i_4_n_0\
    );
\prod0__81_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(17),
      I1 => Q(19),
      O => \prod0__81_carry__3_i_1_n_0\
    );
\prod0__81_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(16),
      I1 => Q(18),
      O => \prod0__81_carry__3_i_2_n_0\
    );
\prod0__81_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(15),
      I1 => Q(17),
      O => \prod0__81_carry__3_i_3_n_0\
    );
\prod0__81_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(14),
      I1 => Q(16),
      O => \prod0__81_carry__3_i_4_n_0\
    );
\prod0__81_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__3_n_0\,
      CO(3) => \prod0__81_carry__4_n_0\,
      CO(2) => \prod0__81_carry__4_n_1\,
      CO(1) => \prod0__81_carry__4_n_2\,
      CO(0) => \prod0__81_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(21 downto 18),
      O(3) => \prod0__81_carry__4_n_4\,
      O(2) => \prod0__81_carry__4_n_5\,
      O(1) => \prod0__81_carry__4_n_6\,
      O(0) => \prod0__81_carry__4_n_7\,
      S(3) => \prod0__81_carry__4_i_1_n_0\,
      S(2) => \prod0__81_carry__4_i_2_n_0\,
      S(1) => \prod0__81_carry__4_i_3_n_0\,
      S(0) => \prod0__81_carry__4_i_4_n_0\
    );
\prod0__81_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(21),
      I1 => Q(23),
      O => \prod0__81_carry__4_i_1_n_0\
    );
\prod0__81_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(20),
      I1 => Q(22),
      O => \prod0__81_carry__4_i_2_n_0\
    );
\prod0__81_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(19),
      I1 => Q(21),
      O => \prod0__81_carry__4_i_3_n_0\
    );
\prod0__81_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(18),
      I1 => Q(20),
      O => \prod0__81_carry__4_i_4_n_0\
    );
\prod0__81_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__4_n_0\,
      CO(3) => \prod0__81_carry__5_n_0\,
      CO(2) => \prod0__81_carry__5_n_1\,
      CO(1) => \prod0__81_carry__5_n_2\,
      CO(0) => \prod0__81_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(25 downto 22),
      O(3) => \prod0__81_carry__5_n_4\,
      O(2) => \prod0__81_carry__5_n_5\,
      O(1) => \prod0__81_carry__5_n_6\,
      O(0) => \prod0__81_carry__5_n_7\,
      S(3) => \prod0__81_carry__5_i_1_n_0\,
      S(2) => \prod0__81_carry__5_i_2_n_0\,
      S(1) => \prod0__81_carry__5_i_3_n_0\,
      S(0) => \prod0__81_carry__5_i_4_n_0\
    );
\prod0__81_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(25),
      I1 => Q(27),
      O => \prod0__81_carry__5_i_1_n_0\
    );
\prod0__81_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(24),
      I1 => Q(26),
      O => \prod0__81_carry__5_i_2_n_0\
    );
\prod0__81_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(23),
      I1 => Q(25),
      O => \prod0__81_carry__5_i_3_n_0\
    );
\prod0__81_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(22),
      I1 => Q(24),
      O => \prod0__81_carry__5_i_4_n_0\
    );
\prod0__81_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__5_n_0\,
      CO(3) => \prod0__81_carry__6_n_0\,
      CO(2) => \prod0__81_carry__6_n_1\,
      CO(1) => \prod0__81_carry__6_n_2\,
      CO(0) => \prod0__81_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(29 downto 26),
      O(3) => \prod0__81_carry__6_n_4\,
      O(2) => \prod0__81_carry__6_n_5\,
      O(1) => \prod0__81_carry__6_n_6\,
      O(0) => \prod0__81_carry__6_n_7\,
      S(3) => \prod0__81_carry__6_i_1_n_0\,
      S(2) => \prod0__81_carry__6_i_2_n_0\,
      S(1) => \prod0__81_carry__6_i_3_n_0\,
      S(0) => \prod0__81_carry__6_i_4_n_0\
    );
\prod0__81_carry__6_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => Q(29),
      I1 => Q(31),
      O => \prod0__81_carry__6_i_1_n_0\
    );
\prod0__81_carry__6_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(28),
      I1 => Q(30),
      O => \prod0__81_carry__6_i_2_n_0\
    );
\prod0__81_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(27),
      I1 => Q(29),
      O => \prod0__81_carry__6_i_3_n_0\
    );
\prod0__81_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(26),
      I1 => Q(28),
      O => \prod0__81_carry__6_i_4_n_0\
    );
\prod0__81_carry__7\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0__81_carry__6_n_0\,
      CO(3) => \NLW_prod0__81_carry__7_CO_UNCONNECTED\(3),
      CO(2) => \prod0__81_carry__7_n_1\,
      CO(1) => \NLW_prod0__81_carry__7_CO_UNCONNECTED\(1),
      CO(0) => \prod0__81_carry__7_n_3\,
      CYINIT => '0',
      DI(3 downto 1) => B"000",
      DI(0) => Q(30),
      O(3 downto 2) => \NLW_prod0__81_carry__7_O_UNCONNECTED\(3 downto 2),
      O(1) => \prod0__81_carry__7_n_6\,
      O(0) => \prod0__81_carry__7_n_7\,
      S(3 downto 2) => B"01",
      S(1) => \prod0__81_carry__7_i_1_n_0\,
      S(0) => \prod0__81_carry__7_i_2_n_0\
    );
\prod0__81_carry__7_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(31),
      O => \prod0__81_carry__7_i_1_n_0\
    );
\prod0__81_carry__7_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(30),
      O => \prod0__81_carry__7_i_2_n_0\
    );
\prod0__81_carry_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(1),
      I1 => Q(3),
      O => \prod0__81_carry_i_1_n_0\
    );
\prod0__81_carry_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(0),
      I1 => Q(2),
      O => \prod0__81_carry_i_2_n_0\
    );
\prod0__81_carry_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(1),
      O => \prod0__81_carry_i_3_n_0\
    );
prod0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => prod0_carry_n_0,
      CO(2) => prod0_carry_n_1,
      CO(1) => prod0_carry_n_2,
      CO(0) => prod0_carry_n_3,
      CYINIT => '0',
      DI(3 downto 2) => Q(1 downto 0),
      DI(1 downto 0) => B"01",
      O(3 downto 1) => NLW_prod0_carry_O_UNCONNECTED(3 downto 1),
      O(0) => prod0_carry_n_7,
      S(3) => prod0_carry_i_1_n_0,
      S(2) => prod0_carry_i_2_n_0,
      S(1) => prod0_carry_i_3_n_0,
      S(0) => Q(0)
    );
\prod0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => prod0_carry_n_0,
      CO(3) => \prod0_carry__0_n_0\,
      CO(2) => \prod0_carry__0_n_1\,
      CO(1) => \prod0_carry__0_n_2\,
      CO(0) => \prod0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(5 downto 2),
      O(3) => \prod0_carry__0_n_4\,
      O(2) => \prod0_carry__0_n_5\,
      O(1) => \prod0_carry__0_n_6\,
      O(0) => \prod0_carry__0_n_7\,
      S(3) => \prod0_carry__0_i_1_n_0\,
      S(2) => \prod0_carry__0_i_2_n_0\,
      S(1) => \prod0_carry__0_i_3_n_0\,
      S(0) => \prod0_carry__0_i_4_n_0\
    );
\prod0_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(5),
      I1 => Q(7),
      O => \prod0_carry__0_i_1_n_0\
    );
\prod0_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(4),
      I1 => Q(6),
      O => \prod0_carry__0_i_2_n_0\
    );
\prod0_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(3),
      I1 => Q(5),
      O => \prod0_carry__0_i_3_n_0\
    );
\prod0_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(2),
      I1 => Q(4),
      O => \prod0_carry__0_i_4_n_0\
    );
\prod0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__0_n_0\,
      CO(3) => \prod0_carry__1_n_0\,
      CO(2) => \prod0_carry__1_n_1\,
      CO(1) => \prod0_carry__1_n_2\,
      CO(0) => \prod0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(9 downto 6),
      O(3) => \prod0_carry__1_n_4\,
      O(2) => \prod0_carry__1_n_5\,
      O(1) => \prod0_carry__1_n_6\,
      O(0) => \prod0_carry__1_n_7\,
      S(3) => \prod0_carry__1_i_1_n_0\,
      S(2) => \prod0_carry__1_i_2_n_0\,
      S(1) => \prod0_carry__1_i_3_n_0\,
      S(0) => \prod0_carry__1_i_4_n_0\
    );
\prod0_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(9),
      I1 => Q(11),
      O => \prod0_carry__1_i_1_n_0\
    );
\prod0_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(8),
      I1 => Q(10),
      O => \prod0_carry__1_i_2_n_0\
    );
\prod0_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(7),
      I1 => Q(9),
      O => \prod0_carry__1_i_3_n_0\
    );
\prod0_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(6),
      I1 => Q(8),
      O => \prod0_carry__1_i_4_n_0\
    );
\prod0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__1_n_0\,
      CO(3) => \prod0_carry__2_n_0\,
      CO(2) => \prod0_carry__2_n_1\,
      CO(1) => \prod0_carry__2_n_2\,
      CO(0) => \prod0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(13 downto 10),
      O(3) => \prod0_carry__2_n_4\,
      O(2) => \prod0_carry__2_n_5\,
      O(1) => \prod0_carry__2_n_6\,
      O(0) => \prod0_carry__2_n_7\,
      S(3) => \prod0_carry__2_i_1_n_0\,
      S(2) => \prod0_carry__2_i_2_n_0\,
      S(1) => \prod0_carry__2_i_3_n_0\,
      S(0) => \prod0_carry__2_i_4_n_0\
    );
\prod0_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(13),
      I1 => Q(15),
      O => \prod0_carry__2_i_1_n_0\
    );
\prod0_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(12),
      I1 => Q(14),
      O => \prod0_carry__2_i_2_n_0\
    );
\prod0_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(11),
      I1 => Q(13),
      O => \prod0_carry__2_i_3_n_0\
    );
\prod0_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(10),
      I1 => Q(12),
      O => \prod0_carry__2_i_4_n_0\
    );
\prod0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__2_n_0\,
      CO(3) => \prod0_carry__3_n_0\,
      CO(2) => \prod0_carry__3_n_1\,
      CO(1) => \prod0_carry__3_n_2\,
      CO(0) => \prod0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(17 downto 14),
      O(3) => \prod0_carry__3_n_4\,
      O(2) => \prod0_carry__3_n_5\,
      O(1) => \prod0_carry__3_n_6\,
      O(0) => \prod0_carry__3_n_7\,
      S(3) => \prod0_carry__3_i_1_n_0\,
      S(2) => \prod0_carry__3_i_2_n_0\,
      S(1) => \prod0_carry__3_i_3_n_0\,
      S(0) => \prod0_carry__3_i_4_n_0\
    );
\prod0_carry__3_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(17),
      I1 => Q(19),
      O => \prod0_carry__3_i_1_n_0\
    );
\prod0_carry__3_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(16),
      I1 => Q(18),
      O => \prod0_carry__3_i_2_n_0\
    );
\prod0_carry__3_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(15),
      I1 => Q(17),
      O => \prod0_carry__3_i_3_n_0\
    );
\prod0_carry__3_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(14),
      I1 => Q(16),
      O => \prod0_carry__3_i_4_n_0\
    );
\prod0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__3_n_0\,
      CO(3) => \prod0_carry__4_n_0\,
      CO(2) => \prod0_carry__4_n_1\,
      CO(1) => \prod0_carry__4_n_2\,
      CO(0) => \prod0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(21 downto 18),
      O(3) => \prod0_carry__4_n_4\,
      O(2) => \prod0_carry__4_n_5\,
      O(1) => \prod0_carry__4_n_6\,
      O(0) => \prod0_carry__4_n_7\,
      S(3) => \prod0_carry__4_i_1_n_0\,
      S(2) => \prod0_carry__4_i_2_n_0\,
      S(1) => \prod0_carry__4_i_3_n_0\,
      S(0) => \prod0_carry__4_i_4_n_0\
    );
\prod0_carry__4_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(21),
      I1 => Q(23),
      O => \prod0_carry__4_i_1_n_0\
    );
\prod0_carry__4_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(20),
      I1 => Q(22),
      O => \prod0_carry__4_i_2_n_0\
    );
\prod0_carry__4_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(19),
      I1 => Q(21),
      O => \prod0_carry__4_i_3_n_0\
    );
\prod0_carry__4_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(18),
      I1 => Q(20),
      O => \prod0_carry__4_i_4_n_0\
    );
\prod0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__4_n_0\,
      CO(3) => \prod0_carry__5_n_0\,
      CO(2) => \prod0_carry__5_n_1\,
      CO(1) => \prod0_carry__5_n_2\,
      CO(0) => \prod0_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => Q(25 downto 22),
      O(3) => \prod0_carry__5_n_4\,
      O(2) => \prod0_carry__5_n_5\,
      O(1) => \prod0_carry__5_n_6\,
      O(0) => \prod0_carry__5_n_7\,
      S(3) => \prod0_carry__5_i_1_n_0\,
      S(2) => \prod0_carry__5_i_2_n_0\,
      S(1) => \prod0_carry__5_i_3_n_0\,
      S(0) => \prod0_carry__5_i_4_n_0\
    );
\prod0_carry__5_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(25),
      I1 => Q(27),
      O => \prod0_carry__5_i_1_n_0\
    );
\prod0_carry__5_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(24),
      I1 => Q(26),
      O => \prod0_carry__5_i_2_n_0\
    );
\prod0_carry__5_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(23),
      I1 => Q(25),
      O => \prod0_carry__5_i_3_n_0\
    );
\prod0_carry__5_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(22),
      I1 => Q(24),
      O => \prod0_carry__5_i_4_n_0\
    );
\prod0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__5_n_0\,
      CO(3) => \prod0_carry__6_n_0\,
      CO(2) => \prod0_carry__6_n_1\,
      CO(1) => \prod0_carry__6_n_2\,
      CO(0) => \prod0_carry__6_n_3\,
      CYINIT => '0',
      DI(3) => \prod0_carry__6_i_1_n_0\,
      DI(2) => Q(30),
      DI(1 downto 0) => Q(27 downto 26),
      O(3) => \prod0_carry__6_n_4\,
      O(2) => \prod0_carry__6_n_5\,
      O(1) => \prod0_carry__6_n_6\,
      O(0) => \prod0_carry__6_n_7\,
      S(3) => \prod0_carry__6_i_2_n_0\,
      S(2) => \prod0_carry__6_i_3_n_0\,
      S(1) => \prod0_carry__6_i_4_n_0\,
      S(0) => \prod0_carry__6_i_5_n_0\
    );
\prod0_carry__6_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(30),
      O => \prod0_carry__6_i_1_n_0\
    );
\prod0_carry__6_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => Q(30),
      I1 => Q(31),
      I2 => Q(29),
      O => \prod0_carry__6_i_2_n_0\
    );
\prod0_carry__6_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => Q(30),
      I1 => Q(28),
      O => \prod0_carry__6_i_3_n_0\
    );
\prod0_carry__6_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(27),
      I1 => Q(29),
      O => \prod0_carry__6_i_4_n_0\
    );
\prod0_carry__6_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(26),
      I1 => Q(28),
      O => \prod0_carry__6_i_5_n_0\
    );
\prod0_carry__7\: unisim.vcomponents.CARRY4
     port map (
      CI => \prod0_carry__6_n_0\,
      CO(3) => \prod0_carry__7_n_0\,
      CO(2) => \NLW_prod0_carry__7_CO_UNCONNECTED\(2),
      CO(1) => \prod0_carry__7_n_2\,
      CO(0) => \prod0_carry__7_n_3\,
      CYINIT => '0',
      DI(3) => '0',
      DI(2) => \prod0_carry__7_i_1_n_0\,
      DI(1) => Q(30),
      DI(0) => \prod0_carry__7_i_2_n_0\,
      O(3) => \NLW_prod0_carry__7_O_UNCONNECTED\(3),
      O(2) => \prod0_carry__7_n_5\,
      O(1) => \prod0_carry__7_n_6\,
      O(0) => \prod0_carry__7_n_7\,
      S(3) => '1',
      S(2) => Q(31),
      S(1) => \prod0_carry__7_i_3_n_0\,
      S(0) => \prod0_carry__7_i_4_n_0\
    );
\prod0_carry__7_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(31),
      O => \prod0_carry__7_i_1_n_0\
    );
\prod0_carry__7_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => Q(31),
      I1 => Q(29),
      O => \prod0_carry__7_i_2_n_0\
    );
\prod0_carry__7_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => Q(30),
      I1 => Q(31),
      O => \prod0_carry__7_i_3_n_0\
    );
\prod0_carry__7_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"87"
    )
        port map (
      I0 => Q(29),
      I1 => Q(31),
      I2 => Q(30),
      O => \prod0_carry__7_i_4_n_0\
    );
prod0_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(1),
      I1 => Q(3),
      O => prod0_carry_i_1_n_0
    );
prod0_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => Q(0),
      I1 => Q(2),
      O => prod0_carry_i_2_n_0
    );
prod0_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(1),
      O => prod0_carry_i_3_n_0
    );
\prod[47]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_onehot_st_reg_n_0_[0]\,
      I1 => start_pulse,
      O => prod
    );
\prod_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__0_n_5\,
      Q => p_0_in1_in(0)
    );
\prod_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__0_n_4\,
      Q => p_0_in1_in(1)
    );
\prod_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__1_n_7\,
      Q => p_0_in1_in(2)
    );
\prod_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__1_n_6\,
      Q => p_0_in1_in(3)
    );
\prod_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__1_n_5\,
      Q => p_0_in1_in(4)
    );
\prod_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__1_n_4\,
      Q => p_0_in1_in(5)
    );
\prod_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__2_n_7\,
      Q => p_0_in1_in(6)
    );
\prod_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__2_n_6\,
      Q => p_0_in1_in(7)
    );
\prod_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__2_n_5\,
      Q => p_0_in1_in(8)
    );
\prod_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__2_n_4\,
      Q => p_0_in1_in(9)
    );
\prod_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__3_n_7\,
      Q => p_0_in1_in(10)
    );
\prod_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__3_n_6\,
      Q => p_0_in1_in(11)
    );
\prod_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__3_n_5\,
      Q => p_0_in1_in(12)
    );
\prod_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__3_n_4\,
      Q => p_0_in1_in(13)
    );
\prod_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__4_n_7\,
      Q => p_0_in1_in(14)
    );
\prod_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__4_n_6\,
      Q => p_0_in1_in(15)
    );
\prod_reg[32]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__4_n_5\,
      Q => p_0_in1_in(16)
    );
\prod_reg[33]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__4_n_4\,
      Q => p_0_in1_in(17)
    );
\prod_reg[34]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__5_n_7\,
      Q => p_0_in1_in(18)
    );
\prod_reg[35]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__5_n_6\,
      Q => p_0_in1_in(19)
    );
\prod_reg[36]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__5_n_5\,
      Q => p_0_in1_in(20)
    );
\prod_reg[37]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__5_n_4\,
      Q => p_0_in1_in(21)
    );
\prod_reg[38]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__6_n_7\,
      Q => p_0_in1_in(22)
    );
\prod_reg[39]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__6_n_6\,
      Q => p_0_in1_in(23)
    );
\prod_reg[40]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__6_n_5\,
      Q => p_0_in1_in(24)
    );
\prod_reg[41]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__6_n_4\,
      Q => p_0_in1_in(25)
    );
\prod_reg[42]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__7_n_7\,
      Q => p_0_in1_in(26)
    );
\prod_reg[43]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__7_n_6\,
      Q => p_0_in1_in(27)
    );
\prod_reg[44]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__7_n_5\,
      Q => p_0_in1_in(28)
    );
\prod_reg[45]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__7_n_4\,
      Q => p_0_in1_in(29)
    );
\prod_reg[46]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__8_n_7\,
      Q => p_0_in1_in(30)
    );
\prod_reg[47]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => \prod0__379_carry__8_n_6\,
      Q => p_0_in1_in(31)
    );
reset_b0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => reset_b0_carry_n_0,
      CO(2) => reset_b0_carry_n_1,
      CO(1) => reset_b0_carry_n_2,
      CO(0) => reset_b0_carry_n_3,
      CYINIT => '1',
      DI(3) => reset_b0_carry_i_1_n_0,
      DI(2) => reset_b0_carry_i_2_n_0,
      DI(1) => reset_b0_carry_i_3_n_0,
      DI(0) => '1',
      O(3 downto 0) => NLW_reset_b0_carry_O_UNCONNECTED(3 downto 0),
      S(3) => reset_b0_carry_i_4_n_0,
      S(2) => reset_b0_carry_i_5_n_0,
      S(1) => reset_b0_carry_i_6_n_0,
      S(0) => reset_b0_carry_i_7_n_0
    );
\reset_b0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => reset_b0_carry_n_0,
      CO(3) => \reset_b0_carry__0_n_0\,
      CO(2) => \reset_b0_carry__0_n_1\,
      CO(1) => \reset_b0_carry__0_n_2\,
      CO(0) => \reset_b0_carry__0_n_3\,
      CYINIT => '0',
      DI(3) => \reset_b0_carry__0_i_1_n_0\,
      DI(2) => \reset_b0_carry__0_i_2_n_0\,
      DI(1) => \reset_b0_carry__0_i_3_n_0\,
      DI(0) => \reset_b0_carry__0_i_4_n_0\,
      O(3 downto 0) => \NLW_reset_b0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3) => \reset_b0_carry__0_i_5_n_0\,
      S(2) => \reset_b0_carry__0_i_6_n_0\,
      S(1) => \reset_b0_carry__0_i_7_n_0\,
      S(0) => \reset_b0_carry__0_i_8_n_0\
    );
\reset_b0_carry__0_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(14),
      I1 => Q(15),
      O => \reset_b0_carry__0_i_1_n_0\
    );
\reset_b0_carry__0_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(12),
      I1 => Q(13),
      O => \reset_b0_carry__0_i_2_n_0\
    );
\reset_b0_carry__0_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(10),
      I1 => Q(11),
      O => \reset_b0_carry__0_i_3_n_0\
    );
\reset_b0_carry__0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(8),
      I1 => Q(9),
      O => \reset_b0_carry__0_i_4_n_0\
    );
\reset_b0_carry__0_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(15),
      I1 => Q(14),
      O => \reset_b0_carry__0_i_5_n_0\
    );
\reset_b0_carry__0_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(13),
      I1 => Q(12),
      O => \reset_b0_carry__0_i_6_n_0\
    );
\reset_b0_carry__0_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(11),
      I1 => Q(10),
      O => \reset_b0_carry__0_i_7_n_0\
    );
\reset_b0_carry__0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(9),
      I1 => Q(8),
      O => \reset_b0_carry__0_i_8_n_0\
    );
\reset_b0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \reset_b0_carry__0_n_0\,
      CO(3) => \reset_b0_carry__1_n_0\,
      CO(2) => \reset_b0_carry__1_n_1\,
      CO(1) => \reset_b0_carry__1_n_2\,
      CO(0) => \reset_b0_carry__1_n_3\,
      CYINIT => '0',
      DI(3) => \reset_b0_carry__1_i_1_n_0\,
      DI(2) => \reset_b0_carry__1_i_2_n_0\,
      DI(1) => \reset_b0_carry__1_i_3_n_0\,
      DI(0) => Q(17),
      O(3 downto 0) => \NLW_reset_b0_carry__1_O_UNCONNECTED\(3 downto 0),
      S(3) => \reset_b0_carry__1_i_4_n_0\,
      S(2) => \reset_b0_carry__1_i_5_n_0\,
      S(1) => \reset_b0_carry__1_i_6_n_0\,
      S(0) => \reset_b0_carry__1_i_7_n_0\
    );
\reset_b0_carry__1_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(22),
      I1 => Q(23),
      O => \reset_b0_carry__1_i_1_n_0\
    );
\reset_b0_carry__1_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(20),
      I1 => Q(21),
      O => \reset_b0_carry__1_i_2_n_0\
    );
\reset_b0_carry__1_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(18),
      I1 => Q(19),
      O => \reset_b0_carry__1_i_3_n_0\
    );
\reset_b0_carry__1_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(23),
      I1 => Q(22),
      O => \reset_b0_carry__1_i_4_n_0\
    );
\reset_b0_carry__1_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(21),
      I1 => Q(20),
      O => \reset_b0_carry__1_i_5_n_0\
    );
\reset_b0_carry__1_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(19),
      I1 => Q(18),
      O => \reset_b0_carry__1_i_6_n_0\
    );
\reset_b0_carry__1_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => Q(16),
      I1 => Q(17),
      O => \reset_b0_carry__1_i_7_n_0\
    );
\reset_b0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \reset_b0_carry__1_n_0\,
      CO(3) => p_0_in,
      CO(2) => \reset_b0_carry__2_n_1\,
      CO(1) => \reset_b0_carry__2_n_2\,
      CO(0) => \reset_b0_carry__2_n_3\,
      CYINIT => '0',
      DI(3) => \reset_b0_carry__2_i_1_n_0\,
      DI(2) => \reset_b0_carry__2_i_2_n_0\,
      DI(1) => \reset_b0_carry__2_i_3_n_0\,
      DI(0) => \reset_b0_carry__2_i_4_n_0\,
      O(3 downto 0) => \NLW_reset_b0_carry__2_O_UNCONNECTED\(3 downto 0),
      S(3) => \reset_b0_carry__2_i_5_n_0\,
      S(2) => \reset_b0_carry__2_i_6_n_0\,
      S(1) => \reset_b0_carry__2_i_7_n_0\,
      S(0) => \reset_b0_carry__2_i_8_n_0\
    );
\reset_b0_carry__2_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => Q(30),
      I1 => Q(31),
      O => \reset_b0_carry__2_i_1_n_0\
    );
\reset_b0_carry__2_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(28),
      I1 => Q(29),
      O => \reset_b0_carry__2_i_2_n_0\
    );
\reset_b0_carry__2_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(26),
      I1 => Q(27),
      O => \reset_b0_carry__2_i_3_n_0\
    );
\reset_b0_carry__2_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(24),
      I1 => Q(25),
      O => \reset_b0_carry__2_i_4_n_0\
    );
\reset_b0_carry__2_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(31),
      I1 => Q(30),
      O => \reset_b0_carry__2_i_5_n_0\
    );
\reset_b0_carry__2_i_6\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(29),
      I1 => Q(28),
      O => \reset_b0_carry__2_i_6_n_0\
    );
\reset_b0_carry__2_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(27),
      I1 => Q(26),
      O => \reset_b0_carry__2_i_7_n_0\
    );
\reset_b0_carry__2_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(25),
      I1 => Q(24),
      O => \reset_b0_carry__2_i_8_n_0\
    );
reset_b0_carry_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(6),
      I1 => Q(7),
      O => reset_b0_carry_i_1_n_0
    );
reset_b0_carry_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(4),
      I1 => Q(5),
      O => reset_b0_carry_i_2_n_0
    );
reset_b0_carry_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => Q(2),
      I1 => Q(3),
      O => reset_b0_carry_i_3_n_0
    );
reset_b0_carry_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(7),
      I1 => Q(6),
      O => reset_b0_carry_i_4_n_0
    );
reset_b0_carry_i_5: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(5),
      I1 => Q(4),
      O => reset_b0_carry_i_5_n_0
    );
reset_b0_carry_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(3),
      I1 => Q(2),
      O => reset_b0_carry_i_6_n_0
    );
reset_b0_carry_i_7: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Q(0),
      I1 => Q(1),
      O => reset_b0_carry_i_7_n_0
    );
reset_b_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => prod,
      CLR => \^s_axi_aresetn_0\,
      D => p_0_in,
      Q => reset_b
    );
s_axi_awready_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \^s_axi_aresetn_0\
    );
\s_axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"222E000022220000"
    )
        port map (
      I0 => \s_axi_rdata_reg[0]\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => \s_axi_rdata_reg[0]_0\,
      I5 => mem_out_q16(0),
      O => D(0)
    );
\s_axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[10]_i_2_n_0\,
      O => D(10)
    );
\s_axi_rdata[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(10),
      I1 => Q(10),
      I2 => \mem_tmp_reg[31]_0\(10),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[10]_i_2_n_0\
    );
\s_axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[11]_i_2_n_0\,
      O => D(11)
    );
\s_axi_rdata[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(11),
      I1 => Q(11),
      I2 => \mem_tmp_reg[31]_0\(11),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[11]_i_2_n_0\
    );
\s_axi_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[12]_i_2_n_0\,
      O => D(12)
    );
\s_axi_rdata[12]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(12),
      I1 => Q(12),
      I2 => \mem_tmp_reg[31]_0\(12),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[12]_i_2_n_0\
    );
\s_axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[13]_i_2_n_0\,
      O => D(13)
    );
\s_axi_rdata[13]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(13),
      I1 => Q(13),
      I2 => \mem_tmp_reg[31]_0\(13),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[13]_i_2_n_0\
    );
\s_axi_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[14]_i_2_n_0\,
      O => D(14)
    );
\s_axi_rdata[14]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(14),
      I1 => Q(14),
      I2 => \mem_tmp_reg[31]_0\(14),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[14]_i_2_n_0\
    );
\s_axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[15]_i_2_n_0\,
      O => D(15)
    );
\s_axi_rdata[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(15),
      I1 => Q(15),
      I2 => \mem_tmp_reg[31]_0\(15),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[15]_i_2_n_0\
    );
\s_axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[16]_i_2_n_0\,
      O => D(16)
    );
\s_axi_rdata[16]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(16),
      I1 => Q(16),
      I2 => \mem_tmp_reg[31]_0\(16),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[16]_i_2_n_0\
    );
\s_axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[17]_i_2_n_0\,
      O => D(17)
    );
\s_axi_rdata[17]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(17),
      I1 => Q(17),
      I2 => \mem_tmp_reg[31]_0\(17),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[17]_i_2_n_0\
    );
\s_axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[18]_i_2_n_0\,
      O => D(18)
    );
\s_axi_rdata[18]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(18),
      I1 => Q(18),
      I2 => \mem_tmp_reg[31]_0\(18),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[18]_i_2_n_0\
    );
\s_axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[19]_i_2_n_0\,
      O => D(19)
    );
\s_axi_rdata[19]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(19),
      I1 => Q(19),
      I2 => \mem_tmp_reg[31]_0\(19),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[19]_i_2_n_0\
    );
\s_axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"222E000022220000"
    )
        port map (
      I0 => \s_axi_rdata[1]_i_2_n_0\,
      I1 => s_axi_araddr(4),
      I2 => s_axi_araddr(2),
      I3 => s_axi_araddr(3),
      I4 => \s_axi_rdata_reg[0]_0\,
      I5 => mem_out_q16(1),
      O => D(1)
    );
\s_axi_rdata[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CACAFFF0CACA0F00"
    )
        port map (
      I0 => \mem_tmp_reg[31]_0\(1),
      I1 => spk_out,
      I2 => s_axi_araddr(3),
      I3 => data0(0),
      I4 => s_axi_araddr(2),
      I5 => Q(1),
      O => \s_axi_rdata[1]_i_2_n_0\
    );
\s_axi_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[20]_i_2_n_0\,
      O => D(20)
    );
\s_axi_rdata[20]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(20),
      I1 => Q(20),
      I2 => \mem_tmp_reg[31]_0\(20),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[20]_i_2_n_0\
    );
\s_axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[21]_i_2_n_0\,
      O => D(21)
    );
\s_axi_rdata[21]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(21),
      I1 => Q(21),
      I2 => \mem_tmp_reg[31]_0\(21),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[21]_i_2_n_0\
    );
\s_axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[22]_i_2_n_0\,
      O => D(22)
    );
\s_axi_rdata[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(22),
      I1 => Q(22),
      I2 => \mem_tmp_reg[31]_0\(22),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[22]_i_2_n_0\
    );
\s_axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[23]_i_2_n_0\,
      O => D(23)
    );
\s_axi_rdata[23]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(23),
      I1 => Q(23),
      I2 => \mem_tmp_reg[31]_0\(23),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[23]_i_2_n_0\
    );
\s_axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[24]_i_2_n_0\,
      O => D(24)
    );
\s_axi_rdata[24]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(24),
      I1 => Q(24),
      I2 => \mem_tmp_reg[31]_0\(24),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[24]_i_2_n_0\
    );
\s_axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[25]_i_2_n_0\,
      O => D(25)
    );
\s_axi_rdata[25]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(25),
      I1 => Q(25),
      I2 => \mem_tmp_reg[31]_0\(25),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[25]_i_2_n_0\
    );
\s_axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[26]_i_2_n_0\,
      O => D(26)
    );
\s_axi_rdata[26]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(26),
      I1 => Q(26),
      I2 => \mem_tmp_reg[31]_0\(26),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[26]_i_2_n_0\
    );
\s_axi_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[27]_i_2_n_0\,
      O => D(27)
    );
\s_axi_rdata[27]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(27),
      I1 => Q(27),
      I2 => \mem_tmp_reg[31]_0\(27),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[27]_i_2_n_0\
    );
\s_axi_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[28]_i_2_n_0\,
      O => D(28)
    );
\s_axi_rdata[28]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(28),
      I1 => Q(28),
      I2 => \mem_tmp_reg[31]_0\(28),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[28]_i_2_n_0\
    );
\s_axi_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[29]_i_2_n_0\,
      O => D(29)
    );
\s_axi_rdata[29]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(29),
      I1 => Q(29),
      I2 => \mem_tmp_reg[31]_0\(29),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[29]_i_2_n_0\
    );
\s_axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[2]_i_2_n_0\,
      O => D(2)
    );
\s_axi_rdata[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(2),
      I1 => Q(2),
      I2 => \mem_tmp_reg[31]_0\(2),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[2]_i_2_n_0\
    );
\s_axi_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[30]_i_2_n_0\,
      O => D(30)
    );
\s_axi_rdata[30]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(30),
      I1 => Q(30),
      I2 => \mem_tmp_reg[31]_0\(30),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[30]_i_2_n_0\
    );
\s_axi_rdata[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[31]_i_2_n_0\,
      O => D(31)
    );
\s_axi_rdata[31]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(31),
      I1 => Q(31),
      I2 => \mem_tmp_reg[31]_0\(31),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[31]_i_2_n_0\
    );
\s_axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[3]_i_2_n_0\,
      O => D(3)
    );
\s_axi_rdata[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(3),
      I1 => Q(3),
      I2 => \mem_tmp_reg[31]_0\(3),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[3]_i_2_n_0\
    );
\s_axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[4]_i_2_n_0\,
      O => D(4)
    );
\s_axi_rdata[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(4),
      I1 => Q(4),
      I2 => \mem_tmp_reg[31]_0\(4),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[4]_i_2_n_0\
    );
\s_axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[5]_i_2_n_0\,
      O => D(5)
    );
\s_axi_rdata[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(5),
      I1 => Q(5),
      I2 => \mem_tmp_reg[31]_0\(5),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[5]_i_2_n_0\
    );
\s_axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[6]_i_2_n_0\,
      O => D(6)
    );
\s_axi_rdata[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(6),
      I1 => Q(6),
      I2 => \mem_tmp_reg[31]_0\(6),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[6]_i_2_n_0\
    );
\s_axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[7]_i_2_n_0\,
      O => D(7)
    );
\s_axi_rdata[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(7),
      I1 => Q(7),
      I2 => \mem_tmp_reg[31]_0\(7),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[7]_i_2_n_0\
    );
\s_axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[8]_i_2_n_0\,
      O => D(8)
    );
\s_axi_rdata[8]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(8),
      I1 => Q(8),
      I2 => \mem_tmp_reg[31]_0\(8),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[8]_i_2_n_0\
    );
\s_axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000100000000"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => s_axi_araddr(6),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(1),
      I4 => s_axi_araddr(0),
      I5 => \s_axi_rdata[9]_i_2_n_0\,
      O => D(9)
    );
\s_axi_rdata[9]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000AA00F0CC00"
    )
        port map (
      I0 => mem_out_q16(9),
      I1 => Q(9),
      I2 => \mem_tmp_reg[31]_0\(9),
      I3 => s_axi_araddr(3),
      I4 => s_axi_araddr(2),
      I5 => s_axi_araddr(4),
      O => \s_axi_rdata[9]_i_2_n_0\
    );
spk_out_i_10: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(24),
      I1 => mem_tmp(25),
      O => spk_out_i_10_n_0
    );
spk_out_i_12: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(22),
      I1 => mem_tmp(23),
      O => spk_out_i_12_n_0
    );
spk_out_i_13: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(20),
      I1 => mem_tmp(21),
      O => spk_out_i_13_n_0
    );
spk_out_i_14: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(18),
      I1 => mem_tmp(19),
      O => spk_out_i_14_n_0
    );
spk_out_i_15: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(22),
      I1 => mem_tmp(23),
      O => spk_out_i_15_n_0
    );
spk_out_i_16: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(20),
      I1 => mem_tmp(21),
      O => spk_out_i_16_n_0
    );
spk_out_i_17: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(18),
      I1 => mem_tmp(19),
      O => spk_out_i_17_n_0
    );
spk_out_i_18: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => mem_tmp(16),
      I1 => mem_tmp(17),
      O => spk_out_i_18_n_0
    );
spk_out_i_20: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(14),
      I1 => mem_tmp(15),
      O => spk_out_i_20_n_0
    );
spk_out_i_21: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(12),
      I1 => mem_tmp(13),
      O => spk_out_i_21_n_0
    );
spk_out_i_22: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(10),
      I1 => mem_tmp(11),
      O => spk_out_i_22_n_0
    );
spk_out_i_23: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(8),
      I1 => mem_tmp(9),
      O => spk_out_i_23_n_0
    );
spk_out_i_24: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(14),
      I1 => mem_tmp(15),
      O => spk_out_i_24_n_0
    );
spk_out_i_25: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(12),
      I1 => mem_tmp(13),
      O => spk_out_i_25_n_0
    );
spk_out_i_26: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(10),
      I1 => mem_tmp(11),
      O => spk_out_i_26_n_0
    );
spk_out_i_27: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(8),
      I1 => mem_tmp(9),
      O => spk_out_i_27_n_0
    );
spk_out_i_28: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(6),
      I1 => mem_tmp(7),
      O => spk_out_i_28_n_0
    );
spk_out_i_29: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(4),
      I1 => mem_tmp(5),
      O => spk_out_i_29_n_0
    );
spk_out_i_3: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => mem_tmp(30),
      I1 => mem_tmp(31),
      O => spk_out_i_3_n_0
    );
spk_out_i_30: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(2),
      I1 => mem_tmp(3),
      O => spk_out_i_30_n_0
    );
spk_out_i_31: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(0),
      I1 => mem_tmp(1),
      O => spk_out_i_31_n_0
    );
spk_out_i_32: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(6),
      I1 => mem_tmp(7),
      O => spk_out_i_32_n_0
    );
spk_out_i_33: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(4),
      I1 => mem_tmp(5),
      O => spk_out_i_33_n_0
    );
spk_out_i_34: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(2),
      I1 => mem_tmp(3),
      O => spk_out_i_34_n_0
    );
spk_out_i_35: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(0),
      I1 => mem_tmp(1),
      O => spk_out_i_35_n_0
    );
spk_out_i_4: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(28),
      I1 => mem_tmp(29),
      O => spk_out_i_4_n_0
    );
spk_out_i_5: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(26),
      I1 => mem_tmp(27),
      O => spk_out_i_5_n_0
    );
spk_out_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => mem_tmp(24),
      I1 => mem_tmp(25),
      O => spk_out_i_6_n_0
    );
spk_out_i_7: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(30),
      I1 => mem_tmp(31),
      O => spk_out_i_7_n_0
    );
spk_out_i_8: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(28),
      I1 => mem_tmp(29),
      O => spk_out_i_8_n_0
    );
spk_out_i_9: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => mem_tmp(26),
      I1 => mem_tmp(27),
      O => spk_out_i_9_n_0
    );
spk_out_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => \FSM_onehot_st_reg_n_0_[2]\,
      CLR => \^s_axi_aresetn_0\,
      D => spk_out_reg_i_1_n_0,
      Q => spk_out
    );
spk_out_reg_i_1: unisim.vcomponents.CARRY4
     port map (
      CI => spk_out_reg_i_2_n_0,
      CO(3) => spk_out_reg_i_1_n_0,
      CO(2) => spk_out_reg_i_1_n_1,
      CO(1) => spk_out_reg_i_1_n_2,
      CO(0) => spk_out_reg_i_1_n_3,
      CYINIT => '0',
      DI(3) => spk_out_i_3_n_0,
      DI(2) => spk_out_i_4_n_0,
      DI(1) => spk_out_i_5_n_0,
      DI(0) => spk_out_i_6_n_0,
      O(3 downto 0) => NLW_spk_out_reg_i_1_O_UNCONNECTED(3 downto 0),
      S(3) => spk_out_i_7_n_0,
      S(2) => spk_out_i_8_n_0,
      S(1) => spk_out_i_9_n_0,
      S(0) => spk_out_i_10_n_0
    );
spk_out_reg_i_11: unisim.vcomponents.CARRY4
     port map (
      CI => spk_out_reg_i_19_n_0,
      CO(3) => spk_out_reg_i_11_n_0,
      CO(2) => spk_out_reg_i_11_n_1,
      CO(1) => spk_out_reg_i_11_n_2,
      CO(0) => spk_out_reg_i_11_n_3,
      CYINIT => '0',
      DI(3) => spk_out_i_20_n_0,
      DI(2) => spk_out_i_21_n_0,
      DI(1) => spk_out_i_22_n_0,
      DI(0) => spk_out_i_23_n_0,
      O(3 downto 0) => NLW_spk_out_reg_i_11_O_UNCONNECTED(3 downto 0),
      S(3) => spk_out_i_24_n_0,
      S(2) => spk_out_i_25_n_0,
      S(1) => spk_out_i_26_n_0,
      S(0) => spk_out_i_27_n_0
    );
spk_out_reg_i_19: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => spk_out_reg_i_19_n_0,
      CO(2) => spk_out_reg_i_19_n_1,
      CO(1) => spk_out_reg_i_19_n_2,
      CO(0) => spk_out_reg_i_19_n_3,
      CYINIT => '1',
      DI(3) => spk_out_i_28_n_0,
      DI(2) => spk_out_i_29_n_0,
      DI(1) => spk_out_i_30_n_0,
      DI(0) => spk_out_i_31_n_0,
      O(3 downto 0) => NLW_spk_out_reg_i_19_O_UNCONNECTED(3 downto 0),
      S(3) => spk_out_i_32_n_0,
      S(2) => spk_out_i_33_n_0,
      S(1) => spk_out_i_34_n_0,
      S(0) => spk_out_i_35_n_0
    );
spk_out_reg_i_2: unisim.vcomponents.CARRY4
     port map (
      CI => spk_out_reg_i_11_n_0,
      CO(3) => spk_out_reg_i_2_n_0,
      CO(2) => spk_out_reg_i_2_n_1,
      CO(1) => spk_out_reg_i_2_n_2,
      CO(0) => spk_out_reg_i_2_n_3,
      CYINIT => '0',
      DI(3) => spk_out_i_12_n_0,
      DI(2) => spk_out_i_13_n_0,
      DI(1) => spk_out_i_14_n_0,
      DI(0) => mem_tmp(17),
      O(3 downto 0) => NLW_spk_out_reg_i_2_O_UNCONNECTED(3 downto 0),
      S(3) => spk_out_i_15_n_0,
      S(2) => spk_out_i_16_n_0,
      S(1) => spk_out_i_17_n_0,
      S(0) => spk_out_i_18_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_lif_step_0_0_lif_step_axi_lite is
  port (
    s_axi_wready : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_lif_step_0_0_lif_step_axi_lite : entity is "lif_step_axi_lite";
end design_1_lif_step_0_0_lif_step_axi_lite;

architecture STRUCTURE of design_1_lif_step_0_0_lif_step_axi_lite is
  signal cur_q16 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \cur_q16[31]_i_3_n_0\ : STD_LOGIC;
  signal cur_q16_0 : STD_LOGIC;
  signal data0 : STD_LOGIC_VECTOR ( 1 to 1 );
  signal done_sticky_i_2_n_0 : STD_LOGIC;
  signal done_sticky_i_3_n_0 : STD_LOGIC;
  signal mem_in_q16 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal mem_in_q16_1 : STD_LOGIC;
  signal \^s_axi_arready\ : STD_LOGIC;
  signal s_axi_arready0 : STD_LOGIC;
  signal s_axi_awready0 : STD_LOGIC;
  signal \^s_axi_bvalid\ : STD_LOGIC;
  signal s_axi_bvalid02_out : STD_LOGIC;
  signal s_axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal \s_axi_rdata[0]_i_2_n_0\ : STD_LOGIC;
  signal \s_axi_rdata[1]_i_3_n_0\ : STD_LOGIC;
  signal \^s_axi_rvalid\ : STD_LOGIC;
  signal s_axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal start_pulse : STD_LOGIC;
  signal start_pulse1_out : STD_LOGIC;
  signal start_pulse_i_2_n_0 : STD_LOGIC;
  signal u_lif_n_0 : STD_LOGIC;
  signal u_lif_n_1 : STD_LOGIC;
  signal u_lif_n_10 : STD_LOGIC;
  signal u_lif_n_11 : STD_LOGIC;
  signal u_lif_n_12 : STD_LOGIC;
  signal u_lif_n_13 : STD_LOGIC;
  signal u_lif_n_14 : STD_LOGIC;
  signal u_lif_n_15 : STD_LOGIC;
  signal u_lif_n_16 : STD_LOGIC;
  signal u_lif_n_17 : STD_LOGIC;
  signal u_lif_n_18 : STD_LOGIC;
  signal u_lif_n_19 : STD_LOGIC;
  signal u_lif_n_2 : STD_LOGIC;
  signal u_lif_n_20 : STD_LOGIC;
  signal u_lif_n_21 : STD_LOGIC;
  signal u_lif_n_22 : STD_LOGIC;
  signal u_lif_n_23 : STD_LOGIC;
  signal u_lif_n_24 : STD_LOGIC;
  signal u_lif_n_25 : STD_LOGIC;
  signal u_lif_n_26 : STD_LOGIC;
  signal u_lif_n_27 : STD_LOGIC;
  signal u_lif_n_28 : STD_LOGIC;
  signal u_lif_n_29 : STD_LOGIC;
  signal u_lif_n_3 : STD_LOGIC;
  signal u_lif_n_30 : STD_LOGIC;
  signal u_lif_n_31 : STD_LOGIC;
  signal u_lif_n_32 : STD_LOGIC;
  signal u_lif_n_33 : STD_LOGIC;
  signal u_lif_n_4 : STD_LOGIC;
  signal u_lif_n_5 : STD_LOGIC;
  signal u_lif_n_6 : STD_LOGIC;
  signal u_lif_n_7 : STD_LOGIC;
  signal u_lif_n_8 : STD_LOGIC;
  signal u_lif_n_9 : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cur_q16[31]_i_2\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of done_sticky_i_2 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of s_axi_bvalid_i_1 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \s_axi_rdata[0]_i_2\ : label is "soft_lutpair1";
begin
  s_axi_arready <= \^s_axi_arready\;
  s_axi_bvalid <= \^s_axi_bvalid\;
  s_axi_rvalid <= \^s_axi_rvalid\;
  s_axi_wready <= \^s_axi_wready\;
\cur_q16[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000020000"
    )
        port map (
      I0 => s_axi_bvalid02_out,
      I1 => \cur_q16[31]_i_3_n_0\,
      I2 => s_axi_awaddr(3),
      I3 => s_axi_awaddr(0),
      I4 => s_axi_awaddr(2),
      I5 => s_axi_awaddr(1),
      O => cur_q16_0
    );
\cur_q16[31]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => s_axi_awvalid,
      I2 => s_axi_wvalid,
      O => s_axi_bvalid02_out
    );
\cur_q16[31]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => s_axi_awaddr(6),
      I1 => s_axi_awaddr(7),
      I2 => s_axi_awaddr(4),
      I3 => s_axi_awaddr(5),
      O => \cur_q16[31]_i_3_n_0\
    );
\cur_q16_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(0),
      Q => cur_q16(0)
    );
\cur_q16_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(10),
      Q => cur_q16(10)
    );
\cur_q16_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(11),
      Q => cur_q16(11)
    );
\cur_q16_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(12),
      Q => cur_q16(12)
    );
\cur_q16_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(13),
      Q => cur_q16(13)
    );
\cur_q16_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(14),
      Q => cur_q16(14)
    );
\cur_q16_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(15),
      Q => cur_q16(15)
    );
\cur_q16_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(16),
      Q => cur_q16(16)
    );
\cur_q16_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(17),
      Q => cur_q16(17)
    );
\cur_q16_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(18),
      Q => cur_q16(18)
    );
\cur_q16_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(19),
      Q => cur_q16(19)
    );
\cur_q16_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(1),
      Q => cur_q16(1)
    );
\cur_q16_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(20),
      Q => cur_q16(20)
    );
\cur_q16_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(21),
      Q => cur_q16(21)
    );
\cur_q16_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(22),
      Q => cur_q16(22)
    );
\cur_q16_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(23),
      Q => cur_q16(23)
    );
\cur_q16_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(24),
      Q => cur_q16(24)
    );
\cur_q16_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(25),
      Q => cur_q16(25)
    );
\cur_q16_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(26),
      Q => cur_q16(26)
    );
\cur_q16_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(27),
      Q => cur_q16(27)
    );
\cur_q16_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(28),
      Q => cur_q16(28)
    );
\cur_q16_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(29),
      Q => cur_q16(29)
    );
\cur_q16_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(2),
      Q => cur_q16(2)
    );
\cur_q16_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(30),
      Q => cur_q16(30)
    );
\cur_q16_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(31),
      Q => cur_q16(31)
    );
\cur_q16_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(3),
      Q => cur_q16(3)
    );
\cur_q16_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(4),
      Q => cur_q16(4)
    );
\cur_q16_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(5),
      Q => cur_q16(5)
    );
\cur_q16_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(6),
      Q => cur_q16(6)
    );
\cur_q16_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(7),
      Q => cur_q16(7)
    );
\cur_q16_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(8),
      Q => cur_q16(8)
    );
\cur_q16_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => cur_q16_0,
      CLR => u_lif_n_0,
      D => s_axi_wdata(9),
      Q => cur_q16(9)
    );
done_sticky_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_araddr(2),
      I1 => s_axi_araddr(3),
      O => done_sticky_i_2_n_0
    );
done_sticky_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000001000"
    )
        port map (
      I0 => s_axi_araddr(6),
      I1 => s_axi_araddr(7),
      I2 => s_axi_arvalid,
      I3 => \^s_axi_arready\,
      I4 => s_axi_araddr(0),
      I5 => s_axi_araddr(1),
      O => done_sticky_i_3_n_0
    );
done_sticky_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => u_lif_n_33,
      Q => data0(1)
    );
\mem_in_q16[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000020000"
    )
        port map (
      I0 => s_axi_bvalid02_out,
      I1 => \cur_q16[31]_i_3_n_0\,
      I2 => s_axi_awaddr(0),
      I3 => s_axi_awaddr(2),
      I4 => s_axi_awaddr(3),
      I5 => s_axi_awaddr(1),
      O => mem_in_q16_1
    );
\mem_in_q16_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(0),
      Q => mem_in_q16(0)
    );
\mem_in_q16_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(10),
      Q => mem_in_q16(10)
    );
\mem_in_q16_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(11),
      Q => mem_in_q16(11)
    );
\mem_in_q16_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(12),
      Q => mem_in_q16(12)
    );
\mem_in_q16_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(13),
      Q => mem_in_q16(13)
    );
\mem_in_q16_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(14),
      Q => mem_in_q16(14)
    );
\mem_in_q16_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(15),
      Q => mem_in_q16(15)
    );
\mem_in_q16_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(16),
      Q => mem_in_q16(16)
    );
\mem_in_q16_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(17),
      Q => mem_in_q16(17)
    );
\mem_in_q16_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(18),
      Q => mem_in_q16(18)
    );
\mem_in_q16_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(19),
      Q => mem_in_q16(19)
    );
\mem_in_q16_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(1),
      Q => mem_in_q16(1)
    );
\mem_in_q16_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(20),
      Q => mem_in_q16(20)
    );
\mem_in_q16_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(21),
      Q => mem_in_q16(21)
    );
\mem_in_q16_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(22),
      Q => mem_in_q16(22)
    );
\mem_in_q16_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(23),
      Q => mem_in_q16(23)
    );
\mem_in_q16_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(24),
      Q => mem_in_q16(24)
    );
\mem_in_q16_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(25),
      Q => mem_in_q16(25)
    );
\mem_in_q16_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(26),
      Q => mem_in_q16(26)
    );
\mem_in_q16_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(27),
      Q => mem_in_q16(27)
    );
\mem_in_q16_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(28),
      Q => mem_in_q16(28)
    );
\mem_in_q16_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(29),
      Q => mem_in_q16(29)
    );
\mem_in_q16_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(2),
      Q => mem_in_q16(2)
    );
\mem_in_q16_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(30),
      Q => mem_in_q16(30)
    );
\mem_in_q16_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(31),
      Q => mem_in_q16(31)
    );
\mem_in_q16_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(3),
      Q => mem_in_q16(3)
    );
\mem_in_q16_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(4),
      Q => mem_in_q16(4)
    );
\mem_in_q16_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(5),
      Q => mem_in_q16(5)
    );
\mem_in_q16_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(6),
      Q => mem_in_q16(6)
    );
\mem_in_q16_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(7),
      Q => mem_in_q16(7)
    );
\mem_in_q16_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(8),
      Q => mem_in_q16(8)
    );
\mem_in_q16_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => mem_in_q16_1,
      CLR => u_lif_n_0,
      D => s_axi_wdata(9),
      Q => mem_in_q16(9)
    );
s_axi_arready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \^s_axi_arready\,
      O => s_axi_arready0
    );
s_axi_arready_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => s_axi_arready0,
      Q => \^s_axi_arready\
    );
s_axi_awready_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_wvalid,
      I2 => \^s_axi_wready\,
      O => s_axi_awready0
    );
s_axi_awready_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => s_axi_awready0,
      Q => \^s_axi_wready\
    );
s_axi_bvalid_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80FF8080"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => s_axi_awvalid,
      I2 => \^s_axi_wready\,
      I3 => s_axi_bready,
      I4 => \^s_axi_bvalid\,
      O => s_axi_bvalid_i_1_n_0
    );
s_axi_bvalid_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => s_axi_bvalid_i_1_n_0,
      Q => \^s_axi_bvalid\
    );
\s_axi_rdata[0]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACC00"
    )
        port map (
      I0 => mem_in_q16(0),
      I1 => cur_q16(0),
      I2 => data0(1),
      I3 => s_axi_araddr(2),
      I4 => s_axi_araddr(3),
      O => \s_axi_rdata[0]_i_2_n_0\
    );
\s_axi_rdata[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => s_axi_araddr(1),
      I2 => s_axi_araddr(7),
      I3 => s_axi_araddr(6),
      I4 => s_axi_araddr(5),
      O => \s_axi_rdata[1]_i_3_n_0\
    );
\s_axi_rdata_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_32,
      Q => s_axi_rdata(0)
    );
\s_axi_rdata_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_22,
      Q => s_axi_rdata(10)
    );
\s_axi_rdata_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_21,
      Q => s_axi_rdata(11)
    );
\s_axi_rdata_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_20,
      Q => s_axi_rdata(12)
    );
\s_axi_rdata_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_19,
      Q => s_axi_rdata(13)
    );
\s_axi_rdata_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_18,
      Q => s_axi_rdata(14)
    );
\s_axi_rdata_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_17,
      Q => s_axi_rdata(15)
    );
\s_axi_rdata_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_16,
      Q => s_axi_rdata(16)
    );
\s_axi_rdata_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_15,
      Q => s_axi_rdata(17)
    );
\s_axi_rdata_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_14,
      Q => s_axi_rdata(18)
    );
\s_axi_rdata_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_13,
      Q => s_axi_rdata(19)
    );
\s_axi_rdata_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_31,
      Q => s_axi_rdata(1)
    );
\s_axi_rdata_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_12,
      Q => s_axi_rdata(20)
    );
\s_axi_rdata_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_11,
      Q => s_axi_rdata(21)
    );
\s_axi_rdata_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_10,
      Q => s_axi_rdata(22)
    );
\s_axi_rdata_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_9,
      Q => s_axi_rdata(23)
    );
\s_axi_rdata_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_8,
      Q => s_axi_rdata(24)
    );
\s_axi_rdata_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_7,
      Q => s_axi_rdata(25)
    );
\s_axi_rdata_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_6,
      Q => s_axi_rdata(26)
    );
\s_axi_rdata_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_5,
      Q => s_axi_rdata(27)
    );
\s_axi_rdata_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_4,
      Q => s_axi_rdata(28)
    );
\s_axi_rdata_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_3,
      Q => s_axi_rdata(29)
    );
\s_axi_rdata_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_30,
      Q => s_axi_rdata(2)
    );
\s_axi_rdata_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_2,
      Q => s_axi_rdata(30)
    );
\s_axi_rdata_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_1,
      Q => s_axi_rdata(31)
    );
\s_axi_rdata_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_29,
      Q => s_axi_rdata(3)
    );
\s_axi_rdata_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_28,
      Q => s_axi_rdata(4)
    );
\s_axi_rdata_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_27,
      Q => s_axi_rdata(5)
    );
\s_axi_rdata_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_26,
      Q => s_axi_rdata(6)
    );
\s_axi_rdata_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_25,
      Q => s_axi_rdata(7)
    );
\s_axi_rdata_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_24,
      Q => s_axi_rdata(8)
    );
\s_axi_rdata_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => s_axi_arready0,
      CLR => u_lif_n_0,
      D => u_lif_n_23,
      Q => s_axi_rdata(9)
    );
s_axi_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F44"
    )
        port map (
      I0 => \^s_axi_arready\,
      I1 => s_axi_arvalid,
      I2 => s_axi_rready,
      I3 => \^s_axi_rvalid\,
      O => s_axi_rvalid_i_1_n_0
    );
s_axi_rvalid_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => s_axi_rvalid_i_1_n_0,
      Q => \^s_axi_rvalid\
    );
start_pulse_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000200000000"
    )
        port map (
      I0 => s_axi_bvalid02_out,
      I1 => s_axi_awaddr(6),
      I2 => s_axi_awaddr(7),
      I3 => s_axi_awaddr(4),
      I4 => s_axi_awaddr(5),
      I5 => start_pulse_i_2_n_0,
      O => start_pulse1_out
    );
start_pulse_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000002"
    )
        port map (
      I0 => s_axi_wdata(0),
      I1 => s_axi_awaddr(2),
      I2 => s_axi_awaddr(1),
      I3 => s_axi_awaddr(3),
      I4 => s_axi_awaddr(0),
      O => start_pulse_i_2_n_0
    );
start_pulse_reg: unisim.vcomponents.FDCE
     port map (
      C => s_axi_aclk,
      CE => '1',
      CLR => u_lif_n_0,
      D => start_pulse1_out,
      Q => start_pulse
    );
u_lif: entity work.design_1_lif_step_0_0_lif_step
     port map (
      D(31) => u_lif_n_1,
      D(30) => u_lif_n_2,
      D(29) => u_lif_n_3,
      D(28) => u_lif_n_4,
      D(27) => u_lif_n_5,
      D(26) => u_lif_n_6,
      D(25) => u_lif_n_7,
      D(24) => u_lif_n_8,
      D(23) => u_lif_n_9,
      D(22) => u_lif_n_10,
      D(21) => u_lif_n_11,
      D(20) => u_lif_n_12,
      D(19) => u_lif_n_13,
      D(18) => u_lif_n_14,
      D(17) => u_lif_n_15,
      D(16) => u_lif_n_16,
      D(15) => u_lif_n_17,
      D(14) => u_lif_n_18,
      D(13) => u_lif_n_19,
      D(12) => u_lif_n_20,
      D(11) => u_lif_n_21,
      D(10) => u_lif_n_22,
      D(9) => u_lif_n_23,
      D(8) => u_lif_n_24,
      D(7) => u_lif_n_25,
      D(6) => u_lif_n_26,
      D(5) => u_lif_n_27,
      D(4) => u_lif_n_28,
      D(3) => u_lif_n_29,
      D(2) => u_lif_n_30,
      D(1) => u_lif_n_31,
      D(0) => u_lif_n_32,
      Q(31 downto 0) => mem_in_q16(31 downto 0),
      data0(0) => data0(1),
      done_sticky_reg => done_sticky_i_2_n_0,
      done_sticky_reg_0 => done_sticky_i_3_n_0,
      \mem_tmp_reg[31]_0\(31 downto 0) => cur_q16(31 downto 0),
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(7 downto 0) => s_axi_araddr(7 downto 0),
      s_axi_araddr_5_sp_1 => u_lif_n_33,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => u_lif_n_0,
      \s_axi_rdata_reg[0]\ => \s_axi_rdata[0]_i_2_n_0\,
      \s_axi_rdata_reg[0]_0\ => \s_axi_rdata[1]_i_3_n_0\,
      start_pulse => start_pulse
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_lif_step_0_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_lif_step_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_lif_step_0_0 : entity is "design_1_lif_step_0_0,lif_step_axi_lite,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_lif_step_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_lif_step_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_lif_step_0_0 : entity is "lif_step_axi_lite,Vivado 2023.2";
end design_1_lif_step_0_0;

architecture STRUCTURE of design_1_lif_step_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of s_axi_aclk : signal is "XIL_INTERFACENAME s_axi_aclk, ASSOCIATED_BUSIF s_axi, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  attribute X_INTERFACE_PARAMETER of s_axi_aresetn : signal is "XIL_INTERFACENAME s_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 s_axi ARREADY";
  attribute X_INTERFACE_INFO of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi ARVALID";
  attribute X_INTERFACE_INFO of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 s_axi AWREADY";
  attribute X_INTERFACE_INFO of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi AWVALID";
  attribute X_INTERFACE_INFO of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 s_axi BREADY";
  attribute X_INTERFACE_INFO of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi BVALID";
  attribute X_INTERFACE_INFO of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 s_axi RREADY";
  attribute X_INTERFACE_PARAMETER of s_axi_rready : signal is "XIL_INTERFACENAME s_axi, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 4, NUM_WRITE_THREADS 4, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi RVALID";
  attribute X_INTERFACE_INFO of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 s_axi WREADY";
  attribute X_INTERFACE_INFO of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 s_axi WVALID";
  attribute X_INTERFACE_INFO of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 s_axi ARADDR";
  attribute X_INTERFACE_INFO of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 s_axi AWADDR";
  attribute X_INTERFACE_INFO of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 s_axi BRESP";
  attribute X_INTERFACE_INFO of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 s_axi RDATA";
  attribute X_INTERFACE_INFO of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 s_axi RRESP";
  attribute X_INTERFACE_INFO of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 s_axi WDATA";
  attribute X_INTERFACE_INFO of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 s_axi WSTRB";
begin
  s_axi_awready <= \^s_axi_awready\;
  s_axi_bresp(1) <= \<const0>\;
  s_axi_bresp(0) <= \<const0>\;
  s_axi_rresp(1) <= \<const0>\;
  s_axi_rresp(0) <= \<const0>\;
  s_axi_wready <= \^s_axi_awready\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
inst: entity work.design_1_lif_step_0_0_lif_step_axi_lite
     port map (
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(7 downto 0) => s_axi_araddr(7 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(7 downto 0) => s_axi_awaddr(7 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_rdata(31 downto 0) => s_axi_rdata(31 downto 0),
      s_axi_rready => s_axi_rready,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_wdata(31 downto 0) => s_axi_wdata(31 downto 0),
      s_axi_wready => \^s_axi_awready\,
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
