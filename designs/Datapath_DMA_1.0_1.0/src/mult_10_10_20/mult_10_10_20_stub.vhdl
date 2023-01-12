-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Fri Jan  6 00:53:38 2023
-- Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/mult_10_10_20/mult_10_10_20_stub.vhdl
-- Design      : mult_10_10_20
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mult_10_10_20 is
  Port ( 
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 9 downto 0 );
    B : in STD_LOGIC_VECTOR ( 9 downto 0 );
    P : out STD_LOGIC_VECTOR ( 19 downto 0 )
  );

end mult_10_10_20;

architecture stub of mult_10_10_20 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,A[9:0],B[9:0],P[19:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "mult_gen_v12_0_18,Vivado 2022.1";
begin
end;
