--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2014.
--
-- file: top_zybo.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This module is the top level module of zc706_base
-- running on a Xilinx ZC706 board.
--
--------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_ARITH.ALL;
use IEEE.std_logic_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity top_zybo is
   port (
      DDR_addr          : inout std_logic_vector ( 14 downto 0 );
      DDR_ba            : inout std_logic_vector ( 2 downto 0 );
      DDR_cas_n         : inout std_logic;
      DDR_ck_n          : inout std_logic;
      DDR_ck_p          : inout std_logic;
      DDR_cke           : inout std_logic;
      DDR_cs_n          : inout std_logic;
      DDR_dm            : inout std_logic_vector ( 3 downto 0 );
      DDR_dq            : inout std_logic_vector ( 31 downto 0 );
      DDR_dqs_n         : inout std_logic_vector ( 3 downto 0 );
      DDR_dqs_p         : inout std_logic_vector ( 3 downto 0 );
      DDR_odt           : inout std_logic;
      DDR_ras_n         : inout std_logic;
      DDR_reset_n       : inout std_logic;
      DDR_we_n          : inout std_logic;
      FIXED_IO_ddr_vrn  : inout std_logic;
      FIXED_IO_ddr_vrp  : inout std_logic;
      FIXED_IO_mio      : inout std_logic_vector ( 53 downto 0 );
      FIXED_IO_ps_clk   : inout std_logic;
      FIXED_IO_ps_porb  : inout std_logic;
      FIXED_IO_ps_srstb : inout std_logic;

      -- zybo I2S audio
      AC_BCLK           : out std_logic_vector( 0 to 0 );
      AC_MCLK           : out std_logic;
      AC_MUTE_N         : out std_logic_vector( 0 to 0 );
      AC_PBLRC          : out std_logic_vector( 0 to 0 );
      AC_RECLRC         : out std_logic_vector( 0 to 0 );
      AC_SDATA_I        : in std_logic;
      AC_SDATA_O        : out std_logic_vector( 0 to 0 );

      -- hdmi port
      HDMI_CLK_N        : out std_logic;
      HDMI_CLK_P        : out std_logic;
      HDMI_D0_N         : out std_logic;
      HDMI_D0_P         : out std_logic;
      HDMI_D1_N         : out std_logic;
      HDMI_D1_P         : out std_logic;
      HDMI_D2_N         : out std_logic;
      HDMI_D2_P         : out std_logic;
      HDMI_OEN          : out std_logic_vector( 0 to 0 );

      -- PS I2C
      iic_0_scl_io        : inout std_logic;
      iic_0_sda_io        : inout std_logic;


      -- PL functions

      -- ZYBO user I/O's
      btns_4bits_tri_i    : in std_logic_vector( 3 downto 0 );
      leds_4bits_tri_o   : out std_logic_vector( 3 downto 0 );
      sws_4bits_tri_i     : in std_logic_vector( 3 downto 0 );
      
      --AD7913 I/O's
      clk_4_96MHz         : out std_logic;
      adc_sync            : out std_logic;
      adc_CS              : out STD_LOGIC;
      adc_DIN             : out STD_LOGIC;
      adc_DOUT            : in STD_LOGIC;
      adc_sclk            : out STD_LOGIC;
      --UART
      uart_tx : out std_logic_vector(7 downto 0);
      uart_rx : in std_logic_vector(7 downto 0)
      
   );
end top_zybo;

