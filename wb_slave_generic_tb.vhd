--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:02:21 10/27/2016
-- Design Name:   
-- Module Name:   /home/brad/Dropbox/2016/Thesis/rhino/WISHBONE_GPMC/wb_slave_generic_tb.vhd
-- Project Name:  WISHBONE_GPMC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: wb_slave_generic
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
 
ENTITY wb_slave_generic_tb IS
END wb_slave_generic_tb;
 
ARCHITECTURE behavior OF wb_slave_generic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT wb_slave_generic
    PORT(
         ADR_I : IN  std_logic_vector(1 downto 0);
         ACK_O : OUT  std_logic;
         CLK_I : IN  std_logic;
         DAT_I : IN  std_logic_vector(15 downto 0);
         DAT_O : OUT  std_logic_vector(15 downto 0);
         RST_I : IN  std_logic;
         STB_I : IN  std_logic;
         WE_I : IN  std_logic;
         PRT_O : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ADR_I : std_logic_vector(1 downto 0) := (others => '0');
   signal CLK_I : std_logic := '0';
   signal DAT_I : std_logic_vector(15 downto 0) := (others => '0');
   signal RST_I : std_logic := '0';
   signal STB_I : std_logic := '0';
   signal WE_I : std_logic := '0';

 	--Outputs
   signal ACK_O : std_logic;
   signal DAT_O : std_logic_vector(15 downto 0);
   signal PRT_O : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant CLK_I_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: wb_slave_generic PORT MAP (
          ADR_I => ADR_I,
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
			RST_I <= '1';
      wait for 100 ns;	
			RST_I <= '0';
      wait for CLK_I_period*10;

      -- insert stimulus here 
			--------------------------
			-- SIMULATE WRITES
			--------------------------
			-- cycle 1 - write to reg1
			ADR_I <= "00";
			DAT_I <= x"000F";
			STB_I <= '1';
			WE_I 	<= '1';
			wait for CLK_I_period;
			
			DAT_I <= (others => 'X');
			STB_I <= '0';
			WE_I 	<= '0';
			
			wait for CLK_I_period;
			-- cycle 2 - write to reg2
			ADR_I <= "01";
			DAT_I <= x"00F0";
			STB_I <= '1';
			WE_I 	<= '1';
			wait for CLK_I_period;
			
			DAT_I <= (others => 'X');
			STB_I <= '0';
			WE_I 	<= '0';
			
			wait for CLK_I_period;
			-- cycle 3 - write to reg3
			ADR_I <= "10";
			DAT_I <= x"0F00";
			STB_I <= '1';
			WE_I 	<= '1';
			wait for CLK_I_period;
			
			DAT_I <= (others => 'X');
			STB_I <= '0';
			WE_I 	<= '0';
			
			wait for CLK_I_period;			
			-- cycle 4 - write to reg4
			ADR_I <= "11";
			DAT_I <= x"F000";
			STB_I <= '1';
			WE_I 	<= '1';
			wait for CLK_I_period;
			
			DAT_I <= (others => 'X');
			STB_I <= '0';
			WE_I 	<= '0';
			
			wait for CLK_I_period;
			--------------------------
			-- SIMULATE READS
			--------------------------
			-- cycle 5 - read from reg1
			ADR_I <= "00";
			WE_I 	<= '0';
			STB_I <= '1';
			wait for CLK_I_period/2;
			assert (DAT_O = x"000F") report "reg1 contains incorrect value, should be x000F." severity ERROR; 
			wait for CLK_I_period/2;
			-- cycle 6 - read from reg2
			ADR_I <= "01";
			WE_I 	<= '0';
			STB_I <= '1';
			wait for CLK_I_period/2;
			assert (DAT_O = x"00F0") report "reg2 contains incorrect value, should be x00F0." severity ERROR; 
			wait for CLK_I_period/2;
			-- cycle 7 - read from reg3
			ADR_I <= "10";
			WE_I 	<= '0';
			STB_I <= '1';
			wait for CLK_I_period/2;
			assert (DAT_O = x"0F00") report "reg3 contains incorrect value, should be x0F00." severity ERROR; 
			wait for CLK_I_period/2;			
			-- cycle 8 - read from reg4
			ADR_I <= "11";
			WE_I 	<= '0';
			STB_I <= '1';
			wait for CLK_I_period/2;
			assert (DAT_O = x"F000") report "reg4 contains incorrect value, should be xF000." severity ERROR; 
			wait for CLK_I_period/2;
			
      wait;
   end process;

END;
