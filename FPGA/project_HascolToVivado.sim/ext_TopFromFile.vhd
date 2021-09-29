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
entity ext_TopFromFile is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      input_data     : in recslave_output_ena; 
       
      input_ena     : in std_logic; 
       
      slave_input_ena_data     : in recslave_output_ena; 
       
      slave_input_ena_ena     : in std_logic; 
       
      slave_output_rdy_ena_data     : in recslave_output_ena; 
       
      slave_output_rdy_ena_ena     : in std_logic; 
       
      output_rdy_ena     : in std_logic; 
       
      slave_input_rdy_ena_rdy_ena     : in std_logic; 
       
      slave_output_ena_rdy_ena     : in std_logic
      ;
      
      -- -- output signals
      input_rdy_ena     : out std_logic; 
       
      slave_input_ena_rdy_ena     : out std_logic; 
       
      slave_output_rdy_ena_rdy_ena     : out std_logic; 
       
      output_data     : out recinp2; 
       
      output_ena     : out std_logic; 
       
      slave_input_rdy_ena_data     : out recslave_output_ena; 
       
      slave_input_rdy_ena_ena     : out std_logic; 
       
      slave_output_ena_data     : out recslave_output_ena; 
       
      slave_output_ena_ena     : out std_logic);
end entity;
architecture rtl of ext_TopFromFile is 
signal cycleNum : integer;

file file_VECTORS : STD.textio.text open read_mode is "D:\input_data.txt";

begin
process (clk) is 
	variable v_ILINE     : STD.textio.line;
	variable TERM1 : integer;
	variable v_SPACE     : character;
	variable end_file : boolean := false;
	variable ValCntrStart:integer:=0;
	variable ValCntrEnd:integer:=0;
begin
	if clk'event and clk='1' then
		if rst='1' then
			output_data.p0 <= std_logic_vector(IEEE.numeric_std.to_signed(0,16));
			output_ena <= '1';
		else
			if ValCntrStart < 1 then
				ValCntrStart := ValCntrStart+1;
			else
				if (not end_file) then
					STD.textio.readline(file_VECTORS, v_ILINE);
					STD.textio.read(v_ILINE, TERM1);
					STD.textio.read(v_ILINE, v_SPACE);           -- read in the space character
					output_data.p0 <= std_logic_vector(IEEE.numeric_std.to_signed(TERM1,16));
					if STD.textio.endfile(file_VECTORS) then
						STD.textio.file_close(file_VECTORS);
						end_file := true;
					end if;
				else
					output_ena <= '0';
				end if;
			end if;
		end if;
	end if;
	input_rdy_ena <= output_rdy_ena;
end process;
end architecture;