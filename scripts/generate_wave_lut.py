import math

PERIOD = 2**16 - 1
MAX = 2**31


def to_n_wide_bin(x, n=8):
	return format(x, "b").zfill(n)


def twos_complent_adjust(x, n=8):
	if x >= 0:
		return x
	return 2**n - (~x + 1)


def generate_sin(offset=0):
	period_step = 2 * math.pi / PERIOD

	with open("sine_lut.bin", "wb") as f:
		b = bytearray()
		for i in range(PERIOD):
			value = int(MAX * math.sin(i * period_step))
			for i in range(4):
				b.append((value >> 8*i) & 0xFF)
		f.write(b)


def main(offset=0):
	generate_sin(0)

if __name__ == "__main__":
	main()
