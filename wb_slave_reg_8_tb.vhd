--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:52:32 07/19/2016
-- Design Name:   
-- Module Name:   /home/brad/xilinx_workspace/wb_slave_reg_8/wb_slave_reg_8_tb.vhd
-- Project Name:  wb_slave_reg_8
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: wb_slave_reg_8
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY wb_slave_reg_8_tb IS
END wb_slave_reg_8_tb;
 
ARCHITECTURE behavior OF wb_slave_reg_8_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT wb_slave_reg_8
    PORT(
         ACK_O : OUT  std_logic;
         CLK_I : IN  std_logic;
         DAT_I : IN  std_logic_vector(7 downto 0);
         DAT_O : OUT  std_logic_vector(7 downto 0);
         RST_I : IN  std_logic;
         STB_I : IN  std_logic;
         WE_I : IN  std_logic;
         PRT_O : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_I : std_logic := '0';
   signal DAT_I : std_logic_vector(7 downto 0) := (others => '0');
   signal RST_I : std_logic := '0';
   signal STB_I : std_logic := '0';
   signal WE_I : std_logic := '0';

 	--Outputs
   signal ACK_O : std_logic;
   signal DAT_O : std_logic_vector(7 downto 0);
   signal PRT_O : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_I_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: wb_slave_reg_8 PORT MAP (
          ACK_O => ACK_O,
          CLK_I => CLK_I,
          DAT_I => DAT_I,
          DAT_O => DAT_O,
          RST_I => RST_I,
          STB_I => STB_I,
          WE_I => WE_I,
          PRT_O => PRT_O
        );

   -- Clock process definitions
   CLK_I_process :process
   begin
		CLK_I <= '0';
		wait for CLK_I_period/2;
		CLK_I <= '1';
		wait for CLK_I_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_I_period*10;

      -- insert stimulus here
			report "STARTING TESTS";
			report "---------------------------------------------------------";
			report "TEST 1: load reg with '10101010'";
			DAT_I <= "10101010";
			STB_I <= '1';
			WE_I 	<= '1';
			
			wait for CLK_I_period;
			
			assert ( PRT_O = "10101010" ) report "FAILED TO LOAD REG WITH TEST INPUT: 10101010." severity ERROR;
			assert ( PRT_O /= "10101010" ) report "PASS" severity NOTE;
			
			report "---------------------------------------------------------";
			
			report "TEST 2: test reset line";

			RST_I <= '1';
			
			wait for CLK_I_period;
			
			assert ( PRT_O = "00000000" ) report "RESET FAILED, REG CONTAINS A VALUE != 00000000" severity ERROR;
			assert ( PRT_O /= "00000000" ) report "PASS" severity NOTE;
			report "---------------------------------------------------------";
		
		report "TESTS COMPLETED";
		wait; 	
   end process;

END;
