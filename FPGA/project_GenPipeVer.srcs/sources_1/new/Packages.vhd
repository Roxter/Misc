library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

package p is
    type Arr is array (0 to 4) of std_logic_vector (15 downto 0);
	type ArrData is array (0 to 2) of Arr;
	type ArrAvrg is array (0 to 3) of std_logic_vector (15 downto 0);
end p;