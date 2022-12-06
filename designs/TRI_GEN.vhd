----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/23/2022 04:50:45 AM
-- Design Name: 
-- Module Name: TRI_GEN - Behavioral
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

entity TRI_GEN is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           index : in STD_LOGIC_VECTOR (13-1 downto 0);
           output : out STD_LOGIC_VECTOR (32-1 downto 0));
end TRI_GEN;

architecture Behavioral of TRI_GEN is
    
begin
    process(reset, clk) 
        variable temp: integer;
    begin
        if (reset = '1') then
            output <= (others => '0');
        elsif (rising_edge(clk)) then
            -- 1/4 ~ 3/4
            if (unsigned(index) >= 2048 and unsigned(index) < 6144) then
                temp := 2** output'length - 1 - 524288 * ( to_integer(unsigned(index)) - 2048);
            -- 3/4 ~ 1
            elsif (unsigned(index) >= 6144) then
                temp := 524288 * ( to_integer(unsigned(index)) - 6144);
            -- 0 ~ 1/4
            else
                temp := 524288 * ( to_integer(unsigned(index)) - 0);
            end if;
            output <= std_logic_vector(to_signed(temp, output'length)) ;
        end if;
    end process;
end Behavioral;
