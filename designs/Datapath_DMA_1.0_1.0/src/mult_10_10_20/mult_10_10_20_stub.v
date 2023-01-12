// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jan  6 00:53:38 2023
// Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/mult_10_10_20/mult_10_10_20_stub.v
// Design      : mult_10_10_20
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_18,Vivado 2022.1" *)
module mult_10_10_20(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[9:0],B[9:0],P[19:0]" */;
  input CLK;
  input [9:0]A;
  input [9:0]B;
  output [19:0]P;
endmodule
