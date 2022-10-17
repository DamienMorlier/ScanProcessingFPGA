library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity FRAME_BUFFER is
	generic(H_RES: integer := 720 - 1);
	port(
		-- REMINDER!!!
		-- ALL NAMES OF PORTS MENTIONED BY DEREK 
		-- WILL START WITH A CAPITAL LETTER
		
		-- Input ports ------------------------------
		-- Global enabler, clock and reset, active high
		clk, en, reset: in std_logic;
		
		-- Reset signal for notifying a new video frame coming in
		clk_video_pixel_in: in std_logic; 
		
		-- Video frames input, single pixel with 8 bit depth in R-G-B
		VIDEO_PIXEL_IN: in std_logic_vector(24-1 downto 0);
		
		-- Pixel selector
		H_IN, V_IN: in unsigned(10-1 downto 0); 
		
		-- Zoom parameter, -64 for 0% and 64 for 200% zoom ratio
		Zoom: in signed(8-1 downto 0);
		
		-- Pixel selector
		H_Position, V_Position: in signed(10-1 downto 0); 
		
		-- Percentage of output frame blanked. 
		-- Range [0,100] (integer)
		H_Blanking, V_Blanking: in unsigned(8-1 downto 0); 
		
		-- Output ports ----------------------------
		-- FSM indicator, if needed
		status: out std_logic_vector(4-1 downto 0);
		
		-- Position and intensity output 
		Xout, Yout: out unsigned (10-1 downto 0);
		Rout, Gout, Bout: out unsigned (8-1 downto 0);
		Iout: out unsigned (8-1 downto 0)
		
	);
end FRAME_BUFFER;

architecture behave of FRAME_BUFFER is
	-- Constants
	constant V_RES: integer := 625 - 1; -- 5^4
	constant H_RATE: integer := 15625; -- 5^5
	constant V_RATE: integer := 25; -- 5^2
	-- The highest frequency in this module is 5.5 MHz.
	
	-- Buses and lines
	signal reg_write_data: unsigned(24-1 downto 0);
	signal reg_write_addr, reg_read_addr_A, reg_read_addr_B: unsigned(20-1 downto 0);
	signal reg_read_internal, reg_read_output: std_logic_vector(24-1 downto 0);
	signal video_in_rgb_to_intensity: unsigned(8-1 downto 0);

begin
	-- Register
	reg_line_prefetch : entity work.RegFile(behave)
	generic map (M => 20, N => 24)
	port map (
		WD => std_logic_vector(VIDEO_PIXEL_IN),
		WAddr => std_logic_vector(reg_write_addr),
		RA => std_logic_vector(reg_read_addr_A),
		RB => std_logic_vector(reg_read_addr_B),
		Write => en,
		ReadA => en,
		ReadB => en,
		reset => reset, 
		clk => clk_video_pixel_in, 
		QA => reg_read_internal,
		QB => reg_read_output
	);
	
	-- ReadOut
	READ_OUT: process(clk, reset, en)
		variable Xout_temp, Yout_temp: signed(18-1 downto 0); 
		variable Xclamping, Yclamping: signed(16-1 downto 0);
		variable Rout_temp, Gout_temp, Bout_temp, Iout_temp: unsigned(8-1 downto 0); 
	begin
		if(reset = '1') then
			-- Initialization
			status <= (others => '0');
			Xout <= (others => '0');
			Yout <= (others => '0');
			Iout <= (others => '0');
			Rout <= (others => '0');
			Gout <= (others => '0');
			Bout <= (others => '0');
		else
			if(rising_edge(clk) and en = '1') then
				-- Main Process Here --
				-- Buffering Datapath
				-- Currently read port A is vacant
				reg_read_addr_A <= (others => '0');
				-- Set up read port B for the next pixel
				reg_read_addr_B <= H_IN + V_IN * V_RES;
				
				-- Fetch a new pixel
				Rout_temp := unsigned(reg_read_output(24-1 downto 16));
				Gout_temp := unsigned(reg_read_output(16-1 downto 8));
				Bout_temp := unsigned(reg_read_output(8-1 downto 0));
				Iout_temp := (Rout_temp + Gout_temp + Bout_temp) / 3;
				
				-- Transformation
				Xout_temp := ( signed(H_IN) - H_RES / 2 ) * Zoom / 100 + signed(H_IN) + signed(H_Position);
				Yout_temp := ( signed(V_IN) - V_RES / 2 ) * Zoom / 100 + signed(V_IN) + signed(V_Position);
				Xclamping := H_RES * signed(H_Blanking) / 100;
				Yclamping := V_RES * signed(V_Blanking) / 100;
				
				-- Clamping and Blanking
				if (((Xout_temp < 0) or (Xout_temp > H_RES - 1))
					or ((Yout_temp < 0) or (Yout_temp > V_RES - 1))
					or (Xout_temp > Xclamping)
					or (Yout_temp > Yclamping)) then
					Iout <= (others => '0');
					Rout <= (others => '0');
					Gout <= (others => '0');
					Bout <= (others => '0');
					Xout <= (others => '1');
					Yout <= (others => '1');
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