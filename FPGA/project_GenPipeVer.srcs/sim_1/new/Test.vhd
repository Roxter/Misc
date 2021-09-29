use work.p.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test is
end entity;

architecture Behavioral of Test is

    signal clk: std_logic;
    signal rst: std_logic;
    signal validGenToPipe: std_logic;
    signal dataGenToPipe: Arr;
    signal rdyVerToPipe: std_logic;
    signal validPipeToVer: std_logic;
    signal rdyPipeToGen: std_logic;
    signal avrgPipeToVer: std_logic_vector (15 downto 0);
    signal dataPipeToVer: Arr;

begin

DUT: entity work.Pipe
port map ( clk=>clk, rst=>rst, in_valid=>validGenToPipe, o_rdy=>rdyPipeToGen, in_data=>dataGenToPipe,
           o_valid=>validPipeToVer, in_rdy=>rdyVerToPipe, o_avrg=>avrgPipeToVer, o_dataPipe=>dataPipeToVer
         );
DUT1: entity work.Gen
port map ( clk=>clk, rst=>rst, o_valid=>validGenToPipe, o_data=>dataGenToPipe, in_rdy=>rdyPipeToGen);
DUT2: entity work.Ver
port map ( clk=>clk, rst=>rst, in_valid=>validPipeToVer, o_rdy=>rdyVerToPipe, in_avrg=>avrgPipeToVer, in_dataPipe=>dataPipeToVer );

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
    rst <= '1';
    wait for 10 ns;
    rst <= '0';
    wait for 10000000 ns;
end process;

end Behavioral;
