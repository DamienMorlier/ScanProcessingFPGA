// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Jan  6 00:53:38 2023
// Host        : DESKTOP-9K6OHUL running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/SCAN/SCAN_VER2/ip_repo/Datapath_DMA_1.0_1.0/src/mult_10_10_20/mult_10_10_20_sim_netlist.v
// Design      : mult_10_10_20
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_10_10_20,mult_gen_v12_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_18,Vivado 2022.1" *) 
(* NotValidForBitStream *)
module mult_10_10_20
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
  (* C_LATENCY = "3" *) 
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
  mult_10_10_20_mult_gen_v12_0_18 U0
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
ZJv8wqkaP/jnFsXtNr6rTjqofNyz0BGQUs2QR29f4xFDOAXAfaGhz16Daxl1f1luj5JAfAfKh9tz
fiibentlnC6uvvBToXEjHyayLGtdlRJjoG2Wt6M560Mr5fcLXpIcuelJotPEofL9kYiKZ2jIaHO9
RwcR1HVuqMZSYbJZLSQ2GWOIcRhHbRianvwkYTodnHjuauv6HIgFvQRWPOy+jXL6+vNw6JSGavBr
uxCiA4eHI6i1zxX8FNH9y1tFkiuoNzcxN+nuy5jrSFN+Iz5WqKlGfMBYR4+VRw738sjFkjroLJRQ
nbkTNgc+H5O504wVuxgTeRjQE1b9pU3nkPvosA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TvYO6sbn+bA8RaOKp2A2/kMV2eWWhBN1KejXTYmEoXOnAhSztCGvUazN8FM/ADIr6yV0se3ra7gG
jiAWhG+1MaNMw+s64S37mzmHc5oJrlSPkGiYbVyt1O9Bc23/6JuHEmEzpvFnz9SPliJ3y4MmSU9P
MUWLBwqyrdNrscrLJgZ7PuJCyOdjfMPO8nmkjiO8Zlt7WjkIflIlQhDeN9ZGP3z/DzF4B/6l7jEV
gR13RkmoE7L7RCdIoCmlbIJ98am8htnUtkYr4X+5q7WLlCumN+rUogw5C8ZS3LwXyOWQx1q+KlDd
dslmPLb3Oqj6X+oyFU/YZK+l7ChRM2m3N6n8XA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 11136)
`pragma protect data_block
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
pSJim95lnnqT2cR3rFDg5tIt7h2o
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
