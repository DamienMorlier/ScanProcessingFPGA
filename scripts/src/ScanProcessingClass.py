import pynq
import time
import matplotlib.pyplot as plt
import array as arr 
 
class DatapathDriver(pynq.DefaultIP):
    GEN_ROUTER_TABLE = [0x0, 0x0, # Router 0
                        0x0, 0x0, # Router 1
                        0x0, 0x0, # Router 2
                        0x0, 0x0, # Router 3
                        0x0, 0x0, # Router 4
                        0x0, 0x0, # Router 5
                        0x0, 0x0, # Router 6
                        0x0, 0x0, # Router 7
                        0x0, 0x0, # Router 8
                        0x0, 0x0, # Router 9
                        0x0, 0x0, # Router 10
                        0x0, 0x0] # Router 11
    if_running = False;
    def __init__(self,description):
        super().__init__(description=description)
    # Old version
    #bindto = ['xilinx.com:user:Datapath_Pure_Slave:2.0']
    
    # New version
    bindto = ['xilinx.com:user:Datapath_DMA:1.0']
    
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
        assert((Phase_or_Offset == 1 and -180 <= phaseOffsetValue <= 180) or (Phase_or_Offset == 0))
        val=self.read(0x18)
        if (Phase_or_Offset == 0): 
            # Offset
            bit_mask = 0xFFFF0000
            self.write(0x18,val & (bit_mask) | int(phaseOffsetValue))
        else: 
            # Phase shift in degrees [0, 360)
            bit_mask=0x0000FFFF
            self.write(0x18,val & (bit_mask) | (int(360 - phaseOffsetValue) << 16))
        return self.read(0x18)
    
    # Change the waveform of the signal
    # Waveform values can be found at the top of this file
    def changeWaveform(self,Waveform):
        val=self.read(0x0)
        bit_mask = 0xFFFFFE1F
        self.write(0x0,val & (bit_mask) | (Waveform << 5))
        return (self.read(0x0) & bit_mask) >> 5
    
    # Change the blanking phase
    def setBlankingPhase(self,blanking_phase):
        val=self.read(0x28)
        bit_mask = 0xFFFF0000
        self.write(0x28,val & (bit_mask) | blanking_phase)
        return (self.read(0x28) & 0x0000FFFF)

    # Change the blanking width
    def setBlankingWidth(self,blanking_width):
        val=self.read(0x28)
        bit_mask = 0x0000FFFF
        self.write(0x28,val & (bit_mask) | blanking_width)
        return (self.read(0x28) & 0xFFFF0000)
    
    # Asynchronously Reset Phase
    def arstPhase(self):
        val = self.read(0x0)
        self.write(0x0, val | 0x80000000)
        time.sleep(1)
        self.write(0x0, val & 0x7FFFFFFF)
    
    # Get the output of a specified function generator
    def readSpecifiedFuncGen(self):
        bit_mask = 0x3FF00000
        return (self.read(0x20) & bit_mask) >> 20
    
    # Check if a certain generator has no more ports to connect
    def chkIfGenUsedUp(self, nGen):
        check = 0
        mask = 1 << int(nGen)
        for i in range(24):
            if(self.GEN_ROUTER_TABLE[i] & mask >= 1):
                check = check + 1
        return (check >= 24)
        
    #################################################################
    # Connection Matrix Configurations
    
    # Exit configurating matrix routers
    def Wiring_Modifier_Deactive(self):
        self.write(0xC,0x00000000)
        return self.read(0xC)
    
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
    def Wiring_Modifier_Enabler(self, Channel, Mult_or_Add_coeff):
        assert ((0 <= Channel <= 11 or Channel == 0xF) and (Mult_or_Add_coeff == 0 or Mult_or_Add_coeff == 1))
        if (Channel != 0xF):
            Wiring_Modifier_En = 0x1 << (2 * Channel + Mult_or_Add_coeff)
        else:
            Wiring_Modifier_En = 0x0
        self.write(0xC,Wiring_Modifier_En)
        self.Wiring_Modifier_Deactive()
        return self.read(0xC)
    
    # An unsafe enabler. Need a deactive after execution manually
    def Wiring_Modifier_Enabler_Unsafe(self, Channel, Mult_or_Add_coeff):
        assert ((0 <= Channel <= 11 or Channel == 0xF) and (Mult_or_Add_coeff == 0 or Mult_or_Add_coeff == 1))
        if (Channel != 0xF):
            Wiring_Modifier_En = 0x1 << (2 * Channel + Mult_or_Add_coeff)
        else:
            Wiring_Modifier_En = 0x0
        self.write(0xC,Wiring_Modifier_En)
        return self.read(0xC)
    
    # Choose which function generator is to be routed
    # 24 function generators in total, and wiring_modifier_param in [0,23]
    def Wiring_Modifier_Param(self, Channel, Mult_or_Add_coeff, nGen):
        assert(24 > int(nGen) >= 0)
        if (int(nGen) < 24): 
            bit_Wiring_Modifier_Param = 0x1 << int(nGen)
        else:
            bit_Wiring_Modifier_Param = 0x1 << 31
        self.write(0x10,bit_Wiring_Modifier_Param)
        self.GEN_ROUTER_TABLE[Channel * 2 + Mult_or_Add_coeff] = bit_Wiring_Modifier_Param
        self.Wiring_Modifier_Enabler(Channel, Mult_or_Add_coeff)
        self.write(0x10,0)
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
        assert ((0 <= Channel <= 11 or Channel == 0xF) and (Mult_or_Add_coeff == 0 or Mult_or_Add_coeff == 1))
        self.Wiring_Modifier_Enabler_Unsafe(Channel, Mult_or_Add_coeff)
        # Generator mapping protection
        self.write(0x10,self.GEN_ROUTER_TABLE[2 * Channel + Mult_or_Add_coeff])
        
        self.P_Param_sel(1)
        if(Mult_or_Add_coeff == 0):
            self.P_MULT_IN(int(Value))
        else:
            self.P_ADD_IN(int(Value))
        self.P_Param_sel(0)
        
        # Enable writing-in
        self.Wiring_Modifier_Deactive()
        self.write(0x10,0)
        
        
    # Get X coordinator
    def readX(self):
        bit_mask = 0x000003FF
        return self.read(0x20) & bit_mask
    
    # Get Y coordinator
    def readY(self):
        bit_mask = 0x000FFC00
        return (self.read(0x20) & bit_mask) >> 10
    
    # Read the pixel color RGB data
    def readHDMIin(self):
        return self.read(0x1C)
    
    # Set frame address bias
    def buffAddrBiasSet(self, frame):
        frame_address = int(frame.device_address)
        self.write(0x24, frame_address)
        return frame_address
        
    
    # Write X, Y and Color data
    def writeXYRGB(self, X, Y, RGB):
        if(X < 0): X = 0
        if(Y < 0): Y = 0
        # RGB should be an [8b, 8b, 8b] array
        # Write XY
        XY = int(int(X) + int(Y * 2 ** 10)) & 0xffffff
        #print("XY = " + str(hex(XY)))
        # Write Color
        Color = int(RGB[0]) * 2 ** 16 + int(RGB[1]) * 2 ** 8 + int(RGB[2])
        #print("Color = " + str(hex(Color)))
        self.write(0x20, XY)
        self.write(0x1C, Color)
        return
    
    ##################################################################
    # Plot helpers
    #
    def plotX(self):
        x_axis = arr.array('i',[])
        y_axis = arr.array('i',[])
        length = 100
        for i in range(length):
            x_axis.append(i)
            y_axis.append(self.readX())

        # plotting the points 
        plt.figure(figsize=(15,5))
        plt.plot(x_axis, y_axis, "-")
        plt.xlim(0, length)
        plt.ylim(0, 1024)
        plt.axhline(y = 640, color = 'b', label = 'X boundary')
        # naming the x axis
        plt.xlabel('n of samples')
        # naming the y axis
        plt.ylabel('X-output')

        # giving a title
        plt.title('X-output Scope')

        # function to show the plot
        plt.show()

    def plotY(self):
        x_axis = arr.array('i',[])
        y_axis = arr.array('i',[])
        length = 100
        for i in range(length):
            x_axis.append(i)
            y_axis.append(self.readY())

        # plotting the points 
        plt.figure(figsize=(15,5))
        plt.plot(x_axis, y_axis, "-")
        plt.xlim(0, length)
        plt.ylim(0, 1024)
        plt.axhline(y = 480, color = 'b', label = 'Y boundary')
        # naming the x axis
        plt.xlabel('n of samples')
        # naming the y axis
        plt.ylabel('Y-output')

        # giving a title
        plt.title('Y-output Scope')

        # function to show the plot
        plt.show()
        
    def plotXY(self, length):
        x_axis = arr.array('i',[])
        y1_axis = arr.array('i',[])
        y2_axis = arr.array('i',[])
        for i in range(length):
            x_axis.append(i)
            y1_axis.append(self.readX())
            y2_axis.append(self.readY())

        # plotting the points 
        plt.figure(figsize=(15,5))
        plt.plot(x_axis, y1_axis, "-")
        plt.plot(x_axis, y2_axis, ".")
        # naming the x axis
        plt.xlabel('n of samples')
        # naming the y axis
        plt.ylabel('XY-output')

        # giving a title
        plt.title('XY-output Scope')

        # function to show the plot
        plt.show()
