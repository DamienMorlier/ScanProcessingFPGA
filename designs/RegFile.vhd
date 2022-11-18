library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity RegFile is
  generic(M, N, C: integer); --M for address length, N for data width, C for total cells in the register file
  port(
    --Input ports
    WD: In std_logic_vector(N-1 downto 0);
    WAddr, RA: In std_logic_vector(M-1 downto 0);
    Write, ReadA, reset, clk: In std_logic;
    
    --Output ports
    QA: Out std_logic_vector(N-1 downto 0)
  );
end RegFile;

architecture behave of RegFile is
  --Reg Array
  -- type RegArray is array(0 to 2**M-1) of std_logic_vector(N-1 downto 0);
  type RegArray is array(0 to C-1) of std_logic_vector(N-1 downto 0);
  signal RegF :RegArray :=(others=>(others=>'0'));
  
  begin
	assert C < 2**M + 1 report "Not enough address bit width to support that much cells!" severity failure;
	QA<=RegF(to_integer(unsigned(RA))) when ReadA='1' else (others=>'0');
    process(reset, clk)
    begin
      if(reset='1') then 
        --Clear array data
        RegF<=(others=>(others=>'0'));
      else
        if(rising_edge(clk)) then
          if(Write='1')then
            RegF(to_integer(unsigned(WAddr))) <= WD;
          end if;
        end if;
      end if;
    end process;
end behave;
