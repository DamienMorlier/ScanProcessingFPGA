// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Thu Dec  8 03:18:34 2022
// Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/SCAN/SCAN_VER2/ip_repo/Datapath_Pure_Slave_1.0/src/dds_DCO_slow/dds_DCO_slow_stub.v
// Design      : dds_DCO_slow
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dds_compiler_v6_0_22,Vivado 2022.1" *)
module dds_DCO_slow(aclk, s_axis_config_tvalid, 
  s_axis_config_tdata, m_axis_phase_tvalid, m_axis_phase_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_config_tvalid,s_axis_config_tdata[31:0],m_axis_phase_tvalid,m_axis_phase_tdata[15:0]" */;
  input aclk;
  input s_axis_config_tvalid;
  input [31:0]s_axis_config_tdata;
  output m_axis_phase_tvalid;
  output [15:0]m_axis_phase_tdata;
endmodule
