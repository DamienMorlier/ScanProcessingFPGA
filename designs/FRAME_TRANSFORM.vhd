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
		
		-- Video stream sync signals
		--vid_clk, vde_out, vsync_out, hsync_out	: in std_logic;
		
		-- Coordinators input
		H_SCAN_IN, V_SCAN_IN: in std_logic_vector(10-1 downto 0); 
		
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
    signal Xout_temp, Yout_temp: signed(20 - 1 downto 0); 
    signal Xmult, Ymult: std_logic_vector(20 - 1 downto 0);
    signal Zoom_temp: signed(10 - 1 downto 0);
    signal h_bl, v_bl: unsigned(8-1 downto 0); -- h_bl = 100 - H_Blanking, and vice versa.
    COMPONENT mult_10_10_20
      PORT (
        CLK : IN STD_LOGIC;
        A : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        P : OUT STD_LOGIC_VECTOR(19 DOWNTO 0) 
      );
    END COMPONENT;
begin
	-- Mults for coordinator calculations
	U_XMULT : mult_10_10_20
      PORT MAP (
        CLK => clk,
        A => H_SCAN_IN,
        B => std_logic_vector(Zoom_temp),
        P => Xmult
      );
      
    U_YMULT : mult_10_10_20
      PORT MAP (
        CLK => clk,
        A => V_SCAN_IN,
        B => std_logic_vector(Zoom_temp),
        P => Ymult
      );
	
	-- ReadOut
	
	READ_OUT: process(clk, reset, en)
		-- variable Xout_temp, Yout_temp: signed(18-1 downto 0); 
		variable Xclamping, Yclamping: integer;
		-- variable zm, h_bl, v_bl: integer;
		variable Rout_temp, Gout_temp, Bout_temp, Iout_temp: unsigned(8-1 downto 0); 
	begin
		if(reset = '1') then
			-- Initialization
			Xout <= (others => '0');
			Yout <= (others => '0');
			Xout_temp <= (others => '0');
			Yout_temp <= (others => '0');
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
					
				-- Zooming
				if(Zoom > 100) then Zoom_temp <= to_signed(200, Zoom_temp'length);
				elsif(Zoom < -100) then Zoom_temp <= to_signed(0, Zoom_temp'length);
				else Zoom_temp <= to_signed(to_integer(Zoom) + 100, Zoom_temp'length);
				end if;
				Xout_temp <= signed(Xmult) / 100 + H_RES / 2 + H_Position;
				Yout_temp <= signed(Ymult) / 100 + V_RES / 2 + V_Position;
				
				-- Clamper
				if(H_Blanking > 100) then h_bl <= to_unsigned(0, h_bl'length);
				else h_bl <= 100 - H_Blanking;
				end if;
				if(V_Blanking > 100) then v_bl <= to_unsigned(0, v_bl'length);
				else v_bl <= 100 - V_Blanking;
				end if;
				Xclamping := H_RES * to_integer(h_bl);
				Yclamping := V_RES * to_integer(v_bl);
				
				-- Clamping and Blanking
				if (((Xout_temp < 0) or (Xout_temp > H_RES - 1))
					or ((Yout_temp < 0) or (Yout_temp > V_RES - 1))
					or (Xout_temp * 100 > Xclamping)
					or (Yout_temp * 100 > Yclamping)
					) then
					Iout <= (others => '0');
					Rout <= (others => '0');
					Gout <= (others => '0');
					Bout <= (others => '0');
				else
					-- Output
					Rout <= Rout_temp;
					Gout <= Gout_temp;
					Bout <= Bout_temp;
					Iout <= Iout_temp;
					Xout <= unsigned(Xout_temp(10-1 downto 0));
				    Yout <= unsigned(Yout_temp(10-1 downto 0));
				end if;
			end if;
		end if;
	end process;
	
end behave;
