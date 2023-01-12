library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.float_pkg.all;
use work.CONN_MAT_PACKAGE.all;

entity DataPath is 
	port(
		-- Input --------------------------------------------
		clk, reset, en: in std_logic;	-- clk should be 100 MHz
		clk_w_11M52, clk_11M52_lckd: in std_logic;         -- clk for frame processor
		HDMI_VIDEO_PIXEL: in std_logic_vector(24-1 downto 0);
		Xsync, Ysync: in std_logic_vector (10-1 downto 0);
		
		-- Function Generator Parameters
		ctr_Gen_Selector: in std_logic_vector(5-1 downto 0); -- Maximum 32 generators
		ctr_Scanner_External_Ramp_in: in std_logic_vector(16-1 downto 0);--External Ramp in
		ctr_Scanner_Frequency           : in std_logic_vector(16-1 downto 0); --/Frequency
        ctr_Scanner_Scale1              : in std_logic_vector(16-1 downto 0);--/Harmonic
        ctr_Scanner_Scale2              : in std_logic_vector(16-1 downto 0);--/Scale
        ctr_Scanner_PhaseOff1           : in std_logic_vector(16-1 downto 0);--/PhaseShift1(Offset)
        ctr_Scanner_PhaseOff2           : in std_logic_vector(16-1 downto 0);--/PhaseShift2(Phase)
        ctr_Scanner_Waveform            : in std_logic_vector(3 downto 0);--/Waveform
        ctr_Blanking_Phase              : in std_logic_vector(10-1 downto 0); --/Blanking Phase
        ctr_Blanking_Width              : in std_logic_vector(10-1 downto 0); --/Blanking Width
		ctr_Phase_Reset					: in std_logic;	--/Reset, set all generators' phase back to 0
		ctr_Sync						: in std_logic; --/Sync
		
		-- Static adjustable variables
		ctr_Perspective_Distance		: in std_logic_vector(8-1 downto 0);--/A, perspective distance, unsigned
		ctr_Distance_Limit				: in std_logic_vector(8-1 downto 0);--/Dmax, unsigned
		ctr_Perspective_Shift_X			: in std_logic_vector(8-1 downto 0);--/Sx, signed
		ctr_Perspective_Shift_Y			: in std_logic_vector(8-1 downto 0);--/Sy, signed
		
		-- Stream Video Sync Signals
		-- vid_clk, vde_out, vsync_out, hsync_out	: in std_logic;
		
		-- Connection Matrix Parameters
		P_PARAM_SEL: in std_logic; -- 1 for loading new coefficients, 0 for latched state
		P_MULT_IN: in std_logic_vector(10-1 downto 0);
		P_ADD_IN: in std_logic_vector(10-1 downto 0);	
		WIRING_MODIFIER_ENABLER: in std_logic_vector(2 * 12 -1 downto 0);
		WIRING_MODIFIER_PARAM: in std_logic_vector(32 - 1 downto 0);
		
		-- Output -------------------------------------------
		-- Parameters output
		ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position: out signed(10-1 downto 0);
		
		-- Divided clock
		clk_sync: out std_logic;
		
		-- Analog controller output
		Xout, Yout: out std_logic_vector (10-1 downto 0);
		Xsel, Ysel: out std_logic_vector (10-1 downto 0);
		Rout, Gout, Bout: out std_logic_vector (8-1 downto 0);
		Iout: out std_logic_vector (8-1 downto 0);
		
		-- For testing
		Gen_probe: out std_logic_vector (10-1 downto 0) -- Function generator scope
	);
end DataPath;

