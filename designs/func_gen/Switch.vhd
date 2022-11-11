library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity Switch is
    generic(
        DATA_WIDTH : integer

    );
    port(
        ctr_DCO_OUT                     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        ctr_Scanner_External_RAMP_IN    : in std_logic_vector(DATA_WIDTH-1 downto 0);
        ctr_Switch_In                   : in std_logic; --Don't forget to have the xdc file
        ctr_Switch_Out                  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end Switch;

architecture behaviour of Switch is 

begin
    P_LOGIC : process(ctr_Switch_In)
    begin
        if (ctr_Switch_In ='1') then 
            ctr_Switch_Out <= ctr_Scanner_External_RAMP_IN;
        else
            ctr_Switch_Out <= ctr_DCO_OUT;
        end if;
    end process P_LOGIC;
end behaviour;

