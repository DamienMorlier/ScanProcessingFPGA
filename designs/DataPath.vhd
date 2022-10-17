library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity DataPath is 
	port(
		-- Input
		-- TC: HDMI frame clock
		-- TD2 ~ TD0: R,G,B components in series
		TC, TD0, TD1, TD2: in std_logic;
		clk, reset, en: in std_logic;
		
		-- Output
		VIDEO_PIXEL_OUT: out std_logic_vector(24-1 downto 0);
	);
end DataPath;

architecture behave of DataPath is
	-- Wiring ----------------------------
	-- HDMI input parser
	signal HDMI_VIDEO_PIXEL: std_logic_vector(24-1 downto 0);
	signal clk_video_frame: std_logic;
	
	-- USB generator controller parser
	signal ctr_Frequency: signed(16-1 downto 0);
	signal ctr_Waveform: unsigned(3-1 downto 0); -- Range 0 to 4
	signal ctr_Phase: unsigned(9-1 downto 0); -- Range 0 to 359
	signal ctr_Offset: 
	
	-- Buffer output
	signal buffer_Xout, buffer_Yout: unsigned (10-1 downto 0);
	signal buffer_Rout, buffer_Gout, buffer_Bout, buffer_Iout: unsigned (8-1 downto 0);
	
	-- Function Generator
	signal 
	
	-- Matrix processor input/output
	signal mat_Zin, mat_Xout, mat_Yout, mat_Zout: unsigned (10-1 downto 0);
	signal mat_Iout: unsigned (8-1 downto 0);
	
	
	
begin

end behave;