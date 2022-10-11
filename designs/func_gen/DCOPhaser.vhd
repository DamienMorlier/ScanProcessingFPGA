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
signal stored_value, new_stored_value : integer :=0;
begin
    P_SEQUENTIAL : process(clock)
    begin
        if(clock'EVENT and clock = '1') then 
            stored_value <= new_stored_value;
        end if;
    end process P_SEQUENTIAL;

    P_COMBINATORIAL : process(stored_value,reset)
    begin
        if(stored_value = max_value) then
            new_stored_value <= 0;
        else
            new_stored_value <=stored_value +1;
        end if;
        if reset = '1' then
            new_stored_value <= 0;
        end if;
    end process P_COMBINATORIAL;
DCO_RAMP <= stored_value;    
end behaviour;