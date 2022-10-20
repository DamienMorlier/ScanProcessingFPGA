library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity FunctionGenerator is 
    port(
    clock               : in std_logic;
    reset               : in std_logic;
    Frequency           : in integer;
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
        generic(
            DATA_WIDTH : integer;
            DATA_SIZE  : integer;
            CLOCK_FREQ : integer
        )
        port(
            reset : in std_logic;
            clock : in std_logic;
            Frequency   : in integer;
            DCO_RAMP : out integer
        );
    end component;

    component Offset
        generic(
            M : integer;
            N : integer;
        )
        port(
            RAMP_IN: in std_logic_vector(M-1 downto 0);
            scaling_value: in std_logic_vector(M-1 downto 0);
            RAMP_OUT : out std_logic_vector(N-1 downto 0)
        );
    
        
        
    end component;

    component scaling
        generic(
            M : integer;
            N : integer;
        )
        port(
            RAMP_IN: in std_logic_vector(M-1 downto 0);
            offset_value: in std_logic_vector(M-1 downto 0);
            RAMP_OUT : out std_logic_vector(N-1 downto 0)
        );
    end component;



signal DCO_RAMP : std_logic_vector(4 downto 0);
signal 

    u1 : DCOPhaser port map(
        reset <= reset,
        clock <= clock,
        Frequency <= Frequency
    );
    u2 : Offset port map(
        offset_value <= Offset,
        RAMP_IN <= DCO_RAMP
    );

    u3 : scaling port map(

        scaling_value <= scaling,
        RAMP_IN <= RAMP_SCALED
    );