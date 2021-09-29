use work.p.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gen is
    Port (
            clk: in std_logic;
            rst: in std_logic;
            in_rdy: in std_logic;
            
            o_valid: out std_logic:='0';
            o_data: out Arr:=(others=>std_logic_vector(to_unsigned(0,16)))
          );
end Gen;

architecture Behavioral of Gen is

signal GenCntr:integer:=0;
signal ValCntr:integer:=0;

begin

    process (clk) is
    begin
        if clk'event and clk='1' then
            if rst='1' then
                o_data<=(std_logic_vector(to_unsigned(GenCntr,16)),std_logic_vector(to_unsigned(GenCntr+1,16)),std_logic_vector(to_unsigned(GenCntr+2,16)),std_logic_vector(to_unsigned(GenCntr+3,16)),std_logic_vector(to_unsigned(GenCntr+4,16)));
                GenCntr<=1;
                o_valid<='1';
                ValCntr<=1;
            else
                if ValCntr<10 then
                    o_valid<='1';
                    ValCntr<=ValCntr+1;
                elsif ValCntr>=10 AND ValCntr<20 then
                    o_valid<='0';
                    ValCntr<=ValCntr+1;
                elsif ValCntr>=20 then
                    ValCntr<=1;
                    o_valid<='1';
                end if;
                if in_rdy='1' then
                    GenCntr<=GenCntr+5;
                    o_data<=(std_logic_vector(to_unsigned(GenCntr,16)),std_logic_vector(to_unsigned(GenCntr+1,16)),std_logic_vector(to_unsigned(GenCntr+2,16)),std_logic_vector(to_unsigned(GenCntr+3,16)),std_logic_vector(to_unsigned(GenCntr+4,16)));
                else
                    o_data<=(others=>std_logic_vector(to_unsigned(0,16)));
                end if;
            end if;
        end if;
    end process;

end Behavioral;