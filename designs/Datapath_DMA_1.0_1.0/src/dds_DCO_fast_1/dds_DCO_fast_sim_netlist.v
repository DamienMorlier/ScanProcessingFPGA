// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Wed Dec 28 17:53:34 2022
// Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/dds_DCO_fast_1/dds_DCO_fast_sim_netlist.v
// Design      : dds_DCO_fast
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "dds_DCO_fast,dds_compiler_v6_0_22,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dds_compiler_v6_0_22,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module dds_DCO_fast
   (aclk,
    aresetn,
    s_axis_config_tvalid,
    s_axis_config_tdata,
    m_axis_phase_tvalid,
    m_axis_phase_tdata);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF M_AXIS_PHASE:S_AXIS_CONFIG:M_AXIS_DATA:S_AXIS_PHASE, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 aresetn_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_CONFIG TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_CONFIG, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_config_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_CONFIG TDATA" *) input [31:0]s_axis_config_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_PHASE TVALID" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_PHASE, TDATA_NUM_BYTES 2, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 0, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.0, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_phase_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_PHASE TDATA" *) output [15:0]m_axis_phase_tdata;

  wire aclk;
  wire aresetn;
  wire [15:0]m_axis_phase_tdata;
  wire m_axis_phase_tvalid;
  wire [31:0]s_axis_config_tdata;
  wire s_axis_config_tvalid;
  wire NLW_U0_debug_axi_resync_in_UNCONNECTED;
  wire NLW_U0_debug_core_nd_UNCONNECTED;
  wire NLW_U0_debug_phase_nd_UNCONNECTED;
  wire NLW_U0_event_phase_in_invalid_UNCONNECTED;
  wire NLW_U0_event_pinc_invalid_UNCONNECTED;
  wire NLW_U0_event_poff_invalid_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_m_axis_data_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_data_tvalid_UNCONNECTED;
  wire NLW_U0_m_axis_phase_tlast_UNCONNECTED;
  wire NLW_U0_s_axis_config_tready_UNCONNECTED;
  wire NLW_U0_s_axis_phase_tready_UNCONNECTED;
  wire [0:0]NLW_U0_debug_axi_chan_in_UNCONNECTED;
  wire [15:0]NLW_U0_debug_axi_pinc_in_UNCONNECTED;
  wire [15:0]NLW_U0_debug_axi_poff_in_UNCONNECTED;
  wire [15:0]NLW_U0_debug_phase_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_data_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_data_tuser_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_phase_tuser_UNCONNECTED;

  (* C_ACCUMULATOR_WIDTH = "16" *) 
  (* C_AMPLITUDE = "0" *) 
  (* C_CHANNELS = "1" *) 
  (* C_CHAN_WIDTH = "1" *) 
  (* C_DEBUG_INTERFACE = "0" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_ARESETN = "1" *) 
  (* C_HAS_M_DATA = "0" *) 
  (* C_HAS_M_PHASE = "1" *) 
  (* C_HAS_PHASEGEN = "1" *) 
  (* C_HAS_PHASE_OUT = "1" *) 
  (* C_HAS_SINCOS = "0" *) 
  (* C_HAS_S_CONFIG = "1" *) 
  (* C_HAS_S_PHASE = "0" *) 
  (* C_HAS_TLAST = "0" *) 
  (* C_HAS_TREADY = "0" *) 
  (* C_LATENCY = "3" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MODE_OF_OPERATION = "0" *) 
  (* C_MODULUS = "9" *) 
  (* C_M_DATA_HAS_TUSER = "0" *) 
  (* C_M_DATA_TDATA_WIDTH = "1" *) 
  (* C_M_DATA_TUSER_WIDTH = "1" *) 
  (* C_M_PHASE_HAS_TUSER = "0" *) 
  (* C_M_PHASE_TDATA_WIDTH = "16" *) 
  (* C_M_PHASE_TUSER_WIDTH = "1" *) 
  (* C_NEGATIVE_COSINE = "0" *) 
  (* C_NEGATIVE_SINE = "0" *) 
  (* C_NOISE_SHAPING = "0" *) 
  (* C_OPTIMISE_GOAL = "0" *) 
  (* C_OUTPUTS_REQUIRED = "2" *) 
  (* C_OUTPUT_FORM = "0" *) 
  (* C_OUTPUT_WIDTH = "3" *) 
  (* C_PHASE_ANGLE_WIDTH = "3" *) 
  (* C_PHASE_INCREMENT = "1" *) 
  (* C_PHASE_INCREMENT_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_PHASE_OFFSET = "1" *) 
  (* C_PHASE_OFFSET_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" *) 
  (* C_POR_MODE = "0" *) 
  (* C_RESYNC = "0" *) 
  (* C_S_CONFIG_SYNC_MODE = "0" *) 
  (* C_S_CONFIG_TDATA_WIDTH = "32" *) 
  (* C_S_PHASE_HAS_TUSER = "0" *) 
  (* C_S_PHASE_TDATA_WIDTH = "1" *) 
  (* C_S_PHASE_TUSER_WIDTH = "1" *) 
  (* C_USE_DSP48 = "1" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  dds_DCO_fast_dds_compiler_v6_0_22 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(aresetn),
        .debug_axi_chan_in(NLW_U0_debug_axi_chan_in_UNCONNECTED[0]),
        .debug_axi_pinc_in(NLW_U0_debug_axi_pinc_in_UNCONNECTED[15:0]),
        .debug_axi_poff_in(NLW_U0_debug_axi_poff_in_UNCONNECTED[15:0]),
        .debug_axi_resync_in(NLW_U0_debug_axi_resync_in_UNCONNECTED),
        .debug_core_nd(NLW_U0_debug_core_nd_UNCONNECTED),
        .debug_phase(NLW_U0_debug_phase_UNCONNECTED[15:0]),
        .debug_phase_nd(NLW_U0_debug_phase_nd_UNCONNECTED),
        .event_phase_in_invalid(NLW_U0_event_phase_in_invalid_UNCONNECTED),
        .event_pinc_invalid(NLW_U0_event_pinc_invalid_UNCONNECTED),
        .event_poff_invalid(NLW_U0_event_poff_invalid_UNCONNECTED),
        .event_s_config_tlast_missing(NLW_U0_event_s_config_tlast_missing_UNCONNECTED),
        .event_s_config_tlast_unexpected(NLW_U0_event_s_config_tlast_unexpected_UNCONNECTED),
        .event_s_phase_chanid_incorrect(NLW_U0_event_s_phase_chanid_incorrect_UNCONNECTED),
        .event_s_phase_tlast_missing(NLW_U0_event_s_phase_tlast_missing_UNCONNECTED),
        .event_s_phase_tlast_unexpected(NLW_U0_event_s_phase_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata(NLW_U0_m_axis_data_tdata_UNCONNECTED[0]),
        .m_axis_data_tlast(NLW_U0_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(1'b0),
        .m_axis_data_tuser(NLW_U0_m_axis_data_tuser_UNCONNECTED[0]),
        .m_axis_data_tvalid(NLW_U0_m_axis_data_tvalid_UNCONNECTED),
        .m_axis_phase_tdata(m_axis_phase_tdata),
        .m_axis_phase_tlast(NLW_U0_m_axis_phase_tlast_UNCONNECTED),
        .m_axis_phase_tready(1'b0),
        .m_axis_phase_tuser(NLW_U0_m_axis_phase_tuser_UNCONNECTED[0]),
        .m_axis_phase_tvalid(m_axis_phase_tvalid),
        .s_axis_config_tdata(s_axis_config_tdata),
        .s_axis_config_tlast(1'b0),
        .s_axis_config_tready(NLW_U0_s_axis_config_tready_UNCONNECTED),
        .s_axis_config_tvalid(s_axis_config_tvalid),
        .s_axis_phase_tdata(1'b0),
        .s_axis_phase_tlast(1'b0),
        .s_axis_phase_tready(NLW_U0_s_axis_phase_tready_UNCONNECTED),
        .s_axis_phase_tuser(1'b0),
        .s_axis_phase_tvalid(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
tfAHA9n8XN2Xh7go7iKKsCi+fjLXTzeVO+u9hRh/13HVhOft/5bTNx9z66TBE9P9ekz5fgKMUFKZ
miSbzdR94KyO+M+HMot1DT4GWPkqaN36bXeUqnORLkGi+c2njYrYAoPUtdZKL5nINe8QDAUvveQd
z5gOHzGP7PgGdvSvEBM=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NK6Fb7SvtSctG3JErVMDM3lYRjQRSCmuIZK2Pk+3J3qszxxZSOMrFxjt7uC0QXQol0ftwAP2dIWX
hkHhcEg2x0Ec022z786VCW1yhDUNqBFR4P6rIB8JQDCOAiyI1dP82kWqzhfmQkVwQHUEbXBu2Yk+
mT8qHAaD1wAiOmcrA2B5/mgL1L6bNWDO8zTcdAO2/UN8AECXF/fRRn2kxx4OiE6rshejr3dtcgfP
RLzZVySO1OtS8NyVTI8Xvtb209YAtsexfdIIT98MxIfy5dGaUPXs0tse2/ASYoBmHEUjRlpMM2lb
JaUj+6NJf+XcnlMSVsNKRMYtWS98vmILHMBE3A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
ah0fMpxZf3XGe3JMPj4AqnuvLykykKII/nkPVLjlJjegFNgfVweKxbd3eN+Mcw+AOdBPIt2bn2ok
yWlg+s+JT4ejh5I78FszhnTfTxOFTbL9OuBRJcbTWtYAdlAcxx2GWL0R7CGCVExExzNYZ6HlsMBL
FrkauCNMqhbEAYttoJc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
b+nJBb4lckV2G25m9ulD/FXceQcibIehmjtoha3Y6gGEkx026f5+tcXFte+7J3mjaKz6yZ3/HDcU
Ty50vNKXQbVeqkiKbMUoRO9tV2Bm7Qt0VQ8cDUAcMnfY9cJcShvycUszMqpX1wDJTffVSdqKZI6Z
B17DiY23LTBwOOraOZIa/Ot10L2g0QqihCL3iAov0eXn4m9ogCI5ILEQNMQlXd6mRKiPmV9jgpnH
xXGYAi1ZZnOhUiLo7AYg2Lh7kt3QS3IbGPzeRejGXRYBsikuwXjobpyNjiLV/uB7TokfLM5T+MdL
eMFQ4nCc+IATee8R58X74lAciMpVXYblpnhjwQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oGscg7axCGXqLvoYAaxMyFMIN5jTPpsjJYMaDJ9rK+jSKOlsVIM0AEw9kliZVSERvWV+ayVEbnWw
tSeGcyM02Kix4DSXjWOCCfOmPzygfp5k2Z7rx5ilqDSQoK9NcgQ7C7isoRT+xlUT1QssqJtD9sVt
uE/TXJAsDSJJMrU04o9FX43ligH573+aWxhW6X6nOZQc6u14Z4+Jdnhh1VPN+0ZAEJ3ztVduFCj2
MS+FYogBjAk3TxVtzLJa0BVeB7BSvfhJVOolME4hMOPCBwBexLaCVT9AXhqyDfUz7DfLfQG8XMCv
OJckt8xXHGq2hdum669KnNTeDL5hl1qLAbDb5A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
S5Jyl+60lPi+QkZVOCU0+Uapa6PIeQ6xAZrCuYdCP/FPz3Veg1OiTcvrUFSJzuKcqU1rA9Mg/XBs
zg2wlAsf3OXrb7W0ldGBh60lVa/OiedOuUjavjZDdvzTYISRoxzWvAGzxlC8y9Ulx5696sXPL1Dj
Cd8qAHGS7zwr/SW9mN92R/BIMQ2A85QzZJ4Xyogfpluo06y+aQf04/kj5x4UxjXjU0w6cP4uCW/s
/f57Klmu/a9gpOYwJgdKXfZTKFsjx70g2tkE+aQhiYpQG6uhy5D5WNa9QtNQfY6xT9y8SgLBmW2V
bbHdw1zLueW7nizWJJvkNgXg8mjRVoyT7CZjTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IRbIH/TnpT04zWetOxh0aM7fy+w+kteBHB/Be/he01qOlK5GbEBomepRkasM6V8PC0dGuvvFxKQJ
6mu7P2oulvfPuPYOubp/7Z55CREn0CYfDRroOE4vVZehF0EQqAAIC3Xy/M+2HndTwbADzvnTECEV
BP9RjfUDPijQHjxsBX3usPJpdqoQFlqlQ5xYs/7Xcumiu3NyWre7q63J8EbBLqQictQK2wllAXgO
m1OaU91aYr88bGKZF2uYVc44N2TyA5pZgKJh8mn4woaSi62SaM34ufAiotjixgLRaew7gfyTwzcU
hwticvyPYE7y1XQ4e7/izwxRVhaL57qgajGMtQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
rTqrUiZPZRxkPmfgOMP0PPLbpK9Upy6xZN0Jbl1TLPOyMXBsIt34kyEy7Fg/eq8JIzbC0mt9WibE
ae8e3H7dWAnBKAhijwh5Kn5IDs9K3fxMp9sf4eTrbPOolPCZZHlypFsAa7c2/awf0LjJf2OTp6lZ
YHNRpe5G7P0bZG4FjAcKoGQUPyQlDBHVOOY2uxeHt8tpTHQp+mnGB+hD4fX+L2rPC2eXTbChQpJE
P1hDWM/WleyK42DzNLvXxw+lktRngKvtcNT3+j7GFUK939hLHuoPpaHCaFoacxuqH7qnV20RrweC
onAPh2RBrz1/W8GsVo37IDyXhvVJuJssKl8EDIxB/+vwGL4EUth+TZOxVypdLrM/zxcrA6bY367I
niBUHM3n3UObVgbtDALnWr8Q4JPkEKss2eSD/2SLxjS/GBNLf0GMyOtmuA7efO03bIcgVMTQ7Rke
mPWWLlz8DWhDvaqWteUNCV7U3r8BVBM9vBlorKpq8JapU4AmkeoRsJrL

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I2b0g2poYXiI+1nYIZN7M+EVNeIwePcvwlLcHJqJ272dQPzPw/j2uE28ssypQGts1QdsnnAAWzQI
gdNp1sNAM/k6JcKeRFaLIoMwCsycUBOoZb2zIF678H15ko9XmyjXl/xFwq1hgJ72anVMfwnw98iz
0/kBB1HItQ8PdQ9upoHL66pEZrjaCz3KNmaEQKqNhdcQfHW3eYVhrz8/j5Dkc+bXUqn+YwFtd1ez
ZwKdG4Zyz1Ygo0DG6KcfDnrtFs64iqnFZsl9csGSat8dgXQyundOJ8+giiupcGtz+1hCUrBFKvqy
jlqlFIFM2Rl2HLvFdzqZlxu4J+lj1tHOqTp3dg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BPXkS2y1DnEMgN4MHI58bbobxxIvTzhUfQ+8Dl7EjfLBklZzxAI3KBcAej0r6q9WMKnlVfHhTU3w
DA0KWqij2ALXnyvaWztzKBgmrPJGLd+BaiImj9FYRLrD6b9h636VuQzrYovgMDmbXLHF8oFhgVjl
zL8dqkVkz/xo/cAjb/2X6OPvianwLgodsjImXeYqKAB1u5HqUiHwkv5ch1OunNxtScJoqAbieAlB
6BF0t/WN79gXeLFAxY2G/UXwiDvGI23X6ZmTdwcesv1J/X+GnkPSk7XyGwDjOV79EplnpIGDD52q
UF6nnMbMHqvHDcAAfyolV0AMbrvvYq7+ODjmog==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
OdIGyDu7QzgTsISA79lQXsrkm0NYP+IkSQ7NniHMZOSAb1yFqnYbmvNTsgHwiGhyAppVpZn4HoH0
ymSfDAq+cZ4UfsjMihr6sdqi9QjAuou1RT4bHz0Tkym2sm+DFPeaOmnGv/m1LoUdsj+tn5M1ZMeu
nolvq5tdKZbjQjy1ohkqVhLLA01DlfaygHrnrGEwSe5Gem5ME7bog/DzUeG0iGaH4uQ+wFWCbeNX
ZvGkzlDIGohImsd96bnTc32CJicr6SeFptEUQmxwfJ7BXO5KxdVYJip9iyGsf+zHOq6CV9feOXC9
1bZs7/e+EfzMt1+IMn4HOul7bAgbHeL3NZzgxw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 51552)
`pragma protect data_block
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
K/a4j1Upnehk3LKAuZQ/zta7q56mDQoo
`pragma protect end_protected
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
