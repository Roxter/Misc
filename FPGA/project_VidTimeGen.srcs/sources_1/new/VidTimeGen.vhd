library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity VidTimeGen is 
    port (
        clk: in std_logic;
        width_f_porch: in unsigned (4 downto 0);
        width_sync: in unsigned (6 downto 0);
        width_b_porch: in unsigned (5 downto 0);
        height_f_porch: in unsigned (3 downto 0);
        height_sync: in unsigned (1 downto 0);
        height_b_porch: in unsigned (4 downto 0);
        hscr: in unsigned (9 downto 0);
        vscr: unsigned (9 downto 0);
        hblank, hsync, vblank, vsync, active_video: out std_logic;
        video_data: out unsigned (9 downto 0);
        valid: in std_logic;
        rst: in std_logic
        );
end VidTimeGen;

architecture Behavioral of VidTimeGen is
    
signal Rst_w: std_logic:='0';
signal Rst_h: std_logic:='0';
signal Cntr_h: unsigned (9 downto 0):=conv_unsigned(0,10);
signal Cntr_w: unsigned (9 downto 0):= conv_unsigned(0,10);
signal Reduced_width_f_porch: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Reduced_width_sync: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Reduced_width_b_porch: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Reduced_height_f_porch: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Reduced_height_sync: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Reduced_height_b_porch: unsigned(9 downto 0):=conv_unsigned(0,10);
signal Video_data_in: unsigned (9 downto 0):=conv_unsigned(0,10);
signal Vblank1: std_logic:='0'; -- Параллельно устанавливащийся с vblank внутренний сигнал, нужен в if-ах для генерации специальных видеоданных во время vblank=1 (т.к. синтаксис не позволит сравнивать с выходным сигналом)

begin

    process (valid) is
    begin
        Reduced_width_f_porch<=unsigned(ext(std_logic_vector(width_f_porch),10))-conv_unsigned(1,10);  -- хз зачем
        Reduced_width_sync<=unsigned(ext(std_logic_vector(width_sync),10));
        Reduced_width_b_porch<=unsigned(ext(std_logic_vector(width_b_porch),10));
        Reduced_height_f_porch<=unsigned(ext(std_logic_vector(height_f_porch),10))-conv_unsigned(1,10);  -- хз зачем
        Reduced_height_sync<=unsigned(ext(std_logic_vector(height_sync),10));
        Reduced_height_b_porch<=unsigned(ext(std_logic_vector(height_b_porch),10));
    end process;


    process (clk) is 
    begin
    
            if clk'event and clk='1' then
                if rst='1' then
                    hblank <= '1'; hsync <= '0';
                    vblank <= '1'; vsync <= '0'; Vblank1 <= '1';
                    active_video <= '0';
                    else
                    if Rst_h='1' then       
                        hblank <= '1';
                        active_video <= '0';
                        Video_data_in<=conv_unsigned(0,10); video_data<=conv_unsigned(0,10);
                        Cntr_h<=conv_unsigned(0,10);
                        Rst_h<='0';
                        if (Rst_w='1') then     -- Логику изменения vblank, vsync вкладывать можно и нужно, потому что они могут меняться и меняются только по прохождению строки.
                            vblank <= '1'; Vblank1 <= '1';
                            Cntr_w<=conv_unsigned(0,10);
                            Rst_w<='0';
                        else
                            if Cntr_w < Reduced_height_f_porch then
                                vblank <= '1'; vsync <= '0'; Vblank1 <= '1';
                            elsif (Cntr_w >= Reduced_height_f_porch) and (Cntr_w < Reduced_height_f_porch+Reduced_height_sync) then
                                vblank <= '1'; vsync <= '1'; Vblank1 <= '1';
                            elsif (Cntr_w >= Reduced_height_f_porch+Reduced_height_sync) and (Cntr_w < Reduced_height_f_porch+Reduced_height_sync+Reduced_height_b_porch) then
                                vblank <= '1'; vsync <= '0'; Vblank1 <= '1';
                            elsif (Cntr_w >= Reduced_height_f_porch+Reduced_height_sync+Reduced_height_b_porch) and (Cntr_w < Reduced_height_f_porch+Reduced_height_sync+Reduced_height_b_porch+vscr-conv_unsigned(1,10)) then
                                vblank <= '0'; vsync <= '0'; Vblank1 <= '0';
                            elsif Cntr_w = Reduced_height_f_porch+Reduced_height_sync+Reduced_height_b_porch+vscr-conv_unsigned(1,10) then
                                Rst_w<='1';
                            end if;
                            Cntr_w<=Cntr_w+conv_unsigned(1,10);
                        end if;
                    else
                        if Cntr_h < Reduced_width_f_porch then
                            hblank <= '1'; hsync <= '0'; active_video <= '0';
                        elsif (Cntr_h >= Reduced_width_f_porch) and (Cntr_h < Reduced_width_f_porch+Reduced_width_sync) then
                            hblank <= '1'; hsync <= '1'; active_video <= '0';
                        elsif (Cntr_h >= Reduced_width_f_porch+Reduced_width_sync) and (Cntr_h < Reduced_width_f_porch+Reduced_width_sync+Reduced_width_b_porch) then
                            hblank <= '1'; hsync <= '0'; active_video <= '0';  
                        elsif (Cntr_h >= Reduced_width_f_porch+Reduced_width_sync+Reduced_width_b_porch) and (Cntr_h < Reduced_width_f_porch+Reduced_width_sync+Reduced_width_b_porch+hscr-conv_unsigned(1,10)) then
                            hblank <= '0'; hsync <= '0'; if (Cntr_w > Reduced_height_f_porch+Reduced_height_sync+Reduced_height_b_porch) then active_video <= '1'; end if;
                            Video_data_in<=Video_data_in+conv_unsigned(1,10); video_data<=Video_data_in; 
                        elsif (Cntr_h = Reduced_width_f_porch+Reduced_width_sync+Reduced_width_b_porch+hscr-conv_unsigned(1,10)) then
                            Video_data_in<=Video_data_in+conv_unsigned(1,10); video_data<=Video_data_in;
                            hblank <= '0';
                            Rst_h<='1';
                        end if;
                        Cntr_h<=Cntr_h+conv_unsigned(1,10);
                    end if;
                end if;
            end if;
    end process;
    
 end architecture;