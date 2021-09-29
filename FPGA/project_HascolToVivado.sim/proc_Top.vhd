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
entity proc_Top is
port (clk : in std_logic;
      rst : in std_logic
      ;
      
      -- input signals
      reset_ena     : in std_logic
      ;
      
      -- -- output signals
      reset_rdy_ena     : out std_logic);
end entity;
architecture rtl of proc_Top is 
signal cycleNum : integer;

signal stubslave_output_rdy_ena_rdy3hscl0000095_ena : std_logic;
signal stubslave_output_rdy_ena_rdy2hscl000009e_ena : std_logic;
signal stubslave_output_rdy_ena_rdy1hscl000009m_ena : std_logic;
signal stubslave_output_rdy_ena_rdyhscl000009u_ena : std_logic;
signal stubslave_output_rdy_ena3hscl0000090_data : recslave_output_ena;
signal stubslave_output_rdy_ena3hscl0000090_ena : std_logic;
signal stubslave_output_rdy_ena2hscl000009a_data : recslave_output_ena;
signal stubslave_output_rdy_ena2hscl000009a_ena : std_logic;
signal stubslave_output_rdy_ena1hscl000009i_data : recslave_output_ena;
signal stubslave_output_rdy_ena1hscl000009i_ena : std_logic;
signal stubslave_output_rdy_enahscl000009q_data : recslave_output_ena;
signal stubslave_output_rdy_enahscl000009q_ena : std_logic;
signal stubslave_output_ena_rdy3hscl0000092_ena : std_logic;
signal stubslave_output_ena_rdy2hscl000009b_ena : std_logic;
signal stubslave_output_ena_rdy1hscl000009j_ena : std_logic;
signal stubslave_output_ena_rdyhscl000009r_ena : std_logic;
signal stubslave_output_ena3hscl0000097_data : recslave_output_ena;
signal stubslave_output_ena3hscl0000097_ena : std_logic;
signal stubslave_output_ena2hscl000009f_data : recslave_output_ena;
signal stubslave_output_ena2hscl000009f_ena : std_logic;
signal stubslave_output_ena1hscl000009n_data : recslave_output_ena;
signal stubslave_output_ena1hscl000009n_ena : std_logic;
signal stubslave_output_enahscl000009v_data : recslave_output_ena;
signal stubslave_output_enahscl000009v_ena : std_logic;
signal stubslave_input_rdy_ena_rdyhscl0000091_ena : std_logic;
signal stubslave_input_rdy_enahscl0000096_data : recslave_output_ena;
signal stubslave_input_rdy_enahscl0000096_ena : std_logic;
signal stubslave_input_ena_rdy3hscl0000094_ena : std_logic;
signal stubslave_input_ena_rdy2hscl000009d_ena : std_logic;
signal stubslave_input_ena_rdy1hscl000009l_ena : std_logic;
signal stubslave_input_ena_rdyhscl000009t_ena : std_logic;
signal stubslave_input_ena3hscl000008z_data : recslave_output_ena;
signal stubslave_input_ena3hscl000008z_ena : std_logic;
signal stubslave_input_ena2hscl0000099_data : recslave_output_ena;
signal stubslave_input_ena2hscl0000099_ena : std_logic;
signal stubslave_input_ena1hscl000009h_data : recslave_output_ena;
signal stubslave_input_ena1hscl000009h_ena : std_logic;
signal stubslave_input_enahscl000009p_data : recslave_output_ena;
signal stubslave_input_enahscl000009p_ena : std_logic;
signal stubreset_rdy4hscl000000b_ena : std_logic;
signal stubreset_rdy3hscl000000j_ena : std_logic;
signal stubreset_rdyhscl0000011_ena : std_logic;
signal stubreset4hscl0000008_ena : std_logic;
signal stubreset3hscl000000i_ena : std_logic;
signal stubresethscl000000x_ena : std_logic;
signal stuboutp_rdy4hscl0000006_ena : std_logic;
signal stuboutp_rdy3hscl000000g_ena : std_logic;
signal stuboutp_rdyhscl000000v_ena : std_logic;
signal stuboutp4hscl000000a_data : recinp;
signal stuboutp4hscl000000a_ena : std_logic;
signal stuboutp3hscl000000l_data : recinp2;
signal stuboutp3hscl000000l_ena : std_logic;
signal stuboutphscl0000010_data : recinp2;
signal stuboutphscl0000010_ena : std_logic;
signal stuboBufFull_rdyhscl000000u_ena : std_logic;
signal stuboBufFullhscl000000y_ena : std_logic;
signal stubinput_rdy3hscl0000093_ena : std_logic;
signal stubinput_rdy2hscl000009c_ena : std_logic;
signal stubinput_rdy1hscl000009k_ena : std_logic;
signal stubinput_rdyhscl000009s_ena : std_logic;
signal stubinput3hscl000008y_data : recslave_output_ena;
signal stubinput3hscl000008y_ena : std_logic;
signal stubinput2hscl0000098_data : recslave_output_ena;
signal stubinput2hscl0000098_ena : std_logic;
signal stubinput1hscl000009g_data : recslave_output_ena;
signal stubinput1hscl000009g_ena : std_logic;
signal stubinputhscl000009o_data : recslave_output_ena;
signal stubinputhscl000009o_ena : std_logic;
signal stubinp_rdy4hscl0000009_ena : std_logic;
signal stubinp_rdy3hscl000000k_ena : std_logic;
signal stubinp_rdyhscl000000z_ena : std_logic;
signal stubinp4hscl0000007_data : recinp;
signal stubinp4hscl0000007_ena : std_logic;
signal stubinp3hscl000000h_data : recinp2;
signal stubinp3hscl000000h_ena : std_logic;
signal stubinphscl000000w_data : recinp2;
signal stubinphscl000000w_ena : std_logic;
signal Main_outp_rdyhscl000008q_ena : std_logic;
signal Main_outpVars_rdyhscl000008r_ena : std_logic;
signal Main_outpVarshscl000008u_data : recoutpVars;
signal Main_outpVarshscl000008u_ena : std_logic;
signal Main_outp1_rdyhscl000008s_ena : std_logic;
signal Main_outp1hscl000008v_data : recoutp;
signal Main_outp1hscl000008v_ena : std_logic;
signal Main_outphscl000008w_data : recoutp;
signal Main_outphscl000008w_ena : std_logic;
signal Main_inp_rdyhscl000008x_ena : std_logic;
signal Main_inphscl000008t_data : recinp2;
signal Main_inphscl000008t_ena : std_logic;


