----------------------------------------------------------------------------------
-- Company:			University of Cape Town
-- Engineer:		Bradley Kahn
--
-- Create Date:	15:20:07 06/22/2016
-- Design Name:
-- Module Name:	gpmc_wishbone - Behavioral
-- Project Name:	gpmc_wishbone
-- Target Devices:RHINO (SPARTAN 6)
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
--			                     gpmc_wishbone
--		                  +-----------------------+
--		gpmc_a            |                       |
--		+----------------->                       |
--		gpmc_d            |                       |
--		<----------------->                       |
--		gpmc_clk_i        |                       |CLK
--		+----------------->                       +------------->
--		gpmc_n_cs         |                       |RST
--		+----------------->                       +------------->
--		gpmc_n_we         |                       |
--		+----------------->                       |ACK_I
--		gpmc_n_oe         |                       <-------------
--		+----------------->                       |DAT_I
--		gpmc_n_adv_ale    |                       <-------------
--		+----------------->                       |DAT_O
--		                  |                       +------------->
--		                  |                       |STB_O
--		                  |                       +------------->
--		sys_clk_P         |                       |WE_O
--		+----------------->                       +------------->
--		sys_clk_N???      |                       |
--		+----------------->                       |
--		                  |                       |
--		                  +-----------------------+

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity gpmc_wishbone is
	port (
		-- GPMC PORTS
		gpmc_a:			in std_logic_vector(10 downto 1);
		gpmc_d:			inout std_logic_vector(15 downto 0);
		gpmc_clk_i:		in std_logic;
		gpmc_n_cs:		in std_logic_vector(6 downto 0);
		gpmc_n_we:		in std_logic;
		gpmc_n_oe:		in std_logic;
		gpmc_n_adv_ale:in std_logic;
		--gpmc_n_wp:		in std_logic; -- UNUSED

		-- WISHBONE SYSCON PORTS
		CLK:				out std_logic;
		RST:				out std_logic;

		-- GPIO PORTS
		gpio_in: 		in std_logic_vector(7 downto 0);
		gpio_out: 		out std_logic_vector(7 downto 0);

		-- SYSTEM CLOCK PORTS
		sys_clk_P: 		in std_logic;
		--sys_clk_N: 		in std_logic;

		-- WISHBONE MASTER INTERFACE PORTS
		ACK_I:  			in  std_logic;
		--CLK_I:  			in  std_logic; --this component contains the syscon.
		--CYC_O:  			out std_logic; --for future use with larger capacity slaves.
		DAT_I:  			in  std_logic_vector( 31 downto 0 );
		DAT_O:  			out std_logic_vector( 31 downto 0 );
		--RST_I:  			in  std_logic; --this component contains the syscon.
		STB_O:  			out std_logic;
		WE_O:   			out std_logic
	);
end gpmc_wishbone;

architecture Behavioral of gpmc_wishbone is

------------------------------------------------------------------------------------
-- Declare types
------------------------------------------------------------------------------------
	type ram_type is array (31 downto 0) of std_logic_vector(15 downto 0);   -- 32 X 16 memory block

------------------------------------------------------------------------------------
-- Declare signals
------------------------------------------------------------------------------------

	-- Define signals for the gpmc bus
	signal gpmc_clk_i_b	: std_logic;  --buffered  gpmc_clk_i
	signal gpmc_address	: std_logic_vector(25 downto 0):=(others => '0');         -- Full de-multiplexed address bus (ref. 16 bits)
	signal gpmc_data_o	: std_logic_vector(15 downto 0):="0000000000000000";      -- Register for output bus value
	signal gpmc_data_i	: std_logic_vector(15 downto 0):="0000000000000000";      -- Register for input bus value

	-- Debug signals
	signal wb_reg_test_sig  : std_logic_vector(15 downto 0) := "0000000000000000";

	ALIAS reg_bank_address	: std_logic_vector(3 downto 0) IS gpmc_address(25 downto 22);
	-- Currently each register is 64 x 16
	ALIAS reg_file_address : std_logic_vector(5 downto 0) IS gpmc_address(5 downto 0);


	signal wb_rst_sig : std_logic;
	signal wb_clk_sig : std_logic;
	signal wb_clk_en : std_logic;

	--Flag signals for WISHBONE state machine
	signal wishbone_write 	: std_logic := '0';
	signal wb_write_req 	: std_logic := '0';
	signal WISHBONE_READ		: std_logic := '0';
	signal wb_write_end			: std_logic := '0';
	signal WISHBONE_READ_END	: std_logic := '0';

