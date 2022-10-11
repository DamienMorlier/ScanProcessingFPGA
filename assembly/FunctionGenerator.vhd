library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity FunctionGenerator is 
    port(
    clock               : in std_logic;
    reset               : in std_logic;
    Frequency           : in std_logic;
    External            : in std_logic;
    Harmonic            : in std_logic;
    Phase               : in std_logic;
    Sync                : in std_logic;
    Blanking_width      : in std_logic;
    Blanking_phase      : in std_logic;
    Waveform            : in std_logic;
    Scale               : in std_logic;
    Offset              : in std_logic;
    I_OUT               : out std_logic;
    B_OUT               : out std_logic;
    );
end FunctionGenerator;

architecture behaviour of FunctionGenerator is
    component DCOPhaser
        port(
            reset : in std_logic;
            clock : in std_logic;
            Frequency   : in integer;
            DCO_RAMP : out integer
        );
    end component;

signal DCO_RAMP : integer :=0;

    u1 : DCOPhaser port map(
        reset <= reset
        clock <= clock
        Frequency <= Frequency

    )