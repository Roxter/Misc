library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.arrayAsAliasTrimmers.all;
use work.types.all;
use work.runtime.all;
use work.IOShuvalkin.all;
use work.bincompl.all;
library unisim;
library UNISIM;
entity ext_TopToFile is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      input_data     : in recslave_output_ena; 
       
      input_ena     : in std_logic; 
       
      inputs_data     : in recoutp; 
       
      inputs_ena     : in std_logic; 
       
      slave_input_ena_data     : in recslave_output_ena; 
       
      slave_input_ena_ena     : in std_logic; 
       
      slave_output_rdy_ena_data     : in recslave_output_ena; 
       
      slave_output_rdy_ena_ena     : in std_logic; 
       
      slave_output_ena_rdy_ena     : in std_logic
      ;
      
      -- -- output signals
      input_rdy_ena     : out std_logic; 
       
      inputs_rdy_ena     : out std_logic; 
       
      slave_input_ena_rdy_ena     : out std_logic; 
       
      slave_output_rdy_ena_rdy_ena     : out std_logic; 
       
      slave_output_ena_data     : out recslave_output_ena; 
       
      slave_output_ena_ena     : out std_logic);
end entity;
architecture rtl of ext_TopToFile is 
signal cycleNum : integer;

file file_VECTORS0 : STD.textio.text open write_mode is "D:\output_data0.txt";
file file_VECTORS1 : STD.textio.text open write_mode is "D:\output_data1.txt";
file file_VECTORS2 : STD.textio.text open write_mode is "D:\output_data2.txt";
file file_VECTORS3 : STD.textio.text open write_mode is "D:\output_data3.txt";

begin
process (clk) is 
	variable v_ILINE0     : STD.textio.line;
	variable v_ILINE1     : STD.textio.line;
	variable v_ILINE2     : STD.textio.line;
	variable v_ILINE3     : STD.textio.line;
	variable ValCntrStartEnd:integer:=0;
	begin
	if clk'event and clk='1' then
		if rst='1' then
		else
			if ValCntrStartEnd < 3 then
				ValCntrStartEnd := ValCntrStartEnd+1;
			else
				if ValCntrStartEnd > 2 and ValCntrStartEnd < 5 then
					STD.textio.writeline(file_VECTORS0, v_ILINE0);
					STD.textio.write(v_ILINE0, conv_integer(conv_unsigned(inputs_data.p0(31 downto 0))));
					STD.textio.writeline(file_VECTORS1, v_ILINE1);
					STD.textio.write(v_ILINE1, conv_integer(conv_unsigned(inputs_data.p1(31 downto 0))));
					STD.textio.writeline(file_VECTORS2, v_ILINE2);
					STD.textio.write(v_ILINE2, conv_integer(conv_unsigned(inputs_data.p2(31 downto 0))));
					STD.textio.writeline(file_VECTORS3, v_ILINE3);
					STD.textio.write(v_ILINE3, conv_integer(conv_unsigned(inputs_data.p3(0 downto 0))));
					if inputs_data.p3(0) = '1' then
						ValCntrStartEnd := ValCntrStartEnd+1;
					end if;
				end if;
			end if;
		end if;
	end if;
end process;
end architecture;