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
entity proc_TopRdyCutStp0Isuint10 is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      outp_rdy_ena     : in std_logic; 
       
      inp_data     : in recinp; 
       
      inp_ena     : in std_logic; 
       
      reset_ena     : in std_logic
      ;
      
      -- -- output signals
      inp_rdy_ena     : out std_logic; 
       
      outp_data     : out recinp; 
       
      outp_ena     : out std_logic; 
       
      reset_rdy_ena     : out std_logic);
end entity;
architecture rtl of proc_TopRdyCutStp0Isuint10 is 
signal cycleNum : integer;
signal p0hscl0000001 :  std_logic_vector (10-1 downto 0);
signal bufFullPlughscl0000000_ena : std_logic;
file p0trace : char_file open write_mode is "Top.RdyCutStp0Isuint10p0.trace";
signal h0s_cond_synchscl0000002 : std_logic_vector (0 downto 0);
signal h1s_cond_synchscl0000003 : std_logic_vector (0 downto 0);
signal h2s_cond_synchscl0000004 : std_logic_vector (0 downto 0);
signal h2sE_cond_synchscl0000005 : std_logic_vector (0 downto 0);

begin
i_TopRdyCutStp0Isuint10BufFull : entity work.ext_TopRdyCutStp0Isuint10BufFull port map 
(rst => rst, clk => clk, outp_ena => bufFullPlughscl0000000_ena, reset_ena => reset_ena, inp_data => inp_data, inp_ena => inp_ena, outp_rdy_ena => outp_rdy_ena)
;process (clk, rst) is
 variable p0PrintVar :  std_logic_vector (10-1 downto 0) ;
 variable p0conflictCounter : integer ;
 begin
   if clk'event and clk = '1' then
     p0conflictCounter := 0 ;
     if h1s_cond_synchscl0000003(0)='1' then
       p0PrintVar := p0hscl0000001 ;
       fprint_stringPtr(p0trace,   toStringUnsigned(p0PrintVar));
       fprint_string(p0trace,  newline);
       p0conflictCounter := p0conflictCounter + 1;
       assert p0conflictCounter <= 1 report "conflict when writing p0" severity failure ; 
       p0hscl0000001 <= inp_data.p0 ;
     else
       null;
     end if;
   end if;
 end process;
 process (bufFullPlughscl0000000_ena) is
 variable s_condExpr : std_logic_vector (0 downto 0) ;
 variable s_cond : std_logic ;
 variable h0s_cond_synchscl0000002_data_dummy : 
 std_logic_vector (0 downto 0) ;
 begin
   inp_rdy_ena <= '0' ;
   
   
   null;
   h0s_cond_synchscl0000002_data_dummy := 
   zero(h0s_cond_synchscl0000002_data_dummy) ;
   h0s_cond_synchscl0000002 <= h0s_cond_synchscl0000002_data_dummy ;
   
   s_condExpr := not2((0 => bufFullPlughscl0000000_ena)) ;
   s_cond := (s_condExpr(0)) ;
   h0s_cond_synchscl0000002 <= (0 => s_cond) ;
   if (s_cond='1') then
     inp_rdy_ena <= '1' ;
     null;
   else
     null;
   end if;
   null;
 end process;
 process (inp_ena, bufFullPlughscl0000000_ena, inp_data, p0hscl0000001) is
 variable s_condExpr : std_logic_vector (0 downto 0) ;
 variable s_cond : std_logic ;
 variable h1s_cond_synchscl0000003_data_dummy : 
 std_logic_vector (0 downto 0) ;
 begin
   
   
   
   h1s_cond_synchscl0000003_data_dummy := 
   zero(h1s_cond_synchscl0000003_data_dummy) ;
   h1s_cond_synchscl0000003 <= h1s_cond_synchscl0000003_data_dummy ;
   
   s_condExpr := not2((0 => bufFullPlughscl0000000_ena)) ;
   s_cond := (s_condExpr(0)) and inp_ena ;
   h1s_cond_synchscl0000003 <= (0 => s_cond) ;
   if (s_cond='1') then
     null;
   else
     null;
   end if;
   null;
 end process;
 process (inp_ena, bufFullPlughscl0000000_ena, inp_data, p0hscl0000001) is
 variable s_condExpr : std_logic_vector (0 downto 0) ;
 variable s_cond : std_logic ;
 variable sE_condExpr : std_logic_vector (0 downto 0) ;
 variable sE_cond : std_logic ;
 variable h2sE_cond_synchscl0000005_data_dummy : 
 std_logic_vector (0 downto 0) ;
 variable h2s_cond_synchscl0000004_data_dummy : 
 std_logic_vector (0 downto 0) ;
 begin
   outp_ena <= '0' ;
   
   
   outp_data <= (p0 => p0hscl0000001) ;
   h2s_cond_synchscl0000004_data_dummy := 
   zero(h2s_cond_synchscl0000004_data_dummy) ;
   h2s_cond_synchscl0000004 <= h2s_cond_synchscl0000004_data_dummy ;
   h2sE_cond_synchscl0000005_data_dummy := 
   zero(h2sE_cond_synchscl0000005_data_dummy) ;
   h2sE_cond_synchscl0000005 <= h2sE_cond_synchscl0000005_data_dummy ;
   
   s_condExpr := (0 => bufFullPlughscl0000000_ena) ;
   s_cond := (s_condExpr(0)) ;
   h2s_cond_synchscl0000004 <= (0 => s_cond) ;
   if (s_cond='1') then
     outp_ena <= '1' ;
     null;
   else
     
     sE_condExpr := (0 => '1') ;
     sE_cond := (sE_condExpr(0)) and inp_ena ;
     h2sE_cond_synchscl0000005 <= (0 => sE_cond) ;
     if (sE_cond='1') then
       outp_ena <= '1' ;
       
       outp_data <= (p0 => inp_data.p0) ;
     else
       null;
     end if;
   end if;
   null;
 end process;
 reset_rdy_ena <= '0' ;
 
end architecture;