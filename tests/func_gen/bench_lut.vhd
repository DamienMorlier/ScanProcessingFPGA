LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY LUT_test_bench IS
END ENTITY LUT_test_bench;

ARCHITECTURE test OF LUT_test_bench IS
	CONSTANT clockcycle : TIME := 2 ns;
	CONSTANT half_clockcycle : TIME := clockcycle/2;

	COMPONENT wave_lut
		GENERIC (
			signal_width : INTEGER := 8
		);
		PORT (
			index : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			output : OUT STD_LOGIC_VECTOR(signal_width - 1 DOWNTO 0)
		);
	END COMPONENT;

	SIGNAL int_clock : STD_LOGIC := '0';

	SIGNAL int_index : unsigned(15 DOWNTO 0) := (OTHERS => '0');
	SIGNAL int_output : unsigned(7 DOWNTO 0);
	SIGNAL output_vector : STD_LOGIC_VECTOR(7 DOWNTO 0);

	type ist_array is array (15 downto 0) of std_logic_vector(24 downto 0);

BEGIN

	int_output <= unsigned(output_vector);

	--Instantiation of the Design Under Test
	DUT : wave_lut
	GENERIC MAP(signal_width => 8)
	PORT MAP(
		index => STD_LOGIC_VECTOR(int_index),
		output => output_vector
	);

	--Generation of Clock cycles and Reset pulse
	int_clock <= NOT(int_clock) AFTER half_clockcycle;

	stimuli_generator : PROCESS
	variable i : integer :=0;
	BEGIN

		-- In range 0 to 255, we expect sine wave.
		stimuli_loop: while i <= 255 loop
			int_index <= int_index + 1;
			i := i + 1;
			wait for clockcycle;
		end loop;

		-- In range 256 to 511, we expect square wave

		-- In range 512 to 767, we expect triangle wave

		ASSERT false REPORT "TESTBENCH FINISHED, raising a Failure to stop" SEVERITY failure;
	END PROCESS;
END test;