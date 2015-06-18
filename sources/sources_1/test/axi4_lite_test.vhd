--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2014.
--
-- file: axi4_lite_test.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module is a simple interface that tests the axi4_lite
-- controller.
--
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on

entity axi4_lite_test is
   port (
      resetn               : in std_logic;
      clk                  : in std_logic; 

      -- write interface from system
      sys_wraddr           : in std_logic_vector(12 downto 2);                      -- address for reads/writes
      sys_wrdata           : in std_logic_vector(31 downto 0);                      -- data/no. bytes
      sys_wr_cmd           : in std_logic;                                          -- write strobe

      sys_rdaddr           : in std_logic_vector(12 downto 2);                      -- address for reads/writes
      sys_rddata           : out std_logic_vector(31 downto 0);                     -- input data port for read operation
      sys_rd_cmd           : in std_logic;                                          -- read strobe
      sys_rd_endcmd        : out std_logic;                                         -- input read strobe

      --adc I/O's
      clk_4_96MHz          : in std_logic;
      sclk                 : out std_logic; 
      CS                   : out std_logic; 
      DIN                  : out std_logic;  
      DOUT                 : in std_logic;  
      
      --UART I/O's
      clk_200MHz           : in std_logic;      
      uart_rx              : in std_logic_vector(7 downto 0);
      uart_tx              : out std_logic_vector(7 downto 0)
   );
end axi4_lite_test;

architecture RTL of axi4_lite_test is

component ad7193 is
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
end component;


component uart is
   port (
      reset             : in  std_logic;                    -- global system reset
      clk               : in  std_logic;                    -- 200MHz system clock
      Baud_sel          : in  std_logic_vector(6 downto 0); -- Baud_sel

      -- external interface
      uart_tx           : out std_logic;                    -- rs232 tx output
      uart_rx           : in  std_logic;                    -- rs232 rx input

      -- external interface to system
      tx_data           : in  std_logic_vector(7 downto 0); -- output word to write
      tx_write          : in  std_logic;                    -- write data to output fifo 
      tx_full           : out std_logic;                    -- output to indicate fifo is full
      rx_data           : out std_logic_vector(7 downto 0); -- input word from serial port
      rx_write          : out std_logic;                     -- rx write data signal
      rx_read           : in std_logic;
      rx_empty          : out std_logic;
      rx_full           : out std_logic
   );
