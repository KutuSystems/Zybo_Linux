--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2013.
--
-- file: uart_tx_module.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module transmits a single channel of rs232/422 using 
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

entity uart_tx_module is
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
end uart_tx_module;

architecture RTL of uart_tx_module is

   signal uart_clk_en         : std_logic:='0';
   signal uart_clk_reg        : std_logic_vector(4 downto 0):=(others=>'0');

   signal state_count         : std_logic_vector(3 downto 0):=(others=>'0');
   signal last_count          : std_logic:='0';
            
   signal mux                 : std_logic_vector(3 downto 0):=(others=>'0');
   signal state_delay         : std_logic_vector(1 downto 0):=(others=>'0');

begin
 
   -- output clock generation
   -- divide 25MHz/7 uart base clock by 31 to get 25MHz/217 = 115207
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            uart_clk_reg   <= "00000";
            uart_clk_en    <= '0';
         else

            -- 5 bit lfsr counts 31 cycles
            if clk_active = '1' then
               lfsrAdd5(uart_clk_reg,uart_clk_reg);
            end if;

            -- generate 115200 baud enable signal
            if uart_clk_reg = "00010" and clk_active = '1' then
               uart_clk_en <= '1';
            else
               uart_clk_en <= '0';
            end if; 

         end if;
      end if;
   end process;

   -- state machine counter
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            state_count    <= "0000";
            last_count     <= '0';
            tx_read        <= '0';
         else
            -- 4 bit lfsr
            if uart_clk_en = '1' then
               if last_count = '1' then
                  state_count <= "0000";
               elsif tx_avail = '1' then
                  lfsrAdd4(state_count,state_count);
               end if;
            end if;

            -- loop after 9 counts
            if state_count = "1110" then
               last_count <= '1';
            else
               last_count <= '0';
            end if;

            -- finished write so clear data
            tx_read <= last_count and uart_clk_en;

         end if;
      end if;
   end process;

   -- output mux
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            mux            <= "1111";
            state_delay    <= "00";
            uart_tx        <= '1';    
         else

            case state_count(1 downto 0) is
               when "00" => mux(0) <= '1';
               when "01" => mux(0) <= tx_output_data(0);
               when "10" => mux(0) <= tx_output_data(3);
               when others => mux(0) <= tx_output_data(6);
            end case;

            case state_count(1 downto 0) is
               when "00" => mux(1) <= '1';
               when "01" => mux(1) <= tx_output_data(2);
               when "10" => mux(1) <= '1';
               when others => mux(1) <= '1';
            end case;

            case state_count(1 downto 0) is
               when "00" => mux(2) <= '0';
               when "01" => mux(2) <= tx_output_data(5);
               when "10" => mux(2) <= tx_output_data(1);
               when others => mux(2) <= '1';
            end case;

            case state_count(1 downto 0) is
               when "00" => mux(3) <= tx_output_data(4);
               when "01" => mux(3) <= '1';
               when "10" => mux(3) <= tx_output_data(7);
               when others => mux(3) <= '1';
            end case;

            state_delay <= state_count(3 downto 2);
            if uart_clk_en = '1' then
               case state_count(3 downto 2) is
                  when "00" => uart_tx <= mux(0);
                  when "01" => uart_tx <= mux(1);
                  when "10" => uart_tx <= mux(2);
                  when others => uart_tx <= mux(3);
               end case;
            end if;
         end if;
      end if;
   end process;

end RTL;

