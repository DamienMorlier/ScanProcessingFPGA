library ieee;
use ieee.std_logic_1164.all;

entity waveshaping is
    generic (
        DATA_WIDTH: integer := 8
    );
    port (
		wave_select: in std_logic_vector(3 downto 0);
		input: in std_logic_vector(DATA_WIDTH-1 downto 0);
		clk: in std_logic;
		output: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end;

architecture behavior of waveshaping is



constant SQUARE_WAVE : std_logic_vector(3 downto 0) := "0000";
constant SINE_WAVE : std_logic_vector(3 downto 0) := "0001";
constant COSINE_WAVE : std_logic_vector(3 downto 0) := "0010";
constant TRIANGLE_WAVE : std_logic_vector(3 downto 0) := "0011";

begin

process(clk)
begin

if rising_edge(clk) then 
	case wave_select is
		when SQUARE_WAVE =>
			output <= (others => '0');
		when SINE_WAVE => 
			output <= (others => '0');
		when COSINE_WAVE =>
			output <= (others => '0');
		when TRIANGLE_WAVE =>
			output <= (others => '0');
		when others =>
			output <= (others => '0');
	end case;
end if;

end process;

end;