architecture behave of DataPath is
	-- Wiring ----------------------------
	
	-- USB generator controller parser
	signal ctr_FrameBuffer_Zoom: signed(8-1 downto 0);
	signal ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel: std_logic_vector(10-1 downto 0);
	signal ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking: unsigned(8-1 downto 0);
	-- signal ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position: signed(10-1 downto 0);
	-- Following the FunctionGenerator.vhd
	signal ctr_Scanner_Sync, ctr_Scanner_Switch: std_logic;
	
	-- Buffer output
	signal buffer_status: std_logic_vector(4-1 downto 0);
	signal buffer_Xout, buffer_Yout: unsigned (10-1 downto 0);
	signal buffer_Rout, buffer_Gout, buffer_Bout, buffer_Iout: unsigned (8-1 downto 0);
	
	-- Generators and Connection Matrix
	signal P_MULT: PARAM_BUS;
	signal P_ADD: PARAM_BUS;
	signal GEN_OUTPUT: CONTROLLER_IN_BUS;	-- True output
	signal GEN_SELECTOR_EN: std_logic_vector(32-1 downto 0);
	signal X_mod, Y_mod, Z_mod, I_mod, -- Signed type
		X_rot, Y_rot, Z_rot, Zoom, 	-- Signed type
		H_position, V_position,	-- Signed type
		H_blanking, V_blanking: std_logic_vector(DATA_WIDTH-1 downto 0);	-- Unsigned type
	
	-- Matrix processor input/output
	signal mat_Zin, mat_Xout, mat_Yout, mat_Zout: unsigned (10-1 downto 0);
	signal mat_Iout: unsigned (8-1 downto 0);
	
	-- Rotation processor
	signal Xro, Yro, Zro: float(5 downto -10);
	
