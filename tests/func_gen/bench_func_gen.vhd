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
    clock               : in std_logic;
    reset               : in std_logic;
    phase_incr          : in std_logic_vector(DATA_WIDTH-1 downto 0); --Wanted Frequency
    Scale               : in std_logic_vector(DATA_WIDTH-1 downto 0);
    Offset_val          : in std_logic_vector(DATA_WIDTH-1 downto 0);
    SIG_OUT             : out std_logic_vector(DATA_WIDTH-1 downto 0);

    --External            : in std_logic;
    --Harmonic            : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --Phase               : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --Sync                : in std_logic;
    waveform            : in std_logic_vector(3 downto 0)
    --I_OUT               : out std_logic;
    --B_OUT               : out std_logic
    );
end component;

--Declaration of the internal  signals used in the testbench

constant int_DATA_WIDTH     : integer := 32;
signal std_clock       	    :  std_logic := '0';
signal std_reset     		:  std_logic := '0';
signal int_phase_incr       : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(15000),int_DATA_WIDTH));
signal int_Scale            : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(3),int_DATA_WIDTH));
signal int_Offset_val       : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_signed(integer(0),int_DATA_WIDTH));
signal int_SIG_OUT          : std_logic_vector(int_DATA_WIDTH-1 downto 0) := (others => '0');
signal std_waveform         : std_logic_vector(3 downto 0);

begin
    DUT : FunctionGenerator
    generic map(
        DATA_WIDTH => int_DATA_WIDTH
    )
    port map(
        clock             => std_clock,
        reset             => std_reset,
        phase_incr        => int_phase_incr,
        Scale             => int_Scale,
        Offset_val        => int_Offset_val,
        waveform          => std_waveform,  
        SIG_OUT           => int_SIG_OUT
    );
    --Generation of Clock cycles and Reset pulse
    std_clock   <= not(std_clock) after half_clockcycle;
    std_waveform <= "0000";
    stimuli_generator: process
    begin
    wait for 1000000*clockcycle;
    assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;
    end process;
    end test;