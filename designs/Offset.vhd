library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity offset is 
  generic(M, N: integer
  ); -- M is for input signal, N is for output signal
  
  port(
    --input ports
    RAMP_IN: in std_logic_vector(M-1 downto 0);
    offset_value: in std_logic_vector(M-1 downto 0);
    --output ports
    RAMP_OUT: out std_logic_vector(N-1 downto 0)
    
);
end offset;

architecture behave of offset is
 
begin
  output <= std_logic_vector(unsigned(input) + unsigned(offset_value),N);
end behave;