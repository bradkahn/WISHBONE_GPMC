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
--	                       gpmc_wishbone
--                  +-----------------------+
--gpmc_a            |                       |
--+----------------->                       |
--gpmc_d            |                       |
--<----------------->                       |               
--gpmc_clk_i        |                       |CLK                   
--+----------------->                       +------------->
--gpmc_n_cs         |                       |RST                   
--+----------------->                       +------------->
--gpmc_n_we         |                       |            
--+----------------->                       |ACK_I                  
--gpmc_n_oe         |                       <-------------
--+----------------->                       |DAT_I           
--gpmc_n_adv_ale    |                       <-------------
--+----------------->                       |DAT_O        
--                  |                       +------------->
--                  |                       |STB_O        
--                  |                       +------------->
--sys_clk_P         |                       |WE_O                 
--+----------------->                       +------------->
--sys_clk_N???      |                       |                         
--+----------------->                       |        
--                  |                       |
--                  +-----------------------+

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

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
	type state_type is (LATCH_ADDRESS, STORE_GPMC_DATA_I, WB_WRITE, WB_READ, STORE_GPMC_DATA_O);

------------------------------------------------------------------------------------
-- Declare signals
------------------------------------------------------------------------------------

	-- Define signals for the gpmc bus
	signal gpmc_clk_i_b	: std_logic;  --buffered  gpmc_clk_i
	signal gpmc_address	: std_logic_vector(25 downto 0):=(others => '0');         -- Full de-multiplexed address bus (ref. 16 bits)
	signal gpmc_data_o	: std_logic_vector(15 downto 0):="0000000000000000";      -- Register for output bus value
	signal gpmc_data_i	: std_logic_vector(15 downto 0):="0000000000000000";      -- Register for input bus value

	-- Debug signals
	signal wb_reg_sig  : std_logic_vector(15 downto 0) := "0000000000000000";

	ALIAS reg_bank_address	: std_logic_vector(3 downto 0) IS gpmc_address(25 downto 22);
	-- Currently each register is 64 x 16
	ALIAS reg_file_address : std_logic_vector(5 downto 0) IS gpmc_address(5 downto 0);
	
--	--Flag signals for WISHBONE state machine 
--	signal WISHBONE_WRITE 	: std_logic := '0';
--	signal WISHBONE_READ		: std_logic := '0';
	
	-- Define signal to for state
--	signal state : state_type := LATCH_ADDRESS; -- Initialize state to LATCH_ADDRESS

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

--CLK <= gpmc_clk_i_b; -- WISHBONE CLK is fed by GPMC CLK generated from ARM !! TODO: NEED TO CHECK!!

RST <= gpio_in(0); -- MAP FPGA_GPIO_0 AS INPUT TO WISHBONE RST

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
  		if (gpmc_n_adv_ale = '0') then
				gpmc_address <= gpmc_a & gpmc_d;   -- Address of 16 bit word
--				WISHBONE_WRITE 	<= '0';
--				WISHBONE_READ		<= '0';
				
  		--Second cycle of the bus is read or write
  		--Check for read
  		elsif (gpmc_n_oe = '0') then
  			case to_integer(unsigned(reg_bank_address)) is
  				when 0 => 
						--gpmc_data_o <= wb_reg_sig;
						gpmc_data_o <= DAT_I(15 downto 0);
						STB_O <= '1';
						WE_O	<= '0';
  				when others => 
						gpmc_data_o <= (others => '0');
  			end case;
			-- read from WISHBONE 
--				WISHBONE_READ		<= '1';
--				WISHBONE_WRITE 	<= '0';
				
  		--Check for write
  		elsif (gpmc_n_we = '0') then
  			case to_integer(unsigned(reg_bank_address)) is
  				when 0 => 
					--wb_reg_sig  <= gpmc_data_i;
					DAT_O	<= x"0000" & gpmc_data_i;
					STB_O <= '1';
					WE_O	<= '1';
  				when others => null;
  			end case;
			-- write out to WISHBONE 
--				WISHBONE_WRITE 	<= '1';
--				WISHBONE_READ		<= '0';
  		
			else
				STB_O <= '0';
				WE_O	<= '0';
--				WISHBONE_WRITE 	<= '0';
--				WISHBONE_READ		<= '0';			
			end if;
     end if;
   else
			STB_O <= '0';
			WE_O	<= '0';
--				WISHBONE_WRITE 	<= '0';
--				WISHBONE_READ		<= '0';
	 end if;
end process;

-----------------------------------------------------------------------------------
-- WISHBONE FSM
-----------------------------------------------------------------------------------

-- triggers whenever WISHBONE_WRITE or WISHBONE_READ goes HIGH
--WISHBONE_ENGAGE: process(WISHBONE_WRITE, WISHBONE_READ)
--begin
--	if  (WISHBONE_WRITE = '1') then
--		clk <= sys_clk_P;
--		-- set state to write
--		state <= WB_WRITE;
--	elsif (WISHBONE_READ = '1') then
--		-- set state to read
--		state <= WB_READ;
--		clk <= sys_clk_P;
--	else
--		clk <= '0';
--		state <= LATCH_ADDRESS;
--	end if;
--end process WISHBONE_ENGAGE;
--
--WISHBONE_FSM: process (sys_clk_P)
--begin
--	if rising_edge (sys_clk_P) then
--		case ( state ) is
--			when LATCH_ADDRESS =>
--				null;
--			when WB_WRITE =>
--				DAT_O	<= x"0000" & wb_reg_sig;
--				STB_O <= '1';
--				WE_O	<= '1';
--			when WB_READ =>
--				--wb_reg_sig <= DAT_I(15 downto 0);
--			when OTHERS =>
--				DAT_O	<= x"00000000";
--				STB_O <= '0';
--				WE_O	<= '0';
--		end case;
--	end if;
--end process ;

------------------------------------------------------------------------------------
-- Manage the tri-state bus
---------------------------------------------------------------------------------
gpmc_d <= gpmc_data_o when (gpmc_n_oe = '0') else (others => 'Z');
gpmc_data_i <= gpmc_d;

end Behavioral;