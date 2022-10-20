library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCOPhaser is 
    generic( DATA_WIDTH : integer :=5;
             DATA_SIZE  : integer :=32;
             CLOCK_FREQ : integer :=1000000 -- 1 Mhz
            );
    port(
        reset       : in std_logic;
        clock       : in std_logic;
        Frequency   : in integer;
        DCO_RAMP    : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end DCOPhaser;

architecture behaviour of DCOPhaser is 
constant bit_jump  : integer := integer(CLOCK_FREQ/Frequency/DATA_SIZE);
signal stored_value, new_stored_value, count,new_count : integer :=0;
begin
    P_SEQUENTIAL : process(clock)
    begin
        if(rising_edge(clock)) then 
            stored_value <= new_stored_value;
            count <= new_count;
        end if;
    end process P_SEQUENTIAL;

    P_COMBINATORIAL : process(stored_value,reset,count)
    begin
        if(count = bit_jump) then
            new_stored_value <= stored_value +1;
            new_count <= 0;
        else
            new_stored_value <=stored_value;
            new_count <= count +1;
        end if;
        if reset = '1' then
            new_stored_value <= 0;
            new_count <= 0;
        end if;
    end process P_COMBINATORIAL;
DCO_RAMP <= std_logic_vector(to_unsigned(stored_value,DATA_WIDTH));    
end behaviour;