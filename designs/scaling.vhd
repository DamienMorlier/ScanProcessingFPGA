library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity scaling is 
	generic(
	  DATA_WIDTH : integer
	);
	port(
	  ctr_Scale_input     : in std_logic_vector(DATA_WIDTH-1 downto 0);
	  ctr_Scale_value     : in std_logic_vector(DATA_WIDTH-1 downto 0);
	  ctr_Scale_output    : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end scaling;

architecture behaviour of scaling is
	signal mult : signed(2*DATA_WIDTH-1 downto 0);
begin
	mult <= (signed(ctr_Scale_input) * signed(ctr_Scale_value) / 2 ** (ctr_Scale_value'length - 1));
	ctr_Scale_output <= std_logic_vector(mult(DATA_WIDTH-1 downto 0));
end behaviour;

architecture behaviour_limited_harm of scaling is
	signal mult : unsigned(2*DATA_WIDTH-1 downto 0);
begin
    process(ctr_Scale_input)
    begin
        mult <= (unsigned(ctr_Scale_input) + unsigned(ctr_Scale_input) * unsigned(ctr_Scale_value) / (2 ** (ctr_Scale_value'length - 1)));    -- Maximum up to 3rd harm. 
	    ctr_Scale_output <= std_logic_vector(mult(DATA_WIDTH-1 downto 0));
    end process;
end behaviour_limited_harm;