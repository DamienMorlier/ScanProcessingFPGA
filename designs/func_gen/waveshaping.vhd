library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity waveshaping is
	generic(
		DATA_WIDTH : integer
	);
	port(
		clk                         : in std_logic;
		ctr_Waveshaping_waveform    : in std_logic_vector(3 downto 0);
		ctr_Waveshaping_input       : in std_logic_vector(DATA_WIDTH-1 downto 0);
		ctr_Waveshaping_output      : out std_logic_vector(DATA_WIDTH-1 downto 0)
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
	case ctr_Waveshaping_waveform is
		when SQUARE_WAVE =>
			if ctr_Waveshaping_input(15) = '1' then
				square := (others => '0');
				ctr_Waveshaping_output <= '1' & square;
			else
				square := (others => '1');
				ctr_Waveshaping_output <= '0' & square;
			end if;
		when SINE_WAVE => 
			lut_index <= "00000" & ctr_Waveshaping_input(31 downto 16);
			ctr_Waveshaping_output <= output_vector;
		when TRIANGLE_WAVE =>
			lut_index <= "00001" & ctr_Waveshaping_input(31 downto 16);
			ctr_Waveshaping_output <= output_vector;
		when others =>
		ctr_Waveshaping_output <= (others => '0');
	end case;
end if;

end process;

end;