architecture RTL of top_zybo is

  component system_bd_wrapper
  port (
    DDR_addr            : inout std_logic_vector( 14 downto 0 );
    DDR_ba              : inout std_logic_vector( 2 downto 0 );
    DDR_cas_n           : inout std_logic;
    DDR_ck_n            : inout std_logic;
    DDR_ck_p            : inout std_logic;
    DDR_cke             : inout std_logic;
    DDR_cs_n            : inout std_logic;
    DDR_dm              : inout std_logic_vector( 3 downto 0 );
    DDR_dq              : inout std_logic_vector( 31 downto 0 );
    DDR_dqs_n           : inout std_logic_vector( 3 downto 0 );
    DDR_dqs_p           : inout std_logic_vector( 3 downto 0 );
    DDR_odt             : inout std_logic;
    DDR_ras_n           : inout std_logic;
    DDR_reset_n         : inout std_logic;
    DDR_we_n            : inout std_logic;
    FIXED_IO_ddr_vrn    : inout std_logic;
    FIXED_IO_ddr_vrp    : inout std_logic;
    FIXED_IO_mio        : inout std_logic_vector( 53 downto 0 );
    FIXED_IO_ps_clk     : inout std_logic;
    FIXED_IO_ps_porb    : inout std_logic;
    FIXED_IO_ps_srstb   : inout std_logic;
    FCLK_RESET0_N       : out std_logic;
    HDMI_CLK_N          : out std_logic;
    HDMI_CLK_P          : out std_logic;
    HDMI_D0_N           : out std_logic;
    HDMI_D0_P           : out std_logic;
    HDMI_D1_N           : out std_logic;
    HDMI_D1_P           : out std_logic;
    HDMI_D2_N           : out std_logic;
    HDMI_D2_P           : out std_logic;
    HDMI_OEN            : out std_logic_vector( 0 to 0 );
    btns_4bits_tri_i    : in std_logic_vector( 3 downto 0 );
    clk_200MHz          : out STD_LOGIC;
    clk_adc             : out std_logic;
    iic_0_scl_io        : inout std_logic;
    iic_0_sda_io        : inout std_logic;
    sws_4bits_tri_i     : in std_logic_vector( 3 downto 0 );
    sys_clk             : out std_logic;
    sys_rd_cmd          : out std_logic;
    sys_rd_endcmd       : in std_logic;
    sys_rdaddr          : out std_logic_vector( 12 downto 2 );
    sys_rddata          : in std_logic_vector( 31 downto 0 );
    sys_wr_cmd          : out std_logic;
    sys_wraddr          : out std_logic_vector( 12 downto 2 );
    sys_wrdata          : out std_logic_vector( 31 downto 0 )

  );
   end component;


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
      uart_tx              : out std_logic_vector(7 downto 0)
   );
   end component;

   signal sys_resetn       : std_logic;         
   signal sys_clk          : std_logic;                                          -- system clk (same as AXI clock
   signal clk_adc          : std_logic;                                          -- system clk (same as AXI clock
   signal sys_wraddr       : std_logic_vector(12 downto 2);                      -- address for reads/writes
   signal sys_wrdata       : std_logic_vector(31 downto 0);                      -- data/no. bytes
   signal sys_wr_cmd       : std_logic;                                          -- write strobe

   signal sys_rdaddr       : std_logic_vector(12 downto 2);                      -- address for reads/writes
   signal sys_rddata       : std_logic_vector(31 downto 0);                      -- input data port for read operation
   signal sys_rd_cmd       : std_logic;                                          -- read strobe
   signal sys_rd_endcmd    : std_logic;                                          -- input read strobe

   signal VGA_BLUE         : std_logic_vector(7 downto 0);
   signal VGA_GREEN        : std_logic_vector(7 downto 0);
   signal VGA_RED          : std_logic_vector(7 downto 0);

   signal gpio_led         : std_logic_vector(3 downto 0); 
   signal count_reg        : std_logic_vector(27 downto 0); 
   signal adc_alive        : std_logic;         
   signal adc_cnt          : std_logic_vector(2 downto 0);
   signal clk_buf          : std_logic;
   signal clk_200MHz       : std_logic;
     
   
begin
  
   system_bd_wrapper_1 : system_bd_wrapper
   port map (
      DDR_addr(14 downto 0)      => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0)         => DDR_ba(2 downto 0),
      DDR_cas_n                  => DDR_cas_n,
      DDR_ck_n                   => DDR_ck_n,
      DDR_ck_p                   => DDR_ck_p,
      DDR_cke                    => DDR_cke,
      DDR_cs_n                   => DDR_cs_n,
      DDR_dm(3 downto 0)         => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0)        => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0)      => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0)      => DDR_dqs_p(3 downto 0),
      DDR_odt                    => DDR_odt,
      DDR_ras_n                  => DDR_ras_n,
      DDR_reset_n                => DDR_reset_n,
      DDR_we_n                   => DDR_we_n,
      FIXED_IO_ddr_vrn           => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp           => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0)  => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk            => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb           => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb          => FIXED_IO_ps_srstb,
      FCLK_RESET0_N              => sys_resetn,

      -- hdmi port
      HDMI_CLK_N                 => HDMI_CLK_N,
      HDMI_CLK_P                 => HDMI_CLK_P,
      HDMI_D0_N                  => HDMI_D0_N,
      HDMI_D0_P                  => HDMI_D0_P,
      HDMI_D1_N                  => HDMI_D1_N,
      HDMI_D1_P                  => HDMI_D1_P,
      HDMI_D2_N                  => HDMI_D2_N,
      HDMI_D2_P                  => HDMI_D2_P,
      HDMI_OEN                   => HDMI_OEN,
     
      --i2c
      iic_0_scl_io               => iic_0_scl_io,
      iic_0_sda_io               => iic_0_sda_io,

      btns_4bits_tri_i           => btns_4bits_tri_i,
      sws_4bits_tri_i            => sws_4bits_tri_i,
      clk_200MHz                 => clk_200MHz,
      clk_adc                    => clk_adc,
      
      sys_clk                    => sys_clk,
      sys_rd_cmd                 => sys_rd_cmd,       -- read strobe
      sys_rd_endcmd              => sys_rd_endcmd,    -- input read strobe
      sys_rdaddr                 => sys_rdaddr,       -- address for reads/writes
      sys_rddata                 => sys_rddata,       -- input data port for read operation
      sys_wr_cmd                 => sys_wr_cmd,       -- write strobe
      sys_wraddr                 => sys_wraddr,       -- address for reads/writes
      sys_wrdata                 => sys_wrdata        -- data/no. bytes
   );

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
      uart_tx              => uart_tx
   );
 
      -- alive led generation   
   process (sys_resetn,clk_adc)
   begin
      if rising_edge(clk_adc) then
         if sys_resetn = '0' then
            count_reg   <= "0000000000000000000000000000"; 
            adc_alive   <= '0';
            leds_4bits_tri_o <= "1111";
         else
            count_reg <= count_reg + 1;
            adc_alive <= count_reg(27);
            leds_4bits_tri_o(3) <= adc_alive;
            
        end if;
      end if;
   end process;
   
    adc_sync <= '1';  
    --ADC 4.96MHz clock 
    clk_4_96MHz <= clk_buf; 
      
    process (sys_resetn,clk_adc)
      begin
         if rising_edge(clk_adc) then
            if(adc_cnt < 4)then
                adc_cnt <= adc_cnt +1;
            else
                clk_buf <= not clk_buf;
                adc_cnt <= (others=>'0');
            end if;
            
         end if;
      end process;
      
end RTL;
