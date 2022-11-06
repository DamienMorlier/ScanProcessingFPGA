library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;


entity FunctionGenerator is 
    generic(
        DATA_WIDTH :integer
    );
    port(
    clock               : in std_logic;
    reset               : in std_logic;
    phase_incr          : in std_logic_vector(DATA_WIDTH-1 downto 0); --Wanted Frequency
    Scale               : in std_logic_vector(DATA_WIDTH-1 downto 0);
    SIG_OUT             : out std_logic_vector(DATA_WIDTH-1 downto 0);   
    Offset_val          : in std_logic_vector(DATA_WIDTH-1 downto 0);

    --External            : in std_logic;
    --Harmonic            : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --Phase               : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --Sync                : in std_logic;
    waveform            : in std_logic_vector(3 downto 0)
    --I_OUT               : out std_logic;
    --B_OUT               : out std_logic
    );
end FunctionGenerator;

architecture behaviour of FunctionGenerator is
    component DCOPhaser
        generic(
            DATA_WIDTH : integer
        );
        port(
            reset        : in std_logic;
            clock        : in std_logic;
            phase_incr   : in std_logic_vector(DATA_WIDTH-1 downto 0);
            DCO_RAMP     : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component Offset
        generic(
            DATA_WIDTH : integer
        );
        port(
            SIG_IN: in std_logic_vector(DATA_WIDTH-1 downto 0);
            offset_value: in std_logic_vector(DATA_WIDTH-1 downto 0);
            SIG_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    
        
        
    end component;

    component scaling
        generic(
            DATA_WIDTH : integer
        );
        port(
            SIG_IN: in std_logic_vector(DATA_WIDTH-1 downto 0);
            scaling_value: in std_logic_vector(DATA_WIDTH-1 downto 0);
            SIG_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;

    component waveshaping
        generic(
            DATA_WIDTH : integer
        );
        port(
            wave_select : std_logic_vector(3 downto 0);
            input: in std_logic_vector(DATA_WIDTH-1 downto 0);
            clk: in std_logic;
            output: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;


signal DCO_RAMP     : std_logic_vector(DATA_WIDTH-1 downto 0);
signal RAMP_SCALED  : std_logic_vector(DATA_WIDTH-1 downto 0);
signal RAMP_OFFSET  : std_logic_vector(DATA_WIDTH-1 downto 0);

begin
    u1 : component DCOPhaser 
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        reset => reset,
        clock => clock,
        phase_incr => phase_incr,
        DCO_RAMP => DCO_RAMP
    );
    u2 : component Offset 
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        SIG_IN      => DCO_RAMP,
        offset_value => Offset_val,
        SIG_OUT     => RAMP_OFFSET
    );

    u3 : component scaling
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        SIG_IN         => RAMP_OFFSET,
        scaling_value   => Scale,
        SIG_OUT        => RAMP_SCALED

    );

    u6 : component waveshaping
    generic map(
        DATA_WIDTH => DATA_WIDTH
    )
    port map(
        input => RAMP_SCALED,
        clk => clock,
        wave_select => waveform,
        output => SIG_OUT
    );
end behaviour;