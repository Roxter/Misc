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
entity proc_TopLInserterStp0Isint16 is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      outp_rdy_ena     : in std_logic; 
       
      inp_data     : in recinp2; 
       
      inp_ena     : in std_logic; 
       
      reset_ena     : in std_logic
      ;
      
      -- -- output signals
      reset_rdy_ena     : out std_logic; 
       
      inp_rdy_ena     : out std_logic; 
       
      outp_data     : out recinp2; 
       
      outp_ena     : out std_logic);
end entity;
architecture rtl of proc_TopLInserterStp0Isint16 is 
signal cycleNum : integer;

signal inp2hscl000000c_data : recinp2;
signal inp2hscl000000c_ena : std_logic;

signal h0s_cond_synchscl000000d : std_logic_vector (0 downto 0);
signal h1s_cond_synchscl000000e : std_logic_vector (0 downto 0);
signal h2s_cond_synchscl000000f : std_logic_vector (0 downto 0);

begin
process (clk, rst) is

begin
  if clk'event and clk = '1' then
    
  end if;
end process;
process (outp_rdy_ena) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h0s_cond_synchscl000000d_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  inp_rdy_ena <= '0' ;
  
  
  null;
  h0s_cond_synchscl000000d_data_dummy := 
  zero(h0s_cond_synchscl000000d_data_dummy) ;
  h0s_cond_synchscl000000d <= h0s_cond_synchscl000000d_data_dummy ;
  
  s_condExpr := (0 => '1') ;
  s_cond := (s_condExpr(0)) and outp_rdy_ena ;
  h0s_cond_synchscl000000d <= (0 => s_cond) ;
  if (s_cond='1') then
    inp_rdy_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
process (inp2hscl000000c_ena, inp2hscl000000c_data) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h1s_cond_synchscl000000e_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  outp_ena <= '0' ;
  
  
  outp_data <= (p0 => inp2hscl000000c_data.p0) ;
  h1s_cond_synchscl000000e_data_dummy := 
  zero(h1s_cond_synchscl000000e_data_dummy) ;
  h1s_cond_synchscl000000e <= h1s_cond_synchscl000000e_data_dummy ;
  
  s_condExpr := (0 => '1') ;
  s_cond := (s_condExpr(0)) and inp2hscl000000c_ena ;
  h1s_cond_synchscl000000e <= (0 => s_cond) ;
  if (s_cond='1') then
    outp_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
process (inp_ena, inp_data) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h2s_cond_synchscl000000f_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  inp2hscl000000c_ena <= '0' ;
  
  
  inp2hscl000000c_data <= (p0 => inp_data.p0) ;
  h2s_cond_synchscl000000f_data_dummy := 
  zero(h2s_cond_synchscl000000f_data_dummy) ;
  h2s_cond_synchscl000000f <= h2s_cond_synchscl000000f_data_dummy ;
  
  s_condExpr := (0 => '1') ;
  s_cond := (s_condExpr(0)) and inp_ena ;
  h2s_cond_synchscl000000f <= (0 => s_cond) ;
  if (s_cond='1') then
    inp2hscl000000c_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
reset_rdy_ena <= '0' ;

end architecture;