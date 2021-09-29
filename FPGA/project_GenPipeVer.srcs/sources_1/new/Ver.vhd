--library xil_defaultlib; --Из-за бага, компилятор приходится ткнуть пальцем
use work.p.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ver is 
    port (
            clk: in std_logic;
            rst: in std_logic;
            in_valid: in std_logic;
            in_avrg: in std_logic_vector(15 downto 0);
            in_dataPipe: in Arr;
            
            o_rdy: out std_logic:='1'
          );
end Ver;

architecture Behavioral of Ver is

signal AvrgVer: integer:=0;
signal Error: std_logic:='0';
signal AvrgPipe: Arr:=(std_logic_vector(to_unsigned(0,16)),std_logic_vector(to_unsigned(0,16)),std_logic_vector(to_unsigned(0,16)),std_logic_vector(to_unsigned(0,16)),std_logic_vector(to_unsigned(0,16)));
signal Cntr: integer:=0;

begin

    process (clk) is 
    begin
        if clk'event and clk='1' then
            if rst='1' then
                
            else
                if in_valid='1' AND Cntr<=30 then
                    if ((conv_integer(in_dataPipe(4)+in_dataPipe(3)+in_dataPipe(2)+in_dataPipe(1)+in_dataPipe(0))*13107)/65536)=conv_integer(in_avrg) OR (((conv_integer(in_dataPipe(4)+in_dataPipe(3)+in_dataPipe(2)+in_dataPipe(1)+in_dataPipe(0))*13107)/65536)=conv_integer(in_avrg)-1) OR (((conv_integer(in_dataPipe(4)+in_dataPipe(3)+in_dataPipe(2)+in_dataPipe(1)+in_dataPipe(0))*13107)/65536)=conv_integer(in_avrg)+1) then
                        AvrgVer<=((conv_integer(in_dataPipe(4)+in_dataPipe(3)+in_dataPipe(2)+in_dataPipe(1)+in_dataPipe(0))*13107)/65536);
                        Error<='0';
                        o_rdy<='1';
                    else
                        AvrgVer<=((conv_integer(in_dataPipe(4)+in_dataPipe(3)+in_dataPipe(2)+in_dataPipe(1)+in_dataPipe(0))*13107)/65536);
                        Error<='1';
                        o_rdy<='0';
                    end if;
                    Cntr<=Cntr+1;
                elsif Cntr<60 AND Cntr>30 then
                    o_rdy<='0';
                    Cntr<=Cntr+1;
                elsif Cntr=60 then
                    o_rdy<='1';
                    Cntr<=0;
                end if;
            end if;
        end if;
    end process;
    
 end architecture;