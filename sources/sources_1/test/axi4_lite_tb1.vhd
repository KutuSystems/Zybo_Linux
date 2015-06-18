--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2014.
--
-- file: axi4_lite_tb1.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This is a simple test bench for testing the the axi4 interface
--
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.axi_sim_pkg.all;

library ieee;
use ieee.std_logic_textio.all;
use std.textio.all;

entity testbench is
end testbench;

architecture testbench_arch of testbench is



   component axi4_lite_test
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
        uart_tx              : out std_logic_vector(7 downto 0);
        -- led output
        gpio_led             : out std_logic_vector(3 downto 0)
   );
   end component;

   constant tCK            : time   := 10000 ps;

begin
   

   UUT_test : axi4_lite_test
   port map (
      resetn               => sys_resetn,
      clk                  => sys_clk,                -- system clk (same as AXI clock

      -- write interface from system
      sys_wraddr           => sys_wraddr,             -- address for reads/writes
      sys_wrdata           => sys_wrdata,             -- data/no. bytes
      sys_wr_cmd           => sys_wr_cmd,             -- write strobe

      sys_rdaddr           => sys_rdaddr,             -- address for reads/writes
      sys_rddata           => sys_rddata,             -- input data port for read operation
      sys_rd_cmd           => sys_rd_cmd,             -- read strobe
      sys_rd_endcmd        => sys_rd_endcmd,          -- input read strobe

      --adc I/O's
      clk_4_96MHz          => clk_buf,
      sclk                 => adc_sclk,
      CS                   => adc_CS,
      DIN                  => adc_DIN,
      DOUT                 => adc_DOUT, 
      
      --UART I/O's
      clk_200MHz           => clk_200MHz,
      uart_rx              => uart_rx,
      uart_tx              => uart_tx,
      
      -- led output
      gpio_led             => gpio_led
   );
 


   process  -- process for clk
   begin
      loop
         clk  <= '1';
         wait for tCK/2;
         clk   <= '0';
         wait for tCK/2;
      end loop;
   end process;



 
end testbench_arch;

configuration top_cfg of testbench is
	for testbench_arch
	end for;
end top_cfg;

