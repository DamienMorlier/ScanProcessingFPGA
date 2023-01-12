library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity FunctionGenerator is 
    generic(
        DATA_WIDTH :integer := 16;
        DATA_OUT_WIDTH: integer := 10
    );
    port(
        clk                             : in std_logic;
        reset                           : in std_logic;
        en                              : in std_logic;
        ctr_Scanner_Sync                : in std_logic; --/Reset
        ctr_Scanner_Switch              : in std_logic; --/Sync
        ctr_Scanner_External_RAMP_IN    : in std_logic_vector(DATA_WIDTH-1 downto 0);--External Ramp in
        ctr_Scanner_Frequency           : in std_logic_vector(DATA_WIDTH-1 downto 0); --/Frequency
        ctr_Scanner_Scale1              : in std_logic_vector(DATA_WIDTH-1 downto 0);--/Harmonic, Maximum 3x of harmony
        ctr_Scanner_Scale2              : in std_logic_vector(DATA_WIDTH-1 downto 0);--/Scale
        ctr_Scanner_PhaseOff1           : in std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift1(Offset)
        ctr_Scanner_PhaseOff2           : in std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift2(Phase)
        ctr_Scanner_Waveform            : in std_logic_vector(3 downto 0);--/Waveform
        ctr_Bipolar_OUT                 : out std_logic_vector(DATA_OUT_WIDTH-1 downto 0)--Desired Wave out
    );
end FunctionGenerator;

architecture behaviour_robin_ver_slow of FunctionGenerator is
	-- Constants
	constant zeros: std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
	
	-- Low speed related wiring
	signal clk_0p01M, nreset_delayed: std_logic;
	signal sDCO_s_axis_config_tvalid, sDCO_m_axis_phase_tvalid: std_logic;
	signal sDCO_s_axis_config_tdata: std_logic_vector(31 downto 0);
	signal sDCO_m_axis_phase_tdata: std_logic_vector(15 downto 0);
	COMPONENT dds_DCO_slow
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_config_tvalid : IN STD_LOGIC;
			s_axis_config_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			m_axis_phase_tvalid : OUT STD_LOGIC;
			m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
		);
	END COMPONENT;
	
	-- Sine LUT
	signal sin_out: std_logic_vector(16-1 downto 0);
	signal sin_ready: std_logic;
	COMPONENT dds_sine_gen
		PORT (
			aclk : IN STD_LOGIC;
			s_axis_phase_tvalid : IN STD_LOGIC;
			s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			m_axis_data_tvalid : OUT STD_LOGIC;
			m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
		);
	END COMPONENT;
	
	-- Harmonizer
	signal harm_in: STD_LOGIC_VECTOR(16 - 1 DOWNTO 0);
	signal harmed_phase: STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
	
	-- Tri gen
	signal tri_output_vector: std_logic_vector(16 - 1 downto 0);
	
	-- SQR gen
	signal sqr_output_vector: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Scaler
	signal scaler_in: std_logic_vector(DATA_OUT_WIDTH - 1 downto 0);
	signal scaler_out: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Output stage
	signal output_buffer: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Controller Registers
	signal ctr_Scanner_Sync_Reg                : std_logic; --/Reset
	signal ctr_Scanner_Switch_Reg              : std_logic; --/Sync
	signal ctr_Scanner_Frequency_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0); --/Frequency
	signal ctr_Scanner_Scale1_Reg              : std_logic_vector(DATA_WIDTH-1 downto 0);--/Harmonic
	signal ctr_Scanner_Scale2_Reg              : std_logic_vector(DATA_WIDTH-1 downto 0);--/Scale
	signal ctr_Scanner_PhaseOff1_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift1(Offset)
	signal ctr_Scanner_PhaseOff2_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift2(Phase)
	signal ctr_Scanner_Waveform_Reg            : std_logic_vector(3 downto 0);--/Waveform