end component;

    signal   data_register        : std_logic_vector(31 downto 0);
    signal   reset                : std_logic;
    signal   sys_rd_end           : std_logic;
    
    --register address--
    
    --read uart
    constant RX_DATA0_ADDR        : std_logic_vector(7 downto 0):=X"00";
    constant RX_DATA1_ADDR        : std_logic_vector(7 downto 0):=X"10";
    constant RX_DATA2_ADDR        : std_logic_vector(7 downto 0):=X"20";
    constant RX_DATA3_ADDR        : std_logic_vector(7 downto 0):=X"30";
    constant RX_DATA4_ADDR        : std_logic_vector(7 downto 0):=X"40";
    constant RX_DATA5_ADDR        : std_logic_vector(7 downto 0):=X"50";
    constant RX_DATA6_ADDR        : std_logic_vector(7 downto 0):=X"60";
    constant RX_DATA7_ADDR        : std_logic_vector(7 downto 0):=X"70";
   
    --write uart--
    constant TX_DATA0_ADDR        : std_logic_vector(7 downto 0):=X"04";
    constant TX_DATA1_ADDR        : std_logic_vector(7 downto 0):=X"14";
    constant TX_DATA2_ADDR        : std_logic_vector(7 downto 0):=X"24";
    constant TX_DATA3_ADDR        : std_logic_vector(7 downto 0):=X"34";
    constant TX_DATA4_ADDR        : std_logic_vector(7 downto 0):=X"44";
    constant TX_DATA5_ADDR        : std_logic_vector(7 downto 0):=X"54";
    constant TX_DATA6_ADDR        : std_logic_vector(7 downto 0):=X"64";
    constant TX_DATA7_ADDR        : std_logic_vector(7 downto 0):=X"74";
    
    --write Baudrate  
    constant BAUD0_ADDR           : std_logic_vector(7 downto 0):= X"08";  
    constant BAUD1_ADDR           : std_logic_vector(7 downto 0):= X"18";
    constant BAUD2_ADDR           : std_logic_vector(7 downto 0):= X"28";
    constant BAUD3_ADDR           : std_logic_vector(7 downto 0):= X"38";
    constant BAUD4_ADDR           : std_logic_vector(7 downto 0):= X"48";
    constant BAUD5_ADDR           : std_logic_vector(7 downto 0):= X"58";
    constant BAUD6_ADDR           : std_logic_vector(7 downto 0):= X"68";
    constant BAUD7_ADDR           : std_logic_vector(7 downto 0):= X"78";
    
    --read status 
    constant STATUS0_ADDR         : std_logic_vector(7 downto 0):= X"0C";  
    constant STATUS1_ADDR         : std_logic_vector(7 downto 0):= X"1C";
    constant STATUS2_ADDR         : std_logic_vector(7 downto 0):= X"2C";
    constant STATUS3_ADDR         : std_logic_vector(7 downto 0):= X"3C";
    constant STATUS4_ADDR         : std_logic_vector(7 downto 0):= X"4C";
    constant STATUS5_ADDR         : std_logic_vector(7 downto 0):= X"5C";
    constant STATUS6_ADDR         : std_logic_vector(7 downto 0):= X"6C";
    constant STATUS7_ADDR         : std_logic_vector(7 downto 0):= X"7C";
    
    --read adc channels
    constant CHAN0_ADDR           : std_logic_vector(7 downto 0):= X"80";
    constant CHAN1_ADDR           : std_logic_vector(7 downto 0):= X"84";
    constant CHAN2_ADDR           : std_logic_vector(7 downto 0):= X"88";
    constant CHAN3_ADDR           : std_logic_vector(7 downto 0):= X"8C";
    constant CHAN4_ADDR           : std_logic_vector(7 downto 0):= X"90";
    constant CHAN5_ADDR           : std_logic_vector(7 downto 0):= X"94";
    constant CHAN6_ADDR           : std_logic_vector(7 downto 0):= X"98";
    constant CHAN7_ADDR           : std_logic_vector(7 downto 0):= X"9C";
    
  
    constant ADC_CONFIG_ADDR      : std_logic_vector(7 downto 0):=X"C0";
    --read address

    signal rd_flag              : std_logic; 
    signal wr_flag              : std_logic;
    signal sys_wr_cmd_delay     : std_logic;
    signal sys_rd_cmd_delay     : std_logic;  
           
    --UART signals
    signal baud_rate0             : std_logic_vector(6 downto 0);    
    signal baud_rate1             : std_logic_vector(6 downto 0);
    signal baud_rate2             : std_logic_vector(6 downto 0);
    signal baud_rate3             : std_logic_vector(6 downto 0);
    signal baud_rate4             : std_logic_vector(6 downto 0);
    signal baud_rate5             : std_logic_vector(6 downto 0);
    signal baud_rate6             : std_logic_vector(6 downto 0);
    signal baud_rate7             : std_logic_vector(6 downto 0);
    
    signal tx_data0               : std_logic_vector(7 downto 0);
    signal tx_data1               : std_logic_vector(7 downto 0);
    signal tx_data2               : std_logic_vector(7 downto 0);
    signal tx_data3               : std_logic_vector(7 downto 0);
    signal tx_data4               : std_logic_vector(7 downto 0);
    signal tx_data5               : std_logic_vector(7 downto 0);
    signal tx_data6               : std_logic_vector(7 downto 0);
    signal tx_data7               : std_logic_vector(7 downto 0);
    
    signal rx_data0               : std_logic_vector(7 downto 0);
    signal rx_data1               : std_logic_vector(7 downto 0);
    signal rx_data2               : std_logic_vector(7 downto 0);
    signal rx_data3               : std_logic_vector(7 downto 0);
    signal rx_data4               : std_logic_vector(7 downto 0);
    signal rx_data5               : std_logic_vector(7 downto 0);
    signal rx_data6               : std_logic_vector(7 downto 0);
    signal rx_data7               : std_logic_vector(7 downto 0);    
    
    signal tx_en0                 : std_logic; 
    signal tx_en1                 : std_logic; 
    signal tx_en2                 : std_logic; 
    signal tx_en3                 : std_logic; 
    signal tx_en4                 : std_logic; 
    signal tx_en5                 : std_logic; 
    signal tx_en6                 : std_logic; 
    signal tx_en7                 : std_logic;
      
  --rx_read strobe 
     signal rx_read0           : std_logic;
     signal rx_read1           : std_logic;
     signal rx_read2           : std_logic; 
     signal rx_read3           : std_logic; 
     signal rx_read4           : std_logic; 
     signal rx_read5           : std_logic; 
     signal rx_read6           : std_logic; 
     signal rx_read7           : std_logic;  
    --status (wr_en,tx_full)
    signal status0                 : std_logic_vector(3 downto 0);
    signal status1                 : std_logic_vector(3 downto 0); 
    signal status2                 : std_logic_vector(3 downto 0); 
    signal status3                 : std_logic_vector(3 downto 0); 
    signal status4                 : std_logic_vector(3 downto 0); 
    signal status5                 : std_logic_vector(3 downto 0); 
    signal status6                 : std_logic_vector(3 downto 0); 
    signal status7                 : std_logic_vector(3 downto 0); 
        
    --ADC signals
    signal Data_CH0               : std_logic_vector(23 downto 0);
    signal Data_CH1               : std_logic_vector(23 downto 0);
    signal Data_CH2               : std_logic_vector(23 downto 0);
    signal Data_CH3               : std_logic_vector(23 downto 0);
    signal Data_CH4               : std_logic_vector(23 downto 0);
    signal Data_CH5               : std_logic_vector(23 downto 0);
    signal Data_CH6               : std_logic_vector(23 downto 0);
    signal Data_CH7               : std_logic_vector(23 downto 0);
    signal adc_config             : std_logic_vector(23 downto 0):=X"14FF58";

   
