----------------------------------------------------------------------------------
-- Company: 				UCT
-- Engineer: 				Bradley Kahn
-- 
-- Create Date:    10:47:39 10/26/2016 
-- Design Name: 
-- Module Name:    wb_slave_generic - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: generic WISHBONE slave device containing n registers of size m bits.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wb_slave_generic is
	generic (
		ADDRESS_WIDTH:	positive := 2; 	-- 2^(ADDRESS_WIDTH) registers
		DATA_WIDTH:			positive := 16	-- size of each register in bits
	);
	Port ( 
				--WISHBONE SLAVE interface:
				ADR_I	:	in STD_LOGIC_VECTOR (ADDRESS_WIDTH - 1 downto 0);
				ACK_O	: out	STD_LOGIC;
				CLK_I	: in	STD_LOGIC;
				DAT_I	: in	STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
				DAT_O	: out	STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
				RST_I	: in	STD_LOGIC;
				STB_I	: in	STD_LOGIC;
				WE_I	: in	STD_LOGIC;
				
				-- Output port (non-wishbone signals):
				PRT_O : out	STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0)
				);
end wb_slave_generic;

architecture Behavioral of wb_slave_generic is

	type register_array_type is array ((2**ADDRESS_WIDTH) - 1 downto 0) of std_logic_vector (DATA_WIDTH - 1 downto 0);
	signal register_array : register_array_type := (others => (others => '0'));

begin
	
	process (CLK_I)
	begin
		if rising_edge(CLK_I) then
			if RST_I = '1' then
				register_array <= (others => (others => '0'));
			else
				for reg_index in 0 to ((2**ADDRESS_WIDTH) -1) loop
					if ((STB_I AND WE_I) = '1' AND to_integer(unsigned(ADR_I)) = reg_index) then
						register_array(reg_index) <= DAT_I;
					else
						register_array(reg_index) <= register_array(reg_index);
					end if;
				end loop;
			end if;
		end if;
	end process;
	
	ACK_O <= STB_I;
	DAT_O <= register_array(to_integer(unsigned(ADR_I)));
	PRT_O <= register_array(to_integer(unsigned(ADR_I)));

end Behavioral;

