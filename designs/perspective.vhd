library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use work.CONN_MAT_PACKAGE.all;
use work.all;
use IEEE.float_pkg.all;
use IEEE.fixed_pkg.all;

entity PSPC is
	port(
		reset, clk: in std_logic;
		X_in, Y_in, Z_in: in float32;
		
		-- A and Dmax are unsigned, Sx, Sy and I_in are signed.
		A, Dmax, Sx, Sy: in std_logic_vector(8-1 downto 0);
		I_in: in std_logic_vector(8-1 downto 0);
		
		X_out, Y_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
		I_out: out std_logic_vector(8-1 downto 0)
	);
end PSPC;

architecture Behavioural of PSPC is
	-- Input: 3-bit integer part fixed-point
	-- Output: 2-bit integer part fixed-point
	signal s_axis_phase_tvalid, m_axis_dout_tvalid: std_logic;
	signal s_axis_phase_tdata: std_logic_vector(32-1 downto 0);
	signal m_axis_dout_tdata: std_logic_vector(64-1 downto 0);
	
	COMPONENT cordic_sinh_cosh
		PORT (
			aclk : IN STD_LOGIC;
			s_axis_phase_tvalid : IN STD_LOGIC;
			s_axis_phase_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			m_axis_dout_tvalid : OUT STD_LOGIC;
			m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
		);
	
END COMPONENT;
begin
	
	CORD_CALC : cordic_sinh_cosh
		PORT MAP (
			aclk => clk,
			s_axis_phase_tvalid => s_axis_phase_tvalid,
			s_axis_phase_tdata => s_axis_phase_tdata,
			m_axis_dout_tvalid => m_axis_dout_tvalid,
			m_axis_dout_tdata => m_axis_dout_tdata
		);

	-- Core
	process(reset, clk)
		variable x_t, y_t, a_t, i_t, sx_t, sy_t, pha, dmax_t, iout_t: float32;
		variable sinh, cosh: std_logic_vector(32-1 downto 0);
		variable sinh_t, cosh_t: float32;
	begin
		if(reset = '1') then
			X_out <= (others => '0');
			Y_out <= (others => '0');
			I_out <= (others => '0');
			s_axis_phase_tvalid <= '0';
			s_axis_phase_tdata <= (others => '0');
		else
			s_axis_phase_tvalid <= '1';
			if(rising_edge(clk)) then
				-- Normalize
				a_t := to_float(unsigned(A)) / 2 ** DATA_WIDTH;
				sx_t := to_float(unsigned(Sx)) / 2 ** DATA_WIDTH;
				sy_t := to_float(unsigned(Sy)) / 2 ** DATA_WIDTH;
				dmax_t := to_float(unsigned(Dmax)) / 2 ** DATA_WIDTH;
				i_t := to_float(unsigned(I_in)) / 2 ** DATA_WIDTH;
				
				-- Perspective transformation (camera)
				x_t := (X_in / Z_in * a_t) + sx_t;
				y_t := (Y_in / Z_in * a_t) + sy_t;
				s_axis_phase_tdata <= to_slv(to_sfixed((dmax_t - (Z_in + 1) / 2) / dmax_t * i_t * 2, 2, -29));
				
				-- Calculate the tanh value of the PREVIOUS i
				sinh := m_axis_dout_tdata(64-1 downto 32);
				cosh := m_axis_dout_tdata(32-1 downto 0);
				sinh_t := to_float(to_sfixed(sinh, 1, -30),sinh_t);
				cosh_t := to_float(to_sfixed(cosh, 1, -30), cosh_t);
				iout_t := sinh_t / cosh_t;
				
				-- Output stage, scale Back to the output frame resolution
				X_out <= std_logic_vector(to_unsigned(x_t * H_RES / 2 + H_RES / 2, X_out'length)); 
				Y_out <= std_logic_vector(to_unsigned(y_t * V_RES / 2 + V_RES / 2, Y_out'length)); 
				if(m_axis_dout_tvalid = '1') then
					I_out <= std_logic_vector(to_unsigned(iout_t * 2 ** 8, I_out'length)); 
				end if;
				
			end if;
		end if;
	end process;

end Behavioural;