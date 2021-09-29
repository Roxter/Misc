use work.p.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pipe is 
    port (
            clk: in std_logic;
            rst: in std_logic;
            in_valid: in std_logic;
            in_rdy: in std_logic;
            in_data: in Arr;
            
            o_valid: out std_logic:='0';
            o_rdy: out std_logic:='1';
            o_avrg: out std_logic_vector (15 downto 0):= std_logic_vector(to_unsigned(0,16));
            o_datapipe: out Arr
          );
end Pipe;

architecture Behavioral of Pipe is

signal Prod: std_logic_vector(31 downto 0):= std_logic_vector(to_unsigned(0,32));
signal Prod1: std_logic_vector(15 downto 0):= std_logic_vector(to_unsigned(0,16));
signal Prod2: std_logic_vector(15 downto 0):= std_logic_vector(to_unsigned(0,16));
signal Prod3: std_logic_vector(15 downto 0):= std_logic_vector(to_unsigned(0,16));
signal ValidInPipe: std_logic_vector(2 downto 0):= std_logic_vector(to_unsigned(0,3));
signal DataInPipe: ArrData;

begin
    process (in_rdy) is
    begin
            if in_rdy='1' then
                o_rdy<='1';
            else
                o_rdy<='0';
            end if;
    end process;

    process (clk) is 
    begin
            if clk'event and clk='1' then
                if rst='1' then
                    ValidInPipe<=std_logic_vector(to_unsigned(0,3));
                    DataInPipe<=(others=>(others=>std_logic_vector(to_unsigned(0,16))));
                    o_avrg<=std_logic_vector(to_unsigned(0,16));
                    o_datapipe<=(others=>std_logic_vector(to_unsigned(0,16)));
                else
                    if in_rdy='1' then
                        DataInPipe(0)<=in_data;
                        ValidInPipe(0)<=in_valid;
                        
                        for i in 1 to 2 loop
                            ValidInPipe(i)<=ValidInPipe(i-1);
                        end loop;
                        for i in 1 to 2 loop
                            DataInPipe(i)<=DataInPipe(i-1);
                        end loop;
                        
                        Prod1<=in_data(3)+in_data(4)+in_data(2);
                        Prod2<=in_data(0)+in_data(1);
                        Prod3<=Prod1+Prod2;
                        Prod<=((Prod3)*std_logic_vector(to_unsigned(65536/5,16))) AND ("11111111111111110000000000000000");
                        o_avrg<=Prod(31 downto 16);
                        o_valid<=ValidInPipe(2);
                        o_datapipe<=DataInPipe(2);
                    end if;
                end if;
            end if;
    end process;

 end architecture;