----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2015 09:08:02
-- Design Name: 
-- Module Name: ad7193 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all; 
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ad7193 is
    port (  
  clk_4_96MHz: in std_logic;
  sclk: out std_logic; 
  CS:   out std_logic; 
  DIN: out std_logic;  
  DOUT: in std_logic;  
  CONFIG: in std_logic_vector(23 downto 0);
  Data_CH0: out std_logic_VECTOR(23 downto 0);
  Data_CH1: out std_logic_VECTOR(23 downto 0);
  Data_CH2: out std_logic_VECTOR(23 downto 0);
  Data_CH3: out std_logic_VECTOR(23 downto 0);
  Data_CH4: out std_logic_VECTOR(23 downto 0);
  Data_CH5: out std_logic_VECTOR(23 downto 0);
  Data_CH6: out std_logic_VECTOR(23 downto 0);
  Data_CH7: out std_logic_VECTOR(23 downto 0)
  ); 
end ad7193;

architecture Behavioral of ad7193 is
signal clk_on: std_logic:='0';
signal state: std_logic_vector(12 downto 0):=(others=>'0');
signal comm_mode: std_logic_vector(7 downto 0):="00001100";
signal comm_config: std_logic_vector(7 downto 0):="00010100";
signal config_reg: std_logic_vector(23 downto 0):="000101001111111101011000";
signal mode: std_logic_vector(23 downto 0):="000101000000000000000001";
signal comm_read: std_logic_vector(7 downto 0):="01011100";
signal data_buff: std_logic_vector(31 downto 0):=(others=>'0');
signal dready: std_logic;
signal sclk_buff: std_logic;
signal Data: std_logic_vector(23 downto 0):=(others=>'0');
signal channel: std_logic_vector(2 downto 0):=(others=>'0');
signal set: std_logic:='0';

begin

CS <= '0';
dready <= '1' when DOUT = '0' else '0';
--sclk managment' 
sclk_buff <= '1' when clk_on = '0' else clk_4_96MHz;
sclk <= sclk_buff;

Channel_control:process(clk_4_96MHz)
begin
    if falling_edge(clk_4_96MHz)then  
        if(state < 50)then
            Data_CH0 <= (others => '0');
            Data_CH1 <= (others => '0');
            Data_CH2 <= (others => '0');
            Data_CH3 <= (others => '0');
            Data_CH4 <= (others => '0');
            Data_CH5 <= (others => '0');
            Data_CH6 <= (others => '0');
            Data_CH7 <= (others => '0');
            
        else
        
           case channel is
   
            when "000" =>
                Data_CH0 <= Data;
     
            when "001" =>
                Data_CH1 <= Data;
                     
            when "010" =>
                Data_CH2 <= Data;
                        
            when "011" =>
                Data_CH3 <= Data;
                
            when "100" =>
                Data_CH4 <= Data;
                      
            when "101" =>
                Data_CH5 <= Data;
              
            when "110" =>
                Data_CH6 <= Data;    
            
            when "111" =>
                Data_CH7 <= Data;
                             
            when others =>
            
    
           end case;
           
        end if;
    end if;
end process;

	
state_control:process(clk_4_96MHz)
begin
    if falling_edge(clk_4_96MHz)then                   
        if(state = 4172)then -- wait for ready flag
            if(dready = '1')then
                state <= state +1;
            end if;
            
        elsif(state = 4205)then
            Data <= data_buff(31 downto 8);
	        channel <= data_buff(2 downto 0);
	        if(config_reg = CONFIG)then
                state <= "1000001001100";--4172
                
            else
                Data <= (others=>'0');
                state <= (others=>'0');--reset
                
            end if;
                     
        else
            state <= state + 1;
            
        end if;
    end if;
end process;    

sclk_enable:process(clk_4_96MHz)
begin
    if rising_edge(clk_4_96MHz) then
        if(state < 50)then
            clk_on                  <= '1';
            
        elsif(state < 4096)then --wiat for power up
            clk_on                  <= '0';
            
        elsif(state > 4095 and state < 4104)then --inital comm write 8bits
            clk_on                  <= '1';
            
        elsif(state = 4104)then
            clk_on                  <= '0';
            
        elsif(state > 4104 and state < 4129)then --mode register 24 bits
            clk_on                  <= '1';
            
        elsif(state = 4129)then
             clk_on                 <= '0';
             
        elsif(state > 4129 and state < 4138)then --comm write for configuration register 8bits
             clk_on                 <= '1';
        
        elsif(state = 4138)then
             clk_on                 <= '0';

        elsif(state > 4138 and state < 4163)then --communication register 24bits
             clk_on                 <= '1';
             
        elsif(state = 4163)then
             clk_on                 <= '0';                      
    
        elsif(state > 4163 and state <  4172)then --comm write for read --8bits
            clk_on                  <= '1';
            
        elsif(state = 4172)then
            clk_on                  <= '0';
 
        elsif(state > 4172 and state < 4205)then --32bits read data  
            clk_on                  <= '1';                

        elsif(state = 4205)then
            clk_on                  <= '0';
            
        end if;     
    
    end if;
end process;

write_control:process(sclk_buff)
begin

    if falling_edge(sclk_buff) then
        
        if(state < 50)then
            DIN    <= '1';
            config_reg <= CONFIG;
            
        elsif(state < 4096)then --wiat for power up
            DIN    <= '1';
            
        elsif(state > 4095 and state < 4104)then --inital comm write 8bits
            DIN                        <= comm_mode(7);
            comm_mode(7 downto 1)      <= comm_mode(6 downto 0);
            comm_mode(0)               <= comm_mode(7);
            
        elsif(state = 4104)then
            DIN                   <= '1';
            
        elsif(state > 4104 and state < 4129)then --mode register 24 bits
            DIN                   <= mode(23);
            mode(23 downto 1)     <= mode(22 downto 0);
            mode(0)               <= mode(23);
            
        elsif(state = 4129)then
             DIN                   <= '1';
             
        elsif(state > 4129 and state < 4138)then --comm write for configuration register 8bits
             DIN                          <= comm_config(7);
             comm_config(7 downto 1)      <= comm_config(6 downto 0);
             comm_config(0)               <= comm_config(7);
        
        elsif(state = 4138)then
             DIN                   <= '1';

        elsif(state > 4138 and state < 4163)then --communication register 24bits
             DIN                     <= config_reg(23);
             config_reg(23 downto 1) <= config_reg(22 downto 0);
             config_reg(0)           <= config_reg(23); 
             
        elsif(state = 4163)then
             DIN                   <= '1';                        

        elsif(state > 4163 and state <  4172)then --comm write for read --8bits
             DIN                   <= comm_read(7);
             comm_read(7 downto 1) <= comm_read(6 downto 0);
             comm_read(0)          <= comm_read(7);         
            
        elsif(state = 4172)then
            DIN  <= '0';         
                     
        end if; 
    end if;
end process;

read_control:process(sclk_buff)
begin
    if rising_edge(sclk_buff) then             
       if(state > 4173 and state < 4206)then --read adc
            data_buff(31 downto 0) <= data_buff(30 downto 0) & DOUT;
            
        end if; 
    end if;
    
end process;  

end Behavioral;
