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
entity ext_TopVarToLog is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      input_data     : in recslave_output_ena; 
       
      input_ena     : in std_logic; 
       
      inputs_data     : in recoutpVars; 
       
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
architecture rtl of ext_TopVarToLog is 
signal cycleNum : integer;

signal LogOutLeft: std_logic_vector(64-1 downto 0);
signal LogOutRight: std_logic_vector(64-1 downto 0);

begin
VarToLogLeft:process(clk)
	variable x1:std_logic_vector(64-1 downto 0);
	variable x2:std_logic_vector(54 downto 0);
	variable xmult:std_logic_vector(2*54+1 downto 0);
	variable p:std_logic_vector(10-1 downto 0);  
	variable pout:std_logic_vector(54-1 downto 0) := conv_std_logic_vector(0,54);
begin
	if clk'event and clk='1' then
		if rst='1' then
		else
			x1 := inputs_data.p1(63 downto 0);
			p := conv_std_logic_vector(64-1, 10);
			for i in 1 to 64 loop
				exit when x1(64-1) = '1';      
				x1 := x1(64-2 downto 0)&'0';
				p := unsigned(p)-1;
			end loop;
			x2 := x1(64-1 downto 64-54-1);
			for i in 1 to 54 loop
				xmult := unsigned(x2) * unsigned(x2);
				if   xmult(2*54+1) = '1' then
					pout(54-i) := '1';
					x2 := xmult(2*54+1 downto 54+1);
				else pout(54-i) := '0';
					x2 := xmult(2*54 downto 54);
				end if;
			end loop;
			if x1=conv_std_logic_vector(0,64) then LogOutLeft <= conv_std_logic_vector(0,64);
			else
				LogOutLeft <= (p & pout);
			end if;
		end if;
	end if;
end process;

VarToLogRight:process(clk)
	variable x1:std_logic_vector(64-1 downto 0);
	variable x2:std_logic_vector(54 downto 0);
	variable xmult:std_logic_vector(2*54+1 downto 0);
	variable p:std_logic_vector(10-1 downto 0);  
	variable pout:std_logic_vector(54-1 downto 0) := conv_std_logic_vector(0,54);
begin
	if clk'event and clk='1' then
		if rst='1' then
		else
			x1 := inputs_data.p2(63 downto 0);
			p := conv_std_logic_vector(64-1, 10);
			for i in 1 to 64 loop
				exit when x1(64-1) = '1';      
				x1 := x1(64-2 downto 0)&'0';
				p := unsigned(p)-1;
			end loop;                   
			x2 := x1(64-1 downto 64-54-1);
			for i in 1 to 54 loop
				xmult := unsigned(x2) * unsigned(x2);
				if   xmult(2*54+1) = '1' then
					pout(54-i) := '1';
					x2 := xmult(2*54+1 downto 54+1);
				else pout(54-i) := '0';
					x2 := xmult(2*54 downto 54);
				end if;
			end loop;
			if x1=conv_std_logic_vector(0,64) then LogOutRight <= conv_std_logic_vector(0,64);
			else
				LogOutRight <= (p & pout);
			end if;
		end if;
	end if;
end process;
end architecture;