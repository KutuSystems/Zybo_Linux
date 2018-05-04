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
      DDR_addr          : inout std_logic_vector (14 downto 0);
      DDR_ba            : inout std_logic_vector (2 downto 0);
      DDR_cas_n         : inout std_logic;
      DDR_ck_n          : inout std_logic;
      DDR_ck_p          : inout std_logic;
      DDR_cke           : inout std_logic;
      DDR_cs_n          : inout std_logic;
      DDR_dm            : inout std_logic_vector (3 downto 0);
      DDR_dq            : inout std_logic_vector (31 downto 0);
      DDR_dqs_n         : inout std_logic_vector (3 downto 0);
      DDR_dqs_p         : inout std_logic_vector (3 downto 0);
      DDR_odt           : inout std_logic;
      DDR_ras_n         : inout std_logic;
      DDR_reset_n       : inout std_logic;
      DDR_we_n          : inout std_logic;
      FIXED_IO_ddr_vrn  : inout std_logic;
      FIXED_IO_ddr_vrp  : inout std_logic;
      FIXED_IO_mio      : inout std_logic_vector (53 downto 0);
      FIXED_IO_ps_clk   : inout std_logic;
      FIXED_IO_ps_porb  : inout std_logic;
      FIXED_IO_ps_srstb : inout std_logic;

      -- hdmi port
      HDMI_CLK_N        : out std_logic;
      HDMI_CLK_P        : out std_logic;
      HDMI_D0_N         : out std_logic;
      HDMI_D0_P         : out std_logic;
      HDMI_D1_N         : out std_logic;
      HDMI_D1_P         : out std_logic;
      HDMI_D2_N         : out std_logic;
      HDMI_D2_P         : out std_logic;
      HDMI_OEN          : out std_logic_vector(0 to 0);

      -- PS I2C
      iic_0_scl_io      : inout std_logic;
      iic_0_sda_io      : inout std_logic;

      -- PL functions

      -- ZYBO user I/O's
      btns_4bits_tri_i  : in  std_logic_vector(3 downto 0);
      leds_4bits_tri_o  : out std_logic_vector(3 downto 0);
      sws_4bits_tri_i   : in  std_logic_vector(3 downto 0);

      -- clock test outputs
      clk_100MHz        : out std_logic;
      clk_148MHz        : out std_logic;
      clk_200MHz        : out std_logic;
      clk_video         : out std_logic
  );
end top_zybo;

architecture RTL of top_zybo is

  component system_bd_wrapper
  port (
    DDR_addr            : inout std_logic_vector(14 downto 0);
    DDR_ba              : inout std_logic_vector(2 downto 0);
    DDR_cas_n           : inout std_logic;
    DDR_ck_n            : inout std_logic;
    DDR_ck_p            : inout std_logic;
    DDR_cke             : inout std_logic;
    DDR_cs_n            : inout std_logic;
    DDR_dm              : inout std_logic_vector(3 downto 0);
    DDR_dq              : inout std_logic_vector(31 downto 0);
    DDR_dqs_n           : inout std_logic_vector(3 downto 0);
    DDR_dqs_p           : inout std_logic_vector(3 downto 0);
    DDR_odt             : inout std_logic;
    DDR_ras_n           : inout std_logic;
    DDR_reset_n         : inout std_logic;
    DDR_we_n            : inout std_logic;
    FIXED_IO_ddr_vrn    : inout std_logic;
    FIXED_IO_ddr_vrp    : inout std_logic;
    FIXED_IO_mio        : inout std_logic_vector(53 downto 0);
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
    HDMI_OEN            : out std_logic_vector(0 to 0);
    btns_4bits_tri_i    : in  std_logic_vector(3 downto 0);
    clk_100MHz          : out std_logic;
    clk_148MHz          : out std_logic;
    clk_200MHz          : out std_logic;
    clk_video           : out std_logic;
    iic_0_scl_io        : inout std_logic;
    iic_0_sda_io        : inout std_logic;
    sws_4bits_tri_i     : in  std_logic_vector(3 downto 0)
  );
   end component;

   constant MAX_BIT        : integer := 28;

   signal sys_resetn       : std_logic;

   signal count100         : std_logic_vector(MAX_BIT downto 0);
   signal count148         : std_logic_vector(MAX_BIT downto 0);
   signal count200         : std_logic_vector(MAX_BIT downto 0);
   signal count_video      : std_logic_vector(MAX_BIT downto 0);

   signal clk_100MHz_sig   : std_logic;
   signal clk_148MHz_sig   : std_logic;
   signal clk_200MHz_sig   : std_logic;
   signal clk_video_sig    : std_logic;
   signal clk_video_buf    : std_logic;

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
      clk_100MHz                 => clk_100MHz_sig,
      clk_148MHz                 => clk_148MHz_sig,
      clk_200MHz                 => clk_200MHz_sig,
      clk_video                  => clk_video_buf
    );

   clk_100MHz  <= clk_100MHz_sig;
   clk_148MHz  <= clk_148MHz_sig;
   clk_200MHz  <= clk_200MHz_sig;
   clk_video   <= clk_video_sig;

   leds_4bits_tri_o <= count200(MAX_BIT) & count148(MAX_BIT) & count100(MAX_BIT) & count_video(MAX_BIT);

   -- clock led generation
   process (clk_100MHz_sig)
   begin
      if rising_edge(clk_100MHz_sig) then
         if sys_resetn = '0' then
            count100   <= (others => '0');
         else
            count100   <= count100 + 1;
         end if;
      end if;
   end process;

   -- clock led generation
   process (clk_200MHz_sig)
   begin
      if rising_edge(clk_200MHz_sig) then
         if sys_resetn = '0' then
            count200   <= (others => '0');
         else
            count200   <= count200 + 1;
         end if;
      end if;
   end process;


   -- clock led generation
   process (clk_148MHz_sig)
   begin
      if rising_edge(clk_148MHz_sig) then
         if sys_resetn = '0' then
            count148   <= (others => '0');
         else
            count148   <= count148 + 1;
         end if;
      end if;
   end process;

   BUFG_inst : BUFG
   port map
   (
      O     => clk_video_sig,
      I     => clk_video_buf
   -- 1-bit input: Clock input (connect to an IBUF or BUFMR).
   );

   -- clock led generation
   process (clk_video_sig)
   begin
      if rising_edge(clk_video_sig) then
         if sys_resetn = '0' then
            count_video <= (others => '0');
         else
            count_video <= count_video + 1;
         end if;
      end if;
   end process;


end RTL;
