library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity scaling is 
  generic(DATA_WIDTH: integer
  ); -- M is for input signal, N is for output signal
  
  port(
    --input ports
    SIG_IN: in std_logic_vector(DATA_WIDTH-1 downto 0);
    scaling_value: in std_logic_vector(DATA_WIDTH-1 downto 0);
    SIG_OUT: out std_logic_vector(DATA_WIDTH-1 downto 0)
    
);
end scaling;

architecture behaviour of scaling is

signal mult : unsigned(2*DATA_WIDTH-1 downto 0);
begin
  mult <= (unsigned(SIG_IN) * unsigned(scaling_value));
  SIG_OUT <= std_logic_vector(mult(DATA_WIDTH-1 downto 0));

end behaviour;