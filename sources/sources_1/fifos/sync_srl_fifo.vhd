--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2013.
-- (C) Copyright Hawk Measurement Pty. Ltd. 2013.
--
-- file: sync_srl_fifo.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This is an 16 element synchronous fifo for a single clock 
-- domain. It provides an external fifo empty and full signal.
-- It uses SRL16E shift registers.
--
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library unisim;
use unisim.vcomponents.all;

entity sync_srl_fifo is
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
end sync_srl_fifo;


architecture RTL of sync_srl_fifo is

   signal inc              : std_logic:='0';
   signal dec              : std_logic:='0';
   signal out_latch_loaded : std_logic:='0';
   signal fifo_full        : std_logic:='0';
   signal fifo_empty       : std_logic:='0';
   signal srl_count        : std_logic_vector(3 downto 0):=(others=>'0');
   signal add_value        : std_logic_vector(3 downto 0):=(others=>'0');
   signal dataout_reg      : std_logic_vector(width-1 downto 0):=(others=>'0');

begin

   -- output signals
   full     <= fifo_full;
   empty    <= not out_latch_loaded;

   --  synchronous fifo using SRL16E's 

   -- 16-bit shift register LUT used as fifo memory
   SRL_FIFO_1: for I in 0 to width-1 generate
      SRL16E_inst : SRL16E generic map (INIT => X"0000")
      port map (
         D     => datain(I),     -- fifo data input
         A0    => srl_count(0),  -- Select[0] input
         A1    => srl_count(1),  -- Select[1] input
         A2    => srl_count(2),  -- Select[2] input
         A3    => srl_count(3),  -- Select[3] input
         CE    => write_en,      -- Clock enable input
         CLK   => clk,           -- Clock input
         Q     => dataout_reg(I) -- fifo data output
      );
   end generate;

   -- combinational inputs to adder
   inc <= write_en and not ((read_en or not out_latch_loaded) and not fifo_empty);
   dec <= ((read_en or not out_latch_loaded) and not fifo_empty) and not write_en;

   -- create either +1, -1 or 0 for adder
   add_value <= dec & dec & dec & (dec xor inc);

   -- address counter for srl16 fifo
   process (clk)
   begin
      if rising_edge (clk) then
         if reset = '1' then
            srl_count  <= "1111";
         else
            srl_count  <= srl_count + add_value;
         end if;
      end if;
   end process;

   -- full signal
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            fifo_full  <= '0';    
         else
--            fifo_full <= srl_count(3) and srl_count(2) and (not srl_count(1) or not srl_count(0));
            case srl_count is
               when "1110" => fifo_full <= '1';
               when "1101" => fifo_full <= '1';
               when "1100" => fifo_full <= '1';
               when "1011" => fifo_full <= '1';
               when "1010" => fifo_full <= '1';
               when "1001" => fifo_full <= '1';
               when others => fifo_full <= '0';
            end case;
         end if;
      end if;
   end process;

   -- empty signal for SRL16
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            fifo_empty  <= '1';    
         else
            if srl_count = "0000" and fifo_empty = '0' and (out_latch_loaded = '0' or read_en = '1') then
               fifo_empty  <= '1';    
            elsif srl_count = "1111" then
               fifo_empty  <= '1';    
            else
               fifo_empty  <= '0';
            end if;
         end if;
      end if;
   end process;


   -- handle output register
   process (clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            out_latch_loaded  <= '0';
            for I in 0 to width - 1 loop
               dataout(I) <= '0';
            end loop;
         else
            if fifo_empty = '0' and (out_latch_loaded = '0' or read_en = '1') then
               dataout <= dataout_reg;
            end if;

            if fifo_empty = '0' then
               out_latch_loaded <= '1';
            elsif fifo_empty = '1' and read_en = '1' then
               out_latch_loaded <= '0';
            end if;
         end if;
      end if;
   end process;

end RTL;



