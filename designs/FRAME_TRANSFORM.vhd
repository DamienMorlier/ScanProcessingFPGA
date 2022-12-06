library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CONN_MAT_PACKAGE.all;

entity FRAME_TRANS is
	-- generic(
	   -- H_RES: integer := 1280 - 1;
	   -- V_RES: integer := 720 - 1
	  -- );
	
	port(
		-- REMINDER!!!
		-- ALL NAMES OF PORTS MENTIONED BY DEREK 
		-- WILL START WITH A CAPITAL LETTER
		
		-- Input ports ------------------------------
		-- Global enabler, clock and reset, active high
		clk, en, reset: in std_logic;
		
		-- Video frames input, single pixel with 8 bit depth in R-G-B
		VIDEO_PIXEL_IN: in std_logic_vector(24-1 downto 0);
		
		-- Coordinators input
		H_SCAN_IN, V_SCAN_IN: in unsigned(10-1 downto 0); 
		
		-- Zoom parameter, -100 for 0% and 100 for 200% zoom ratio
		Zoom: in signed(8-1 downto 0);
		
		-- 2D shift parameters
		H_Position, V_Position: in signed(10-1 downto 0); 
		
		-- Percentage of output frame blanked. 
		-- Range [0,100] (integer)
		H_Blanking, V_Blanking: in unsigned(8-1 downto 0); 
		
		-- Output ports ----------------------------
		-- Position and intensity output 
		Xout, Yout: out unsigned (10-1 downto 0);
		Rout, Gout, Bout: out unsigned (8-1 downto 0);
		Iout: out unsigned (8-1 downto 0)
		
	);
end FRAME_TRANS;

architecture behave of FRAME_TRANS is
	-- FSM indicator
	signal FSM_status: std_logic_vector (4-1 downto 0);
    
begin
	  
	-- ReadOut
	READ_OUT: process(clk, reset, en)
		variable Xout_temp, Yout_temp: signed(18-1 downto 0); 
		variable Xclamping, Yclamping: integer;
		variable Rout_temp, Gout_temp, Bout_temp, Iout_temp: unsigned(8-1 downto 0); 
	begin
		if(reset = '1') then
			-- Initialization
			Xout <= (others => '0');
			Yout <= (others => '0');
			Iout <= (others => '0');
			Rout <= (others => '0');
			Gout <= (others => '0');
			Bout <= (others => '0');
		else
			if(rising_edge(clk) and (en = '1')) then
				-- Main Process Here --
				-- Buffering Datapath
				-- Fetch a new pixel
				Rout_temp := unsigned(VIDEO_PIXEL_IN(24-1 downto 16));
				Gout_temp := unsigned(VIDEO_PIXEL_IN(16-1 downto 8));
				Bout_temp := unsigned(VIDEO_PIXEL_IN(8-1 downto 0));
				Iout_temp := (Rout_temp + Gout_temp + Bout_temp) / 3;
				
				-- Transformation
				Xout_temp := ( signed(V_SCAN_IN) - V_RES / 2 ) * (100 + Zoom) / 100 + V_RES / 2 + V_Position;
				Yout_temp := ( signed(H_SCAN_IN) - H_RES / 2 ) * (100 + Zoom) / 100 + H_RES / 2 + H_Position;
				-- For Debugging
				report "Xout_temp = "& integer'image(to_integer(Xout_temp));
				report "Yout_temp = "& integer'image(to_integer(Yout_temp));
				
				-- Clamper
				Xclamping := V_RES * (100 - to_integer(V_Blanking)) / 100;
				Yclamping := H_RES * (100 - to_integer(H_Blanking)) / 100;
				-- For Debugging
				report "Xclamping = "& integer'image(Xclamping);
				report "Yclamping = "& integer'image(Yclamping);
				-- stop;
				
				-- Clamping and Blanking
				if (((Xout_temp < 0) or (Xout_temp > V_RES - 1))
					or ((Yout_temp < 0) or (Yout_temp > H_RES - 1))
					or (Xout_temp > Xclamping)
					or (Yout_temp > Yclamping)) then
					Iout <= (others => '0');
					Rout <= (others => '0');
					Gout <= (others => '0');
					Bout <= (others => '0');
					Xout <= (others => '0');
					Yout <= (others => '0');
				else
					-- Output
					Xout <= unsigned(Xout_temp(10-1 downto 0));
					Yout <= unsigned(Yout_temp(10-1 downto 0));
					Rout <= Rout_temp;
					Gout <= Gout_temp;
					Bout <= Bout_temp;
					Iout <= Iout_temp;
				end if;
				
			end if;
		end if;
	end process;
	
end behave;
