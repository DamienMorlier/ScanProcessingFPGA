library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--use work.all;


entity FunctionGenerator is 
    generic(
        DATA_WIDTH :integer
    );
    port(
        clk                             : in std_logic;
        reset                           : in std_logic;
        ctr_Scanner_Sync                : in std_logic; --/Sync
        ctr_Scanner_Switch              : in std_logic;
        ctr_Scanner_External_RAMP_IN    : in std_logic_vector(DATA_WIDTH-1 downto 0);--External Ramp in
        ctr_Scanner_Frequency           : in std_logic_vector(DATA_WIDTH-1 downto 0); --/Frequency
        ctr_Scanner_Scale1              : in std_logic_vector(DATA_WIDTH-1 downto 0);--/Harmonic
        ctr_Scanner_Scale2              : in std_logic_vector(DATA_WIDTH-1 downto 0);--/Scale
        ctr_Scanner_PhaseOff1           : in std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift1(Offset)
        ctr_Scanner_PhaseOff2           : in std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift2(Phase)
        ctr_Scanner_Waveform            : in std_logic_vector(3 downto 0);--/Waveform
        ctr_DCO_OUT                     : out std_logic_vector(DATA_WIDTH-1 downto 0);--Saw Wave out
        ctr_Intensity_OUT               : out std_logic_vector(DATA_WIDTH-1 downto 0);--??
        ctr_Bipolar_OUT                 : out std_logic_vector(DATA_WIDTH-1 downto 0)--Desired Wave out
    );
end FunctionGenerator;

architecture behaviour of FunctionGenerator is
    component Register_1
    generic(
        DATA_WIDTH : integer
    );
    port(clk : in  std_logic;
        shift_in           : in  std_logic_vector (DATA_WIDTH downto 0);
        shift_out          : out std_logic_vector (DATA_WIDTH downto 0)
        );
    end component;
    component DCOPhaser
        generic(
            DATA_WIDTH : integer
        );
        port(
            reset                       : in std_logic;
            clk                         : in std_logic;
            ctr_DCO_Phaser_sync         : in std_logic;
            ctr_DCOPhaser_frequency     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_DCOPhaser_output        : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component Switch 
        generic(
            DATA_WIDTH : integer
    
        );
        port(
            ctr_DCO_OUT                     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Scanner_External_RAMP_IN    : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Switch_In                   : in std_logic; --Don't forget to have the xdc file
            ctr_Switch_Out                  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component Offset
        generic(
            DATA_WIDTH : integer
        );
        port(
            ctr_Offset_input    : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Offset_val      : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Offset_output   : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    
        
        
    end component;

    component scaling
        generic(
            DATA_WIDTH : integer
        );
        port(
            ctr_Scale_input     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Scale_value     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Scale_output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component waveshaping
        generic(
            DATA_WIDTH : integer
        );
        port(
            clk                         : in std_logic;
            ctr_Waveshaping_waveform    : in std_logic_vector(3 downto 0);
            ctr_Waveshaping_input       : in std_logic_vector(DATA_WIDTH-1 downto 0);
            ctr_Waveshaping_output      : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;


signal ctr_FuncGen_Saw          : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_SwitchOut    : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_Offset1      : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_Offset2      : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_Scale1       : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_Scale2       : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_WaveShaping : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_RegisterOut1 : std_logic_vector(DATA_WIDTH-1 downto 0);
signal ctr_FuncGen_RegisterOut2 : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    RAMP : component DCOPhaser 
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        reset                   =>      reset,
        clk                     =>      clk,
        ctr_DCO_Phaser_sync     =>      ctr_Scanner_Sync,
        ctr_DCOPhaser_frequency =>      ctr_Scanner_Frequency,
        ctr_DCOPhaser_output    =>      ctr_FuncGen_Saw        

    );
    SWITCH_1 : component Switch
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        ctr_DCO_OUT                     => ctr_FuncGen_Saw,
        ctr_Scanner_External_RAMP_IN    => ctr_Scanner_External_RAMP_IN,
        ctr_Switch_In                   => ctr_Scanner_Switch,                   
        ctr_Switch_Out                  => ctr_FuncGen_SwitchOut               
    );
    OFFSET_1 : component Offset 
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        ctr_Offset_input    => ctr_FuncGen_SwitchOut,
        ctr_Offset_val      => ctr_Scanner_PhaseOff1,
        ctr_Offset_output   => ctr_FuncGen_Offset1
    );
    REGISTER_0 : component Register_1
        generic map(
            DATA_WIDTH => DATA_WIDTH
        )
        port map(
            clk => clk,
            shift_in => ctr_FuncGen_Offset1,
            shift_out => ctr_FuncGen_RegisterOut1
        );
    SCALE_1 : component scaling
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        ctr_Scale_input    => ctr_FuncGen_RegisterOut1,
        ctr_Scale_value    => ctr_Scanner_Scale1,
        ctr_Scale_output   => ctr_FuncGen_Scale1

    );

    WAVESHAPE : component waveshaping
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        clk                         => clk,
        ctr_Waveshaping_waveform    => ctr_Scanner_Waveform,
        ctr_Waveshaping_input       => ctr_FuncGen_Scale1,
        ctr_Waveshaping_output      => ctr_FuncGen_WaveShaping
    );

    REGISTER_2 : component Register_1
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        clk => clk,
        shift_in => ctr_FuncGen_WaveShaping,
        shift_out => ctr_FuncGen_RegisterOut2
    );
    SCALE_2 : component scaling
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        ctr_Scale_input    => ctr_FuncGen_RegisterOut2,
        ctr_Scale_value    => ctr_Scanner_Scale2,
        ctr_Scale_output   => ctr_FuncGen_Scale2

    );
    OFFSET_2 : component Offset 
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        ctr_Offset_input    => ctr_FuncGen_Scale2,
        ctr_Offset_val      => ctr_Scanner_PhaseOff2,
        ctr_Offset_output   => ctr_FuncGen_Offset2
    );

    ctr_Bipolar_OUT <= ctr_FuncGen_Offset2;
    ctr_DCO_OUT     <= ctr_FuncGen_Saw;
end behaviour;