begin
i_TopVarToLog : entity work.ext_TopVarToLog port map 
(rst => rst, clk => clk, slave_output_ena_data => stubslave_output_enahscl000009v_data, slave_output_ena_ena => stubslave_output_enahscl000009v_ena, slave_output_rdy_ena_rdy_ena => stubslave_output_rdy_ena_rdyhscl000009u_ena, slave_input_ena_rdy_ena => stubslave_input_ena_rdyhscl000009t_ena, inputs_rdy_ena => Main_outpVars_rdyhscl000008r_ena, input_rdy_ena => stubinput_rdyhscl000009s_ena, slave_output_ena_rdy_ena => stubslave_output_ena_rdyhscl000009r_ena, slave_output_rdy_ena_data => stubslave_output_rdy_enahscl000009q_data, slave_output_rdy_ena_ena => stubslave_output_rdy_enahscl000009q_ena, slave_input_ena_data => stubslave_input_enahscl000009p_data, slave_input_ena_ena => stubslave_input_enahscl000009p_ena, inputs_data => Main_outpVarshscl000008u_data, inputs_ena => Main_outpVarshscl000008u_ena, input_data => stubinputhscl000009o_data, input_ena => stubinputhscl000009o_ena)
;i_TopToFile1 : entity work.ext_TopToFile1 port map 
 (rst => rst, clk => clk, slave_output_ena_data => stubslave_output_ena1hscl000009n_data, slave_output_ena_ena => stubslave_output_ena1hscl000009n_ena, slave_output_rdy_ena_rdy_ena => stubslave_output_rdy_ena_rdy1hscl000009m_ena, slave_input_ena_rdy_ena => stubslave_input_ena_rdy1hscl000009l_ena, inputs_rdy_ena => Main_outp1_rdyhscl000008s_ena, input_rdy_ena => stubinput_rdy1hscl000009k_ena, slave_output_ena_rdy_ena => stubslave_output_ena_rdy1hscl000009j_ena, slave_output_rdy_ena_data => stubslave_output_rdy_ena1hscl000009i_data, slave_output_rdy_ena_ena => stubslave_output_rdy_ena1hscl000009i_ena, slave_input_ena_data => stubslave_input_ena1hscl000009h_data, slave_input_ena_ena => stubslave_input_ena1hscl000009h_ena, inputs_data => Main_outp1hscl000008v_data, inputs_ena => Main_outp1hscl000008v_ena, input_data => stubinput1hscl000009g_data, input_ena => stubinput1hscl000009g_ena)
 ;i_TopToFile : entity work.ext_TopToFile port map 
  (rst => rst, clk => clk, slave_output_ena_data => stubslave_output_ena2hscl000009f_data, slave_output_ena_ena => stubslave_output_ena2hscl000009f_ena, slave_output_rdy_ena_rdy_ena => stubslave_output_rdy_ena_rdy2hscl000009e_ena, slave_input_ena_rdy_ena => stubslave_input_ena_rdy2hscl000009d_ena, inputs_rdy_ena => Main_outp_rdyhscl000008q_ena, input_rdy_ena => stubinput_rdy2hscl000009c_ena, slave_output_ena_rdy_ena => stubslave_output_ena_rdy2hscl000009b_ena, slave_output_rdy_ena_data => stubslave_output_rdy_ena2hscl000009a_data, slave_output_rdy_ena_ena => stubslave_output_rdy_ena2hscl000009a_ena, slave_input_ena_data => stubslave_input_ena2hscl0000099_data, slave_input_ena_ena => stubslave_input_ena2hscl0000099_ena, inputs_data => Main_outphscl000008w_data, inputs_ena => Main_outphscl000008w_ena, input_data => stubinput2hscl0000098_data, input_ena => stubinput2hscl0000098_ena)
  ;i_TopFromFile : entity work.ext_TopFromFile port map 
   (rst => rst, clk => clk, slave_output_ena_data => stubslave_output_ena3hscl0000097_data, slave_output_ena_ena => stubslave_output_ena3hscl0000097_ena, slave_input_rdy_ena_data => stubslave_input_rdy_enahscl0000096_data, slave_input_rdy_ena_ena => stubslave_input_rdy_enahscl0000096_ena, output_data => Main_inphscl000008t_data, output_ena => Main_inphscl000008t_ena, slave_output_rdy_ena_rdy_ena => stubslave_output_rdy_ena_rdy3hscl0000095_ena, slave_input_ena_rdy_ena => stubslave_input_ena_rdy3hscl0000094_ena, input_rdy_ena => stubinput_rdy3hscl0000093_ena, slave_output_ena_rdy_ena => stubslave_output_ena_rdy3hscl0000092_ena, slave_input_rdy_ena_rdy_ena => stubslave_input_rdy_ena_rdyhscl0000091_ena, output_rdy_ena => Main_inp_rdyhscl000008x_ena, slave_output_rdy_ena_data => stubslave_output_rdy_ena3hscl0000090_data, slave_output_rdy_ena_ena => stubslave_output_rdy_ena3hscl0000090_ena, slave_input_ena_data => stubslave_input_ena3hscl000008z_data, slave_input_ena_ena => stubslave_input_ena3hscl000008z_ena, input_data => stubinput3hscl000008y_data, input_ena => stubinput3hscl000008y_ena)
   ;i_TopMain : entity work.proc_TopMain port map 
    (rst => rst, clk => clk, inp_rdy_ena => Main_inp_rdyhscl000008x_ena, outp_data => Main_outphscl000008w_data, outp_ena => Main_outphscl000008w_ena, outp1_data => Main_outp1hscl000008v_data, outp1_ena => Main_outp1hscl000008v_ena, outpVars_data => Main_outpVarshscl000008u_data, outpVars_ena => Main_outpVarshscl000008u_ena, reset_rdy_ena => reset_rdy_ena, inp_data => Main_inphscl000008t_data, inp_ena => Main_inphscl000008t_ena, outp1_rdy_ena => Main_outp1_rdyhscl000008s_ena, outpVars_rdy_ena => Main_outpVars_rdyhscl000008r_ena, outp_rdy_ena => Main_outp_rdyhscl000008q_ena, reset_ena => reset_ena)
    ;i_TopPipeStp0Isint16 : entity work.proc_TopPipeStp0Isint16 port map 
     (rst => rst, clk => clk, reset_rdy_ena => stubreset_rdyhscl0000011_ena, outp_data => stuboutphscl0000010_data, outp_ena => stuboutphscl0000010_ena, inp_rdy_ena => stubinp_rdyhscl000000z_ena, oBufFull_ena => stuboBufFullhscl000000y_ena, reset_ena => stubresethscl000000x_ena, inp_data => stubinphscl000000w_data, inp_ena => stubinphscl000000w_ena, outp_rdy_ena => stuboutp_rdyhscl000000v_ena, oBufFull_rdy_ena => stuboBufFull_rdyhscl000000u_ena)
     ;i_TopLInserterStp0Isint16 : entity work.proc_TopLInserterStp0Isint16 port map 
      (rst => rst, clk => clk, outp_data => stuboutp3hscl000000l_data, outp_ena => stuboutp3hscl000000l_ena, inp_rdy_ena => stubinp_rdy3hscl000000k_ena, reset_rdy_ena => stubreset_rdy3hscl000000j_ena, reset_ena => stubreset3hscl000000i_ena, inp_data => stubinp3hscl000000h_data, inp_ena => stubinp3hscl000000h_ena, outp_rdy_ena => stuboutp_rdy3hscl000000g_ena)
      ;i_TopRdyCutStp0Isuint10 : entity work.proc_TopRdyCutStp0Isuint10 port map 
       (rst => rst, clk => clk, reset_rdy_ena => stubreset_rdy4hscl000000b_ena, outp_data => stuboutp4hscl000000a_data, outp_ena => stuboutp4hscl000000a_ena, inp_rdy_ena => stubinp_rdy4hscl0000009_ena, reset_ena => stubreset4hscl0000008_ena, inp_data => stubinp4hscl0000007_data, inp_ena => stubinp4hscl0000007_ena, outp_rdy_ena => stuboutp_rdy4hscl0000006_ena)
       ;process (clk, rst) is
        
        begin
          if clk'event and clk = '1' then
            
          end if;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubinputhscl000009o_ena <= '0' ;
          
          
          stubinputhscl000009o_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinputhscl000009o_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_input_enahscl000009p_ena <= '0' ;
          
          
          stubslave_input_enahscl000009p_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_input_enahscl000009p_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubslave_output_ena_rdyhscl000009r_ena <= '0' ;
          
          
          null;
          
          stubslave_output_ena_rdyhscl000009r_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_output_rdy_enahscl000009q_ena <= '0' ;
          
          
          stubslave_output_rdy_enahscl000009q_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_output_rdy_enahscl000009q_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubinput1hscl000009g_ena <= '0' ;
          
          
          stubinput1hscl000009g_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinput1hscl000009g_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_input_ena1hscl000009h_ena <= '0' ;
          
          
          stubslave_input_ena1hscl000009h_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_input_ena1hscl000009h_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubslave_output_ena_rdy1hscl000009j_ena <= '0' ;
          
          
          null;
          
          stubslave_output_ena_rdy1hscl000009j_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_output_rdy_ena1hscl000009i_ena <= '0' ;
          
          
          stubslave_output_rdy_ena1hscl000009i_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_output_rdy_ena1hscl000009i_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubinput2hscl0000098_ena <= '0' ;
          
          
          stubinput2hscl0000098_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinput2hscl0000098_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_input_ena2hscl0000099_ena <= '0' ;
          
          
          stubslave_input_ena2hscl0000099_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_input_ena2hscl0000099_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubslave_output_ena_rdy2hscl000009b_ena <= '0' ;
          
          
          null;
          
          stubslave_output_ena_rdy2hscl000009b_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_output_rdy_ena2hscl000009a_ena <= '0' ;
          
          
          stubslave_output_rdy_ena2hscl000009a_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_output_rdy_ena2hscl000009a_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubinput3hscl000008y_ena <= '0' ;
          
          
          stubinput3hscl000008y_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinput3hscl000008y_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_input_ena3hscl000008z_ena <= '0' ;
          
          
          stubslave_input_ena3hscl000008z_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_input_ena3hscl000008z_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubslave_input_rdy_ena_rdyhscl0000091_ena <= '0' ;
          
          
          null;
          
          stubslave_input_rdy_ena_rdyhscl0000091_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubslave_output_ena_rdy3hscl0000092_ena <= '0' ;
          
          
          null;
          
          stubslave_output_ena_rdy3hscl0000092_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized : std_logic_vector (0 downto 0) ;
        begin
          stubslave_output_rdy_ena3hscl0000090_ena <= '0' ;
          
          
          stubslave_output_rdy_ena3hscl0000090_data <= 
          (p0 => zero(dummyUninitialized)) ;
          
          stubslave_output_rdy_ena3hscl0000090_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized :  std_logic_vector (16-1 downto 0) ;
        begin
          stubinphscl000000w_ena <= '0' ;
          
          
          stubinphscl000000w_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinphscl000000w_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stuboBufFull_rdyhscl000000u_ena <= '0' ;
          
          
          null;
          
          stuboBufFull_rdyhscl000000u_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stuboutp_rdyhscl000000v_ena <= '0' ;
          
          
          null;
          
          stuboutp_rdyhscl000000v_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubresethscl000000x_ena <= '0' ;
          
          
          null;
          
          stubresethscl000000x_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized :  std_logic_vector (16-1 downto 0) ;
        begin
          stubinp3hscl000000h_ena <= '0' ;
          
          
          stubinp3hscl000000h_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinp3hscl000000h_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stuboutp_rdy3hscl000000g_ena <= '0' ;
          
          
          null;
          
          stuboutp_rdy3hscl000000g_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubreset3hscl000000i_ena <= '0' ;
          
          
          null;
          
          stubreset3hscl000000i_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        variable dummyUninitialized :  std_logic_vector (10-1 downto 0) ;
        begin
          stubinp4hscl0000007_ena <= '0' ;
          
          
          stubinp4hscl0000007_data <= (p0 => zero(dummyUninitialized)) ;
          
          stubinp4hscl0000007_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stuboutp_rdy4hscl0000006_ena <= '0' ;
          
          
          null;
          
          stuboutp_rdy4hscl0000006_ena <= '1' ;
          null;
          wait until false;
        end process;
        process  is
        
        begin
          stubreset4hscl0000008_ena <= '0' ;
          
          
          null;
          
          stubreset4hscl0000008_ena <= '1' ;
          null;
          wait until false;
        end process;
        
end architecture;