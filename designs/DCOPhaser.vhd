library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCOPhaser is 
    port(
        reset : in std_logic;
        clock : in std_logic;
        Frequency   : in integer;

        DCO_RAMP : out integer
    );
end DCOPhaser;

architecture behaviour of DCOPhaser is 
constant max_value: integer := Frequency;
signal sig_out: integer;
begin
    P_SEQUENTIAL : process(clock)
    begin
        if(clock'EVENT and clock = '1') then 
        sig_out <= sig_out+1;
            if(sig_out = max_value) then
                sig_out <= 0;
            end if;
            if reset = '1' then
                sig_out <= 0;
            end if;
        end if;
    end process P_SEQUENTIAL;
DCO_RAMP <= sig_out;    
end behaviour;