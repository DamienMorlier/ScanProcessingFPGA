library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity offset is 
  generic(M, N: integer
  ); -- M is for input signal, N is for output signal
  
  port(
    --input ports
    SIG_IN: in std_logic_vector(M-1 downto 0);
    offset_value: in std_logic_vector(M-1 downto 0);
    --output ports
    SIG_OUT: out std_logic_vector(N-1 downto 0)
    
);
end offset;

architecture behave of offset is
 
begin
  SIG_OUT <= std_logic_vector(unsigned(SIG_IN) + unsigned(offset_value));
end behave;