begin

------------------------------------------------------------------------------------
-- Instantiate input buffer for FPGA_PROC_BUS_CLK
------------------------------------------------------------------------------------

IBUFG_gpmc_clk_i : IBUFG
generic map
(
	IBUF_LOW_PWR => FALSE,
	IOSTANDARD => "DEFAULT"
)
port map
(
	I => gpmc_clk_i,
	O => gpmc_clk_i_b
);

wb_clk_sig <= sys_clk_P; -- WISHBONE CLK is fed by system clk (assumed to be the >> faster than gpmc_clk TODO: check this)
wb_rst_sig <= gpio_in(0); -- MAP FPGA_GPIO_0 AS INPUT TO WISHBONE RST

-----------------------------------------------------------------------------------
-- Register File: Read
-----------------------------------------------------------------------------------

-- SYM FILE REGISTERS
-- 0	"count"	3	0x08000000	0x02

process (gpmc_clk_i_b,gpmc_n_cs,gpmc_n_oe,gpmc_n_we,gpmc_n_adv_ale,gpmc_d,gpmc_a)
begin
  if (gpmc_n_cs /= "1111111")  then             -- CS 1
		if gpmc_clk_i_b'event and gpmc_clk_i_b = '1' then

				--First cycle of the bus transaction record the address
				--RECORD THE ADDRESS
			if (gpmc_n_adv_ale = '0') then
					gpmc_address <= gpmc_a & gpmc_d;   -- Address of 16 bit word
					wb_write_req <= '0';
					WISHBONE_READ	<= '0';

				--Second cycle of the bus is read or write
				--CHECK FOR READ
			elsif (gpmc_n_oe = '0') then
				case to_integer(unsigned(reg_bank_address)) is --might be irrelevent once WB_ADDRESS signal is used TODO ...
					when 0 =>
						--gpmc_data_o <= wb_reg_test_sig; -- only used for testing module w/o wb-slave connected
						--gpmc_data_o <= DAT_I(15 downto 0); --uncommenting this will cause test to fail...
					when 1 =>
						null;
					when 2 =>
						null;
					when others =>
						--gpmc_data_o <= (others => '0');
				end case;
					-- read from WISHBONE
					WISHBONE_READ	<= '1';

				--CHECK FOR WRITE
			elsif (gpmc_n_we = '0') then
				wb_write_req 	<= '1';
				case to_integer(unsigned(reg_bank_address)) is --might be irrelevent once WB_ADDRESS signal is used TODO ...
					when 0 =>
						--wb_reg_test_sig  <= gpmc_data_i;
					when 1 =>
						null;
					when 2 =>
						null;
					when others => null;
				end case;

				--OTHER CONDITION
			else
				wb_write_req <= '0';
				WISHBONE_READ	<= '0';
			end if;
		end if;
   else
		wb_write_req <= '0';
		WISHBONE_READ	<= '0';
	end if;
end process;

------------------------------------------------------------------------------------
-- WISHBONE CLK & RST SIGNALS
------------------------------------------------------------------------------------
	RST	<= wb_rst_sig;
	wb_clk_process: process(wb_clk_sig)
	variable cycle_counter : unsigned (2 downto 0) := "000";
	begin
		if rising_edge ( wb_clk_sig ) then
			if wishbone_write = '1' then
				if cycle_counter < 2 then
					wb_clk_en <= '1';
					if cycle_counter = "000" then
						DAT_O	<= x"0000" & gpmc_data_i;
						STB_O <= '1';
						WE_O	<= '1';
						wb_write_end<= '0';
					elsif cycle_counter = "001" then
						DAT_O	<= (others => 'X');
						STB_O <= '0';
						WE_O	<= '0';
						wb_write_end<= '1';
					end if;
					cycle_counter := cycle_counter + "001";
				end if;
			else
				wb_clk_en <= '0';
				cycle_counter := "000";
				if wb_write_req = '0' then
					wb_write_end<= '0';
				end if;
				DAT_O	<= (others => 'X');
				STB_O <= '0';
				WE_O	<= '0';
			end if;
		end if;
	end process;

	CLK 	<= wb_clk_sig when wb_clk_en = '1' else '0';
	wishbone_write <= wb_write_req and (not wb_write_end);
------------------------------------------------------------------------------------
-- Manage the tri-state bus
---------------------------------------------------------------------------------
gpmc_d <= gpmc_data_o when (gpmc_n_oe = '0') else (others => 'Z');
gpmc_data_i <= gpmc_d;

end Behavioral;
