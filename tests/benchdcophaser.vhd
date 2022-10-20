library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCO_test_bench is
end entity DCO_test_bench;

architecture test of DCO_test_bench is


    constant clockcycle : time := 100 ns;
    constant half_clockcycle : time := clockcycle/2;

    component DCOPhaser
    generic(
        DATA_WIDTH : integer;
        DATA_SIZE  : integer;
        CLOCK_FREQ : integer
    );
    port(
        clock       : in std_logic;
        reset       : in std_logic;
        frequency   : in integer ;
        DCO_RAMP    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    end component;

    --Declaration of the internal  signals used in the testbench
    constant int_DATA_WIDTH : integer := 5;
    constant int_DATA_SIZE  : integer := 32;
    constant int_CLOCK_FREQ : integer := 500000;
    signal int_clock       	    :  std_logic := '0';
	signal int_reset     		:  std_logic := '0';
	signal real_frequency 	    :  integer := 1000;
	signal int_ramp_out      	:  std_logic_vector(int_DATA_WIDTH-1 downto 0);

  
    begin

    --Instantiation of the Design Under Test
        DUT : DCOPhaser
            generic map(
                DATA_WIDTH => int_DATA_WIDTH,
                CLOCK_FREQ => int_CLOCK_FREQ,
                DATA_SIZE => int_DATA_SIZE
            )
            port map (
                clock           => int_clock,
                reset           => int_reset,
                frequency       => real_frequency,
                DCO_RAMP        => int_ramp_out
                ) ;

    --Generation of Clock cycles and Reset pulse
        int_clock   <= not(int_clock) after half_clockcycle;

  stimuli_generator: process
  begin
  wait for 15*clockcycle;
  int_reset <= '1';
  wait for clockcycle;
  int_reset <= '0';
  wait until int_ramp_out = "00000";
  wait until int_ramp_out = "11111";
  wait until int_ramp_out = "00000";
  wait until int_ramp_out = "11111";
  --Raise a deliberate failure to stop execution
  assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;
  end process;
  end test;
