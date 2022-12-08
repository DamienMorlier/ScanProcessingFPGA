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
    Port ( reset, clk_in : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_100M_0p01M;

architecture Behavioral of clk_100M_0p01M is
    signal count: unsigned(14-1 downto 0);
begin
    process(reset, clk_in ) begin
        if(reset = '1') then
            count <= (others => '0');
        elsif (rising_edge(clk_in)) then
            if(count = 9999) then
                count <= (others => '0');
            else 
                count <= count + 1;
            end if;
        end if;
    end process;

end Behavioral;
