library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

-- PLEASE INCLUDE THIS PACKAGE IN EVERY BLOCK 
-- WHICH HAS SOMETHING TO DO WITH THE CONTROLLER MATRIX, 
-- E.G. CONNECTIONS, 2ND-LAYER DEVELOPMENT, ETC. (YUDONG LIN)

package CONN_MAT_PACKAGE is
    -- For testing only
	-- constant N_GENERATORS: integer := 2;	-- Number of function generators
    
	-- TYPE DEF & CONSTANTS
	constant H_RES: integer := 640; -- Horizontal resolution
	constant V_RES: integer := 480; -- Vertical resolution
	constant V_RATE: integer := 25; -- Refresh rate
	constant N_CALC_UNITS: integer := 12;	-- Number of calculator units. DON'T MODIFY THIS PARAMETER!!!!
	constant N_GENERATORS: integer := 24;	-- Number of function generators. 
	constant DATA_WIDTH: integer := 10;	-- DATA bus width, change with caution!!!! (never goes beyond 16!!!)
	constant ADDR_WIDTH: integer := N_GENERATORS;	-- Address bus width
	type CONTROLLER_IN_BUS is array (0 to N_GENERATORS-1) of std_logic_vector(DATA_WIDTH-1 downto 0);	-- Generator signal receiver bus
	type PARAM_BUS is array (0 to N_CALC_UNITS-1) of std_logic_vector(DATA_WIDTH-1 downto 0);	-- Parameters signal receiver bus
	type PARAM_BUS_EX is array (0 to 2 * N_CALC_UNITS-1) of std_logic_vector(DATA_WIDTH-1 downto 0);	-- Parameters signal receiver bus
	
	
	
	-- FUNCTION DEF
	-- This function is used for guarding against the same generator connecting to a same calc. unit. 
	function ADDR_CHECK(ADDR_IN: in std_logic_vector(ADDR_WIDTH-1 downto 0))
		return std_logic_vector;
end package CONN_MAT_PACKAGE;

package body CONN_MAT_PACKAGE is
	function ADDR_CHECK(ADDR_IN: in std_logic_vector(ADDR_WIDTH-1 downto 0))
		return std_logic_vector is
		
		-- Vars
		variable ADDR_TEMP: std_logic_vector(ADDR_WIDTH-1 downto 0);
	begin
		ADDR_TEMP := ADDR_IN;
		for i in 0 to N_CALC_UNITS - 1 loop
			if not(ADDR_TEMP(2*i+1 downto 2*i) /= "11") then
				ADDR_TEMP(2*i+1 downto 2*i) := "00";
			end if;
		end loop;
		return ADDR_TEMP;
	end;
end package body CONN_MAT_PACKAGE;