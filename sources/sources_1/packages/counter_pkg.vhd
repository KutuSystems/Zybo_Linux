--------------------------------------------------------------
--
-- (C) Copyright Kutu Pty. Ltd. 2013.
--
-- file: counter_pkg.vhd
--
-- author: Greg Smart
--
--------------------------------------------------------------
--------------------------------------------------------------
--
-- This is a vhdl package for containing procedures for different
-- types of counters.  It includes lfsr up counters, lfsr down
-- counters, lfsr up down counters and small gray code counters.
-- 
--------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package counter_pkg is

   -- lfsrAdd is a forward lfsr counter
   procedure lfsrAdd3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0));
   procedure lfsrAdd4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0));
   procedure lfsrAdd5(signal count : in std_logic_vector(4 downto 0);
                     signal countP1 : out std_logic_vector(4 downto 0));
   procedure lfsrAdd6(signal count : in std_logic_vector(5 downto 0);
                     signal countP1 : out std_logic_vector(5 downto 0));
   procedure lfsrAdd7(signal count : in std_logic_vector(6 downto 0);
                     signal countP1 : out std_logic_vector(6 downto 0));
   procedure lfsrAdd8(signal count : in std_logic_vector(7 downto 0);
                     signal countP1 : out std_logic_vector(7 downto 0));
   procedure lfsrAdd9(signal count : in std_logic_vector(8 downto 0);
                     signal countP1 : out std_logic_vector(8 downto 0));
   procedure lfsrAdd10(signal count : in std_logic_vector(9 downto 0);
                     signal countP1 : out std_logic_vector(9 downto 0));
   procedure lfsrAdd11(signal count : in std_logic_vector(10 downto 0);
                     signal countP1 : out std_logic_vector(10 downto 0));
   procedure lfsrAdd12(signal count : in std_logic_vector(11 downto 0);
                     signal countP1 : out std_logic_vector(11 downto 0));
   procedure lfsrAdd13(signal count : in std_logic_vector(12 downto 0);
                     signal countP1 : out std_logic_vector(12 downto 0));
   procedure lfsrAdd14(signal count : in std_logic_vector(13 downto 0);
                     signal countP1 : out std_logic_vector(13 downto 0));
   procedure lfsrAdd15(signal count : in std_logic_vector(14 downto 0);
                     signal countP1 : out std_logic_vector(14 downto 0));
   procedure lfsrAdd16(signal count : in std_logic_vector(15 downto 0);
                     signal countP1 : out std_logic_vector(15 downto 0));
   procedure lfsrAdd32(signal count : in std_logic_vector(31 downto 0);
                     signal countP1 : out std_logic_vector(31 downto 0));

   -- lfsrSub is a reverse lfsr counter
   procedure lfsrSub3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0));
   procedure lfsrSub4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0));
   procedure lfsrSub5(signal count : in std_logic_vector(4 downto 0);
                     signal countP1 : out std_logic_vector(4 downto 0));
   procedure lfsrSub6(signal count : in std_logic_vector(5 downto 0);
                     signal countP1 : out std_logic_vector(5 downto 0));
   procedure lfsrSub7(signal count : in std_logic_vector(6 downto 0);
                     signal countP1 : out std_logic_vector(6 downto 0));
   procedure lfsrSub8(signal count : in std_logic_vector(7 downto 0);
                     signal countP1 : out std_logic_vector(7 downto 0));
   procedure lfsrSub9(signal count : in std_logic_vector(8 downto 0);
                     signal countP1 : out std_logic_vector(8 downto 0));
   procedure lfsrSub10(signal count : in std_logic_vector(9 downto 0);
                     signal countP1 : out std_logic_vector(9 downto 0));
   procedure lfsrSub11(signal count : in std_logic_vector(10 downto 0);
                     signal countP1 : out std_logic_vector(10 downto 0));
   procedure lfsrSub12(signal count : in std_logic_vector(11 downto 0);
                     signal countP1 : out std_logic_vector(11 downto 0));
   procedure lfsrSub13(signal count : in std_logic_vector(12 downto 0);
                     signal countP1 : out std_logic_vector(12 downto 0));
   procedure lfsrSub14(signal count : in std_logic_vector(13 downto 0);
                     signal countP1 : out std_logic_vector(13 downto 0));
   procedure lfsrSub15(signal count : in std_logic_vector(14 downto 0);
                     signal countP1 : out std_logic_vector(14 downto 0));
   procedure lfsrSub16(signal count : in std_logic_vector(15 downto 0);
                     signal countP1 : out std_logic_vector(15 downto 0));

   -- lfsrUpDn is an up-down lfsr counter
   procedure lfsrUpDn3(signal count : in std_logic_vector(2 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(2 downto 0));
   procedure lfsrUpDn4(signal count : in std_logic_vector(3 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(3 downto 0));
   procedure lfsrUpDn5(signal count : in std_logic_vector(4 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(4 downto 0));
   procedure lfsrUpDn6(signal count : in std_logic_vector(5 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(5 downto 0));
   procedure lfsrUpDn7(signal count : in std_logic_vector(6 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(6 downto 0));
   procedure lfsrUpDn8(signal count : in std_logic_vector(7 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(7 downto 0));
   procedure lfsrUpDn9(signal count : in std_logic_vector(8 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(8 downto 0));
   procedure lfsrUpDn10(signal count : in std_logic_vector(9 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(9 downto 0));
   procedure lfsrUpDn11(signal count : in std_logic_vector(10 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(10 downto 0));
   procedure lfsrUpDn12(signal count : in std_logic_vector(11 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(11 downto 0));
   procedure lfsrUpDn13(signal count : in std_logic_vector(12 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(12 downto 0));
   procedure lfsrUpDn14(signal count : in std_logic_vector(13 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(13 downto 0));
   procedure lfsrUpDn15(signal count : in std_logic_vector(14 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(14 downto 0));
   procedure lfsrUpDn16(signal count : in std_logic_vector(15 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(15 downto 0));

   -- grayAdd is a forward gray counter
   procedure grayAdd2(signal count : in std_logic_vector(1 downto 0);
                     signal countP1 : out std_logic_vector(1 downto 0));
   procedure grayAdd3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0));
   procedure grayAdd4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0));

end counter_pkg;

package body counter_pkg is

   procedure lfsrAdd3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1) xnor count(2);
      countP1(0)  <= count(2);
   end;

   procedure lfsrSub3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2) xnor count(0);
      countP1(2) <= count(0);
   end;

   procedure lfsrUpDn3(signal count : in std_logic_vector(2 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(2 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd3(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub3(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2) xnor count(3);
      countP1(0)  <= count(3);
   end;

   procedure lfsrSub4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3) xnor count(0);
      countP1(3) <= count(0);
   end;

   procedure lfsrUpDn4(signal count : in std_logic_vector(3 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(3 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd4(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub4(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd5(signal count : in std_logic_vector(4 downto 0);
                     signal countP1 : out std_logic_vector(4 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2) xnor count(4);
      countP1(4)  <= count(3);
      countP1(0)  <= count(4);
   end;

   procedure lfsrSub5(signal count : in std_logic_vector(4 downto 0);
                     signal countP1 : out std_logic_vector(4 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3) xnor count(0);
      countP1(3) <= count(4);
      countP1(4) <= count(0);
   end;

   procedure lfsrUpDn5(signal count : in std_logic_vector(4 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(4 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd5(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub5(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd6(signal count : in std_logic_vector(5 downto 0);
                     signal countP1 : out std_logic_vector(5 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4) xnor count(5);
      countP1(0)  <= count(5);
   end;

   procedure lfsrSub6(signal count : in std_logic_vector(5 downto 0);
                     signal countP1 : out std_logic_vector(5 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5) xnor count(0);
      countP1(5) <= count(0);
   end;

   procedure lfsrUpDn6(signal count : in std_logic_vector(5 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(5 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd6(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub6(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd7(signal count : in std_logic_vector(6 downto 0);
                     signal countP1 : out std_logic_vector(6 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5) xnor count(6);
      countP1(0)  <= count(6);
   end;

   procedure lfsrSub7(signal count : in std_logic_vector(6 downto 0);
                     signal countP1 : out std_logic_vector(6 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5);
      countP1(5) <= count(6) xnor count(0);
      countP1(6) <= count(0);
   end;

   procedure lfsrUpDn7(signal count : in std_logic_vector(6 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(6 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd7(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub7(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd8(signal count : in std_logic_vector(7 downto 0);
                     signal countP1 : out std_logic_vector(7 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3) xnor count(7);
      countP1(5)  <= count(4) xnor count(7);
      countP1(6)  <= count(5) xnor count(7);
      countP1(7)  <= count(6);
      countP1(0)  <= count(7);
   end;

   procedure lfsrSub8(signal count : in std_logic_vector(7 downto 0);
                     signal countP1 : out std_logic_vector(7 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4) xnor count(0);
      countP1(4) <= count(5) xnor count(0);
      countP1(5) <= count(6) xnor count(0);
      countP1(6) <= count(7);
      countP1(7) <= count(0);
   end;

   procedure lfsrUpDn8(signal count : in std_logic_vector(7 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(7 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd8(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub8(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd9(signal count : in std_logic_vector(8 downto 0);
                     signal countP1 : out std_logic_vector(8 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4) xnor count(8);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(0)  <= count(8);
   end;

   procedure lfsrSub9(signal count : in std_logic_vector(8 downto 0);
                     signal countP1 : out std_logic_vector(8 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5) xnor count(0);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8) <= count(0);
   end;

   procedure lfsrUpDn9(signal count : in std_logic_vector(8 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(8 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd9(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub9(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd10(signal count : in std_logic_vector(9 downto 0);
                     signal countP1 : out std_logic_vector(9 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6) xnor count(9);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(0)  <= count(9);
   end;

   procedure lfsrSub10(signal count : in std_logic_vector(9 downto 0);
                     signal countP1 : out std_logic_vector(9 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5);
      countP1(5) <= count(6);
      countP1(6) <= count(7) xnor count(0);
      countP1(7) <= count(8);
      countP1(8) <= count(9);
      countP1(9) <= count(0);
   end;

   procedure lfsrUpDn10(signal count : in std_logic_vector(9 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(9 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd10(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub10(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd11(signal count : in std_logic_vector(10 downto 0);
                     signal countP1 : out std_logic_vector(10 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8) xnor count(10);
      countP1(10) <= count(9);
      countP1(0)  <= count(10);
   end;

   procedure lfsrSub11(signal count : in std_logic_vector(10 downto 0);
                     signal countP1 : out std_logic_vector(10 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8) <= count(9) xnor count(0);
      countP1(9) <= count(10);
      countP1(10) <= count(0);
   end;

   procedure lfsrUpDn11(signal count : in std_logic_vector(10 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(10 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd11(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub11(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd12(signal count : in std_logic_vector(11 downto 0);
                     signal countP1 : out std_logic_vector(11 downto 0)) is
   begin
      countP1(1)  <= count(0) xnor count(11);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3) xnor count(11);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5) xnor count(11);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(0)  <= count(11);
   end;

   procedure lfsrSub12(signal count : in std_logic_vector(11 downto 0);
                     signal countP1 : out std_logic_vector(11 downto 0)) is
   begin
      countP1(0) <= count(1) xnor count(0);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4) xnor count(0);
      countP1(4) <= count(5);
      countP1(5) <= count(6) xnor count(0);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8)  <= count(9);
      countP1(9)  <= count(10);
      countP1(10) <= count(11);
      countP1(11) <= count(0);
   end;

   procedure lfsrUpDn12(signal count : in std_logic_vector(11 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(11 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd12(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub12(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd13(signal count : in std_logic_vector(12 downto 0);
                     signal countP1 : out std_logic_vector(12 downto 0)) is
   begin
      countP1(1)  <= count(0) xnor count(12);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2) xnor count(12);
      countP1(4)  <= count(3) xnor count(12);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(12) <= count(11);
      countP1(0)  <= count(12);
   end;

   procedure lfsrSub13(signal count : in std_logic_vector(12 downto 0);
                     signal countP1 : out std_logic_vector(12 downto 0)) is
   begin
      countP1(0) <= count(1) xnor count(0);
      countP1(1) <= count(2);
      countP1(2) <= count(3) xnor count(0);
      countP1(3) <= count(4) xnor count(0);
      countP1(4) <= count(5);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8)  <= count(9);
      countP1(9)  <= count(10);
      countP1(10) <= count(11);
      countP1(11) <= count(12);
      countP1(12) <= count(0);
   end;

   procedure lfsrUpDn13(signal count : in std_logic_vector(12 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(12 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd13(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub13(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd14(signal count : in std_logic_vector(13 downto 0);
                     signal countP1 : out std_logic_vector(13 downto 0)) is
   begin
      countP1(1)  <= count(0) xnor count(13);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2) xnor count(13);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4) xnor count(13);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(12) <= count(11);
      countP1(13) <= count(12);
      countP1(0)  <= count(13);
   end;

   procedure lfsrSub14(signal count : in std_logic_vector(13 downto 0);
                     signal countP1 : out std_logic_vector(13 downto 0)) is
   begin
      countP1(0) <= count(1) xnor count(0);
      countP1(1) <= count(2);
      countP1(2) <= count(3) xnor count(0);
      countP1(3) <= count(4);
      countP1(4) <= count(5) xnor count(0);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8)  <= count(9);
      countP1(9)  <= count(10);
      countP1(10) <= count(11);
      countP1(11) <= count(12);
      countP1(12) <= count(13);
      countP1(13) <= count(0);
   end;

   procedure lfsrUpDn14(signal count : in std_logic_vector(13 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(13 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd14(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub14(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd15(signal count : in std_logic_vector(14 downto 0);
                     signal countP1 : out std_logic_vector(14 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(12) <= count(11);
      countP1(13) <= count(12);
      countP1(14) <= count(13) xnor count(14);
      countP1(0)  <= count(14);
   end;

   procedure lfsrSub15(signal count : in std_logic_vector(14 downto 0);
                     signal countP1 : out std_logic_vector(14 downto 0)) is
   begin
      countP1(0) <= count(1);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8)  <= count(9);
      countP1(9)  <= count(10);
      countP1(10) <= count(11);
      countP1(11) <= count(12);
      countP1(12) <= count(13);
      countP1(13) <= count(14) xnor count(0);
      countP1(14) <= count(0);
   end;

   procedure lfsrUpDn15(signal count : in std_logic_vector(14 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(14 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd15(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub15(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd16(signal count : in std_logic_vector(15 downto 0);
                     signal countP1 : out std_logic_vector(15 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(2)  <= count(1);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3) xnor count(15);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(12) <= count(11);
      countP1(13) <= count(12) xnor count(15);
      countP1(14) <= count(13);
      countP1(15) <= count(14) xnor count(15);
      countP1(0)  <= count(15);
   end;

   procedure lfsrSub16(signal count : in std_logic_vector(15 downto 0);
                     signal countP1 : out std_logic_vector(15 downto 0)) is
   begin
      countP1(0) <= count(1) xnor count(0);
      countP1(1) <= count(2);
      countP1(2) <= count(3);
      countP1(3) <= count(4);
      countP1(4) <= count(5);
      countP1(5) <= count(6);
      countP1(6) <= count(7);
      countP1(7) <= count(8);
      countP1(8)  <= count(9);
      countP1(9)  <= count(10);
      countP1(10) <= count(11);
      countP1(11) <= count(12);
      countP1(12) <= count(13) xnor count(0);
      countP1(13) <= count(14);
      countP1(14) <= count(15) xnor count(0);
      countP1(15) <= count(0);
   end;

   procedure lfsrUpDn16(signal count : in std_logic_vector(15 downto 0);
                       signal up,down : in std_logic;
                     signal countP1 : out std_logic_vector(15 downto 0)) is
   begin
      if up = '1' and down = '0' then
         lfsrAdd16(count,countP1);
      elsif up = '0' and down = '1' then
         lfsrSub16(count,countP1);
      else
         countP1 <= count;
      end if;
   end;

   procedure lfsrAdd32(signal count : in std_logic_vector(31 downto 0);
                     signal countP1 : out std_logic_vector(31 downto 0)) is
   begin
      countP1(1)  <= count(0) xnor count(31);
      countP1(2)  <= count(1) xnor count(31);
      countP1(3)  <= count(2);
      countP1(4)  <= count(3);
      countP1(5)  <= count(4);
      countP1(6)  <= count(5);
      countP1(7)  <= count(6);
      countP1(8)  <= count(7);
      countP1(9)  <= count(8);
      countP1(10) <= count(9);
      countP1(11) <= count(10);
      countP1(12) <= count(11);
      countP1(13) <= count(12);
      countP1(14) <= count(13);
      countP1(15) <= count(14);
      countP1(16) <= count(15);
      countP1(17) <= count(16);
      countP1(18) <= count(17);
      countP1(19) <= count(18);
      countP1(20) <= count(19);
      countP1(21) <= count(20);
      countP1(22) <= count(21) xnor count(31);
      countP1(23) <= count(22);
      countP1(24) <= count(23);
      countP1(25) <= count(24);
      countP1(26) <= count(25);
      countP1(27) <= count(26);
      countP1(28) <= count(27);
      countP1(29) <= count(28);
      countP1(30) <= count(29);
      countP1(31) <= count(30);
      countP1(0)  <= count(31);
   end;



   procedure grayAdd2(signal count : in std_logic_vector(1 downto 0);
                     signal countP1 : out std_logic_vector(1 downto 0)) is
   begin
      countP1(1)  <= count(0);
      countP1(0)  <= not count(1);
   end;

   procedure grayAdd3(signal count : in std_logic_vector(2 downto 0);
                     signal countP1 : out std_logic_vector(2 downto 0)) is
   begin
      countP1(2)  <= (count(2) and count(0)) or (count(1) and not count(0));
      countP1(1)  <= (not count(2) and count(0)) or (count(1) and not count(0));
      countP1(0)  <= (count(2) and count(1)) or (not count(2) and not count(1));
   end;

   procedure grayAdd4(signal count : in std_logic_vector(3 downto 0);
                     signal countP1 : out std_logic_vector(3 downto 0)) is
   begin

      countP1(3)  <= (count(2) and not count(1) and not count(0)) or
                     (count(3) and count(0)) or (count(3) and count(1));

      countP1(2)  <= (not count(3) and count(1) and not count(0)) or
                     (count(2) and not count(1)) or (count(2) and count(0));

      countP1(1)  <= (count(1) and not count(0)) or
                     (not count(3) and not count(2) and count(0)) or 
                     (count(3) and count(2) and count(0));

      countP1(0)  <= (not count(3) and not count(2) and not count(1)) or
                     (not count(3) and count(2) and count(1)) or 
                     (count(3) and count(2) and not count(1)) or 
                     (count(3) and not count(2) and count(1));
   end;

end package body counter_pkg;


