library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity Test is
end entity;

architecture Behavioral of Test is

    signal clk: std_logic;
    signal width_f_porch: unsigned (4 downto 0):=conv_unsigned(16,5);
    signal width_sync: unsigned (6 downto 0):=conv_unsigned(96,7);
    signal width_b_porch: unsigned (5 downto 0):=conv_unsigned(48,6);
    signal height_f_porch: unsigned (3 downto 0):= conv_unsigned(11,4);
    signal height_sync: unsigned (1 downto 0):=conv_unsigned(2,2);
    signal height_b_porch: unsigned (4 downto 0):=conv_unsigned(31,5);
    signal hscr: unsigned (9 downto 0):=conv_unsigned(640,10);
    signal vscr: unsigned (9 downto 0):=conv_unsigned(4,10);
    signal hblank, hsync, vblank, vsync, active_video:std_logic:='0';
    signal valid: std_logic:='1';
    signal Rst_cntr_width: std_logic:='0';
    signal rst: std_logic:='0';

begin

DUT : entity work.VidtimeGen

port map (  clk=>clk,
            width_f_porch=>width_f_porch, width_sync=>width_sync, width_b_porch=>width_b_porch,
            height_f_porch=>height_f_porch, height_sync=>height_sync, height_b_porch=>height_b_porch,
            hscr=>hscr, vscr=>vscr, hsync=>hsync, hblank=>hblank, vsync=>vsync, vblank=>vblank,
            active_video=>active_video, valid=>valid, rst=>rst
          );


process is
begin
    while true loop
        clk <= '1';        
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
    end loop;
end process;

process is
begin
    valid<='0';
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 1000000 ns;
end process;

end Behavioral;
