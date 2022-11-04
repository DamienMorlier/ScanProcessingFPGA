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
		RGB_OUTPUT: out std_logic_vector(24-1 downto 0);
		CTRL_WORD: out std_logic_vector(8-1 downto 0);
		clk_video_pixel, CTRL_SIG: out std_logic
	);
end HDMI_RECV;

architecture behave of HDMI_RECV is
	-- 8b/10b decoder by Chuck Benz.
	COMPONENT dec_8b10b
	  PORT (
		reset : in std_logic; --Active high reset
        clk : in std_logic;   --Clock to register output and disparity
        datain : in std_logic_vector(9 downto 0); --10b data input
        ena : in std_logic; -- Enable registers for output and disparity
        ko : out std_logic ;-- Active high K indication
        dataout : out std_logic_vector(7 downto 0); --Decoded output
        code_err : out std_logic; --Indication for illegal character
        disp_err : out std_logic --Indication for disparity error
	  );
	END COMPONENT;
	signal dec_data_in: std_logic_vector(10-1 downto 0);
	signal dec_data_out: std_logic_vector(8-1 downto 0);
	signal ko, code_err, disp_err: std_logic;

	-- Constants
	constant V_RES: integer := 625 - 1; -- 5^4
	constant H_RATE: integer := 15625; -- 5^5
	constant V_RATE: integer := 25; -- 5^2
	-- The highest frequency in this module is 5.5 MHz.
	
	-- Signals or buffers
	signal HDMI_INPUT_PARSER: std_logic_vector(30-1 downto 0);
	signal HDMI_INPUT_BUFFER: std_logic_vector(30-1 downto 0); -- Just a copy of the parser
	signal HDMI_INPUT_BUFFER_RDY: std_logic; -- Indicator of whether the parser is full
	signal TC_B, TD0_B, TD1_B, TD2_B: std_logic;
	signal counter: unsigned(6-1 downto 0);
	signal status: std_logic_vector(2-1 downto 0);
begin
	-- Decoder Instantition
	DECODER: dec_8b10b
		port map(
			reset => reset,
			clk => clk,
			datain => dec_data_in, 
			ena => en,
			ko => ko, 
			dataout => dec_data_out, 
			code_err => code_err,
			disp_err => disp_err
		);

	-- Buffering signals for integerity
	TC_B <= TC;
	TD0_B <= TD0;
	TD1_B <= TD1;
	TD2_B <= TD2;
	
	SEQ_PARSER: process(clk, reset, en)
		variable counter_temp: integer range 0 to 24;
	begin
		if ((reset = '1') or (en /= '1')) then
			counter <= (others => '0');
			status <= "01";
			HDMI_INPUT_PARSER <= (others => '1');
			HDMI_INPUT_BUFFER <= (others => '0');
			HDMI_INPUT_BUFFER_RDY <= '0';
		else
			case status is
				when "01" =>
					-- First start, wait for 30 complete pixels for stability
					if (rising_edge(TC)) then
						counter <= counter + 1;
						if(counter = 30) then 
							counter <= (others => '0');
							status <= "10";
						end if;
					end if;
				when "10" =>
					-- Capturing data
					if(rising_edge(clk)) then 
						counter_temp := to_integer(counter);
						-- R component bit
						HDMI_INPUT_PARSER(counter_temp + 20) <= TD2_B;
						-- G component bit
						HDMI_INPUT_PARSER(counter_temp + 10) <= TD1_B;
						-- B component bit
						HDMI_INPUT_PARSER(counter_temp + 0) <= TD0_B;
						counter_temp := counter_temp + 1;
						if(counter_temp = 10) then 
							counter_temp := 0; 
						else 
							if((counter_temp = 0) and (HDMI_INPUT_BUFFER_RDY = '0')) then
								HDMI_INPUT_BUFFER_RDY <= '1';
								HDMI_INPUT_BUFFER <= HDMI_INPUT_PARSER;
							end if;
						end if;
						counter <= to_unsigned(counter_temp, counter'length);
					end if;
				when others =>
					-- Exception process
					counter <= (others => '0');
					status <= "01";
					HDMI_INPUT_PARSER <= (others => '1');
			end case;
		end if;
	end process;
	
	DECODE: process(clk, reset)
	begin
		if(reset = '1') then 
			RGB_OUTPUT <= (others => '0');
			dec_data_in <= (others => '0');
			clk_video_pixel <= '0';
		else
			if(rising_edge(clk)) then
				-- Pipelining: shared decoder to cut down the scale
				-- Refresh CTR_SIG when control signal is detected
				CTRL_SIG <= ko;
				if ko = '1' then 
				    CTRL_WORD <= dec_data_out;
				end if;
				case to_integer(counter) is
					when 1 =>
						-- Load Red signal
						dec_data_in <= HDMI_INPUT_BUFFER(30-1 downto 20);
					when 2 =>
						-- Export Red signal
						if ko = '0' then
							RGB_OUTPUT(24-1 downto 16) <= dec_data_out;
						else
							RGB_OUTPUT(24-1 downto 16) <= (others => '0');
						end if;
						-- Load Green signal
						dec_data_in <= HDMI_INPUT_BUFFER(20-1 downto 10);
					when 3 =>
						-- Export Green signal
						if ko = '0' then
							RGB_OUTPUT(16-1 downto 8) <= dec_data_out;
						else
							RGB_OUTPUT(16-1 downto 8) <= (others => '0');
						end if;
						-- Load Blue signal
						dec_data_in <= HDMI_INPUT_BUFFER(10-1 downto 0);
					when 4 =>
						-- Export Green signal
						if ko = '0' then
							RGB_OUTPUT(8-1 downto 0) <= dec_data_out;
						else
							RGB_OUTPUT(8-1 downto 0) <= (others => '0');
						end if;
						-- Set "new pixel ready" flag and remove the "buffer-ready" flag
						clk_video_pixel <= '1';
						HDMI_INPUT_BUFFER_RDY <= '0';
					when others =>
						-- Reset pixel clock
						clk_video_pixel <= '0';
				end case;
			end if;
		end if;
	end process;
	
end behave;
