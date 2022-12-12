library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.float_pkg.all;
use work.CONN_MAT_PACKAGE.all;

entity ROT_cell is 
	port(
		reset, clk: in std_logic;
		R: in unsigned(16 - 1 downto 0);
		x1_in, x2_in: in float32; -- Unsigned in
		x1_out, x2_out: out float32 -- Unsigned out
	);
end ROT_cell;

architecture Behavioural of ROT_cell is
	COMPONENT dds_cos
	  PORT (
		aclk : IN STD_LOGIC;
		s_axis_phase_tvalid : IN STD_LOGIC;
		s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		m_axis_data_tvalid : OUT STD_LOGIC;
		m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
	  );
	END COMPONENT;

	COMPONENT dds_sine
	  PORT (
		aclk : IN STD_LOGIC;
		s_axis_phase_tvalid : IN STD_LOGIC;
		s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		m_axis_data_tvalid : OUT STD_LOGIC;
		m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
	  );
	END COMPONENT;
	
	signal s_axis_phase_tvalid, m_axis_data_tvalid: std_logic_vector(4-1 downto 0);
	signal s_axis_phase_tdata_cos1, 
		s_axis_phase_tdata_sin1, 
		m_axis_data_tdata_cos1,  
		m_axis_data_tdata_sin1 
		: std_logic_vector(16-1 downto 0);
begin
	cos : dds_cos
		PORT MAP (
		aclk => clk,
		s_axis_phase_tvalid => s_axis_phase_tvalid(0),
		s_axis_phase_tdata => s_axis_phase_tdata_cos1,
		m_axis_data_tvalid => m_axis_data_tvalid(0),
		m_axis_data_tdata => m_axis_data_tdata_cos1
	);

	sin : dds_sine
	  PORT MAP (
		aclk => clk,
		s_axis_phase_tvalid => s_axis_phase_tvalid(2),
		s_axis_phase_tdata => s_axis_phase_tdata_sin1,
		m_axis_data_tvalid => m_axis_data_tvalid(2),
		m_axis_data_tdata => m_axis_data_tdata_sin1
	  );

	s_axis_phase_tdata_cos1 <= std_logic_vector(R);
	s_axis_phase_tdata_sin1 <= std_logic_vector(R);
	
	process (clk, reset)
		variable cos1, sin1: float32;
	begin
		if(reset = '1') then
			x1_out <= to_float(0);
			x2_out <= to_float(0);
			s_axis_phase_tvalid <= (others => '0');
		else
			cos1 := to_float32(to_float(signed(m_axis_data_tdata_cos1), 32) / 2 ** 16);
			sin1 := to_float32(to_float(signed(m_axis_data_tdata_sin1), 32) / 2 ** 16);
			
			if(rising_edge(clk)) then
				s_axis_phase_tvalid <= (others => '1');
				x1_out <= x2_in * cos1 - x1_in * sin1;
				x2_out <= x2_in * sin1 + x1_in * cos1;
			end if;
		end if;
	end process;
end Behavioural;

-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.float_pkg.all;
use IEEE.math_real.all;
use work.CONN_MAT_PACKAGE.all;

entity ROT is
	port(
		reset, clk: in std_logic;
		X_in, Y_in, Z_in: in std_logic_vector(DATA_WIDTH - 1 downto 0);	-- Signed input
		X_rot, Y_rot, Z_rot: in std_logic_vector(DATA_WIDTH - 1 downto 0);	-- Signed input
		X_out, Y_out, Z_out: out float32
	);
end ROT;

architecture Behavioural of ROT is
	constant bias: integer := 2**16 / 4;
	signal xf, yf, zf: float32;	-- Float input
	signal xr, yr, zr: unsigned(16-1 downto 0); -- Rotator params
	signal zro1, zro2, xro1, xro2, yro1, yro2: float32; -- Rotator cell output
begin
	-- Rotator cells instantiation
	z_rot_cell: entity work.ROT_cell(Behavioural)
		port map(
			reset => reset,
			clk => clk,
			R => zr,
			x1_in => xf,
			x2_in => yf,
			x1_out => zro1,
			x2_out => zro2
		);
		
	x_rot_cell: entity work.ROT_cell(Behavioural)
		port map(
			reset => reset,
			clk => clk,
			R => xr,
			x1_in => zro2,
			x2_in => zf,
			x1_out => xro1,
			x2_out => xro2
		);
		
	y_rot_cell: entity work.ROT_cell(Behavioural)
		port map(
			reset => reset,
			clk => clk,
			R => yr,
			x1_in => zro1,
			x2_in => zro1,
			x1_out => yro1,
			x2_out => yro2
		);
	
	-- Main controller
	process (reset, clk)
		variable xr_t, yr_t, zr_t: unsigned(16-1 downto 0);
	begin
		if(reset = '1') then
			xf <= to_float(0);
			yf <= to_float(0);
			zf <= to_float(0);
			xr <= (others => '0');
			yr <= (others => '0');
			zr <= (others => '0');
		else
			if(rising_edge(clk)) then
				-- Scale the coordinator signals in [-1, 1]
				xf <= to_float(signed(X_in), xf) / 2**(DATA_WIDTH - 1);
				yf <= to_float(signed(Y_in), yf) / 2**(DATA_WIDTH - 1);
				zf <= to_float(signed(Z_in), zf) / 2**(DATA_WIDTH - 1);
				
				-- Rotation params need to be biased
				xr_t := to_unsigned((to_integer(signed(X_rot)) * (2 ** (16 - DATA_WIDTH)) + bias + 2**16) mod 2**16, 16);
				yr_t := to_unsigned((to_integer(signed(Y_rot)) * (2 ** (16 - DATA_WIDTH)) + 2**16) mod 2**16, 16);
				zr_t := to_unsigned((to_integer(signed(Z_rot)) * (2 ** (16 - DATA_WIDTH)) - bias + 2**16) mod 2**16, 16);
				
				xr <= xr_t;
				yr <= yr_t;
				zr <= zr_t;
				
				-- Output stage. 2 clock period of pipelining
				X_out <= yro1;
				Z_out <= yro2;
				Y_out <= xro2;
			end if;
		end if;
	end process;
end Behavioural;