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
	signal B1_REG, B2_REG: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal X1_BUFF, X2_BUFF: std_logic_vector(DATA_WIDTH-1 downto 0);
	-- signal Mult, Add: signed(2 * DATA_WIDTH - 1 downto 0);
begin
	-- Concurrent X's buffers and calculation process. Used en as a gate controller for energy-saving design. 
	X_BUFFER_WIRING: process(reset, clk, en)
		variable OUTPUT_TEMP: signed(2 * DATA_WIDTH-1 downto 0);
	begin
		if (reset = '1') then
			X1_BUFF <= (others => '0');
			X2_BUFF <= (others => '0');
			B1_REG <= std_logic_vector(to_signed(1, B1_REG'length));	-- B1 will be set to 1 by default
			B2_REG <= (others => '0');	-- B2 will be set to 0 by default
		elsif (en = '1' and rising_edge(clk)) then
		    -- Parameter registers renewal
            B1_REG <= B1;
            B2_REG <= B2;
		    
			X1_BUFF <= X1;
			X2_BUFF <= X2;
		end if;
		OUTPUT_TEMP := signed(X1_BUFF) * signed(B1_REG) + signed(X2_BUFF) + signed(B2_REG);
		SIG_OUT <= std_logic_vector(OUTPUT_TEMP(OUTPUT_TEMP'length - 1 downto OUTPUT_TEMP'length - 1)) & std_logic_vector(OUTPUT_TEMP(10-2 downto 0)); -- Delay: 1 clock period
	end process;
end behaviour;

-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- EXTENDED VERSION
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CONN_MAT_PACKAGE.all;

-- Calculation Cells in the connection matrix. 

entity CONN_MAT_CALC_UNIT_EXT is
	generic(OUTPUT_WIDTH: integer := DATA_WIDTH);	-- For user defined output bit width, 
	port(
		reset, en, clk: in std_logic;
		-- X's for generator signals (not registered), and B's for numeric parameters (usually constants, registered)
		-- All input signals are signed
		X1, X2, X3, B1, B2: in std_logic_vector(DATA_WIDTH-1 downto 0);
		-- SIG_OUT = X1 * X2 * B1 + X3 + B2, signed
		SIG_OUT: out std_logic_vector(OUTPUT_WIDTH-1 downto 0)
	);
end CONN_MAT_CALC_UNIT_EXT;

architecture behaviour of CONN_MAT_CALC_UNIT_EXT is 
	signal B1_REG, B2_REG: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal X1_BUFF, X2_BUFF, X3_BUFF: std_logic_vector(DATA_WIDTH-1 downto 0);
	COMPONENT mult_10_10_20
      PORT (
        CLK : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(19 DOWNTO 0) 
      );
    END COMPONENT;
    
    COMPONENT mult_10_20_30
      PORT (
        CLK : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(29 DOWNTO 0) 
      );
    END COMPONENT;
begin
	-- Concurrent X's buffers and calculation process. Used en as a gate controller for energy-saving design. 
	X_BUFFER_WIRING: process(reset, clk, en)
		variable OUTPUT_TEMP: signed(3 * DATA_WIDTH-1 downto 0);
	begin
		if (reset = '1') then
			X1_BUFF <= (others => '0');
			X2_BUFF <= (others => '0');
			X3_BUFF <= (others => '0');
			B1_REG <= std_logic_vector(to_signed(1, B1_REG'length));	-- B1 will be set to 1 by default
			B2_REG <= (others => '0');	-- B2 will be set to 0 by default
		elsif (en = '1' and rising_edge(clk)) then
		    -- Parameter registers renewal
            B1_REG <= B1;
            B2_REG <= B2;
		    
			X1_BUFF <= X1;
			X2_BUFF <= X2;
			X3_BUFF <= X2;
		end if;
		
		OUTPUT_TEMP := signed(X1_BUFF) * signed(X2_BUFF) * signed(B1_REG) + signed(X3_BUFF) + signed(B2_REG);
		SIG_OUT <= std_logic_vector(OUTPUT_TEMP(OUTPUT_TEMP'length - 1 downto OUTPUT_TEMP'length - 1)) & std_logic_vector(OUTPUT_TEMP(10-2 downto 0)); 
	end process;
end behaviour;