library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CONN_MAT_PACKAGE.all;

-- The body of the connection matrix (Yudong Lin)

entity CONN_MAT is 
	generic(
		OUTPUT_WIDTH: integer := DATA_WIDTH
	);
	port(
		reset, en, clk: in std_logic;
		
		-- INPUT
		GEN_IN: in CONTROLLER_IN_BUS;
		P_MULT_IN: in PARAM_BUS;	-- Multiplier parameters in
		P_ADD_IN: in PARAM_BUS;	-- Adder parameters in
		WIRING_MODIFIER_ENABLER: in std_logic_vector(2 * N_CALC_UNITS-1 downto 0);	-- Select which calculator cell is going to be wired in the matrix
		WIRING_MODIFIER_PARAM: in std_logic_vector(ADDR_WIDTH-1 downto 0);	-- Specify to which generator(s) will be connected to this calculator cell input port
		
		-- OUTPUT
		X_mod, Y_mod, Z_mod, I_mod, -- Signed type
		X_rot, Y_rot, Z_rot, Zoom, 	-- Signed type
		H_position, V_position,	-- Signed type
		H_blanking, V_blanking: out std_logic_vector(DATA_WIDTH-1 downto 0)	-- Unsigned type
	);
end CONN_MAT;

architecture structural of CONN_MAT is
	type CONTROLLER_BUS is array (0 to ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal CONT_BUS: CONTROLLER_BUS;	-- Input buffer of the calculation cells
	signal CONT_OUT: PARAM_BUS;	-- Output buffer before the output port
	
begin
	-- REMINDER: Function generator input buffer may need fanout buffer in future design for higher operation speed. (Yudong Lin)
	
	-- Generate the controller matrix
	CONTROLLER_BUS_CONNECTION: for i in 0 to N_CALC_UNITS - 1 generate
	begin
		U_ROUTER_PORT_MULT_IN: entity work.CONN_MAT_ROUTER(behaviour)
			port map(
				reset => reset, en => WIRING_MODIFIER_ENABLER(2 * i), clk => clk,
				DATA_IN => GEN_IN,
				ADDR_IN => WIRING_MODIFIER_PARAM,
				DATA_OUT => CONT_BUS(2 * i)
			);
			
		U_ROUTER_PORT_ADD_IN: entity work.CONN_MAT_ROUTER(behaviour)
			port map(
				reset => reset, en => WIRING_MODIFIER_ENABLER(2 * i + 1), clk => clk,
				DATA_IN => GEN_IN,
				ADDR_IN => WIRING_MODIFIER_PARAM,
				DATA_OUT => CONT_BUS(2 * i + 1)
			);
			
		U_CALC_CELL: entity work.CONN_MAT_CALC_UNIT(behaviour)
			generic map(OUTPUT_WIDTH => OUTPUT_WIDTH)
			port map(
				reset => reset, en => en, clk => clk,
				X1 => CONT_BUS(2 * i), X2 => CONT_BUS(2 * i + 1), 
				B1 => P_MULT_IN(i), B2 => P_ADD_IN(i),
				SIG_OUT => CONT_OUT(i)
			);
	end generate;
	
	-- Output assignments
	X_mod <= CONT_OUT(0);
	Y_mod <= CONT_OUT(1);
	Z_mod <= CONT_OUT(2);
	I_mod <= CONT_OUT(3);
	X_rot <= CONT_OUT(4);
	Y_rot <= CONT_OUT(5);
	Z_rot <= CONT_OUT(6);
	Zoom <= CONT_OUT(7);
	H_position <= CONT_OUT(8);
	V_position <= CONT_OUT(9);
	H_blanking <= CONT_OUT(10);
	V_blanking <= CONT_OUT(11);
	
end structural;