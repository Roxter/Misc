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
entity ext_TopToFile1 is
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
architecture rtl of ext_TopToFile1 is 
signal cycleNum : integer;

file file_VECTORS4 : STD.textio.text open write_mode is "D:\output_data4.txt";
file file_VECTORS5 : STD.textio.text open write_mode is "D:\output_data5.txt";
file file_VECTORS6 : STD.textio.text open write_mode is "D:\output_data6.txt";
file file_VECTORS7 : STD.textio.text open write_mode is "D:\output_data7.txt";

begin
process (clk) is 
	variable v_ILINE4     : STD.textio.line;
	variable v_ILINE5     : STD.textio.line;
	variable v_ILINE6     : STD.textio.line;
	variable v_ILINE7     : STD.textio.line;
	variable ValCntrEnd:integer:=0;
	begin
	if clk'event and clk='1' then
		if rst='1' then
		else
			if inputs_ena = '1' or ValCntrEnd = 61 then
				STD.textio.writeline(file_VECTORS4, v_ILINE4);
				STD.textio.write(v_ILINE4, conv_integer(conv_unsigned(inputs_data.p0(31 downto 0))));
				STD.textio.writeline(file_VECTORS5, v_ILINE5);
				STD.textio.write(v_ILINE5, conv_integer(conv_unsigned(inputs_data.p1(31 downto 0))));
				STD.textio.writeline(file_VECTORS6, v_ILINE6);
				STD.textio.write(v_ILINE6, conv_integer(conv_unsigned(inputs_data.p2(31 downto 0))));
				STD.textio.writeline(file_VECTORS7, v_ILINE7);
				STD.textio.write(v_ILINE7, conv_integer(conv_unsigned(inputs_data.p3(0 downto 0))));
				ValCntrEnd := ValCntrEnd+1;
			end if;
		end if;
	end if;
end process;
end architecture;