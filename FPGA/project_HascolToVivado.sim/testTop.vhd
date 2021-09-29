

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.arrayAsAliasTrimmers.all;
use work.types.all;
use work.runtime.all;
use work.bincompl.all;

entity test is 
end entity;

architecture behav of test is 

signal rst : std_logic := '1';
signal reset_ena : std_logic := '1';
signal clk : std_logic := '1';


begin

  clk <= not clk after 5 ns;
  rst <= '0' after 20 ns;
  reset_ena <= '0' after 40 ns;

  t : entity work.RenamerWrapper_Top port map (
    clk => clk, rst => rst 
  );

end behav;
