import math

PERIOD = 2**16 - 1
MAX = 2**31

TOP = """
library ieee;
use ieee.std_logic_1164.all;

entity wave_lut is
	generic (
		signal_width: integer := 32
	);
	port (
		index : in std_logic_vector(20 downto 0);
		output : out std_logic_vector(signal_width - 1 downto 0)
	);
end;

architecture behavior of wave_lut is

begin

process (index)
begin

case index(18 downto 0) is
"""
BOTTOM = """
when others => output <= (others => '0');
end case;

end process;

end;
"""

def to_n_wide_bin(x, n=32):
	return format(x, "b").zfill(n)


def twos_complent_adjust(x, n=32):
	if x >= 0:
		return x
	return 2**n - (~x + 1)


def generate_sin(offset=0):
	period_step = 2 * math.pi / PERIOD

	print("-- sine wave")

	for i in range(PERIOD):
		value = int(MAX * math.sin(i * period_step))
		binary = to_n_wide_bin(twos_complent_adjust(value))
		print(f'when "{to_n_wide_bin(i | (offset * 2**16), 18)}" => output <= "{binary}";')


def generate_triangle(offset = 0):
	print("-- triangle wave")

	for i in range(PERIOD):
		value = 0
		if i <= PERIOD / 4:
			value = MAX * 4 * i / PERIOD
		if i > PERIOD / 4 and i <= 3 * PERIOD / 4:
			value = MAX - 4 * MAX * (i - PERIOD / 4) / PERIOD
		if i > 3 * PERIOD / 4:
			value = MAX * 4 * (i - 3 * PERIOD / 4) / PERIOD - MAX
		value = int(value)
		binary = to_n_wide_bin(twos_complent_adjust(value))
		print(f"when \"{to_n_wide_bin(i | (offset * 2**16), 18)}\" => output <= \"{binary}\";")


def main(offset=0):
	print(TOP)
	generate_sin(0)
	print("")
	generate_triangle(1)
	print(BOTTOM)

if __name__ == "__main__":
	main()
