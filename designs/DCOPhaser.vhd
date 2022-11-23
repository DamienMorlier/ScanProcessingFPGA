library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DCOPhaser is
    generic(
        DATA_WIDTH : integer
    );
    port(
        reset                       : in std_logic;
        clk                         : in std_logic;
        ctr_DCO_Phaser_sync         : in std_logic;
        ctr_DCOPhaser_frequency     : in std_logic_vector(DATA_WIDTH-1 downto 0);
        ctr_DCOPhaser_output        : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end DCOPhaser;
architecture behaviour of DCOPhaser is
    signal   count     : unsigned(DATA_WIDTH-1 downto 0 ) := (others => '0');
begin
    P_SEQUENTIAL : process(clk,reset,ctr_DCO_Phaser_sync)
    begin
        if (ctr_DCO_Phaser_sync = '1') then
            count <=(others => '0');
        end if;
        if (reset = '1') then
            count <=(others => '0');
        end if;
        if(rising_edge(clk)) then
            count <= count + unsigned(ctr_DCOPhaser_frequency);
        end if; 
    end process P_SEQUENTIAL;

    ctr_DCOPhaser_output <= std_logic_vector(count);    

end behaviour ; 
