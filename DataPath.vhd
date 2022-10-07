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
		clk_video_frame: out std_logic
	);
end DataPath;

architecture behave of DataPath is

begin

end behave;