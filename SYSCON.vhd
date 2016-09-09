----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:34:04 07/09/2016 
-- Design Name: 
-- Module Name:    SYSCON - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SYSCON is
port(
            -- WISHBONE Interface

            CLK_O:  out std_logic;
            RST_O:  out std_logic;


            -- NON-WISHBONE Signals

            EXTCLK: in  std_logic;
            EXTTST: in  std_logic
         );
end SYSCON;

architecture Behavioral of SYSCON is


    signal      DLY:    std_logic;
    signal      RST:    std_logic;

begin

    ------------------------------------------------------------------
    -- Reset generator.
    ------------------------------------------------------------------

    RST_GENERATOR: process( EXTCLK )
    begin                                     

        if( rising_edge(EXTCLK) ) then

            DLY <= ( not(EXTTST) and     DLY  and not(RST) )
                or ( not(EXTTST) and not(DLY) and     RST  );

            RST <= ( not(EXTTST) and not(DLY) and not(RST) );

        end if;

    end process RST_GENERATOR;


    ------------------------------------------------------------------
    -- Make selected signals available to the outside world.
    ------------------------------------------------------------------

    MAKE_VISIBLE: process( EXTCLK, RST )
    begin

        CLK_O <= EXTCLK;
        RST_O <= RST;

    end process MAKE_VISIBLE;



end Behavioral;

