library ieee;
use ieee.std_logic_1164.all;

entity waveshaping is
    generic (
        DATA_WIDTH: integer := 32
    );
    port (
		wave_select: in std_logic_vector(3 downto 0);
		input: in std_logic_vector(DATA_WIDTH - 1 downto 0);
		clk: in std_logic;
		output: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end;

architecture behavior of waveshaping is

COMPONENT wave_lut
	GENERIC (
		signal_width : integer
	);
	PORT (
		index : IN std_logic_vector(20 DOWNTO 0);
		output : OUT std_logic_vector(signal_width - 1 DOWNTO 0)
	);
END COMPONENT;

constant SINE_WAVE : std_logic_vector(3 downto 0) := "0000";
constant SQUARE_WAVE : std_logic_vector(3 downto 0) := "0001";
constant TRIANGLE_WAVE : std_logic_vector(3 downto 0) := "0010";

signal output_vector : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal lut_index : std_logic_vector(20 downto 0);

begin

waves : wave_lut
GENERIC MAP(signal_width => DATA_WIDTH)
PORT MAP(
	index => lut_index,
	output => output_vector
);

process(clk)
variable square: std_logic_vector(30 downto 0);
begin

if rising_edge(clk) then 
	case wave_select is
		when SQUARE_WAVE =>
			if input(15) = '1' then
				square := (others => '0');
				output <= '1' & square;
			else
				square := (others => '1');
				output <= '0' & square;
			end if;
		when SINE_WAVE => 
			lut_index <= "00000" & input(31 downto 16);
			output <= output_vector;
		when TRIANGLE_WAVE =>
			lut_index <= "00001" & input(31 downto 16);
			output <= output_vector;
		when others =>
			output <= (others => '0');
	end case;
end if;

end process;

end;