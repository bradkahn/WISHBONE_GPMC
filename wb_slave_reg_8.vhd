----------------------------------------------------------------------------------
-- Company: 			UCT
-- Engineer: 			Bradley Kahn
-- 
-- Create Date:		19:05:03 07/19/2016 
-- Design Name: 
-- Module Name:		wb_slave_reg_8 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Simple 8-bit register. Adapted from sample given on pg 104 of Wishbine B4 Manual.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--              wb_slave_reg_8
--           +-----------------+
--      CLK_I|                 |
-- ---------->                 |
--      RST_I|                 |
-- ---------->                 |
--           |                 |
--      ACK_O|                 |
-- <---------+                 |
--      DAT_O|                 |PRT_O
-- <---------+                 +---------------->
--      DAT_I|                 |
-- ---------->                 |
--      STB_I|                 |
-- ---------->                 |
--      WE_I |                 |
-- ---------->                 |
--           |                 |
--           +-----------------+

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity wb_slave_reg_8 is
    Port ( 
					--WISHBONE SLAVE interface:
					ACK_O	: out	STD_LOGIC;
					CLK_I	: in	STD_LOGIC;
					DAT_I	: in	STD_LOGIC_VECTOR (7 downto 0);
					DAT_O	: out	STD_LOGIC_VECTOR (7 downto 0);
					RST_I	: in	STD_LOGIC;
					STB_I	: in	STD_LOGIC;
					WE_I	: in	STD_LOGIC;
					
					-- Output port (non-wishbone signals):
					PRT_O : out	STD_LOGIC_VECTOR (7 downto 0)
					);
end wb_slave_reg_8;

architecture Behavioral of wb_slave_reg_8 is

	signal reg_state : STD_LOGIC_VECTOR (7 downto 0);

begin
	
	process (CLK_I)
	begin
		if rising_edge(CLK_I) then
			if RST_I = '1' then
				reg_state <= "00000000";
			elsif ((STB_I AND WE_I) = '1') then
				reg_state <= DAT_I;
			else
				reg_state <= reg_state;
			end if;
		end if;
	end process;
	
	ACK_O <= STB_I;
	DAT_O <= reg_state;
	PRT_O <= reg_state;
	
end Behavioral;

