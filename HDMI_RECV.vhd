library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity HDMI_RECV is 
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
end HDMI_RECV;

architecture behave of HDMI_RECV is
	-- Constants
	constant V_RES: integer := 625 - 1; -- 5^4
	constant H_RATE: integer := 15625; -- 5^5
	constant V_RATE: integer := 25; -- 5^2
	-- The highest frequency in this module is 5.5 MHz.
	
	-- Signals or buffers
	signal TC_B, TD0_B, TD1_B, TD2_B: std_logic;
	signal counter: unsigned(6-1 downto 0);
	signal status: std_logic_vector(2-1 downto 0);
begin
	-- Buffering signals for integerity
	TC_B <= TC;
	TD0_B <= TD0;
	TD1_B <= TD1;
	TD2_B <= TD2;
	
	process(clk, reset, en)
		variable counter_temp: integer range 0 to 24;
	begin
		if ((reset = '1') or (en /= '1')) then
			counter <= (others => '0');
			status <= "01";
			VIDEO_PIXEL_OUT <= (others => '1');
			clk_video_frame <= '0';
		else
			case status is
				when "01" =>
					-- First start, wait for 16 complete frames for stability
					if (rising_edge(TC)) then
						counter <= counter + 1;
						if(counter = 16) then 
							counter <= (others => '0');
							status <= "10";
						end if;
					end if;
				when "10" =>
					-- Capturing data
					if(rising_edge(clk)) then 
						counter_temp := to_integer(counter);
						-- R component bit
						VIDEO_PIXEL_OUT(counter_temp + 16) <= TD2_B;
						-- G component bit
						VIDEO_PIXEL_OUT(counter_temp + 8) <= TD1_B;
						-- B component bit
						VIDEO_PIXEL_OUT(counter_temp + 0) <= TD0_B;
						counter_temp := counter_temp + 1;
						if(counter_temp = 8) then 
							counter_temp := 0; 
							clk_video_frame <= '1';
						else 
							clk_video_frame <= '0';
						end if;
						counter <= to_unsigned(counter_temp, counter'length);
					end if;
				when others =>
					-- Exception process
					counter <= (others => '0');
					status <= "01";
					VIDEO_PIXEL_OUT <= (others => '1');
					clk_video_frame <= '0';
			end case;
		end if;
	end process;
	
end behave;
