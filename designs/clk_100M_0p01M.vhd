----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/12/08 03:19:19
-- Design Name: 
-- Module Name: clk_100M_0p01M - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_100M_0p01M is
    Port ( reset, anreset, clk_in : in STD_LOGIC;
           clk_out, nreset_out : out STD_LOGIC);
end clk_100M_0p01M;

architecture Behavioral of clk_100M_0p01M is
    signal count: unsigned(14-1 downto 0);
	signal nrst_delay: unsigned(2 - 1 downto 0);
begin
	nreset_out <= not(or(std_logic_vector(nrst_delay)));
	
    process(reset, clk_in, anreset) begin
        if(reset = '1') then
            count <= (others => '0');
			nrst_delay <= to_unsigned(3, 2);
			clk_out <= '0';
        else
			if (rising_edge(clk_in) and anreset = '1') then
				if(count = 9999) then
					count <= (others => '0');
				else 
					count <= count + 1;
				end if;
				
				-- Delayed reset (3 clk periods)
				if(nrst_delay > 0) then
					nrst_delay <= nrst_delay - 1;
				end if;
				
				if(count >= 5000) then clk_out <= '0';
				else clk_out <= '1';
				end if;
			end if;
			
			if (anreset = '0') then
				nrst_delay <= to_unsigned(3, 2);
				count <= (others => '0');
				clk_out <= '0';
			end if;
        end if;
		
		
    end process;

end Behavioral;