begin

ad7193_inst : ad7193
port map(  
    clk_4_96MHz     => clk_4_96MHz,
    sclk            => sclk,
    CS              => CS,
    DIN             => DIN,
    DOUT            => DOUT,
    CONFIG          => adc_config, 
    Data_CH0        => Data_CH0,
    Data_CH1        => Data_CH1,
    Data_CH2        => Data_CH2,
    Data_CH3        => Data_CH3,
    Data_CH4        => Data_CH4,
    Data_CH5        => Data_CH5,
    Data_CH6        => Data_CH6,
    Data_CH7        => Data_CH7
); 

uart_channel0 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate0,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(0),                     -- rs232 tx output
    uart_rx         => uart_rx(0),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data0,                     -- output word to write
    tx_write        => tx_en0,                     -- write data to output fifo 
    tx_full         => status0(0),                     -- output to indicate fifo is full
    rx_data         => rx_data0,                     -- input word from serial port
    rx_write        => status0(1),                     -- rx write data signal
    rx_read         => rx_read0,
    rx_empty        => status0(2),
    rx_full         => status0(3)
);    

uart_channel1 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate1,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(1),                     -- rs232 tx output
    uart_rx         => uart_rx(1),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data1,                     -- output word to write
    tx_write        => tx_en1,                     -- write data to output fifo 
    tx_full         => status1(0),                     -- output to indicate fifo is full
    rx_data         => rx_data1,                     -- input word from serial port
    rx_write        => status1(1),                     -- rx write data signal
    rx_read         => rx_read1,
    rx_empty        => status1(2),
    rx_full         => status1(3)
);    

