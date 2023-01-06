# Configuration

### Number of components

- Function generators: 24
- Channels: 12

## Syntax

- \<n> denotes any positive integer, 0, 1, 2, 3, ...
- \<f> denotes a floating point number
- \<s> denotes a string

## Generator

| Address | Arguments | Description |
| --- | --- | --- | 
| /generator/\<n>/frequency | <n: frequency> | Set the frequency [Hz] of the function generator \<n>. |
| /generator/\<n>/harmonic | <n: frequency> | Set the frequency [Hz] of the function generator \<n>. |
| /generator/\<n>/scale | <f: scale> | Set the scale of the function generator \<n>. [0 - 1] |
| /generator/\<n>/phase | <n: phase> | Set the phase of the function generator \<n>. [degrees] |
| /generator/\<n>/offset | <n: offset> | Set the offset of the function generator n. [-2^9:2^9-1] |
| /generator/\<n>/blanking | <n: width> <n: phase> | Sets the blanking of the function generator n. |
| /generator/\<n>/waveform | \<s> | Set the waveform of the function generator n. Can be set to "triangle", "sine", "square", "dc", "saw" |

## Wiring

| Address | Arguments | Description |
| --- | --- | --- |
| /wiring/<n: channel>/modifier | <n: B1> <n: b2> | Set wiring modifier coefficients |
| /wiring/<n: channel>/connection | <n: f1> <n: f2> <n: f3> | Connect the function generator f1, f2, and f3 to wiring channel. Set argument to "null" to not connect anything. |

# Description

## Function generator

There are 24 function generators in total which are numbered from 0 to 23. Among thme, function generators No.0 and 1 supports high frequency signal generation (1.526kHz - 20 MHz, 1.526 kHz of precision) but not capable of adding harmonics when the generator is set to "sine wave" mode. The remaining generators are low speed generators (0.15 Hz - 5 kHz, 0.1526 Hz in precision). Each function generator can be wired to multiple controller sockets. 

The parameter "frequency" indicates the frequency of the output signal. For high-speed function generators the unit of this parameter is kHz, while for the low-speed the unit is Hz. Any frequency value below the lower boundary will be considered as zero. The frequency will never go above the upper limit of the range of the function generator. 

The parameter "harmonic" functions as a frequency multiplier with a range of [0, 2^10 - 1], while 0 indicates the base frequency and the maximum for triple frequency. 

The parameter "offset" is the DC bias directly added to the output.

## Wiring

The connection matrix has 12 output channel and each of them functions as a specific controller signal as the table below shows. 

    0: X_mod    1: Y_mod    2: Z_mod    3: I_mod
    4: X_rot    5: Y_rot    6: Z_rot    7: Zoom
    8: H_pos    9: V_pos    A: H_blank  B: V_blank
    
    F: (null)

Each channel consists of two groups of parameters which can be described as Y = (f1 * B1) + (f2 + b2), where Y is the channel output, f1 and f2 are function generator input, and B1, B2 are constants. It is advised that f1, f2 are different generator output for better performance but you could still assign them to a same generator if you want. 
