--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:35:53 07/09/2016
-- Design Name:   
-- Module Name:   /home/brad/xilinx_workspace/WB_SYSCON/SYSCON_TB.vhd
-- Project Name:  WB_SYSCON
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SYSCON
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
 
ENTITY SYSCON_TB IS
END SYSCON_TB;
 
ARCHITECTURE behavior OF SYSCON_TB IS 

    ------------------------------------------------------------------
    -- Define the module under test as a component.
    ------------------------------------------------------------------

    component SYSCON
    port(
            CLK_O:  out std_logic;
            RST_O:  out std_logic;
            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );

    end component SYSCON;


    ------------------------------------------------------------------
    -- Define some local signals to assign values and observe.
    ------------------------------------------------------------------

    signal  CLK_O:  std_logic;
    signal  EXTCLK: std_logic;
    signal  EXTTST: std_logic;
    signal  RST_O:  std_logic;


begin

    ------------------------------------------------------------------
    -- Port map for the device under test.
    ------------------------------------------------------------------

    TBENCH: SYSCON
    port map(
                CLK_O   =>  CLK_O,
                RST_O   =>  RST_O,
                EXTCLK  =>  EXTCLK,
                EXTTST  =>  EXTTST
            );


    ------------------------------------------------------------------
    -- Test process.
    ------------------------------------------------------------------

    TEST_PROCESS: process

        --------------------------------------------------------------
        -- Specify the time duration for constant PERIOD.  This value
        -- is used only as a convienience for the simulation.  The
        -- actual value will be determined by the ASIC/FPGA router.
        --------------------------------------------------------------

        constant PERIOD: time := 100 ns;

    begin

        --------------------------------------------------------------
        -- Initialize all of the inputs, including 'EXTTST'.  Generate
        -- a single clock pulse, and verify that everything initial-
        -- izes correctly.
        --------------------------------------------------------------

        EXTCLK  <= '0';
        EXTTST  <= '1';
        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 2);
        EXTCLK  <= '0';

        wait for (PERIOD / 4);
        EXTTST  <= '0';
        wait for (PERIOD / 4);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( CLK_O = '1' )  report "CLK_O FAILURE." severity ERROR;
        assert( RST_O = '1' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';


        --------------------------------------------------------------
        -- Verify that the [CLK_O] and [RST_O] signals work correctly.
        --------------------------------------------------------------

        wait for (PERIOD / 4);
        assert( CLK_O = '0' )  report "CLK_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( CLK_O = '1' )  report "CLK_O FAILURE." severity ERROR;
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait for (PERIOD / 2);
        EXTCLK  <= '1';
        wait for (PERIOD / 4);
        assert( RST_O = '0' )  report "RST_O FAILURE." severity ERROR;
        wait for (PERIOD / 4);
        EXTCLK  <= '0';

        wait;
   end process;

END;