uart_channel2 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate2,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(2),                     -- rs232 tx output
    uart_rx         => uart_rx(2),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data2,                     -- output word to write
    tx_write        => tx_en2,                     -- write data to output fifo 
    tx_full         => status2(0),                     -- output to indicate fifo is full
    rx_data         => rx_data2,                     -- input word from serial port
    rx_write        => status2(1),                     -- rx write data signal
    rx_read         => rx_read2,
    rx_empty        => status2(2),
    rx_full         => status2(3)
);    

uart_channel3 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate3,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(3),                     -- rs232 tx output
    uart_rx         => uart_rx(3),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data3,                     -- output word to write
    tx_write        => tx_en3,                     -- write data to output fifo 
    tx_full         => status3(0),                     -- output to indicate fifo is full
    rx_data         => rx_data3,                     -- input word from serial port
    rx_write        => status3(1),                     -- rx write data signal
    rx_read         => rx_read3,
    rx_empty        => status3(2),
    rx_full         => status3(3)
);    

uart_channel4 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate4,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(4),                     -- rs232 tx output
    uart_rx         => uart_rx(4),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data4,                     -- output word to write
    tx_write        => tx_en4,                     -- write data to output fifo 
    tx_full         => status4(0),                     -- output to indicate fifo is full
    rx_data         => rx_data4,                     -- input word from serial port
    rx_write        => status4(1),                     -- rx write data signal
    rx_read         => rx_read4,
    rx_empty        => status4(2),
    rx_full         => status4(3)
);    

uart_channel5 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate5,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(5),                     -- rs232 tx output
    uart_rx         => uart_rx(5),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data5,                     -- output word to write
    tx_write        => tx_en5,                     -- write data to output fifo 
    tx_full         => status5(0),                     -- output to indicate fifo is full
    rx_data         => rx_data5,                     -- input word from serial port
    rx_write        => status5(1),                     -- rx write data signal
    rx_read         => rx_read5,
    rx_empty        => status5(2),
    rx_full         => status5(3)
);    

uart_channel6 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate6,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(6),                     -- rs232 tx output
    uart_rx         => uart_rx(6),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data6,                     -- output word to write
    tx_write        => tx_en6,                     -- write data to output fifo 
    tx_full         => status6(0),                     -- output to indicate fifo is full
    rx_data         => rx_data6,                     -- input word from serial port
    rx_write        => status6(1),                     -- rx write data signal
    rx_read         => rx_read6,
    rx_empty        => status6(2),
    rx_full         => status6(3)
);   

uart_channel7 : uart
port map(  
    reset           => reset,                     -- global system reset
    clk             => clk_200MHz,                     -- 200MHz system clock
    Baud_sel        => baud_rate7,                     -- 0 = 115k, 1 = 921k
    
    -- external interface
    uart_tx         => uart_tx(7),                     -- rs232 tx output
    uart_rx         => uart_rx(7),                     -- rs232 rx input
    
    -- external interface to system
    tx_data         => tx_data7,                     -- output word to write
    tx_write        => tx_en7,                     -- write data to output fifo 
    tx_full         => status7(0),                     -- output to indicate fifo is full
    rx_data         => rx_data7,                     -- input word from serial port
    rx_write        => status7(1),                     -- rx write data signal
    rx_read         => rx_read7,
    rx_empty        => status7(2),
    rx_full         => status7(3)
);  

   sys_rd_endcmd  <= sys_rd_end and sys_rd_cmd;
   reset          <= not resetn;
