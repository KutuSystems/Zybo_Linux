--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2013.
--
-- file: uart.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module transmits and receives a single channel of
-- rs232 using 8-N-1 at data rates 115200 from a 200Mhz reference 
-- clock. 
--
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.counter_pkg.ALL;

-- synopsys translate_off
library unisim;
use unisim.vcomponents.all;
-- synopsys translate_on

entity uart is
   port (
      reset             : in  std_logic;                    -- global system reset
      clk               : in  std_logic;                    -- 200MHz system clock
      Baud_sel          : in  std_logic_vector(6 downto 0);-- Baud_sel
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
end uart;

architecture RTL of uart is
 
   signal uart_tx_pad         : std_logic:='0';
   signal uart_rx_pad         : std_logic:='0';

   signal clk_baud_en        : std_logic:='0';
   signal uart_clk_en         : std_logic:='0';
   signal div8_reg            : std_logic_vector(2 downto 0):="000";
   signal uart_clk_reg        : std_logic_vector(2 downto 0):="000";

   signal tx_avail            : std_logic:='0';
   signal tx_empty            : std_logic:='0';
   signal tx_read             : std_logic:='0';
   signal tx_output_data      : std_logic_vector(7 downto 0):=(others=>'0');
   signal rx_datain           : std_logic_vector(7 downto 0):=(others=>'0');
   signal rx_wr               : std_logic:='0';
   signal Baud_cnt            : std_logic_vector( 6 downto 0):=(others=>'0');
   
   attribute box_type : string; 

   component OBUF_LVCMOS25
      port (I: in std_logic; 
            O: out std_logic);
   end component;   
   attribute box_type of OBUF_LVCMOS25: component is "black_box"; 

   component IBUF_LVCMOS25
      port (I: in std_logic; 
            O: out std_logic);
   end component;   
   attribute box_type of IBUF_LVCMOS25 : component is "black_box"; 
   
   component uart_tx_module
   port (
      reset             : in  std_logic;                    -- global system reset
      clk               : in  std_logic;                    -- 200MHz system clock
      clk_active        : in  std_logic;                    -- system clock enable (div56)

      -- external interface
      uart_tx           : out std_logic;                    -- rs232 tx output

      -- external interface to system
      tx_output_data    : in  std_logic_vector(7 downto 0); -- output word to write
      tx_avail          : in  std_logic;                    -- input to indicate word is available for output 
      tx_read           : out std_logic                     -- output to clear data or read fifo
  );
   end component;

   component uart_rx_module
   port (
      reset             : in  std_logic;                    -- global system reset
      clk               : in  std_logic;                    -- 200MHz system clock
      clk_active        : in  std_logic;                    -- system clock enable (div56)

      -- external interface
      uart_rx           : in  std_logic;                    -- rs422 rx input

      -- external interface to system
      rx_data           : out std_logic_vector(7 downto 0); -- input word from serial port
      rx_write          : out std_logic                     -- rx write data signal
   );
   end component;

   component sync_srl_fifo
   generic(width        : integer := 8);
   Port (
      reset             : in std_logic;
      clk               : in std_logic;

      -- input interface
      write_en          : in std_logic;
      full              : out std_logic;
      datain            : in std_logic_vector(width-1 downto 0);

      -- output interface
      read_en           : in std_logic;
      empty             : out std_logic;
      dataout           : out std_logic_vector(width-1 downto 0)
   );
   end component;

begin

   OBUF_UART_OUT1:   OBUF_LVCMOS25 port map (I => uart_tx_pad, O => uart_tx);
   IBUF_UART_IN1:    IBUF_LVCMOS25 port map (I => uart_rx, O => uart_rx_pad);
 
   tx_avail <= not tx_empty;

   uart_tx1: uart_tx_module
   port map (
      reset             => reset,
      clk               => clk,
      clk_active        => uart_clk_en,

      -- external interface
      uart_tx           => uart_tx_pad,                     -- rs232 tx output

      -- external interface to system
      tx_output_data    => tx_output_data,                  -- output word to write
      tx_avail          => tx_avail,                        -- input to indicate word is available for output 
      tx_read           => tx_read                          -- output to clear data or read fifo
   );

   tx_fifo1: sync_srl_fifo
   generic map (width => 8)
   port map (
      reset             => reset,
      clk               => clk,

      -- input interface from module
      write_en          => tx_write,
      full              => tx_full,
      datain            => tx_data,

      -- output interface to uart_tx
      read_en           => tx_read,
      empty             => tx_empty,
      dataout           => tx_output_data
   );

   rx_fifo1: sync_srl_fifo
   generic map (width => 8)
   port map (
      reset             => reset,
      clk               => clk,

      -- input interface from module
      write_en          => rx_wr,
      full              => rx_full,
      datain            => rx_datain,

      -- output interface to uart_tx
      read_en           => rx_read,
      empty             => rx_empty,
      dataout           => rx_data
   );

   uart_rx1: uart_rx_module
   port map (
      reset             => reset,
      clk               => clk,
      clk_active        => uart_clk_en,                     -- enable every 56 sys clk cycles

      -- external interface
      uart_rx           => uart_rx_pad,                     -- rs422 rx input

      -- external interface to system
      rx_data           => rx_datain,                         -- input word from serial port
      rx_write          => rx_wr                         -- rx write data signal
   );


    rx_write <= rx_wr; 
    
   -- load Baud rate register
   process (clk)
   begin
      if rising_edge(clk) then
         if(reset = '1')then
            Baud_cnt    <= (others=>'0');
            clk_baud_en <= '0';
            
         else
            if(Baud_sel = 0)then
                 Baud_cnt <= (others=>'0');
                 clk_baud_en <= '0';
                 
            elsif(Baud_sel = 1)then
                 Baud_cnt <= (others=>'0');
                 clk_baud_en <= '1';
                 
            elsif(Baud_cnt < (Baud_sel-1))then
                Baud_cnt <= Baud_cnt + 1;
                clk_baud_en <= '0';
                
            else
                Baud_cnt <= (others=>'0');
                clk_baud_en <= '1';
                
            end if;

         end if;
      end if;
   end process;
   
   -- divide 25MHz clock to get 25MHz/7 uart base clock
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            uart_clk_reg   <= "000";
            uart_clk_en    <= '0';
         else
            if clk_baud_en = '1' then
               lfsrAdd3(uart_clk_reg,uart_clk_reg);
            end if;

            if uart_clk_reg = "010" and clk_baud_en = '1' then
               uart_clk_en <= '1';
            else
               uart_clk_en <= '0';
            end if; 

         end if;
      end if;
   end process;

end RTL;



