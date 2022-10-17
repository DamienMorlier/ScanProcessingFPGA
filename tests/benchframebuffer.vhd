library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity FB_test_bench is
end entity FB_test_bench;

architecture test of FB_test_bench is


    constant clockcycle : time := 2 ns;
    constant half_clockcycle : time := clockcycle/2;

    component FRAME_BUFFER 
    generic(
        H_RES : integer
    );
    port(
        clk                     : in std_logic;
        en                      : in std_logic;
        reset                   : in std_logic;
        clk_video_pixel_in      : in std_logic;
        VIDEO_PIXEL_IN          : in std_logic_vector(24-1 downto 0);
        H_IN, V_IN              : in unsigned(10-1 downto 0);
        Zoom                    : in signed(8-1 downto 0);
        H_Position, V_Position  : in signed(10-1 downto 0);
        H_Blanking, V_Blanking  : in unsigned(8-1 downto 0);
        status                  : out std_logic_vector(4-1 downto 0);
        Xout, Yout              : out unsigned (10-1 downto 0);
        Rout, Gout, Bout        : out unsigned (8-1 downto 0);
        Iout                    : out unsigned (8-1 downto 0)
    );
    end component;

    --Declaration of the internal  signals used in the testbench
    constant h_res                  : integer := 719;
    signal int_clk       	        : std_logic := '0';
    signal int_en       	        : std_logic := '0';
	signal int_reset     		    : std_logic := '0';
    signal int_clk_video_pixel_in   : std_logic;
    signal int_VIDEO_PIXEL_IN       : std_logic_vector(24-1 downto 0);
    signal int_H_IN                 : unsigned(10-1 downto 0);
    signal int_V_IN                 : unsigned(10-1 downto 0);
    signal int_Zoom                 : signed(8-1 downto 0);
    signal int_H_Position           : signed(10-1 downto 0);
    signal int_V_Position           : signed(10-1 downto 0);
    signal int_H_Blanking           : unsigned(8-1 downto 0);
    signal int_V_Blanking           : unsigned(8-1 downto 0);
    signal int_status               : std_logic_vector(4-1 downto 0);
    signal int_Xout                 : unsigned (10-1 downto 0);
    signal int_Yout                 : unsigned (10-1 downto 0);
    signal int_Rout                 : unsigned (8-1 downto 0);
    signal int_Gout                 : unsigned (8-1 downto 0);
    signal int_Bout                 : unsigned (8-1 downto 0);
    signal int_Iout                 : unsigned (8-1 downto 0);
  
    begin

    --Instantiation of the Design Under Test
        DUT : FRAME_BUFFER
            generic map(
                H_RES => h_res
            )
            port map (
                clk                 => int_clk,
                en                  => int_en,
                reset               => int_reset,
                clk_video_pixel_in  => int_clk_video_pixel_in,
                VIDEO_PIXEL_IN      => int_VIDEO_PIXEL_IN,
                H_IN                => int_H_IN,
                V_IN                => int_V_IN,
                Zoom                => int_Zoom,
                H_Position          => int_H_Position,
                V_Position          => int_V_Position,
                H_Blanking          => int_H_Blanking,
                V_Blanking          => int_V_Blanking,
                status              => int_status,
                Xout                => int_Xout,
                Yout                => int_Yout,
                Rout                => int_Rout,
                Gout                => int_Gout,
                Bout                => int_Bout,
                Iout                => int_Iout
                ) ;

    --Generation of Clock cycles and Reset pulse
        int_clk   <= not(int_clk) after half_clockcycle;

  stimuli_generator: process
  begin
  wait for clockcycle;
  for i in 0 to 30 loop
    int_VIDEO_PIXEL_IN <= std_logic_vector(to_unsigned(i, 24));
    wait for clockcycle;
  end loop;

  int_H_IN <= to_unsigned(0, 10);
  int_V_IN <= to_unsigned(0, 10);
  wait for clockcycle;
  assert (int_Rout /= int_Bout and int_Bout /= int_Gout) report "Wrong output" severity failure;

  wait for 10*clockcycle;
  --Raise a deliberate failure to stop execution
  assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;

  end process;
  end test;
