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
entity proc_TopPipeStp0Isint16 is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      oBufFull_rdy_ena     : in std_logic; 
       
      outp_rdy_ena     : in std_logic; 
       
      inp_data     : in recinp2; 
       
      inp_ena     : in std_logic; 
       
      reset_ena     : in std_logic
      ;
      
      -- -- output signals
      oBufFull_ena     : out std_logic; 
       
      inp_rdy_ena     : out std_logic; 
       
      outp_data     : out recinp2; 
       
      outp_ena     : out std_logic; 
       
      reset_rdy_ena     : out std_logic);
end entity;
architecture rtl of proc_TopPipeStp0Isint16 is 
signal cycleNum : integer;
signal bufFullhscl000000n : std_logic_vector (0 downto 0) := (0 => '0');
signal p0hscl000000o :  std_logic_vector (16-1 downto 0);
signal canInputhscl000000m_ena : std_logic;
file bufFulltrace : char_file open write_mode is "Top.PipeStp0Isint16bufFull.trace";
file p0trace : char_file open write_mode is "Top.PipeStp0Isint16p0.trace";
signal h0s_cond_synchscl000000p : std_logic_vector (0 downto 0);
signal h1s_cond_synchscl000000q : std_logic_vector (0 downto 0);
signal h3s_cond_synchscl000000r : std_logic_vector (0 downto 0);
signal h4s_cond_synchscl000000s : std_logic_vector (0 downto 0);
signal h5s_cond_synchscl000000t : std_logic_vector (0 downto 0);

begin
process (clk, rst) is
variable bufFullPrintVar : std_logic_vector (0 downto 0) ;
variable bufFullconflictCounter : integer ;
variable p0PrintVar :  std_logic_vector (16-1 downto 0) ;
variable p0conflictCounter : integer ;
variable tmp : std_logic_vector (0 downto 0) ;
variable tmp1 : std_logic_vector (0 downto 0) ;
variable tmp2 : std_logic_vector (0 downto 0) ;
begin
  if clk'event and clk = '1' then
    bufFullconflictCounter := 0 ;
    p0conflictCounter := 0 ;
    if conv_boolean((0 => canInputhscl000000m_ena)) then
      tmp := (0 => '0') ;
    else
      tmp := bufFullhscl000000n ;
    end if;
    if conv_boolean((0 => inp_ena)) then
      tmp1 := (0 => '1') ;
    else
      tmp1 := tmp ;
    end if;
    if conv_boolean((0 => reset_ena)) then
      tmp2 := (0 => '0') ;
    else
      tmp2 := tmp1 ;
    end if;
    bufFullPrintVar := bufFullhscl000000n ;
    fprint_stringPtr(bufFulltrace,  toString(bufFullPrintVar));
    fprint_string(bufFulltrace,  newline);
    bufFullconflictCounter := bufFullconflictCounter + 1;
    assert bufFullconflictCounter <= 1 report "conflict when writing bufFull" severity failure ; 
    bufFullhscl000000n <= tmp2 ;
    if h3s_cond_synchscl000000r(0)='1' then
      p0PrintVar := p0hscl000000o ;
      fprint_stringPtr(p0trace,   toStringSigned(p0PrintVar));
      fprint_string(p0trace,  newline);
      p0conflictCounter := p0conflictCounter + 1;
      assert p0conflictCounter <= 1 report "conflict when writing p0" severity failure ; 
      p0hscl000000o <= inp_data.p0 ;
    else
      null;
    end if;
  end if;
end process;
process (bufFullhscl000000n) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h0s_cond_synchscl000000p_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  oBufFull_ena <= '0' ;
  
  
  null;
  h0s_cond_synchscl000000p_data_dummy := 
  zero(h0s_cond_synchscl000000p_data_dummy) ;
  h0s_cond_synchscl000000p <= h0s_cond_synchscl000000p_data_dummy ;
  
  s_condExpr := bufFullhscl000000n ;
  s_cond := (s_condExpr(0)) ;
  h0s_cond_synchscl000000p <= (0 => s_cond) ;
  if (s_cond='1') then
    oBufFull_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
process (canInputhscl000000m_ena) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h1s_cond_synchscl000000q_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  inp_rdy_ena <= '0' ;
  
  
  null;
  h1s_cond_synchscl000000q_data_dummy := 
  zero(h1s_cond_synchscl000000q_data_dummy) ;
  h1s_cond_synchscl000000q <= h1s_cond_synchscl000000q_data_dummy ;
  
  s_condExpr := (0 => canInputhscl000000m_ena) ;
  s_cond := (s_condExpr(0)) ;
  h1s_cond_synchscl000000q <= (0 => s_cond) ;
  if (s_cond='1') then
    inp_rdy_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
process (inp_ena, bufFullhscl000000n, reset_ena, canInputhscl000000m_ena) is

begin
  
  
  
  
  null;
  null;
end process;
process (inp_ena, p0hscl000000o, inp_data, canInputhscl000000m_ena) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h3s_cond_synchscl000000r_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  
  
  
  h3s_cond_synchscl000000r_data_dummy := 
  zero(h3s_cond_synchscl000000r_data_dummy) ;
  h3s_cond_synchscl000000r <= h3s_cond_synchscl000000r_data_dummy ;
  
  s_condExpr := (0 => '1') ;
  s_cond := (s_condExpr(0)) and inp_ena and canInputhscl000000m_ena ;
  h3s_cond_synchscl000000r <= (0 => s_cond) ;
  if (s_cond='1') then
    null;
  else
    null;
  end if;
  null;
end process;
process (bufFullhscl000000n, outp_rdy_ena) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h4s_cond_synchscl000000s_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  canInputhscl000000m_ena <= '0' ;
  
  
  null;
  h4s_cond_synchscl000000s_data_dummy := 
  zero(h4s_cond_synchscl000000s_data_dummy) ;
  h4s_cond_synchscl000000s <= h4s_cond_synchscl000000s_data_dummy ;
  
  s_condExpr := or2(not2(bufFullhscl000000n),  (0 => outp_rdy_ena)) ;
  s_cond := (s_condExpr(0)) ;
  h4s_cond_synchscl000000s <= (0 => s_cond) ;
  if (s_cond='1') then
    canInputhscl000000m_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
process (p0hscl000000o, bufFullhscl000000n) is
variable s_condExpr : std_logic_vector (0 downto 0) ;
variable s_cond : std_logic ;
variable h5s_cond_synchscl000000t_data_dummy : std_logic_vector (0 downto 0) 
;
begin
  outp_ena <= '0' ;
  
  
  outp_data <= (p0 => p0hscl000000o) ;
  h5s_cond_synchscl000000t_data_dummy := 
  zero(h5s_cond_synchscl000000t_data_dummy) ;
  h5s_cond_synchscl000000t <= h5s_cond_synchscl000000t_data_dummy ;
  
  s_condExpr := bufFullhscl000000n ;
  s_cond := (s_condExpr(0)) ;
  h5s_cond_synchscl000000t <= (0 => s_cond) ;
  if (s_cond='1') then
    outp_ena <= '1' ;
    null;
  else
    null;
  end if;
  null;
end process;
reset_rdy_ena <= '0' ;

end architecture;