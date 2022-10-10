library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCO_test_bench is
end entity DCO_test_bench;

architecture test of DCO_test_bench is


    constant clockcycle : time := 2 ns;
    constant half_clockcycle : time := clockcycle/2;

    component DCOPhaser 
    port(
        clock       : in std_logic;
        reset       : in std_logic;
        frequency   : in integer :=10;
        DCO_RAMP    : out integer
    );
    end component;

    --Declaration of the internal  signals used in the testbench
    signal int_clock       	    :  std_logic := '0';
	signal int_reset     		:  std_logic := '0';
	signal real_frequency 	    :  integer := 10;
	signal int_ramp_out      	:  integer;

  
    begin

    --Instantiation of the Design Under Test
        DUT : DCOPhaser
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
  wait for 5*clockcycle;
  wait for clockcycle;
  wait for clockcycle;
  wait for clockcycle;
  wait until rising_edge(int_clock);
  wait for clockcycle;

  wait for 10*clockcycle;
  --Raise a deliberate failure to stop execution

  end process;
  end test;
