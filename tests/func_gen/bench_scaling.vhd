library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;



entity scaling_test_bench is
end entity scaling_test_bench;

architecture test of scaling_test_bench is

    
    constant clockcycle : time := 20 ns;
    constant half_clockcycle : time := clockcycle/2;

    component scaling

    generic(DATA_WIDTH : integer);
    port(
        SIG_IN        : in std_logic_vector(DATA_WIDTH-1 downto 0);
        scaling_value : in std_logic_vector(DATA_WIDTH-1 downto 0);
        SIG_OUT       : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    end component;

    --Declaration of the internal  signals used in the testbench
    constant int_DATA_WIDTH     : integer := 16;
    signal int_sig_in           : std_logic_vector(int_DATA_WIDTH-1 downto 0) := (others => '0');
    signal int_scaling_value    : std_logic_vector(int_DATA_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(2,int_DATA_WIDTH));
    signal int_sig_out          : std_logic_vector(int_DATA_WIDTH-1 downto 0);
    signal int_clock       	    :  std_logic := '0';

    begin

        DUT : scaling
            generic map(
                DATA_WIDTH => int_DATA_WIDTH
            )
            port map(
                SIG_IN => int_sig_in,
                SIG_OUT => int_sig_out,
                scaling_value => int_scaling_value
            );
    
    --Generation of Clock cycles and Reset pulse
    int_clock   <= not(int_clock) after half_clockcycle;

    stimuli_generator : process
    begin
    wait for 1*clockcycle;

    int_sig_in <= "1111111111111111";

    wait for 10*clockcycle;

    int_scaling_value <= std_logic_vector(to_unsigned(4,int_DATA_WIDTH));

    wait for 5*clockcycle;

    --Raise a deliberate failure to stop execution
    assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;
    end process;
    end test;
