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
		VIDEO_PIXEL_OUT_RGB_RAW: out std_logic_vector(24-1 downto 0);	-- RAW 24bit pixel data
		-- HDMI output
		TMDS_R : out STD_LOGIC;
		TMDS_G : out STD_LOGIC;
		TMDS_B : out STD_LOGIC;
		TMDS_CLK : out STD_LOGIC;
		
		-- Analog controller output
		Xout, Yout: out unsigned (10-1 downto 0);
		Rout, Gout, Bout: out unsigned (8-1 downto 0);
		Iout: out unsigned (8-1 downto 0)
	);
end DataPath;

architecture behave of DataPath is
	-- Wiring ----------------------------
	-- HDMI input parser
	signal HDMI_VIDEO_PIXEL: std_logic_vector(24-1 downto 0);
	signal CTRL_WORD: std_logic_vector(8-1 downto 0);
	signal clk_video_pixel, CTRL_SIG: std_logic;
	
	-- USB generator controller parser
	signal ctr_FrameBuffer_Zoom: in signed(8-1 downto 0);
	signal ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking: in unsigned(8-1 downto 0);
	signal ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position: in signed(10-1 downto 0);
	signal ctr_Scanner_H_Frequency: unsigned(16-1 downto 0); -- Derek says he also wanted backward scanning, so should we consider a signed frequency value? 
	signal ctr_Scanner_H_Waveform: unsigned(3-1 downto 0); -- Range 0 to 4
	signal ctr_Scanner_H_Phase: unsigned(9-1 downto 0); -- Range 0 to 359
	signal ctr_Scanner_H_Offset: unsigned(16-1 downto 0);
	signal ctr_Scanner_H_Scale: unsigned(16-1 downto 0);
	signal ctr_Scanner_H_RAMP: std_logic_vector(16-1 downto 0);
	signal ctr_Scanner_V_Frequency: unsigned(16-1 downto 0);
	signal ctr_Scanner_V_Waveform: unsigned(3-1 downto 0); -- Range 0 to 4
	signal ctr_Scanner_V_Phase: unsigned(9-1 downto 0); -- Range 0 to 359
	signal ctr_Scanner_V_Offset: unsigned(16-1 downto 0);
	signal ctr_Scanner_V_Scale: unsigned(16-1 downto 0);
	signal ctr_Scanner_V_RAMP: std_logic_vector(16-1 downto 0);
	
	-- Scanning generator output
	signal I_OUT, B_OUT: std_logic; -- Seems the generator is not fully developed
	signal DCO_OUT: std_logic_vector(10-1 downto 0);
	
	-- Buffer output
	signal buffer_status: std_logic_vector(4-1 downto 0);
	signal buffer_Xout, buffer_Yout: unsigned (10-1 downto 0);
	signal buffer_Rout, buffer_Gout, buffer_Bout, buffer_Iout: unsigned (8-1 downto 0);
	
	-- Matrix processor input/output
	signal mat_Zin, mat_Xout, mat_Yout, mat_Zout: unsigned (10-1 downto 0);
	signal mat_Iout: unsigned (8-1 downto 0);
		
begin
	--------------------------------------------------------------------
	-- HDMI input 
	HDMI_IN: entity work.HDMI_RECV(behave)
		port map(
			TC, TD0, TD1, TD2,
			clk, reset, en,
			HDMI_VIDEO_PIXEL, 
			CTRL_WORD,
			clk_video_pixel, CTRL_SIG
		);

	--------------------------------------------------------------------
	-- Scanning generator
	SCANNING_H_GEN: entity work.FunctionGenerator(behaviour)
		generic map(16)
		port map(
			clock => clk, 
			reset => reset,
			phase_incr => std_logic_vector(ctr_Scanner_H_Frequency),
			Scale => std_logic_vector(ctr_Scanner_H_Scale),
			Offset_val => std_logic_vector(ctr_Scanner_H_Offset),
			External => '0', -- Unused port in FunctionGenerator!!! 
			Harmonic => (others => '0'), -- Unused port in FunctionGenerator!!!
			Phase => std_logic_vector(ctr_Scanner_H_Phase),
			Sync => '0', -- Unused port in FunctionGenerator, but '0' indicates internal DCO selected
			Waveform => '0', -- Unused port in FunctionGenerator, but the ramp waveform should be selected in this instance
			DCO_OUT => ctr_Scanner_H_RAMP, 
			I_OUT =>I_OUT,
			B_OUT => B_OUT
		);
		
	SCANNING_V_GEN: entity work.FunctionGenerator(behaviour)
		generic map(16)
		port map(
			clock => clk, 
			reset => reset,
			phase_incr => std_logic_vector(ctr_Scanner_V_Frequency),
			Scale => std_logic_vector(ctr_Scanner_V_Scale),
			Offset_val => std_logic_vector(ctr_Scanner_V_Offset),
			External => '0', -- Unused port in FunctionGenerator!!! 
			Harmonic => (others => '0'), -- Unused port in FunctionGenerator!!!
			Phase => std_logic_vector(ctr_Scanner_V_Phase),
			Sync => '0', -- Unused port in FunctionGenerator, but '0' indicates internal DCO selected
			Waveform => '0', -- Unused port in FunctionGenerator, but the ramp waveform should be selected in this instance
			DCO_OUT => ctr_Scanner_V_RAMP, 
			I_OUT =>I_OUT,
			B_OUT => B_OUT
		);
		
	--------------------------------------------------------------------
	-- Frame Buffer
	FRAME_BUFF: entity work.FRAME_BUFFER(behave)
		port map(
			clk, en, reset, 
			clk_video_pixel, 
			HDMI_VIDEO_PIXEL, 
			ctr_Scanner_H_RAMP(16-1 downto 6), ctr_Scanner_V_RAMP(16-1 downto 6), 
			ctr_FrameBuffer_Zoom,
			ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position, 
			ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking, 
			buffer_status, 
			buffer_Xout, buffer_Yout, 
			buffer_Rout, buffer_Gout, buffer_Bout, 
			buffer_Iout
		);
		
	-- Directly connect the buffer to analog output for the current testing stage
	Xout <= buffer_Xout; Yout <= buffer_Yout; 
	Rout <= buffer_Rout; Gout <= buffer_Gout; Bout <= buffer_Bout; 
	Iout <= buffer_Iout; 
	
	-- To HDMI output
	HDMI_OUT: entity work.HDMI_OUTPUT(Behavioral)
		port map(
			clk, reset, en, 
			buffer_Rout & buffer_Gout & buffer_Bout,
			TMDS_R, TMDS_G, TMDS_B, TMDS_CLK
		);
	        
end behave; 