library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;


entity switch_test_bench is
end entity switch_test_bench;
    
architecture test of switch_test_bench is

    constant clockcycle : time := 20 ns;
    constant half_clockcycle : time := clockcycle/2;
    component Switch 
        generic(
            DATA_WIDTH : integer);
            port(
                ctr_DCO_OUT                     : in std_logic_vector(DATA_WIDTH-1 downto 0);
                ctr_Scanner_External_RAMP_IN    : in std_logic_vector(DATA_WIDTH-1 downto 0);
                ctr_Switch_In                   : in std_logic; --Don't forget to have the xdc file
                ctr_Switch_Out                  : out std_logic_vector(DATA_WIDTH-1 downto 0)
            );
     end component;

    constant int_DATA_WIDTH : integer :=32;
    signal int_ctr_DCO_OUT : std_logic_vector(int_DATA_WIDTH-1 downto 0);
    signal int_ctr_Scanner_External_RAMP_IN  : std_logic_vector(int_DATA_WIDTH-1 downto 0);
    signal int_ctr_Switch_In                 : std_logic := '0';
    signal int_ctr_Switch_out                : std_logic_vector(int_DATA_WIDTH-1 downto 0);

    begin
        DUT : Switch 
        generic map(
            DATA_WIDTH => int_DATA_WIDTH
        )
        port map(
            ctr_DCO_OUT => int_ctr_DCO_OUT,
            ctr_Scanner_External_RAMP_IN => int_ctr_Scanner_External_RAMP_IN,
            ctr_Switch_In => int_ctr_Switch_In,
            ctr_Switch_out => int_ctr_Switch_out
        );

        stimuli_generator: process
        begin

        int_ctr_Switch_in <= '0';
        int_ctr_DCO_OUT <= "11111111111111111111111111111111";
        int_ctr_Scanner_External_RAMP_IN <= "11111111111111111111111111110000";
        wait for 2*clockcycle;
        int_ctr_Switch_in <= '1';
        wait for 100*clockcycle;
        assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;
        end process;
        end test;
        