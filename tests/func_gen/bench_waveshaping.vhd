LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY waveshaping_test_bench IS
END ENTITY waveshaping_test_bench;

ARCHITECTURE test OF waveshaping_test_bench IS
	CONSTANT clockcycle : TIME := 2 ns;
	CONSTANT half_clockcycle : TIME := clockcycle/2;

	COMPONENT waveshaping is
		generic (
			DATA_WIDTH: integer := 8
		);
		port (
			wave_select: in std_logic_vector(3 downto 0);
			input: in std_logic_vector(DATA_WIDTH-1 downto 0);
			clk: in std_logic;
			output: out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
	END COMPONENT;

	signal int_clock : std_logic := '0';

	signal int_wave_select : std_logic_vector(3 downto 0);
	signal int_input : std_logic_vector(7 downto 0);
	signal int_output : std_logic_vector(7 downto 0);

BEGIN

	--Instantiation of the Design Under Test
	DUT : waveshaping
	GENERIC MAP(DATA_WIDTH => 8)
	PORT MAP(
		wave_select => int_wave_select,
		input => int_input,
		clk => int_clock,
		output => int_output
	);

	--Generation of Clock cycles and Reset pulse
	int_clock <= NOT(int_clock) AFTER half_clockcycle;

	stimuli_generator : PROCESS
	variable i : integer :=0;
	BEGIN

		-- Select sine wave
		int_wave_select <= "0000";
		int_input <= (others => '0');
		i := 0;
		wait for clockcycle;
		stimuli_loop: while i <= 255 loop
			int_input <= std_logic_vector(unsigned(int_input) + 1);
			i := i + 1;
			wait for clockcycle;
		end loop;

		-- Select square wave
		int_wave_select <= "0001";
		int_input <= (others => '0');
		i := 0;
		wait for clockcycle;
		stimuli_loop2: while i <= 255 loop
			int_input <= std_logic_vector(unsigned(int_input) + 1);
			i := i + 1;
			wait for clockcycle;
		end loop;

		-- Select triangle wave
		int_wave_select <= "0010";
		int_input <= (others => '0');
		i := 0;
		wait for clockcycle;
		stimuli_loop3: while i <= 255 loop
			int_input <= std_logic_vector(unsigned(int_input) + 1);
			i := i + 1;
			wait for clockcycle;
		end loop;

		ASSERT false REPORT "TESTBENCH FINISHED, raising a Failure to stop" SEVERITY failure;
	END PROCESS;
END test;