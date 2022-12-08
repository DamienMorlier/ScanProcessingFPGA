library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity waveshaping is
	generic(
		DATA_WIDTH : integer
	);
	port(
		clk, reset                  : in std_logic;
		ctr_Waveshaping_waveform    : in std_logic_vector(3 downto 0);
		ctr_Waveshaping_input       : in std_logic_vector(DATA_WIDTH-1 downto 0);
		ctr_Waveshaping_output      : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end;

architecture behavior of waveshaping is

--COMPONENT wave_lut
--	GENERIC (
--		signal_width : integer
--	);
--	PORT (
--		index : IN std_logic_vector(20 DOWNTO 0);
--		output : OUT std_logic_vector(signal_width - 1 DOWNTO 0)
--	);
--END COMPONENT;
COMPONENT dds_sine_gen
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) 
  );
END COMPONENT;

constant SINE_WAVE : std_logic_vector(3 downto 0) := "0001";
constant SQUARE_WAVE : std_logic_vector(3 downto 0) := "0010";
constant TRIANGLE_WAVE : std_logic_vector(3 downto 0) := "0100";

signal output_vector : std_logic_vector(DATA_WIDTH - 1 downto 0);
--signal lut_index : std_logic_vector(13-1 downto 0);
signal s_axis_phase_tdata: std_logic_vector(16-1 downto 0);
signal m_axis_data_tvalid: std_logic;
signal m_axis_data_tdata: std_logic_vector(10-1 DOWNTO 0);
signal tri_output_vector: std_logic_vector(32-1 downto 0);

begin

--waves : wave_lut
--GENERIC MAP(signal_width => DATA_WIDTH)
--PORT MAP(
--	index => lut_index,
--	output => output_vector
--);

SIN_GEN : dds_sine_gen
  PORT MAP (
    aclk => clk,
    s_axis_phase_tvalid => '1',
    s_axis_phase_tdata => s_axis_phase_tdata,
    m_axis_data_tvalid => m_axis_data_tvalid,
    m_axis_data_tdata => m_axis_data_tdata
  );

TRI_WAVE_GEN: entity work.TRI_GEN(Behavioral)
    port map(
        clk, reset, 
        ctr_Waveshaping_input(DATA_WIDTH-1 downto DATA_WIDTH-13),
        tri_output_vector
    );

process(clk)
variable square: std_logic_vector(DATA_WIDTH-2 downto 0);
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
		    s_axis_phase_tdata <= ctr_Waveshaping_input;
			ctr_Waveshaping_output <= m_axis_data_tdata & "000000";
		when TRIANGLE_WAVE =>
			ctr_Waveshaping_output <= tri_output_vector(32-1 downto 32-DATA_WIDTH);
		when others =>
		  ctr_Waveshaping_output <= (others => '0');
	end case;
end if;

end process;

end;