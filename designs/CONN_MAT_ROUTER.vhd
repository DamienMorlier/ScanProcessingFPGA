library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CONN_MAT_PACKAGE.all;

-- A 24 input router (Yudong Lin)

entity CONN_MAT_ROUTER is
	port(
		reset, en, clk: in std_logic;	-- Reminder: en for activating the address register
		DATA_IN: in CONTROLLER_IN_BUS;
		ADDR_IN: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		DATA_OUT: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end CONN_MAT_ROUTER;

architecture behaviour of CONN_MAT_ROUTER is
	signal ADDR_BUFFER: std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
	-- Main process
	process (reset, clk, en, DATA_IN)
	begin
		if (reset = '1') then
			DATA_OUT <= (others => '0');
			ADDR_BUFFER <= (others => '0');
		else 
			if (rising_edge(clk) AND en = '1') then
				ADDR_BUFFER <= ADDR_IN;
			end if;
			
			-- Concurrent switchers
            for i in 0 to ADDR_WIDTH-1 loop
                if (ADDR_BUFFER(i) = '1') then
                    DATA_OUT <= DATA_IN(i);
                    exit;
                else
                    DATA_OUT <= (others => '0');
                end if;
            end loop;
		end if;
	end process;
	
end behaviour;