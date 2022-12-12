library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CONN_MAT_PACKAGE.all;

-- Calculation Cells in the connection matrix. 

entity CONN_MAT_CALC_UNIT is
	generic(OUTPUT_WIDTH: integer := DATA_WIDTH);	-- For user defined output bit width, 
	port(
		reset, en, clk: in std_logic;
		-- X's for generator signals (not registered), and B's for numeric parameters (usually constants, registered)
		-- All input signals are signed
		X1, X2, B1, B2: in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- SIG_OUT = X1 * B1 + X2 + B2, signed
		SIG_OUT: out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
	);
end CONN_MAT_CALC_UNIT;

architecture behaviour of CONN_MAT_CALC_UNIT is 
	signal B1_REG, B2_REG, X1_BUFF, X2_BUFF: std_logic_vector(DATA_WIDTH-1 downto 0);
begin
	-- Concurrent X's buffers and calculation process. Used en as a gate controller for energy-saving design. 
	X_BUFFER_WIRING: process(reset, clk, en)
		variable OUTPUT_TEMP: signed(2 * DATA_WIDTH-1 downto 0);
	begin
		if (reset = '1') then
			X1_BUFF <= (others => '0');
			X2_BUFF <= (others => '0');
		elsif (rising_edge(clk) and en = '1') then
			X1_BUFF <= X1;
			X2_BUFF <= X2;
			OUTPUT_TEMP := signed(X1_BUFF) * signed(B1_REG)+ signed(X2_BUFF) + signed(B2_REG);
			SIG_OUT <= 
				std_logic_vector(OUTPUT_TEMP(DATA_WIDTH-1 downto 0));
		end if;
	end process;
	
	-- Parameter registers
	B_REGS_PROC: process(reset, en, clk)
	begin
		if (reset = '1') then
			B1_REG <= std_logic_vector(to_signed(1, B1_REG'length));	-- B1 will be set to 1 by default
			B2_REG <= (others => '0');	-- B2 will be set to 0 by default
		elsif (en = '1' and rising_edge(clk)) then
			B1_REG <= B1;
			B2_REG <= B2;
		end if;
	end process;
end behaviour;