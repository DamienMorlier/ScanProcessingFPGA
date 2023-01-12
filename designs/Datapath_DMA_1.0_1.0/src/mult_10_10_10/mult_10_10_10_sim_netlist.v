// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Thu Jan  5 21:28:31 2023
// Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/mult_10_10_10/mult_10_10_10_sim_netlist.v
// Design      : mult_10_10_10
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_10_10_10,mult_gen_v12_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_18,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module mult_10_10_10
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [9:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [9:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [19:0]P;

  wire [9:0]A;
  wire [9:0]B;
  wire CLK;
  wire [19:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "10" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "10" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "19" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  mult_10_10_10_mult_gen_v12_0_18 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2022.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
t16GlZFP6wSHOfCuAKBB/aPhRt430na0RFcw9RLqLlFnTIXf0J5icL3Tu/TFzA59bhtk+ZNdlj7F
7orXq0M9haENsb+TBIeK/GuLcI1S2IEIkFVmtIvegJBlN3srdWrLqI/AyFdszg5PkZrzXG88Xc2b
2WO3QwoaFVIK/AojhI0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UtSqlFV62lL0vsa+Fh+XV0GodQOhNU+6dPw5SjSuv0OvMPVTZXVGpv55T6fELMTk959mSyk6Ry8g
0O9Y+nqYj7I0zkNLWT7cwBX+iLCmX2JSQo0kktzf26plrcNa51Bs4Rbc4NpXOM0qb4rXVuoKypyP
HSgLU/Y/LJXF61+xWUxlO/iS23d098gIYO7aX1Nz0Zpxw9ecqpaiqqmINjKd7+FoOYwpOnngiAXz
pOgYfhxk1ISU+bUSjZjeDoP7g1lNCWE31RTqWkWQGF10aXAKjpV/urSILMIltA6tEQlYe504jcmA
K6CG5Be/e48W9rZhr524SoZsyb09Xu0ljFmYyw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
s9gMEzowcFxkq1MbQ+ohDFKy7tBz/pLyjan2X3aZrppPTnWFYxUwzBEF/ro/EfUUM8uTCttMSXmu
O+6LCUK5jgPjkaMWPsMS55hYAR6EBnyybIWMRKkzEnFIHYmOxoJXN6aejqQdGAJpk/GM0k2kE/2C
QJ0emaNzqpUFy8zVyD8=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a0jBWiKNqZ7hnx/6B7nI5ufxVeaI4NzBKnxHHL8rwEz+qZ6mQupkBL3OTKmXAoK5zM5zDX0BoIdg
g+qNbp2F/8a5NuDvQMSkFxXdX7tOsauze3WM5EFttlHDYHZKU6UpAJzbezDElKw67YmPdL2ias/f
cSf3Fsh+XYTJ2zk/Aki0aFTehgi8L4XtguQEsT9XeeJ+tXYAZohSNP/ZXyhbkIW1mpV3SlcC1dRy
fSbB/vnosDy99WZN5QQbdfYRLfBvXzklzldu53DJpWg3jshPotjjSI5uzp9DlhnDpOfdwh9CxlWq
JE6qCDbRp5l1ZZOW0Ts19+g/aN9sVzjbQ4oDlA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
qAarq/HXu81d0yuylcPPXIPWsCCc2TC6LAm/TCo4PR7216jMtwG+SOM1+zlbzk5Kpoch2SxtyiyE
5sK7WhCCZrOW1iGC/V20t18okkAYc4u3L4md0H66B/+eKmZgbzcFSwiDhMJoBwjF2zjk2TM4Bm93
BlxsT6IQkVfY9OKxz3GKD18ZjGSQJb5rVaf/7yNlHKzsG7Zc5elrKUlCAelqg//v1qERxc0ZG5Mj
w9CJUiyPyaJZc6G+R+HfcZEK0Fuzs6xXGFnB6brHur9bHoCc0zmUXG+id4uvtFlqHTuH9Q8Ki3tS
3rXAl0lciyqfBhhsnTnP0yNu1Nj58S3wQZETeQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_07", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
m+BUnInKIetlcLwW5iyofYSLsTDcXRlNB6pr6H27L0tCYqG/fBmMFNiAUrJVb1hcbAOcDFCc5rjd
xA3xq3XzBTBLb5c6E202/xQvY32FumZ7gT+LPjb38Dqx7+alozDd+UEUruhrn6Sf4y8lmFklMZwW
a+Mf69X3eouV8s/54pNM77bHRMFHIqgva8hdzjjPB4kd8LddABMlTi3n2xgGCzXS8TAAAInPnR91
J9/U+l7mZ2BaratH/KLMMYOyoh4VmQUGPqHz2qXcCqu5CgODCZd5pkhugY9ByDQjLYVnmlxFG9Kc
4zXrtf2d25q9Kn9btoNwzwELaiybU8i6WgtJxg==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
nSH0KxJSxKPrCObmIHBcS8P1BA8mMtMKqPe8mvzoRbgsm/8Hz3rOL+ObP57qGSnFfseFbJy9iUl4
6EJIYYkZ94Q6lS6wsmymnSoy+vX3DDIbRcxWwZa8R3Zi3CDJdN+2l8QTxVl+S9SKUWPl1QseYb7V
bEl29QVgno6+ByYpHrXetmxVyG9o+GqR7GXlr/EZDwiUB/mB2Vyy7uNdZ/Fr9y/FsEphy+7K2lIx
nszpEPcZoKK2zlEs9wAnacKPuzf2VujZw4paW7aIhaUZlfzpP97rwUq4nCcDhV+xfol9uV1ThT1+
ZpLPKV9L6J7YIr0IXR65jxMP75KM36Wmqsns4g==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gpqCjOGJ637kBUJ19PgbSJOhTU2E6DfZTimxleISPs9RU7JykCGy9SPqx5xyVl3r6c6UYgi5hKNu
BVJDY+U9sVxwTjIgNs7zH/d8a5TQkliqDGq/Y/imWwPXYCADds3+N4PR+uXE+Ul2KsnNQP/gHXdU
ycgvwzTDcsyE+cntZUH35EtHyv2IvPhE9aJb1ZPvCY3uR1kG6KQwF10Ww7LEKRWTr5oMxz/R0s35
M833FVtkrZ9uTzKLa4Joo8ARMQx66IAKO6CKl30kcdr6kGrVWo8ArEB8h/7amQkkEKGVq/D0sTHK
2uHyOt6xvSrj6l9Hae1Sd1o6qu4mcFIsIacU+BJLJXt8FwLu6oobnGTewU+GNlAqvMxjdly3MScb
LDBHIzqAlqgCo2w4/I5QLKRCErydKjZ/8en4d1c22Zr89egLY08IctZj0FJ+GBh8Z04DzVom/E8V
CsPGJD1cFSZfb2/Uu9L3NPANh/eOGvxqlVycjSoPL4y/QjfdEZkR1djC

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Lzl+f5a5cWrBOpktelLybDJh26zODO1cHXsoEd4TW3dG5VAyRkeqtbBdb2PUWyKp7FY1uPuLyZog
BI9Pe1gS/m4LY6swFIngwuj94CQmLxPk9/yO7WrUCtlvlQrzSmQfxSpsqripZlybkc1jfloeNkb5
FoKJ9ORCPnEzASlhTb7+ZNMpY3FSm46yfpRyBw9OylwmX7enBBmMuxzGgVilSG1Zb2pCbJuWdplU
vc0acLwej8Ct03etO29l9Voikk1nGEBCUDPO/RrHuTvxnv0uruDhViyY/1Aq27n3r9qK1Ii5IGRY
t8uLW08VQmUHPHrU/dETI3BxChGHPvbitgbnkQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WaY4ULGrragIcSkW40aFJTOwysFlz5/dZfzIoWqdrpoL/6pl9dNg4L/t7Ol+Se9ddoVBW6ZPF8Vu
3gNi6CmpveiRFUlqRWRaFqyekLLBIj17PCu+mMYA51Sti7Vng+Bx8dbiED96TaNUflJNLu03omxU
Nd/GTA7QrExNgsUDcP1qNLZ78lwK2W6j7ykaGGkskxdLKZrQZq++OX6WwoX8USVMqtBtBFBdm6+M
ci1MZfHERmE95d8K/kNXy6JHs4UeLUAQDcD9bXSAZBxUg6fT3u41JOXuIe4lzqMTtbgNcnmkxEw4
S6i4uVXcZAZQAT1W2lJViC/qjB4DysgYpNo91A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a/poQHNCNCV2ZLv/I/I9H1zlCUFzT9Cox7+GuaspHMgdDVZpfxbnOyx8d5N/3+YMlw9I1rUJnlNN
RTYUk5jEhlrefqiXXUgRzl+rzMZyoTc5rvgSicLT6bRutzU+ONVQgsU2ZgFUzyA2+EjrvmC/gPVl
J7U+4KxMATbliEuikotBayp5q27A2VhsSAE7OMZ9OIUVIpQQaIaJDDSf0T1KJCqrvaersmTZ85sl
pGE4Yut5+e6GmBXJzvZDTPkiJAU41M9zlCUZ4N2EaAcPfJOEw87EBfUxJpW3ls7Suh+/t4O+txT/
1oww5nL+PYAjVhJeJ1btNh265vV/a0u69MMsOw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11168)
`pragma protect data_block
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
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
