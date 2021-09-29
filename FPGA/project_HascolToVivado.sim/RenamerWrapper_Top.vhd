

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.arrayAsAliasTrimmers.all;
use work.types.all;
use work.runtime.all;

use work.bincompl.all;

entity RenamerWrapper_Top is port (
clk : in std_logic;
rst : in std_logic
);
end entity;

architecture rtl of RenamerWrapper_Top is 
signal reset_ena : std_logic_vector(1 downto 0);

begin
  
  process (clk, rst) is 
  begin
    if rst = '1' then 
      reset_ena <= B"11";
    elsif clk'event and clk = '1' then 
      reset_ena <= reset_ena(0) & B"0";
    end if;
  end process;

  inner : entity work.proc_Top port map (
    clk => clk,
rst => rst,
reset_ena => reset_ena(1)
  );



end rtl;
