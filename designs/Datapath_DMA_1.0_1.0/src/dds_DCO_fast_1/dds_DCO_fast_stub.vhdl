-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
-- Date        : Wed Dec 28 17:53:34 2022
-- Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/dds_DCO_fast_1/dds_DCO_fast_stub.vhdl
-- Design      : dds_DCO_fast
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dds_DCO_fast is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_config_tvalid : in STD_LOGIC;
    s_axis_config_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_phase_tvalid : out STD_LOGIC;
    m_axis_phase_tdata : out STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end dds_DCO_fast;

architecture stub of dds_DCO_fast is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_config_tvalid,s_axis_config_tdata[31:0],m_axis_phase_tvalid,m_axis_phase_tdata[15:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "dds_compiler_v6_0_22,Vivado 2022.1";
begin
end;
