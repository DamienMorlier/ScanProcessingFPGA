library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity offset is 
generic(
  DATA_WIDTH : integer
);
port(
  ctr_Offset_input    : in std_logic_vector(DATA_WIDTH-1 downto 0);
  ctr_Offset_val      : in std_logic_vector(DATA_WIDTH-1 downto 0);
  ctr_Offset_output   : out std_logic_vector(DATA_WIDTH-1 downto 0)
);

end offset;

architecture behave of offset is
	
begin
  ctr_Offset_output <= std_logic_vector(unsigned(ctr_Offset_input) + unsigned(ctr_Offset_val));
end behave;