--Uart read pulse
process(clk_200MHz)
begin
    if falling_edge(clk_200MHz) then
        if(sys_rd_cmd_delay = '0')then
            rd_flag <= '0';
            rx_read0 <= '0';
            rx_read1 <= '0';
            rx_read2 <= '0';
            rx_read3 <= '0';
            rx_read4 <= '0';
            rx_read5 <= '0';
            rx_read6 <= '0';
            rx_read7 <= '0';
            
        elsif(rd_flag ='0' and sys_rd_cmd ='0')then
            rd_flag <= '1';
            
            case sys_rdaddr(7 downto 2) is
            --read pulse
                when RX_DATA0_ADDR(7 downto 2) =>
                    rx_read0 <= '1';
                
                when RX_DATA1_ADDR(7 downto 2)  =>
                    rx_read1 <= '1';
               
                when RX_DATA2_ADDR(7 downto 2)  =>
                    rx_read2 <= '1';
                        
                when RX_DATA3_ADDR(7 downto 2)  =>
                    rx_read3 <= '1';
                    
                when RX_DATA4_ADDR(7 downto 2)  =>
                    rx_read4 <= '1';
                    
                when RX_DATA5_ADDR(7 downto 2)  =>
                    rx_read5 <= '1';
                    
                when RX_DATA6_ADDR(7 downto 2)  =>
                    rx_read6 <= '1';
                    
                when RX_DATA7_ADDR(7 downto 2)  =>
                    rx_read7 <= '1';
                    
                when others =>
                    rx_read0 <= '0';
                    rx_read1 <= '0';
                    rx_read2 <= '0';
                    rx_read3 <= '0';
                    rx_read4 <= '0';
                    rx_read5 <= '0';
                    rx_read6 <= '0';
                    rx_read7 <= '0';                  
                    rd_flag <= '0';
                    
              end case;
            
        else
            rx_read0 <= '0';
            rx_read1 <= '0';
            rx_read2 <= '0';
            rx_read3 <= '0';
            rx_read4 <= '0';
            rx_read5 <= '0';
            rx_read6 <= '0';
            rx_read7 <= '0';
        end if;
    end if;
end process;


--Uart write pulse
process(clk_200MHz)
begin
    if falling_edge(clk_200MHz) then
        if(sys_wr_cmd_delay = '0')then
            wr_flag <= '0';
            tx_en0 <= '0';
            tx_en1 <= '0';
            tx_en2 <= '0';
            tx_en3 <= '0';
            tx_en4 <= '0';
            tx_en5 <= '0';
            tx_en6 <= '0';
            tx_en7 <= '0';
            
        elsif(wr_flag ='0' and sys_wr_cmd = '0')then
            wr_flag <= '1';
            
            case sys_wraddr(7 downto 2) is

                when TX_DATA0_ADDR(7 downto 2)  =>
                    tx_en0 <= '1';
                
                when TX_DATA1_ADDR(7 downto 2) =>
                    tx_en1 <= '1';
               
                when TX_DATA2_ADDR(7 downto 2) =>
                    tx_en2 <= '1';
                        
                when TX_DATA3_ADDR(7 downto 2) =>
                    tx_en3 <= '1';
                    
                when TX_DATA4_ADDR(7 downto 2) =>
                    tx_en4 <= '1';
                    
                when TX_DATA5_ADDR(7 downto 2) =>
                    tx_en5 <= '1';
                    
                when TX_DATA6_ADDR(7 downto 2) =>
                    tx_en6 <= '1';
                    
                when TX_DATA7_ADDR(7 downto 2) =>
                    tx_en7 <= '1'; 
                                       
                when others =>
                    tx_en0 <= '0';
                    tx_en1 <= '0';
                    tx_en2 <= '0';
                    tx_en3 <= '0';
                    tx_en4 <= '0';
                    tx_en5 <= '0';
                    tx_en6 <= '0';
                    tx_en7 <= '0';                    
                    wr_flag <= '0';
                    
              end case;
            
        else
            tx_en0 <= '0';
            tx_en1 <= '0';
            tx_en2 <= '0';
            tx_en3 <= '0';
            tx_en4 <= '0';
            tx_en5 <= '0';
            tx_en6 <= '0';
            tx_en7 <= '0';  
            
        end if;
    end if;
