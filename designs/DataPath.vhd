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
		clk, reset, en: in std_logic;	-- clk should be 200 MHz
		
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
	signal vid_pVDE, vid_pHSync, vid_pVSync: std_logic;
	signal clk_video_reLock: std_logic;
	signal CTRL_WORD: std_logic_vector(8-1 downto 0);
	signal clk_video_pixel, clk_video_pixel_5x, clk_video_pixel_Lckd, CTRL_SIG: std_logic;
	-- Optional DDC port
	signal DDC_SDA_I, DDC_SDA_O, DDC_SDA_T, DDC_SCL_I, DDC_SCL_O, DDC_SCL_T: std_logic;
	
	-- USB generator controller parser
	signal ctr_FrameBuffer_Zoom: signed(8-1 downto 0);
	signal ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel: unsigned(10-1 downto 0);
	signal ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking: unsigned(8-1 downto 0);
	signal ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position: signed(10-1 downto 0);
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
	signal ctr_Scanner_IF_RECV: std_logic := '1';
	
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
	
	-- Final-stage output buffer
	signal RGB_RAW_out: std_logic_vector(24-1 downto 0);
begin
	--------------------------------------------------------------------
	-- HDMI input 
	HDMI_INPUT: entity work.dvi2rgb(Behavioral)
		port map(
			TMDS_Clk_p => TC,
			TMDS_Clk_n => not TC,
			TMDS_Data_p => TD2 & TD1 & TD0,
			TMDS_Data_n => (not TD2) & (not TD1) & (not TD0),

			-- Auxiliary signals 
			RefClk => clk, --200 MHz reference clock for IDELAYCTRL, reset, lock monitoring etc.
			aRst => reset, --asynchronous reset; must be reset when RefClk is not within spec
			aRst_n => not reset, --asynchronous reset; must be reset when RefClk is not within spec

			-- Video out
			vid_pData => HDMI_VIDEO_PIXEL,
			vid_pVDE => vid_pVDE,
			vid_pHSync => vid_pHSync,
			vid_pVSync => vid_pVSync,

			PixelClk => clk_video_pixel, --pixel-clock recovered from the DVI interface

			SerialClk => clk_video_pixel_5x, -- advanced use only; 5x PixelClk
			aPixelClkLckd => clk_video_pixel_Lckd, -- advanced use only; PixelClk and SerialClk stable

			-- Optional DDC port
			DDC_SDA_I => DDC_SDA_I,
			DDC_SDA_O => DDC_SDA_O,
			DDC_SDA_T => DDC_SDA_T,
			DDC_SCL_I => DDC_SCL_I,
			DDC_SCL_O => DDC_SCL_O, 
			DDC_SCL_T => DDC_SCL_T,

			pRst => clk_video_reLock, -- synchronous reset; will restart locking procedure
			pRst_n => clk_video_reLock -- synchronous reset; will restart locking procedure
		);
		
	--------------------------------------------------------------------
	-- Frame Buffer
	FRAME_BUFF: entity work.FRAME_BUFFER(behave)
		port map(
			clk, en, reset, 
			clk_video_pixel, 
			HDMI_VIDEO_PIXEL, 
			ctr_Scanner_IF_RECV,
			ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel,
			vid_pHSync, vid_pVSync,
			vid_pVDE,
			ctr_FrameBuffer_Zoom,
			ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position, 
			ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking, 
			buffer_status, 
			clk_video_reLock,
			buffer_Xout, buffer_Yout, 
			buffer_Rout, buffer_Gout, buffer_Bout, 
			buffer_Iout
		);
	
	-- Here for process matrixes stuff
	
	
	-- Directly connect the buffer to analog output for the current testing stage
	Xout <= buffer_Xout; Yout <= buffer_Yout; 
	Rout <= buffer_Rout; Gout <= buffer_Gout; Bout <= buffer_Bout; 
	Iout <= buffer_Iout; 
	
	-- To HDMI output
	RGB_RAW_out <= std_logic_vector(buffer_Rout) & std_logic_vector(buffer_Gout) & std_logic_vector(buffer_Bout);
	VIDEO_PIXEL_OUT_RGB_RAW <= RGB_RAW_out;
	        
end behave; 