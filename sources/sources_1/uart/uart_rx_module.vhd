--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2013.
--
-- file: uart_rx_module.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module receives a single channel of rs232/422 using 
-- 8-N-1 at data rates 115200 from a 200Mhz reference clock.
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

entity uart_rx_module is
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
end uart_rx_module;

architecture RTL of uart_rx_module is

   signal uart_clk_en         : std_logic:='0';
   signal uart_clk_reg        : std_logic_vector(4 downto 0):=(others=>'0');

   signal uart_rx_reg         : std_logic:='0';
   signal uart_rx_dly         : std_logic:='0';
   signal edge_detect         : std_logic:='0';

   signal state_count         : std_logic_vector(3 downto 0):=(others=>'0');
   signal shift_reg           : std_logic_vector(7 downto 0):=(others=>'0');
   signal rx_run              : std_logic:='0';

begin
 
   -- use shift register as output register directly
   rx_data     <= shift_reg;
  
   -- input clock generation
   -- divide 25MHz/7 uart base clock by 31 to get 25MHz/217 = 115207
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            uart_clk_reg   <= "00000";
            uart_clk_en    <= '0';
         else

            -- 5 bit lfsr counts 31 cycles
            -- resets whenever edge on input is detected, and rolls over at 115200 baud
            if edge_detect = '1' then
               uart_clk_reg   <= "00000";
            elsif clk_active = '1' then
               lfsrAdd5(uart_clk_reg,uart_clk_reg);
            end if;

            -- generate 115200 baud sample signal
--            if uart_clk_reg = "10111" and clk_active = '1' then
            if uart_clk_reg = "01111" and clk_active = '1' then
               uart_clk_en <= '1';
            else
               uart_clk_en <= '0';
            end if; 

         end if;
      end if;
   end process;

   -- input data and edge detection
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            uart_rx_reg    <= '1';
            uart_rx_dly    <= '1';
            edge_detect    <= '0';
         else
            uart_rx_reg    <= uart_rx;
            uart_rx_dly    <= uart_rx_reg;
            edge_detect    <= uart_rx_reg xor uart_rx_dly;
         end if;
      end if;
   end process;

   -- state counter
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            rx_run         <= '0';
            shift_reg      <= "00000000";
            rx_write       <= '0';
            state_count    <= "0000";
         else

            -- enable shift register when start bit is detected
            -- disable after 8 bits
            if state_count = "1001" and uart_clk_en = '1' then
               rx_run <= '0';
            elsif uart_clk_en = '1' and uart_rx_reg = '0' then
               rx_run <= '1';
            end if;
            
            -- shift in 8 bits of data
            if uart_clk_en = '1' and rx_run = '1' then
               shift_reg(7)            <= uart_rx_reg;
               shift_reg(6 downto 0)   <= shift_reg(7 downto 1);
            end if;

            -- send output write when stop bit occurs
            if state_count = "0011" and uart_clk_en = '1' and uart_rx_reg = '1' then
               rx_write    <= '1';
            else
               rx_write    <= '0';
            end if;
 
            -- run lfsr counter for 8 data bits
            if uart_clk_en = '1' and uart_rx_reg = '1' and rx_run = '0' then
               state_count <= "0000";
            elsif uart_clk_en = '1' and rx_run = '1' then
               lfsrAdd4(state_count,state_count);
            end if;

         end if;
      end if;
   end process;



end RTL;