end process;

   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            sys_rddata     <= X"00000000";
            sys_rd_end     <= '0';
            baud_rate0      <= "0000000";
            baud_rate1      <= "0000000";
            baud_rate2      <= "0000000";
            baud_rate3      <= "0000000";
            baud_rate4      <= "0000000";
            baud_rate5      <= "0000000";
            baud_rate6      <= "0000000";
            baud_rate7      <= "0000000";
            
         else
            sys_wr_cmd_delay <= sys_wr_cmd;
            sys_rd_cmd_delay <= sys_rd_cmd;
                                --UART read from address--                     
                                         
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA0_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data0;
            end if;
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA1_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data1;
            end if;     
 
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA2_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data2;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA3_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data3;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA4_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data4;
            end if;

            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA5_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data5;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA6_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data6;
            end if;   
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = RX_DATA7_ADDR(7 downto 2)) then
               sys_rddata <= X"000000" & rx_data7;
            end if;    
                        
                                --BAUD Write to address--           
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD0_ADDR(7 downto 2)) then
               baud_rate0 <= sys_wrdata(6 downto 0);
            end if;
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD1_ADDR(7 downto 2)) then
               baud_rate1 <= sys_wrdata(6 downto 0);
            end if;     
 
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD2_ADDR(7 downto 2)) then
               baud_rate2 <= sys_wrdata(6 downto 0);
            end if;    
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD3_ADDR(7 downto 2)) then
               baud_rate3 <= sys_wrdata(6 downto 0);
            end if;    
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD4_ADDR(7 downto 2)) then
               baud_rate4 <= sys_wrdata(6 downto 0);
            end if;

            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD5_ADDR(7 downto 2)) then
               baud_rate5 <= sys_wrdata(6 downto 0);
            end if;    
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD6_ADDR(7 downto 2)) then
               baud_rate6 <= sys_wrdata(6 downto 0);
            end if;   
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = BAUD7_ADDR(7 downto 2)) then
               baud_rate7 <= sys_wrdata(6 downto 0);
            end if;                                           

                               --UART Write to address--                                                                                
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA0_ADDR(7 downto 2)) then            
               tx_data0 <= sys_wrdata(7 downto 0);
               
            end if;  

            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA1_ADDR(7 downto 2)) then
               tx_data1 <= sys_wrdata(7 downto 0);
            end if;  
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA2_ADDR(7 downto 2)) then
               tx_data2 <= sys_wrdata(7 downto 0);
            end if;  
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA3_ADDR(7 downto 2)) then
               tx_data3 <= sys_wrdata(7 downto 0);
            end if;              

            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA4_ADDR(7 downto 2)) then       
               tx_data4 <= sys_wrdata(7 downto 0);
            end if;  
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA5_ADDR(7 downto 2)) then             
               tx_data5 <= sys_wrdata(7 downto 0);
            end if;  
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA6_ADDR(7 downto 2)) then        
               tx_data6 <= sys_wrdata(7 downto 0);
            end if;  
            
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = TX_DATA7_ADDR(7 downto 2)) then
                tx_data7 <= sys_wrdata(7 downto 0);
            end if;  
 
                            --UART read status from address--                   
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS0_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status0;
            end if;
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS1_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status1;
            end if;     
        
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS2_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status2;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS3_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status3;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS4_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status4;
            end if;
        
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS5_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status5;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS6_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status6;
            end if;   
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = STATUS7_ADDR(7 downto 2)) then
               sys_rddata <= X"0000000" & status7;
            end if;                
                               
                                --ADC read channels from address
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN0_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH0;
            end if;
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN1_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH1;
            end if;     
        
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN2_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH2;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN3_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH3;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN4_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH4;
            end if;
        
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN5_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH5;
            end if;    
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN6_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH6;
            end if;   
            
            if sys_rd_cmd = '1' and (sys_rdaddr(7 downto 2) = CHAN7_ADDR(7 downto 2)) then
               sys_rddata <= X"00" & Data_CH7;
            end if;                                                                    
                               
                                --ADC Config Write to address
                                
            if sys_wr_cmd = '1' and (sys_wraddr(7 downto 2) = ADC_CONFIG_ADDR(7 downto 2)) then
               adc_config <= sys_wrdata(23 downto 0);
            end if;  

            -- This will be more complex in most cases
            if sys_rd_cmd = '1' then
               sys_rd_end <= '1';
            elsif sys_rd_cmd = '0' then 
               sys_rd_end <= '0';
            end if;

         end if;
      end if;
   end process;

 end RTL;



