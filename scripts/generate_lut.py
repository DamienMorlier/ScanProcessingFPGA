import math

PERIOD = 2**8 - 1
MAX = 2**7

def to_n_wide_bin(x, n=8):
    return format(x, 'b').zfill(n)

def twos_complent_adjust(x, n=8):
    if x >= 0:
        return x
    return 2**n - (~x + 1)

def generate_sin():
	period_step = 2*math.pi / PERIOD
	
	for i in range(PERIOD):
		value = int(MAX * math.sin(i * period_step))
		binary = to_n_wide_bin(twos_complent_adjust(value))
		print(f"when \"{to_n_wide_bin(i)}\" => output <= \"{binary}\";")

def generate_cosine():
    pass

def generate_square():
    pass

def generate_triangle():
    pass

def main():
	generate_sin()

if __name__ == "__main__":
	main()