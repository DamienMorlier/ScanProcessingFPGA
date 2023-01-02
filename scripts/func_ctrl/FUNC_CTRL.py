import pynq as pynq

# Waveform Parameters
DC = 0x1 << 3
TRI = 0x1 << 2
SQU = 0x1 << 1
SIN = 0x1
SAW = 0x0

class DatapathDriver(pynq.DefaultIP):
    def __init__(self,description):
        super().__init__(description=description)
    bindto = ['xilinx.com:user:Datapath_Pure_Slave:1.0']
    
    #################################################################
    # Connection Matrix Configurations
    
    # Select the function generator you want to configure. Currently supports 
    # 24 function generators in total, while Gen0 and Gen1 support [0.001, 100] MHz 
    # frequency, and the others within [0, 5000] Hz. 
    # FuncGenID: index of the expected function generator, range[0, 23]
    #
    # IT IS HIGHLY RECOMMENDED THAT FUNCTION GENERATOR SET TO A VALUE OUT OF THE
    # VALID RANGE OR USE deselectFuncGen AFTER CONFIGURATIONS IN CASE 
    # CHANGING THE PARAMETERS UNINTENTIONALLY
    def selectFuncGen(self,FuncGenID):
        assert(0 <= int(FuncGenID))
        val= self.read(0x0)
        bit_mask = 0xFFFFFFE0
        self.write(0x0,val &(bit_mask) | int(FuncGenID))
        return self.read(0x0)
    
    # Exit configuring function generators
    def deselectFuncGen(self):
        val= self.read(0x0)
        bit_mask = 0xFFFFFFE0
        self.write(0x0,val &(bit_mask) | 31)
        return self.read(0x0)
    
    # Set the frequency of the specified function generator.
    def setFrequency(self, freqValue):
        val=self.read(0x4)
        bit_mask = 0xFFFF0000
        self.write(0x4,val &(bit_mask) | int(freqValue))
        return self.read(0x0)
    
    # Harmonic or scale settings
    def setScale(self, ScaleMode, scaleValue):
        assert(ScaleMode == 0 or ScaleMode == 1)
        val=self.read(0x14)
        if (ScaleMode == 0): 
            # Choose to modify added harmonics
            bit_mask = 0xFFFF0000
            self.write(0x14,val & (bit_mask) | int(scaleValue * 2 ** 16))
        else: 
            # Choose to modify the output scale
            bit_mask=0x0000FFFF
            self.write(0x14,val & (bit_mask) | (int(scaleValue * 2 ** 15) << 16))
        
        return self.read(0x14) & ~(bit_mask) >> (16 * ScaleMode)
    
    # Phase or offset settings
    def setPhaseOffset(self, Phase_or_Offset, phaseOffsetValue):
        assert((Phase_or_Offset == 1 and 0<= phaseOffsetValue < 360) or (Phase_or_Offset == 0))
        val=self.read(0x18)
        if (Phase_or_Offset == 0): 
            # Offset
            bit_mask = 0xFFFF0000
            self.write(0x18,val & (bit_mask) | int(phaseOffsetValue))
        else: 
            # Phase shift in degrees [0, 360)
            bit_mask=0x0000FFFF
            self.write(0x18,val & (bit_mask) | (int(phaseOffsetValue) << 16))
        return self.read(0x18)
    
    # Change the waveform of the signal
    # Waveform values can be found at the top of this file
    def changeWaveform(self,Waveform):
        val=self.read(0x0)
        bit_mask = 0xFFFFFE1F
        self.write(0x0,val & (bit_mask) | (Waveform << 5))
        return (self.read(0x0) & bit_mask) >> 5
    
    # Get the output of a specified function generator
    def readSpecifiedFuncGen(self):
        bit_mask = 0x3FF00000
        return (self.read(0x20) & bit_mask) >> 20
        
    #################################################################
    # Connection Matrix Configurations
    
    # Choose which channel to configure
    # There are 12 channels in total as listed below: 
    '''
    0: X_mod    1: Y_mod    2: Z_mod    3: I_mod
    4: X_rot    5: Y_rot    6: Z_rot    7: Zoom
    8: H_pos    9: V_pos    A: H_blank  B: V_blank
    
    F: (null)
    '''
    # And each channel has two sub channels, one goes into the multiplier 
    # and another into the adder. 
    # Channel: specify which channel you want to change
    # Mult_or_Add_coeff: specify which way the generator signal goes in, 
    #     0 for multiplier, and 1 for adder
    #
    # IT IS HIGHLY RECOMMENDED TO SET CHANNEL TO 0xF OR USE 
    # Wiring_Modifier_DeactiveFOR SAFETY IN CASE
    # CHANGING THE PARAMETERS UNINTENTIONALLY. 
    def Wiring_Modifier_Enabler(self, Channel, Mult_or_Add_coeff):
        assert ((0 <= Channel <= 0xB or Channel == 0xF) and (Mult_or_Add_coeff == 0 or Mult_or_Add_coeff == 1))
        if (Channel != 0xF):
            Wiring_Modifier_En = 1 << (2 * Channel + Mult_or_Add_coeff)
        else:
            Wiring_Modifier_En = 0
        self.write(0xC,Wiring_Modifier_En)
        return self.read(0xC)
    
    # Exit configurating matrix routers
    def Wiring_Modifier_Deactive(self):
        self.write(0xC,0x0000)
        return self.read(0xC)
    
    # Choose which function generator is to be routed
    # 24 function generators in total, and wiring_modifier_param in [0,23]
    #
    # IT IS HIGHLY RECOMMENDED USE 
    # Wiring_Modifier_Deactive FOR SAFETY IN CASE
    # CHANGING THE PARAMETERS UNINTENTIONALLY. 
    def Wiring_Modifier_Param(self, Channel, Mult_or_Add_coeff, nGen):
        assert(24 > int(nGen) >= 0)
        self.Wiring_Modifier_Enabler(Channel, Mult_or_Add_coeff)
        if (int(nGen) < 24): 
            bit_Wiring_Modifier_Param = 1 << int(nGen)
        else:
            bit_Wiring_Modifier_Param = 1 << 31
        
        self.write(0x10,bit_Wiring_Modifier_Param)
        return self.read(0x10)
    
    # Param settings (aux functions)
    # Param configuration ctivated when P_Param_SEL is high
    def P_Param_sel(self,P_Param_SEL):
        val=self.read(0x0)
        bit_mask=0xFFFFFEFF
        self.write(0x0,val & (bit_mask) | (P_Param_SEL << 9))
        
    def P_ADD_IN(self,P_ADD_IN):
        val=self.read(0x0)
        bit_mask=0xC00FFFFF
        self.write(0x0,val & (bit_mask) | (P_ADD_IN << 20))
    
    def P_MULT_IN(self,P_MULT_IN):
        val=self.read(0x0)
        bit_mask=0xFFF003FF
        self.write(0x0,val & (bit_mask) | (P_MULT_IN << 10))
        
    # Param settings
    # Channel: specify which channel you want to change
    # Mult_or_Add_coeff: specify which way the generator signal goes in, 
    #     0 for multiplier, and 1 for adder
    # Parameters above are of same meanings with that of Wiring_Modifier_Enabler function.
    # Please refer to the comment of Wiring_Modifier_Enabler for details
    # Value: value the coefficient to be set to 
    def paramConf(self, Channel, Mult_or_Add_coeff, Value):
        self.Wiring_Modifier_Enabler(Channel, Mult_or_Add_coeff)
        self.P_Param_sel(1)
        if(Mult_or_Add_coeff == 0):
            self.P_MULT_IN(int(Value))
        else:
            self.P_ADD_IN(int(Value))
        self.P_Param_sel(0)
    
    # Get X coordinator
    def readX(self):
        bit_mask = 0x000003FF
        return self.read(0x20) & bit_mask
    
    # Get X coordinator
    def readY(self):
        bit_mask = 0x000FFC00
        return (self.read(0x20) & bit_mask) >> 10
    
    # Write back the specified pixel color RGB data
    def sendHDMIin(self,HDMI_VIDEO_PIXEL):
        self.write(0x1C,HDMI_VIDEO_PIXEL)
        return self.read(0x1C)
    
    # Use the pixel channel temporarily for X, Y and I output,
    # Rout <= X, Gout <= Y, Iout <= I
    def sendXYIin(self, X, Y, I):
        self.write(0x1C, X << 16 + Y << 8 + I)
    