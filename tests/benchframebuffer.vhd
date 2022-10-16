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
    port(
        clk                     : in std_logic;
        en                      : in std_logic;
        reset                   : in std_logic;
        clk_video_pixel_in      : in std_logic
        VIDEO_PIXEL_IN          : in std_logic_vector(24-1 downto 0)
        H_IN, V_IN              : in unsigned(10-1 downto 0)
        Zoom                    : in signed(8-1 downto 0)
        H_Position, V_Position  : in signed(10-1 downto 0)
        H_Blanking, V_Blanking  : in unsigned(8-1 downto 0)
        status                  : out std_logic_vector(4-1 downto 0)
        Xout, Yout              : out unsigned (10-1 downto 0)
        Rout, Gout, Bout        : out unsigned (8-1 downto 0)
        Iout                    : out unsigned (8-1 downto 0)
    );
    end component;

    --Declaration of the internal  signals used in the testbench
    signal int_clk       	        : std_logic := '0';
    signal int_en       	        : std_logic := '0';
	signal int_reset     		    : std_logic := '0';
    signal int_clk_video_pixel_in   : in std_logic
    signal int_VIDEO_PIXEL_IN       : in std_logic_vector(24-1 downto 0)
    signal int_H_IN                 : in unsigned(10-1 downto 0)
    signal int_V_IN                 : in unsigned(10-1 downto 0)
    signal int_Zoom                 : in signed(8-1 downto 0)
    signal int_H_Position           : in signed(10-1 downto 0)
    signal int_V_Position           : in signed(10-1 downto 0)
    signal int_H_Blanking           : in unsigned(8-1 downto 0)
    signal int_V_Blanking           : in unsigned(8-1 downto 0)
    signal int_status               : out std_logic_vector(4-1 downto 0)
    signal int_Xout                 : out unsigned (10-1 downto 0)
    signal int_Yout                 : out unsigned (10-1 downto 0)
    signal int_Rout                 : out unsigned (8-1 downto 0)
    signal int_Gout                 : out unsigned (8-1 downto 0)
    signal int_Bout                 : out unsigned (8-1 downto 0)
    signal int_Iout                 : out unsigned (8-1 downto 0)
  
    begin

    --Instantiation of the Design Under Test
        DUT : FRAME_BUFFER
            port map (
                clk                 => int_clk,
                en                  => int_en,
                reset               => int_reset,
                clk_video_pixel_in  => int_clk_video_pixel_in
                VIDEO_PIXEL_IN      => int_VIDEO_PIXEL_IN
                H_IN                => int_H_IN
                V_IN                => int_V_IN
                Zoom                => int_Zoom
                H_Position          => int_H_Position
                V_Position          => int_V_Position
                H_Blanking          => int_H_Blanking
                V_Blanking          => int_V_Blanking
                status              => int_status
                Xout                => int_Xout
                Yout                => int_Yout
                Rout                => int_Rout
                Gout                => int_Gout
                Bout                => int_Bout
                Iout                => Iout
                ) ;

    --Generation of Clock cycles and Reset pulse
        int_clock   <= not(int_clock) after half_clockcycle;

  stimuli_generator: process
  begin
  for i in 0 to 300000 loop
    int_VIDEO_PIXEL_IN <= std_logic_vector(unsigned(i))
    wait for clockcycle;
  end loop

  int_H_IN <= '0'
  int_V_IN <= '0'
  wait for clockcycle;
  assert (int_Rout != int_Bout and int_Bout != int_Gout) report "Wrong output" severity failure;

  wait for 10*clockcycle;
  --Raise a deliberate failure to stop execution
  assert false report "TESTBENCH FINISHED, raising a Failure to stop" severity failure;

  end process;
  end test;
