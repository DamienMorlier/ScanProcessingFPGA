library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity func_gen_test_bench is
end entity func_gen_test_bench;

architecture test of func_gen_test_bench is
    
    constant clockcycle : time := 20 ns;
    constant half_clockcycle : time := clockcycle/2;

    component FunctionGenerator 
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
end component;

--Declaration of the internal  signals used in the testbench

constant int_DATA_WIDTH     : integer := 32;
signal std_clock       	    :  std_logic := '0';
signal std_reset     		:  std_logic := '0';
signal int_ctr_Scanner_Frequency       : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(1500000),int_DATA_WIDTH));

signal int_ctr_Scanner_PhaseOff1       : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(0),int_DATA_WIDTH));
signal int_ctr_Scanner_PhaseOff2           :  std_logic_vector(int_DATA_WIDTH-1 downto 0)  := std_logic_vector(to_signed(integer(0),int_DATA_WIDTH));

signal int_ctr_Scanner_Scale1            : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(3),int_DATA_WIDTH));
signal int_ctr_Scanner_Scale2            : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(3),int_DATA_WIDTH));


signal ctr_Scanner_Waveform            :  std_logic_vector(3 downto 0);--/Waveform
signal int_ctr_Intensity_OUT          : std_logic_vector(int_DATA_WIDTH-1 downto 0) := (others => '0');
signal std_waveform                     : std_logic_vector(3 downto 0);

signal std_ctr_Scanner_Sync                :  std_logic :='0'; --/Sync
signal std_ctr_Scanner_Switch              :  std_logic :='0';
signal int_ctr_Scanner_External_RAMP_IN    :  std_logic_vector(int_DATA_WIDTH-1 downto 0) := (others => '0');--External Ramp in

signal int_ctr_DCO_OUT                     :  std_logic_vector(int_DATA_WIDTH-1 downto 0);--Saw Wave out
signal int_ctr_Bipolar_OUT                 :  std_logic_vector(int_DATA_WIDTH-1 downto 0);--Desired Wave out

begin
    DUT : FunctionGenerator
    generic map(
        DATA_WIDTH => int_DATA_WIDTH
    )
    port map(
        clk             => std_clock,
        reset             => std_reset,
        ctr_Scanner_Frequency           => int_ctr_Scanner_Frequency,

        ctr_Scanner_Scale1              => int_ctr_Scanner_Scale1,
        ctr_Scanner_Scale2              => int_ctr_Scanner_Scale2,

        ctr_Scanner_PhaseOff1           => int_ctr_Scanner_PhaseOff1,
        ctr_Scanner_PhaseOff2           => int_ctr_Scanner_PhaseOff2,

        ctr_Scanner_Waveform            => std_waveform,  
        ctr_Intensity_OUT               => int_ctr_Intensity_OUT,
        ctr_Bipolar_OUT                 => int_ctr_Bipolar_OUT,
        ctr_DCO_OUT                     => int_ctr_DCO_OUT,
        ctr_Scanner_Sync                => std_ctr_Scanner_Sync,
        ctr_Scanner_Switch              => std_ctr_Scanner_Switch,
        ctr_Scanner_External_RAMP_IN    => int_ctr_Scanner_External_RAMP_IN



    );
    --Generation of Clock cycles and Reset pulse
    std_clock   <= not(std_clock) after half_clockcycle;
    std_waveform <= "0000";
    stimuli_generator: process
    begin
    wait for 10000*clockcycle;
    assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;
    end process;
    end test;