library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;
-- use std.env.stop; -- For testbench only

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
		
		-- Controller for if accepting input data
		IF_RECV: in std_logic;
		
		-- Pixel selector
		H_IN, V_IN: in unsigned(10-1 downto 0); 
		
		-- Frame buffer input selector
		H_SCAN_IN, V_SCAN_IN: in unsigned(10-1 downto 0); 
		
		-- Zoom parameter, -100 for 0% and 100 for 200% zoom ratio
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
	constant V_RES: integer := 576 - 1; 
	constant V_RATE: integer := 25; 
	-- The highest frequency in this module is 10.368 MHz under PAL standard
	
	-- Buses and lines
	signal reg_write_data: unsigned(24-1 downto 0);
	signal reg_write_addr, reg_read_addr_A, reg_read_addr_B: unsigned(20-1 downto 0);
	signal reg_read_internal, reg_read_output: std_logic_vector(24-1 downto 0);
	signal reg_write_en: std_logic;
	signal if_new_pixel_available, if_new_pixel_read: std_logic;

begin
	-- Register
	-- Refresh the write-in address
	reg_write_addr <= V_SCAN_IN + H_SCAN_IN * V_RES;
	-- Currently read port A is vacant
	reg_read_addr_A <= (others => '0');
	-- Set up read port B for the next pixel
	reg_read_addr_B <= V_IN + H_IN * V_RES;
	
	-- Stop renewing the data when no input clock is detected or IF_RECV is false
	reg_write_en <= en and if_new_pixel_available and IF_RECV;
	
	-- Buffer instantiation
	reg_line_prefetch : entity work.RegFile(behave)
	generic map (M => 20, N => 24, C => H_RES * V_RES)
	port map (
		WD => std_logic_vector(VIDEO_PIXEL_IN),
		WAddr => std_logic_vector(reg_write_addr),
		RA => std_logic_vector(reg_read_addr_A),
		RB => std_logic_vector(reg_read_addr_B),
		Write => reg_write_en,
		ReadA => '0', -- Port A not using
		ReadB => en,
		reset => reset, 
		clk => clk_video_pixel_in, 
		QA => reg_read_internal,
		QB => reg_read_output
	);
	
	-- ReadOut
	READ_OUT: process(clk, reset, en)
		variable Xout_temp, Yout_temp: signed(18-1 downto 0); 
		variable Xclamping, Yclamping: integer;
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
			if_new_pixel_read <= '0';
			if_new_pixel_available <= '0';
		else
			if(rising_edge(clk) and (en = '1')) then
				-- Main Process Here --
				-- Buffering Datapath
				-- Fetch a new pixel
				Rout_temp := unsigned(reg_read_output(24-1 downto 16));
				Gout_temp := unsigned(reg_read_output(16-1 downto 8));
				Bout_temp := unsigned(reg_read_output(8-1 downto 0));
				Iout_temp := (Rout_temp + Gout_temp + Bout_temp) / 3;
				
				-- Transformation
				Xout_temp := ( signed(V_IN) - V_RES / 2 ) * (100 + Zoom) / 100 + V_RES / 2 + V_Position;
				Yout_temp := ( signed(H_IN) - H_RES / 2 ) * (100 + Zoom) / 100 + H_RES / 2 + H_Position;
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
				
				if (if_new_pixel_available = '1') then
					-- Set pixel-is-read flag
					if_new_pixel_read <= '1';
					if_new_pixel_available <= '0';
				else
					-- Check if new pixel available
					if(clk_video_pixel_in = '1') then
						if_new_pixel_available <= '1';
					else 
						if_new_pixel_read <= '0';
					end if;
				end if;
			end if;
		end if;
	end process;
	
end behave;
