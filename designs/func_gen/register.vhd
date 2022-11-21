library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_1 is
    generic(
        DATA_WIDTH : integer
    );
    port(clk               : in  std_logic;
        shift_in           : in  std_logic_vector (DATA_WIDTH-1 downto 0);
        shift_out          : out std_logic_vector (DATA_WIDTH-1 downto 0)
        );
end Register_1;

architecture a of Register_1   is
  signal reg : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
  p_register : process (clk)
  begin
    if (clk'event and clk = '1') then
        reg <= shift_in;
    end if;

  end process p_register;

  shift_out <= reg;
end a;
