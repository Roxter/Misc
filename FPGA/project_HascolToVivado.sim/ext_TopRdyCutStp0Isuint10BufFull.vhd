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
entity ext_TopRdyCutStp0Isuint10BufFull is
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
      outp_ena     : out std_logic);
end entity;
architecture rtl of ext_TopRdyCutStp0Isuint10BufFull is 
signal cycleNum : integer;


signal CE, D : std_logic;



begin


  CE <= (outp_rdy_ena) or (inp_ena and not outp_rdy_ena);
  D  <= inp_ena and not outp_rdy_ena;

  FDRE_inst : UNISIM.vcomponents.FDRE
   generic map (
      INIT => '0') -- Initial value of register ('0' or '1')
   port map (
      Q => outp_ena,      -- Data output
      C => clk,      -- Clock input
      CE => CE,    -- Clock enable input
      R => reset_ena,      -- Synchronous reset input
      D => D       -- Data input
   );


end architecture;