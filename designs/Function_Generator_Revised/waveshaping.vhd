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

COMPONENT wave_lut
	GENERIC (
		signal_width : INTEGER := 8
	);
	PORT (
		index : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(signal_width - 1 DOWNTO 0)
	);
END COMPONENT;

constant SINE_WAVE : std_logic_vector(3 downto 0) := "0000";
constant SQUARE_WAVE : std_logic_vector(3 downto 0) := "0001";
constant TRIANGLE_WAVE : std_logic_vector(3 downto 0) := "0010";

signal output_vector : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal lut_index : std_logic_vector(15 downto 0);

begin

waves : wave_lut
GENERIC MAP(signal_width => DATA_WIDTH)
PORT MAP(
	index => lut_index,
	output => output_vector
);

process(clk)
begin

if rising_edge(clk) then 
	case wave_select is
		when SQUARE_WAVE =>
			if input(7) = '1' then
				output <= "10000000";
			else
				output <= "01111111";
			end if;
		when SINE_WAVE => 
			lut_index <= "00000000" & input;
			output <= output_vector;
		when TRIANGLE_WAVE =>
			lut_index <= "00000001" & input;
			output <= output_vector;
		when others =>
			output <= (others => '0');
	end case;
end if;

end process;

end;