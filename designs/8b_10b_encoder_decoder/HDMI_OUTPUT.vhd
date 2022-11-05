library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HDMI_OUTPUT is
    Port ( clk : in STD_LOGIC; --Should be 10.368MHz under PAL signal standard (720x576@25)
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           RGB_in : in STD_LOGIC_VECTOR (24-1 downto 0); --M->L : R,G,B
           TMDS_R : out STD_LOGIC;
           TMDS_G : out STD_LOGIC;
           TMDS_B : out STD_LOGIC;
           TMDS_CLK : out STD_LOGIC);
end HDMI_OUTPUT;

architecture Behavioral of HDMI_OUTPUT is
	-- LUT INSTANTIATION
	COMPONENT LUT_RD_NEG
	  PORT (
		a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		spo : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) 
	  );
	END COMPONENT;
	
	COMPONENT LUT_RD_POS
	  PORT (
		a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		spo : OUT STD_LOGIC_VECTOR(9 DOWNTO 0) 
	  );
	END COMPONENT;

	signal seq_cnt: unsigned(4-1 downto 0);	-- Counter of bit sequence. Also used in pipelining
	
	-- Most-significant 10 bits for buffering and least-significant 10 bits for output
	signal TMDS_R_REG, TMDS_G_REG, TMDS_B_REG: std_logic_vector(20-1 downto 0);
	
	-- 8b/10b encoder input/output buffer
	signal LUT_RD_NEG_OUT, LUT_RD_POS_OUT, LUT_OUTPUT: std_logic_vector(10-1 downto 0);
	signal LUT_INPUT: std_logic_vector(8-1 downto 0);
	
	-- Running disparity register, 0 for RD-, 1 for RD+
	-- The initial state should be 1 to force the first output using a 
	-- RD- code by standard
	signal RD, RD_R, RD_G, RD_B: std_logic;
	
begin
	-- REMEMBER! All encoder LUT tables are ROMs generated using 
	-- "Block Memory Generator" ip core, with 8-bit address
	-- and 10-bit output
	LUT_RD_NEG_ENCODER: LUT_RD_NEG
		port map(
			a => LUT_INPUT, -- L->M: abcdef
			spo => LUT_RD_NEG_OUT -- L->M: jhgfiedcba
		);
	
	LUT_RD_POS_ENCODER: LUT_RD_POS
		port map(
			a => LUT_INPUT, -- L->M: abcdef
			spo => LUT_RD_POS_OUT -- L->M: jhgfiedcba
		);
	
	-- Concurrent LUT encoder output switcher
	RD <= 
		RD_R when seq_cnt = 6 else
		RD_G when seq_cnt = 7 else
		RD_B when seq_cnt = 8 else 
		'1';
		
	LUT_OUTPUT <= LUT_RD_POS_OUT when RD = '0' else LUT_RD_NEG_OUT;
	
	process (clk, reset)
		-- variables
		variable count: integer range 0 to 9;
		variable RD_ones_count: integer range 0 to 10;
	begin
		count := to_integer(seq_cnt);
		if(reset = '1') then
			RD_R <= '1';
			RD_G <= '1';
			RD_B <= '1';
			LUT_INPUT <= (others => '0');
			TMDS_R_REG <= (others => '0');
			TMDS_G_REG <= (others => '0');
			TMDS_B_REG <= (others => '0');
			TMDS_CLK <= '0';
			seq_cnt <= (others => '0');
		else
			if(rising_edge(clk) and (en = '1')) then
				-- Timing of 10-bit output sequence
				if (count = 9) then seq_cnt <= "0000";
				else seq_cnt <= seq_cnt + 1;
				end if;
				
				-- Sequence output
				if(count < 5) then 
					TMDS_CLK <= '1';
				else 
					TMDS_CLK <= '0';
				end if;
				TMDS_R <= TMDS_R_REG(count);
				TMDS_G <= TMDS_G_REG(count);
				TMDS_B <= TMDS_B_REG(count);
				
				-- RD check and set, using previous data
				-- saved in RMDS_x_REG[9:0]
				for i in 0 to 9 loop
					if LUT_OUTPUT(i) = '1' then 
						RD_ones_count := RD_ones_count + 1;
					end if;
				end loop;
				
				if RD_ones_count < 5 then
					RD <= '0';
				elsif RD_ones_count > 5 then
					RD <= '1';
				end if;
				
				-- Pipelining
				case count is
					when 5 => 
						LUT_INPUT <= RGB_in(24-1 downto 16);
					when 6 => 
						TMDS_R_REG(20-1 downto 10) <= LUT_OUTPUT;
						LUT_INPUT <= RGB_in(16-1 downto 8);
					when 7 =>
						TMDS_G_REG(20-1 downto 10) <= LUT_OUTPUT;
						LUT_INPUT <= RGB_in(8-1 downto 0);
					when 8 =>
						TMDS_B_REG(20-1 downto 10) <= LUT_OUTPUT;
					when 9 =>
						TMDS_R_REG <= std_logic_vector(shift_right(unsigned(TMDS_R_REG),10));
						TMDS_G_REG <= std_logic_vector(shift_right(unsigned(TMDS_G_REG),10));
						TMDS_B_REG <= std_logic_vector(shift_right(unsigned(TMDS_B_REG),10));
					when others => NULL;
				end case;
			end if;
		end if;
		
	end process;
		
end Behavioral;