begin
	
	-- Slow DCO clock divider
	CLK_DIV: entity work.clk_100M_0p01M(Behavioral)
		port map(
			reset => reset,
			anreset => not (ctr_Scanner_Sync_Reg),
			clk_in => clk,
			clk_out => clk_0p01M,
			nreset_out => nreset_delayed
		);
		
	-- Low-speed DCO
	SLOW_DCO: dds_DCO_slow
		PORT MAP (
			aclk => clk_0p01M,
			aresetn => not ctr_Scanner_Sync,
			s_axis_config_tvalid => sDCO_s_axis_config_tvalid,
			s_axis_config_tdata => sDCO_s_axis_config_tdata,
			m_axis_phase_tvalid => sDCO_m_axis_phase_tvalid,
			m_axis_phase_tdata => sDCO_m_axis_phase_tdata
		);
		
	-- Harmonizer
	with ctr_Scanner_Switch_Reg select harm_in <=
		ctr_Scanner_External_RAMP_IN when '1',
		sDCO_m_axis_phase_tdata when others;
		
	HARM_GEN: entity work.scaling(behaviour_limited_harm)
		generic map(DATA_WIDTH)
		port map(
			ctr_Scale_input => harm_in,
			ctr_Scale_value => ctr_Scanner_Scale1_Reg,
			ctr_Scale_output => harmed_phase
		);
	
	-- Low-speed sine gen
	SLOW_SIN: dds_sine_gen
		PORT MAP (
			aclk => clk,
			s_axis_phase_tvalid => sDCO_m_axis_phase_tvalid,
			s_axis_phase_tdata => harmed_phase,
			m_axis_data_tvalid => sin_ready,
			m_axis_data_tdata => sin_out
		);
	
	-- Triangle gen
	TRI_WAVE_GEN: entity work.TRI_GEN(Behavioral)
    port map(
        clk, reset, 
        harmed_phase(sDCO_m_axis_phase_tdata'length - 1 downto sDCO_m_axis_phase_tdata'length - 13),
        tri_output_vector
    );
	
	-- Square gen
	SQR_WAVE_GEN: process(sDCO_m_axis_phase_tvalid, harmed_phase)
		variable square: std_logic_vector(DATA_WIDTH-2 downto 0);
	begin
		if(sDCO_m_axis_phase_tvalid = '1') then
			if harmed_phase(15) = '1' then
				square := (others => '0');
				sqr_output_vector <= '1' & square;
			else
				square := (others => '1');
				sqr_output_vector <= '0' & square;
			end if;
		end if;
	end process;
	
	REG_REFRESHER: process(reset, clk, en)
		variable pha_incr: integer;
	begin
		if(reset = '1') then
			ctr_Scanner_Sync_Reg            	   <= '0';
			ctr_Scanner_Switch_Reg          	   <= '0';
			ctr_Scanner_Frequency_Reg       	   <= (others => '0');
			ctr_Scanner_Scale1_Reg          	   <= (others => '0');
			ctr_Scanner_Scale2_Reg          	   <= (others => '0');
			ctr_Scanner_PhaseOff1_Reg       	   <= (others => '0');
			ctr_Scanner_PhaseOff2_Reg       	   <= (others => '0');
			ctr_Scanner_Waveform_Reg        	   <= (others => '0');
		elsif (rising_edge(clk) and en = '1') then
			ctr_Scanner_Sync_Reg            	   <= ctr_Scanner_Sync;
			ctr_Scanner_Switch_Reg          	   <= ctr_Scanner_Switch;
			ctr_Scanner_Scale1_Reg          	   <= ctr_Scanner_Scale1;
			ctr_Scanner_Scale2_Reg          	   <= ctr_Scanner_Scale2;
			ctr_Scanner_PhaseOff1_Reg       	   <= ctr_Scanner_PhaseOff1;
			ctr_Scanner_Waveform_Reg        	   <= ctr_Scanner_Waveform;
			
			-- Translate frequency data into phase increment. 
			-- Warning! This slow function generator has a frequency precision of approx. 0.15Hz, 
			-- That is, the real output frequency = ctr_Scanner_Frequency / 10 < 5000 Hz. 
			if(unsigned(ctr_Scanner_Frequency) < 5000) then
				pha_incr := to_integer(unsigned(ctr_Scanner_Frequency)) * 2 ** 16 / 10000;
			else 
				pha_incr := 5000 * 2 ** 16 / 10000;
			end if;
			ctr_Scanner_Frequency_Reg <= 
				std_logic_vector(to_unsigned(pha_incr, ctr_Scanner_Frequency_Reg'length));
			ctr_Scanner_PhaseOff2_Reg <= 
				std_logic_vector(to_unsigned(to_integer(unsigned(ctr_Scanner_PhaseOff2)) mod 360 * 2 ** 16 / 360, ctr_Scanner_PhaseOff2_Reg'length));
			
		end if;
	end process;
	
	-- Waveform selector
	WAVEFORM: process(reset, clk)
	begin
		if ctr_Scanner_Waveform_Reg(3) = '1' then	-- Force Zero
			scaler_in <= (others => '0');
		elsif ctr_Scanner_Waveform_Reg(2) = '1' then	-- Tri wave
			scaler_in <= tri_output_vector(tri_output_vector'length - 1 downto tri_output_vector'length - DATA_OUT_WIDTH);
		elsif ctr_Scanner_Waveform_Reg(1) = '1' then	-- Square wave
			scaler_in <= sqr_output_vector(sqr_output_vector'length - 1 downto sqr_output_vector'length - DATA_OUT_WIDTH);
		elsif ctr_Scanner_Waveform_Reg(0) = '1' then	-- Sine wave
			scaler_in <= sin_out(10 - 1 downto 0);
		else 
			scaler_in <= sDCO_m_axis_phase_tdata(sDCO_m_axis_phase_tdata'length - 1 downto sDCO_m_axis_phase_tdata'length - DATA_OUT_WIDTH);
		end if;
	end process;
	
	-- Frequency and Phase Shift settings
	FREQ_PHA_SET: process(reset, clk)
	begin
		if(reset = '1') then
			sDCO_s_axis_config_tdata <= (others => '0');
			sDCO_s_axis_config_tvalid <= '0';
		elsif (rising_edge(clk)) then
			sDCO_s_axis_config_tdata <= ctr_Scanner_PhaseOff2_Reg & ctr_Scanner_Frequency_Reg;
			sDCO_s_axis_config_tvalid <= '1';
		end if;
	end process;
	
	-- Scaling
	Scaler: entity work.scaling(behaviour)
		generic map(DATA_WIDTH)
		port map(
			ctr_Scale_input 	=> scaler_in & (zeros'length - scaler_in'length - 1 downto 0 => '0'),
			ctr_Scale_value 	=> ctr_Scanner_Scale2_Reg,
			ctr_Scale_output	=> scaler_out
		);
	
	-- Offset
	OUT_BIAS: entity work.offset(behave)
		generic map(DATA_WIDTH)
		port map(
			ctr_Offset_input    => scaler_out,
			ctr_Offset_val      => ctr_Scanner_PhaseOff1_Reg,
			ctr_Offset_output   => output_buffer
		);
		
	-- Output stage
	ctr_Bipolar_OUT <= output_buffer(DATA_WIDTH - 1 downto DATA_WIDTH - DATA_OUT_WIDTH);
	-- ctr_DCO_OUT <= sDCO_m_axis_phase_tdata(16 - 1 downto 16 - DATA_OUT_WIDTH);
	
end behaviour_robin_ver_slow;

architecture behaviour_robin_ver_fast of FunctionGenerator is
	-- Reminder: fast generators DO NOT SUPPORT EXTERNAL RAMP IN
	
	-- Constants
	constant zeros: std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
	
	-- Low speed related wiring
	signal fDCO_s_axis_config_tvalid, fDCO_m_axis_phase_tvalid: std_logic;
	signal fDCO_s_axis_config_tdata: std_logic_vector(31 downto 0);
	signal fDCO_m_axis_phase_tdata: std_logic_vector(15 downto 0);
	COMPONENT dds_DCO_fast
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_config_tvalid : IN STD_LOGIC;
			s_axis_config_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			m_axis_phase_tvalid : OUT STD_LOGIC;
			m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
		);
	END COMPONENT;
	
	-- Sine Gen
	signal fSIN_m_axis_data_tdata: std_logic_vector(16-1 downto 0);
	signal fSIN_s_axis_config_tdata: std_logic_vector(32-1 downto 0);
	signal fSIN_m_axis_data_tvalid, fSIN_s_axis_config_tvalid: std_logic;
	COMPONENT dds_sine_fast
		PORT (
			aclk : IN STD_LOGIC;
			aresetn : IN STD_LOGIC;
			s_axis_config_tvalid : IN STD_LOGIC;
			s_axis_config_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			m_axis_data_tvalid : OUT STD_LOGIC;
			m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
		);
	END COMPONENT;
	
	-- Harmonizer
	signal harmed_phase: STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
	
	-- Tri gen
	signal tri_output_vector: std_logic_vector(16 - 1 downto 0);
	
	-- SQR gen
	signal sqr_output_vector: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Scaler
	signal scaler_in: std_logic_vector(DATA_OUT_WIDTH - 1 downto 0);
	signal scaler_out: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Output stage
	signal output_buffer: std_logic_vector(DATA_WIDTH - 1 downto 0);
	
	-- Controller Registers
	signal ctr_Scanner_Sync_Reg                : std_logic; --/Sync
	signal ctr_Scanner_Switch_Reg              : std_logic;
	signal ctr_Scanner_Frequency_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0); --/Frequency
	signal ctr_Scanner_Scale1_Reg              : std_logic_vector(DATA_WIDTH-1 downto 0);--/Harmonic
	signal ctr_Scanner_Scale2_Reg              : std_logic_vector(DATA_WIDTH-1 downto 0);--/Scale
	signal ctr_Scanner_PhaseOff1_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift1(Offset)
	signal ctr_Scanner_PhaseOff2_Reg           : std_logic_vector(DATA_WIDTH-1 downto 0);--/PhaseShift2(Phase)
	signal ctr_Scanner_Waveform_Reg            : std_logic_vector(3 downto 0);--/Waveform
	
	-- Delayed Reset
	signal nreset_delayed						: std_logic;
	signal nrst_delay_cnt						: unsigned(2-1 downto 0);
begin
	-- Delayed asyn-neg-reset
	nreset_delayed <= not(or(std_logic_vector(nrst_delay_cnt)));

	-- High-speed DCO
	FAST_DCO: dds_DCO_fast
		PORT MAP (
			aclk => clk,
			aresetn => not ctr_Scanner_Sync,
			s_axis_config_tvalid => fDCO_s_axis_config_tvalid,
			s_axis_config_tdata => fDCO_s_axis_config_tdata,
			m_axis_phase_tvalid => fDCO_m_axis_phase_tvalid,
			m_axis_phase_tdata => fDCO_m_axis_phase_tdata
		);
		
	-- Harmonizer
	HARM_GEN: entity work.scaling(behaviour_limited_harm)
		generic map(DATA_WIDTH)
		port map(
			ctr_Scale_input => fDCO_m_axis_phase_tdata,
			ctr_Scale_value => ctr_Scanner_Scale1_Reg,
			ctr_Scale_output => harmed_phase
		);
	
	-- High-speed sine gen
	FAST_SIN: dds_sine_fast
		PORT MAP (
			aclk => clk,
			aresetn => not ctr_Scanner_Sync,
			s_axis_config_tvalid => fSIN_s_axis_config_tvalid,
			s_axis_config_tdata => fSIN_s_axis_config_tdata,
			m_axis_data_tvalid => fSIN_m_axis_data_tvalid,
			m_axis_data_tdata => fSIN_m_axis_data_tdata
		);
	
	-- Triangle gen
	TRI_WAVE_GEN: entity work.TRI_GEN(Behavioral)
    port map(
        clk, reset, 
        harmed_phase(fDCO_m_axis_phase_tdata'length - 1 downto fDCO_m_axis_phase_tdata'length - 13),
        tri_output_vector
    );
	
	-- Square gen
	SQR_WAVE_GEN: process(fDCO_m_axis_phase_tvalid, harmed_phase)
		variable square: std_logic_vector(DATA_WIDTH-2 downto 0);
	begin
		if(fDCO_m_axis_phase_tvalid = '1') then
			if harmed_phase(15) = '1' then
				square := (others => '0');
				sqr_output_vector <= '1' & square;
			else
				square := (others => '1');
				sqr_output_vector <= '0' & square;
			end if;
		end if;
	end process;
	
	REG_REFRESHER: process(reset, clk, en)
		variable pha_incr: integer;
	begin
		if(reset = '1') then
			ctr_Scanner_Sync_Reg            	   <= '0';
			ctr_Scanner_Switch_Reg          	   <= '0';
			ctr_Scanner_Frequency_Reg       	   <= (others => '0');
			ctr_Scanner_Scale1_Reg          	   <= (others => '0');
			ctr_Scanner_Scale2_Reg          	   <= (others => '0');
			ctr_Scanner_PhaseOff1_Reg       	   <= (others => '0');
			ctr_Scanner_PhaseOff2_Reg       	   <= (others => '0');
			ctr_Scanner_Waveform_Reg        	   <= (others => '0');
		elsif (rising_edge(clk) and en = '1') then
			ctr_Scanner_Sync_Reg            	   <= ctr_Scanner_Sync;
			ctr_Scanner_Switch_Reg          	   <= ctr_Scanner_Switch;
			ctr_Scanner_Scale1_Reg          	   <= ctr_Scanner_Scale1;
			ctr_Scanner_Scale2_Reg          	   <= ctr_Scanner_Scale2;
			ctr_Scanner_PhaseOff1_Reg       	   <= ctr_Scanner_PhaseOff1;
			ctr_Scanner_Waveform_Reg        	   <= ctr_Scanner_Waveform;
			
			-- Delayed reset
			if ctr_Scanner_Sync_Reg = '1' then
				nrst_delay_cnt <= to_unsigned(3, 2);
			else
				if(nrst_delay_cnt > 0) then
					nrst_delay_cnt <= nrst_delay_cnt - 1;
				end if;
			end if;
			
			-- Translate frequency data into phase increment. 
			-- This should be an integer value of a ctr_Scanner_Frequency kHz.
			-- Warning! This fast function generator has a frequency precision of approx. 1.5kHz, 
			-- That is, the real output frequency = ctr_Scanner_Frequency / 100000 < 20 MHz. 
			if(unsigned(ctr_Scanner_Frequency) < 20000) then
				pha_incr := to_integer(unsigned(ctr_Scanner_Frequency)) * 2 ** 16 / 100000;
			else 
				pha_incr := 20000 * 2 ** 16 / 100000;
			end if;
			ctr_Scanner_Frequency_Reg <= 
				std_logic_vector(to_unsigned(pha_incr, ctr_Scanner_Frequency_Reg'length));
			ctr_Scanner_PhaseOff2_Reg <= 
				std_logic_vector(to_unsigned(to_integer(unsigned(ctr_Scanner_PhaseOff2)) mod 360 * 2 ** 16 / 360, ctr_Scanner_PhaseOff2_Reg'length));
		
		end if;
	end process;
	
	-- Waveform selector
	WAVEFORM: process(reset, clk)
	begin
		if ctr_Scanner_Waveform_Reg(3) = '1' then	-- Force Zero
			scaler_in <= (others => '0');
		elsif ctr_Scanner_Waveform_Reg(2) = '1' then	-- Tri wave
			scaler_in <= tri_output_vector(tri_output_vector'length - 1 downto tri_output_vector'length - DATA_OUT_WIDTH);
		elsif ctr_Scanner_Waveform_Reg(1) = '1' then	-- Square wave
			scaler_in <= sqr_output_vector(sqr_output_vector'length - 1 downto sqr_output_vector'length - DATA_OUT_WIDTH);
		elsif ctr_Scanner_Waveform_Reg(0) = '1' then	-- Sine wave
			scaler_in <= fSIN_m_axis_data_tdata(10 - 1 downto 0);
		else 
			scaler_in <= fDCO_m_axis_phase_tdata(fDCO_m_axis_phase_tdata'length - 1 downto fDCO_m_axis_phase_tdata'length - DATA_OUT_WIDTH);
		end if;
	end process;
	
	-- Frequency and Phase Shift settings
	FREQ_PHA_SET: process(reset, clk)
	begin
		if(reset = '1') then
			fDCO_s_axis_config_tdata <= (others => '0');
			fDCO_s_axis_config_tvalid <= '0';
			fSIN_s_axis_config_tdata <= (others => '0');
			fSIN_s_axis_config_tvalid <= '0';
		elsif (rising_edge(clk)) then
			fDCO_s_axis_config_tdata <= ctr_Scanner_PhaseOff2_Reg & ctr_Scanner_Frequency_Reg;
			fSIN_s_axis_config_tdata <= ctr_Scanner_PhaseOff2_Reg & std_logic_vector(resize(unsigned(ctr_Scanner_Frequency_Reg) * (1 + unsigned(ctr_Scanner_Scale1_Reg) / (2 ** (ctr_Scanner_Scale1_Reg'length - 1))), 16));
            fDCO_s_axis_config_tvalid <= '1';
            fSIN_s_axis_config_tvalid <= '1';
		end if;
	end process;
	
	-- Scaling
	Scaler: entity work.scaling(behaviour)
		generic map(DATA_WIDTH)
		port map(
			ctr_Scale_input 	=> scaler_in & (zeros'length - scaler_in'length - 1 downto 0 => '0'),
			ctr_Scale_value 	=> ctr_Scanner_Scale2_Reg,
			ctr_Scale_output	=> scaler_out
		);
	
	-- Offset
	OUT_BIAS: entity work.offset(behave)
		generic map(DATA_WIDTH)
		port map(
			ctr_Offset_input    => scaler_out,
			ctr_Offset_val      => ctr_Scanner_PhaseOff1_Reg,
			ctr_Offset_output   => output_buffer
		);
		
	-- Output stage
	ctr_Bipolar_OUT <= output_buffer(DATA_WIDTH - 1 downto DATA_WIDTH - DATA_OUT_WIDTH);
	-- ctr_DCO_OUT <= fDCO_m_axis_phase_tdata(16 - 1 downto 16 - DATA_OUT_WIDTH);
	
end behaviour_robin_ver_fast;