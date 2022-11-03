library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCOPhaser is
    generic(DATA_WIDTH : integer
            );
    port(
        --Frequency : in integer;
        phase_incr : in std_logic_vector(DATA_WIDTH-1 downto 0);
        clock     : in std_logic;
        reset     : in std_logic;
        DCO_RAMP  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end DCOPhaser;
architecture behaviour of DCOPhaser is
    --constant data_size  : integer := integer(2**DATA_WIDTH);
    --constant phase_incr : integer := integer(Frequency*data_size/CLOCK_FREQ);
    signal   count     : unsigned(DATA_WIDTH-1 downto 0 ) := (others => '0');


begin
    P_SEQUENTIAL : process(clock,reset)
    begin
        if (reset = '1') then
            count <=(others => '0');
        end if;
        if(rising_edge(clock)) then
            count <= count + unsigned(phase_incr);
        end if; 
    end process P_SEQUENTIAL;

DCO_RAMP <= std_logic_vector(count);    

end behaviour ; -- arch
