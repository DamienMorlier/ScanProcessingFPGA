import math

PERIOD = 2**8 - 1
MAX = 2**7


def to_n_wide_bin(x, n=8):
	return format(x, "b").zfill(n)


def twos_complent_adjust(x, n=8):
	if x >= 0:
		return x
	return 2**n - (~x + 1)


def generate_sin(offset=0):
	period_step = 2 * math.pi / PERIOD

	print("-- sine wave")

	for i in range(PERIOD):
		value = int(MAX * math.sin(i * period_step))
		binary = to_n_wide_bin(twos_complent_adjust(value))
		print(f'when "{to_n_wide_bin(i | (offset * 2**8), 10)}" => output <= "{binary}";')


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
		print(f"when \"{to_n_wide_bin(i | (offset * 2**8), 10)}\" => output <= \"{binary}\";")


def main(offset=0):
	generate_sin(0)
	print("")
	generate_triangle(1)

if __name__ == "__main__":
	main()