begin
	------------------------------------------------------------------------------
	-- Matrix and Transformations
	
	-- Piles of All-purpose Function Generators
	GEN_SEL: for i in 0 to 32-1 generate
	   process (clk) begin
	       if(to_integer(unsigned(ctr_Gen_Selector)) = i) then
	           GEN_SELECTOR_EN(i) <= '1';
	       else
	           GEN_SELECTOR_EN(i) <= '0';
	       end if;
	   end process;
	end generate;
	
	-- Mapping the parameters
	PARAM_MAP: process (clk, en, reset)
	begin
		if(reset = '1') then
			for i in 0 to N_CALC_UNITS-1 loop
				P_MULT(i) <= std_logic_vector(to_signed(1, DATA_WIDTH));
				P_ADD(i) <= std_logic_vector(to_signed(0, DATA_WIDTH));
			end loop;
			
			Gen_probe <= (others => '0');
		else
			if(en= '1') then
				for i in 0 to N_CALC_UNITS-1 loop
					if P_PARAM_SEL = '1' then
						-- Low index high priority. Only set the selected generator with the lowest index
						if(WIRING_MODIFIER_ENABLER(i * 2) = '1') then
							P_MULT(i) <= P_MULT_IN;
						end if;
						if(WIRING_MODIFIER_ENABLER(i * 2 + 1) = '1') then
							P_ADD(i) <= P_ADD_IN;
						end if;
					end if;
				end loop;
				
				-- For testing use. Output the selected generator.
				for i in 0 to 2*N_CALC_UNITS-1 loop
					if GEN_SELECTOR_EN(i) = '1' then
						Gen_probe <= GEN_OUTPUT(i);
						exit;
					end if;
				end loop;
			end if;
		end if;
	end process;
			
	-- Robin ver generators
	ctr_Scanner_Switch <= ctr_Sync;
	ctr_Scanner_Sync <= ctr_Phase_Reset;
	-- First two are fast generators that supports high definition video scanning
	GEN_MAT_FAST: for i in 0 to 1 generate
		U_GEN_FAST: entity work.FunctionGenerator(behaviour_robin_ver_fast)
			generic map(DATA_WIDTH=>16)
			port map(
				clk => clk, 
				reset => reset,
				en => GEN_SELECTOR_EN(i),
				ctr_Scanner_Sync => ctr_Scanner_Sync,
				ctr_Scanner_External_Ramp_in => ctr_Scanner_External_Ramp_in, 
				ctr_Scanner_Switch => ctr_Scanner_Switch,
				ctr_Scanner_Frequency => ctr_Scanner_Frequency,
				ctr_Scanner_Scale1 => ctr_Scanner_Scale1,
				ctr_Scanner_Scale2 => ctr_Scanner_Scale2,
				ctr_Scanner_PhaseOff1 => ctr_Scanner_PhaseOff1,
				ctr_Scanner_PhaseOff2 => ctr_Scanner_PhaseOff2,
				ctr_Scanner_Waveform => ctr_Scanner_Waveform,
				-- ctr_DCO_OUT => GEN_DCO_OUT(i),
				ctr_Bipolar_OUT => GEN_OUTPUT(i)
			);
	end generate;
	
	-- The remaining 22 are slow oscillators for modulations (<5000 Hz)
	GEN_MAT_SLOW: for i in 2 to N_GENERATORS-1 generate
		U_GEN_SLOW: entity work.FunctionGenerator(behaviour_robin_ver_slow)
			generic map(DATA_WIDTH=>16)
			port map(
				clk => clk, 
				reset => reset,
				en => GEN_SELECTOR_EN(i),
				ctr_Scanner_Sync => ctr_Scanner_Sync,
				ctr_Scanner_External_Ramp_in => ctr_Scanner_External_Ramp_in, 
				ctr_Scanner_Switch => ctr_Scanner_Switch,
				ctr_Scanner_Frequency => ctr_Scanner_Frequency,
				ctr_Scanner_Scale1 => ctr_Scanner_Scale1,
				ctr_Scanner_Scale2 => ctr_Scanner_Scale2,
				ctr_Scanner_PhaseOff1 => ctr_Scanner_PhaseOff1,
				ctr_Scanner_PhaseOff2 => ctr_Scanner_PhaseOff2,
				ctr_Scanner_Waveform => ctr_Scanner_Waveform,
				-- ctr_DCO_OUT => GEN_DCO_OUT(i),
				ctr_Bipolar_OUT => GEN_OUTPUT(i)
			);
	end generate;
	
	-- Here for process matrixes stuff
	ctr_FrameBuffer_H_Position <= signed(H_position);
	ctr_FrameBuffer_V_Position <= signed(V_position);
	ctr_FrameBuffer_H_Blanking <= unsigned(H_blanking(DATA_WIDTH-1 downto DATA_WIDTH-8));
	ctr_FrameBuffer_V_Blanking <= unsigned(V_blanking(DATA_WIDTH-1 downto DATA_WIDTH-8));
	CONN_MATRIX: entity work.CONN_MAT(structural)
		port map(
			reset, en, clk,
			GEN_IN => GEN_OUTPUT,
			P_MULT_IN => P_MULT,
			P_ADD_IN => P_ADD,
			WIRING_MODIFIER_ENABLER => WIRING_MODIFIER_ENABLER,
			WIRING_MODIFIER_PARAM => WIRING_MODIFIER_PARAM(N_GENERATORS - 1 downto 0),
			X_mod => X_mod,
			Y_mod => Y_mod,
			Z_mod => Z_mod,
			I_mod => I_mod,
			X_rot => X_rot,
			Y_rot => Y_rot,
			Z_rot => Z_rot,
			Zoom => Zoom,
			H_position => H_position, 
			V_position => V_position,
			H_blanking => H_blanking, 
			V_blanking => V_blanking
		);
		
	-- For debugging only!!
	ctr_FrameBuffer_X_Sel <= X_mod;
	ctr_FrameBuffer_Y_Sel <= Y_mod;
	ctr_FrameBuffer_Zoom <= signed(Zoom(Zoom'length - 1 downto Zoom'length - ctr_FrameBuffer_Zoom'length));
	
	---------------------------------------------------------------------------------
	-- Transformers
	
	 --Remove the commentary marks if you want to activate them...
	 --Rotator
--	 ROTATOR: entity work.ROT(Behavioural)
--		 port map(
--			 reset, clk,
--			 X_mod, Y_mod, Z_mod, 
--			 X_rot, Y_rot, Z_rot, 
--			 Xro, Yro, Zro
--		 );
	
	-- Perspective processor
--	 PP: entity work.PSPC(Behavioural)
--		 port map(
--			 reset, clk, 
--			 Xro, Yro, Zro, 
--			 ctr_Perspective_Distance, ctr_Distance_Limit, ctr_Perspective_Shift_X, ctr_Perspective_Shift_Y, 
--			 std_logic_vector(buffer_Iout), 
--			 ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel, Iout
--		 );
	
	--------------------------------------------------------------------
	-- Frame Transformer router
    	
	FRAME_TR: entity work.FRAME_TRANS(behave)
		port map(
			clk, en, reset,
			HDMI_VIDEO_PIXEL, 
			--vid_clk, vde_out, vsync_out, hsync_out,
			Xsync, Ysync,
			ctr_FrameBuffer_Zoom,
			--ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position, 
			ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking,
			buffer_Xout, buffer_Yout,
			buffer_Rout, buffer_Gout, buffer_Bout, 
			buffer_Iout
		);
	clk_sync <= clk_w_11M52;
	
	-- Analog output stage
	ANA_OUT: process(reset, clk, en) begin
        if reset = '1' then
            Xout <= (others => '0');
            Yout <= (others => '0');
            Rout <= (others => '0');
            Gout <= (others => '0');
            Bout <= (others => '0');
            Iout <= (others => '0');
        else
            if(rising_edge(clk) and en = '1') then
                -- For testing
                --Xout <= std_logic_vector(ctr_FrameBuffer_X_Sel); Yout <= std_logic_vector(ctr_FrameBuffer_Y_Sel); 
                
                Xout <= std_logic_vector(buffer_Xout); Yout <= std_logic_vector(buffer_Yout); 
                Rout <= std_logic_vector(buffer_Rout); Gout <= std_logic_vector(buffer_Gout); Bout <= std_logic_vector(buffer_Bout);
				Iout <= std_logic_vector(buffer_Iout);
            end if;
        end if;
    end process;
    
    Xsel <= ctr_FrameBuffer_X_Sel;
    Ysel <= ctr_FrameBuffer_Y_Sel;
	
end behave; 


architecture behave_ext of DataPath is
	-- Wiring ----------------------------
	
	-- USB generator controller parser
	signal ctr_FrameBuffer_Zoom: signed(8-1 downto 0);
	signal ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel: std_logic_vector(10-1 downto 0);
	signal ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking: unsigned(8-1 downto 0);
	-- signal ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position: signed(10-1 downto 0);
	-- Following the FunctionGenerator.vhd
	signal ctr_Scanner_Sync, ctr_Scanner_Switch: std_logic;
	
	-- Buffer output
	signal buffer_status: std_logic_vector(4-1 downto 0);
	signal buffer_Xout, buffer_Yout: unsigned (10-1 downto 0);
	signal buffer_Rout, buffer_Gout, buffer_Bout, buffer_Iout: unsigned (8-1 downto 0);
	
	-- Generators and Connection Matrix
	signal P_MULT: PARAM_BUS_EX;
	signal P_ADD: PARAM_BUS_EX;
	signal GEN_OUTPUT: CONTROLLER_IN_BUS;	-- True output
	signal GEN_SELECTOR_EN: std_logic_vector(32-1 downto 0);
	signal X_coord, Y_coord, Z_coord, I_mod, -- Signed type
		X_rot, Y_rot, Z_rot, Zoom, 	-- Signed type
		H_position, V_position,	-- Signed type
		X_to_rot, Y_to_rot,	Z_to_rot -- Signed type
		: std_logic_vector(DATA_WIDTH-1 downto 0);	-- Unsigned type
	
	-- Matrix processor input/output
	signal mat_Zin, mat_Xout, mat_Yout, mat_Zout: unsigned (10-1 downto 0);
	signal mat_Iout: unsigned (8-1 downto 0);
	
	-- Rotation processor
	signal Xro, Yro, Zro: float(5 downto -10);
	
begin
	------------------------------------------------------------------------------
	-- Matrix and Transformations
	
	-- Piles of All-purpose Function Generators
	GEN_SEL: for i in 0 to 32-1 generate
	   process (clk) begin
	       if(to_integer(unsigned(ctr_Gen_Selector)) = i) then
	           GEN_SELECTOR_EN(i) <= '1';
	       else
	           GEN_SELECTOR_EN(i) <= '0';
	       end if;
	   end process;
	end generate;
	
	-- Mapping the parameters
	PARAM_MAP: process (clk, en, reset)
	begin
		if(reset = '1') then
			for i in 0 to N_CALC_UNITS-1 loop
				P_MULT(i) <= std_logic_vector(to_signed(1, DATA_WIDTH));
				P_ADD(i) <= std_logic_vector(to_signed(0, DATA_WIDTH));
			end loop;
			
			Gen_probe <= (others => '0');
		else
			if(en= '1') then
				for i in 0 to N_CALC_UNITS-1 loop
					if P_PARAM_SEL = '1' then
						-- Low index high priority. Only set the selected generator with the lowest index
						if(WIRING_MODIFIER_ENABLER(i * 2) = '1') then
							P_MULT(i) <= P_MULT_IN;
						end if;
						if(WIRING_MODIFIER_ENABLER(i * 2 + 1) = '1') then
							P_ADD(i) <= P_ADD_IN;
						end if;
					end if;
				end loop;
				
				-- For testing use. Output the selected generator.
				for i in 0 to 2*N_CALC_UNITS-1 loop
					if GEN_SELECTOR_EN(i) = '1' then
						Gen_probe <= GEN_OUTPUT(i);
						exit;
					end if;
				end loop;
			end if;
		end if;
	end process;
			
	-- Robin ver generators
	ctr_Scanner_Switch <= ctr_Sync;
	ctr_Scanner_Sync <= ctr_Phase_Reset;
	-- First two are fast generators that supports high definition video scanning
	GEN_MAT_FAST: for i in 0 to 1 generate
		U_GEN_FAST: entity work.FunctionGenerator(behaviour_robin_ver_fast)
			generic map(DATA_WIDTH=>16)
			port map(
				clk => clk, 
				reset => reset,
				en => GEN_SELECTOR_EN(i),
				ctr_Scanner_Sync => ctr_Scanner_Sync,
				ctr_Scanner_External_Ramp_in => ctr_Scanner_External_Ramp_in, 
				ctr_Scanner_Switch => ctr_Scanner_Switch,
				ctr_Scanner_Frequency => ctr_Scanner_Frequency,
				ctr_Scanner_Scale1 => ctr_Scanner_Scale1,
				ctr_Scanner_Scale2 => ctr_Scanner_Scale2,
				ctr_Scanner_PhaseOff1 => ctr_Scanner_PhaseOff1,
				ctr_Scanner_PhaseOff2 => ctr_Scanner_PhaseOff2,
				ctr_Scanner_Waveform => ctr_Scanner_Waveform,
				-- ctr_DCO_OUT => GEN_DCO_OUT(i),
				ctr_Bipolar_OUT => GEN_OUTPUT(i)
			);
	end generate;
	
	-- The remaining 22 are slow oscillators for modulations (<5000 Hz)
	GEN_MAT_SLOW: for i in 2 to N_GENERATORS-1 generate
		U_GEN_SLOW: entity work.FunctionGenerator(behaviour_robin_ver_slow)
			generic map(DATA_WIDTH=>16)
			port map(
				clk => clk, 
				reset => reset,
				en => GEN_SELECTOR_EN(i),
				ctr_Scanner_Sync => ctr_Scanner_Sync,
				ctr_Scanner_External_Ramp_in => ctr_Scanner_External_Ramp_in, 
				ctr_Scanner_Switch => ctr_Scanner_Switch,
				ctr_Scanner_Frequency => ctr_Scanner_Frequency,
				ctr_Scanner_Scale1 => ctr_Scanner_Scale1,
				ctr_Scanner_Scale2 => ctr_Scanner_Scale2,
				ctr_Scanner_PhaseOff1 => ctr_Scanner_PhaseOff1,
				ctr_Scanner_PhaseOff2 => ctr_Scanner_PhaseOff2,
				ctr_Scanner_Waveform => ctr_Scanner_Waveform,
				-- ctr_DCO_OUT => GEN_DCO_OUT(i),
				ctr_Bipolar_OUT => GEN_OUTPUT(i)
			);
	end generate;
	
	-- Here for process matrixes stuff
	ctr_FrameBuffer_H_Position <= signed(H_position);
	ctr_FrameBuffer_V_Position <= signed(V_position);
	CONN_MATRIX: entity work.CONN_MAT_EXTENDED(structural)
		port map(
			reset, en, clk,
			GEN_IN => GEN_OUTPUT,
			P_MULT_IN => P_MULT,
			P_ADD_IN => P_ADD,
			WIRING_MODIFIER_ENABLER => WIRING_MODIFIER_ENABLER,
			WIRING_MODIFIER_PARAM => WIRING_MODIFIER_PARAM(N_GENERATORS - 1 downto 0),
			X_in => Xsync,
			Y_in => Ysync,
			X_coord => X_coord,
			Y_coord => Y_coord,
			Z_coord => Z_coord,
			I_mod => I_mod,
			X_rot => X_rot,
			Y_rot => Y_rot,
			Z_rot => Z_rot,
			Zoom => Zoom,
			H_position => H_position, 
			V_position => V_position,
			X_to_rot => X_to_rot,
			Y_to_rot => Y_to_rot,
			Z_to_rot => Z_to_rot
		);
		
	ctr_FrameBuffer_X_Sel <= X_coord;
	ctr_FrameBuffer_Y_Sel <= Y_coord;
	ctr_FrameBuffer_Zoom <= signed(Zoom(Zoom'length - 1 downto Zoom'length - ctr_FrameBuffer_Zoom'length));
	
	---------------------------------------------------------------------------------
	-- Transformers
	
	 --Remove the commentary marks if you want to activate them...
	 --Rotator
--	 ROTATOR: entity work.ROT(Behavioural)
--		 port map(
--			 reset, clk,
--			 X_to_rot, Y_to_rot, Z_to_rot, 
--			 X_rot, Y_rot, Z_rot, 
--			 Xro, Yro, Zro
--		 );
	
	-- Perspective processor
--	 PP: entity work.PSPC(Behavioural)
--		 port map(
--			 reset, clk, 
--			 Xro, Yro, Zro, 
--			 ctr_Perspective_Distance, ctr_Distance_Limit, ctr_Perspective_Shift_X, ctr_Perspective_Shift_Y, 
--			 std_logic_vector(buffer_Iout), 
--			 ctr_FrameBuffer_X_Sel, ctr_FrameBuffer_Y_Sel, Iout
--		 );
	
	--------------------------------------------------------------------
	-- Frame Transformer router
    	
	FRAME_TR: entity work.FRAME_TRANS(behave)
		port map(
			clk, en, reset,
			HDMI_VIDEO_PIXEL, 
			--vid_clk, vde_out, vsync_out, hsync_out,
			Xsync, Ysync,
			ctr_FrameBuffer_Zoom,
			--ctr_FrameBuffer_H_Position, ctr_FrameBuffer_V_Position, 
			ctr_FrameBuffer_H_Blanking, ctr_FrameBuffer_V_Blanking,
			buffer_Xout, buffer_Yout,
			buffer_Rout, buffer_Gout, buffer_Bout, 
			buffer_Iout
		);
	clk_sync <= clk_w_11M52;
	
	-- Analog output stage
	ANA_OUT: process(reset, clk, en) begin
        if reset = '1' then
            Xout <= (others => '0');
            Yout <= (others => '0');
            Rout <= (others => '0');
            Gout <= (others => '0');
            Bout <= (others => '0');
            Iout <= (others => '0');
        else
            if(rising_edge(clk) and en = '1') then
                -- For testing
                --Xout <= std_logic_vector(ctr_FrameBuffer_X_Sel); Yout <= std_logic_vector(ctr_FrameBuffer_Y_Sel); 
                
                Xout <= std_logic_vector(buffer_Xout); Yout <= std_logic_vector(buffer_Yout); 
                Rout <= std_logic_vector(buffer_Rout); Gout <= std_logic_vector(buffer_Gout); Bout <= std_logic_vector(buffer_Bout);
				Iout <= std_logic_vector(buffer_Iout);
            end if;
        end if;
    end process;
    
    Xsel <= ctr_FrameBuffer_X_Sel;
    Ysel <= ctr_FrameBuffer_Y_Sel;
	
end behave_ext; 