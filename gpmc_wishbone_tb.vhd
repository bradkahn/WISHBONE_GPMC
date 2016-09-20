--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   09:08:10 07/20/2016
-- Design Name:
-- Module Name:   /home/brad/Dropbox/2016/Thesis/rhino/WISHBONE_GPMC/gpmc_wishbone_tb.vhd
-- Project Name:  WISHBONE_GPMC
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: gpmc_wishbone
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

ENTITY gpmc_wishbone_tb IS
END gpmc_wishbone_tb;

ARCHITECTURE behavior OF gpmc_wishbone_tb IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT gpmc_wishbone
    PORT(
         gpmc_a : IN  std_logic_vector(10 downto 1);
         gpmc_d : INOUT  std_logic_vector(15 downto 0);
         gpmc_clk_i : IN  std_logic;
         gpmc_n_cs : IN  std_logic_vector(6 downto 0);
         gpmc_n_we : IN  std_logic;
         gpmc_n_oe : IN  std_logic;
         gpmc_n_adv_ale : IN  std_logic;
         -- gpmc_n_wp : IN  std_logic; UNUSED
         CLK : OUT  std_logic;
         RST : OUT  std_logic;
         gpio_in : IN  std_logic_vector(7 downto 0);
         gpio_out : OUT  std_logic_vector(7 downto 0);
				 sys_clk_P: 		in std_logic;
         ACK_I : IN  std_logic;
         --CLK_I : IN  std_logic;
         --CYC_O : OUT  std_logic;
         DAT_I : IN  std_logic_vector(31 downto 0);
         DAT_O : OUT  std_logic_vector(31 downto 0);
         --RST_I : IN  std_logic;
         STB_O : OUT  std_logic;
         WE_O : OUT  std_logic
        );
    END COMPONENT;


   --Inputs
   signal gpmc_a : std_logic_vector(10 downto 1) := (others => '0');
   signal gpmc_clk_i : std_logic := '0';
   signal gpmc_n_cs : std_logic_vector(6 downto 0) := (others => '0');
   signal gpmc_n_we : std_logic := '0';
   signal gpmc_n_oe : std_logic := '0';
   signal gpmc_n_adv_ale : std_logic := '0';
   signal gpmc_n_wp : std_logic := '0';
   signal ACK_I : std_logic := '0';
   signal DAT_I : std_logic_vector(31 downto 0) := (others => 'X');
   signal RST_I : std_logic := '0';
   signal gpio_in : std_logic_vector(7 downto 0);

	--BiDirs
   signal gpmc_d : std_logic_vector(15 downto 0);

 	--Outputs
   signal CLK : std_logic;
   signal RST : std_logic;
   signal gpio_out : std_logic_vector(7 downto 0);

   --signal CYC_O : std_logic;
   signal DAT_O : std_logic_vector(31 downto 0);
   signal STB_O : std_logic;
   signal WE_O : std_logic;

	signal gpmc_fclk : std_logic; -- runs at 2x speed of gpmc_clk
	signal sys_clk_P : std_logic;
   -- Clock period definitions
   --constant gpmc_clk_i_period : time := 20 ns;
	constant gpmc_fclk_period : time := 20 ns;
	constant sys_clk_period		: time := 5 ns;

	-- Constants for dummy data
	constant ADDRESS_A 	: std_logic_vector (9 downto 0)	:= "0000000000"; -- address 0 (reg_count)
	constant ADDRESS_D 	: std_logic_vector (15 downto 0) := "0000000000000000";
	constant ADDRESS		: std_logic_vector (25 downto 0) := ADDRESS_A & ADDRESS_D;
	constant DUMMY_DATA	: std_logic_vector (15 downto 0) := "0000000010100011";


BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: gpmc_wishbone PORT MAP (
          gpmc_a => gpmc_a,
          gpmc_d => gpmc_d,
          gpmc_clk_i => gpmc_clk_i,
          gpmc_n_cs => gpmc_n_cs,
          gpmc_n_we => gpmc_n_we,
          gpmc_n_oe => gpmc_n_oe,
          gpmc_n_adv_ale => gpmc_n_adv_ale,
--          gpmc_n_wp => gpmc_n_wp, UNUSED
          CLK => CLK,
          RST => RST,
          gpio_in => gpio_in,
          gpio_out => gpio_out,
					sys_clk_P => sys_clk_P,
          ACK_I => ACK_I,
          --CLK_I => CLK_I,
          --CYC_O => CYC_O,
          DAT_I => DAT_I,
          DAT_O => DAT_O,
          --RST_I => RST_I,
          STB_O => STB_O,
          WE_O => WE_O
        );



   -- Clock process definitions
	gpmc_fclk_proc : process
	begin
		gpmc_fclk <= '0';
		wait for gpmc_fclk_period/2;
		gpmc_fclk <= '1';
		wait for gpmc_fclk_period/2;
	end process;

	sys_clk_proc : process
	begin
		sys_clk_P <= '0';
		wait for sys_clk_period/2;
		sys_clk_P <= '1';
		wait for sys_clk_period/2;
	end process;

--   gpmc_clk_i_proc :process
--   begin
--		gpmc_clk_i <= '0';
--		wait for gpmc_clk_i_period/2;
--		gpmc_clk_i <= '1';
--		wait for gpmc_clk_i_period/2;
--   end process;

   -- Stimulus process
   stim_proc: process
   begin
		report "STARTING STIMULATION" severity NOTE;
		report "---------------------------------------------------------";
		report "Initialising Inputs";
		report "---------------------------------------------------------";
		-- init
		gpmc_n_cs <= "1111111";
		gpmc_n_oe <= '1';
		gpmc_n_we <= '1';
		gpmc_clk_i <= '0';
		gpmc_n_adv_ale <= '1';
		gpmc_a <= (others => '1');
		gpmc_d <= "ZZZZZZZZZZZZZZZZ";

		-- hold reset state for 50 ns.
      wait for 50 ns;

		gpio_in <= "00000000";
      wait for gpmc_fclk_period*10;

		--pull RST high for a cycle
		report "Asserting RST for 20 ns" severity NOTE;
		gpio_in(0) <= '1';
		wait for 5 ns;
		assert RST = '1' report "FAIL: WB RST OUTPUT NOT HIGH" severity ERROR;
		assert RST = '0'  report "__PASS" severity NOTE;
		--wait for gpmc_clk_i_period;
		wait for 20 ns;
		gpio_in(0) <= '0';
		--wait for gpmc_clk_i_period;
		wait for 20 ns;
		report "---------------------------------------------------------";

		------------------------------------------------------------------------
		-- WRITE OPERATION
		-- TAKES 6 GPMC_FCLK CYCLES
		-- GPMC_FCLK IS AN INTERNAL CLK THAT RUNS AT TWICE THE RATE OF GPMC_CLK
		------------------------------------------------------------------------
		report "PERFORMING WRITE OPERATION" severity NOTE;
		report "---------------------------------------------------------";
		report "time 0 - ARM WRITES";
		gpmc_clk_i <= '0';
		gpmc_n_cs <= "1111110";
		gpmc_n_we <= '1';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '1';
		gpmc_a <= ADDRESS_A;
		gpmc_d <= ADDRESS_D;
		wait for gpmc_fclk_period;

		report "time 1";
		gpmc_clk_i <= '0';
		gpmc_n_cs <= "1111110";
		gpmc_n_we <= '1';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '0';
		--gpmc_d <= "0000000000000000";
		wait for gpmc_fclk_period;

		report "time 2 - FPGA READS ADDR";
		gpmc_clk_i <= '1';
		gpmc_n_cs <="1111110";
		gpmc_n_we <= '1';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '0';
		--gpmc_d <= "0000000000000000";
		wait for gpmc_fclk_period;

		report "time 3 - ARM WRITES DATA";
		gpmc_clk_i <= '0';
		gpmc_n_cs <= "1111110";
		gpmc_n_we <= '0';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '1';
		gpmc_d <= DUMMY_DATA; -- data being sent to fpga
		wait for gpmc_fclk_period;

		report "time 4 - FPGA READS DATA";
		gpmc_clk_i <= '1';
		gpmc_n_cs <= "1111110";
		gpmc_n_we <= '0';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '1';
		gpmc_a <= (others => 'X');
		--gpmc_d <= "0000000010100011";
		wait for gpmc_fclk_period;

		report "time 5";
		gpmc_clk_i <= '0';
		gpmc_n_cs <=  "1111111"; -- select nothing
		gpmc_n_we <= '1';
		gpmc_n_oe <= '1';
		gpmc_n_adv_ale <= '1';
		gpmc_a <= (others => 'X');
		gpmc_d <= (others => 'X');
		wait for gpmc_fclk_period;

--		report "time 6";
--		gpmc_clk_i <= '1';
--		gpmc_n_cs <=  "1111111";
--		gpmc_n_we <= '1';
--		gpmc_n_oe <= '1';
--		gpmc_n_adv_ale <= '1';
--		gpmc_a <= (others => '0');
--		gpmc_d <= (others => 'Z');
--		wait for gpmc_fclk_period;

		gpmc_clk_i<= '0';
		report "---------------------------------------------------------";
		wait for gpmc_fclk_period*3;


		------------------------------------------------------------------------
		-- READ OPERATION
		-- TAKES 8 GPMC_FCLK CYCLES
		------------------------------------------------------------------------
		report "READ OPERATION";
		report "---------------------------------------------------------";

		report "time 0 - ARM WRITES ADDRESS";
		gpmc_n_cs <=  "1111110";
		gpmc_a <= ADDRESS_A; -- address 0 (reg_count)
		gpmc_d <= ADDRESS_D;
		wait for gpmc_fclk_period;

		report "time 1";
		gpmc_n_adv_ale <= '0';
		wait for gpmc_fclk_period;

		report "time 2 - FPGA READS ADDRESS";
		gpmc_clk_i <= '1';
		wait for gpmc_fclk_period;

		report "time 3 - ARM RELEASES ADDRESS BUS";
		gpmc_clk_i <= '0';
		gpmc_n_adv_ale <= '1';
		gpmc_n_oe <= '0';
		gpmc_a <= (others => 'X');
		gpmc_d <= (others => 'Z');
		wait for gpmc_fclk_period;

		report "time 4 - FPGA WRITES DATA";
		gpmc_clk_i <= '1';
    DAT_I <= "0000000000000000" & DUMMY_DATA;
		wait for gpmc_fclk_period;
		-- CHECK DATA LINE gpmc_d is correct value stored at location 0000000000
		assert gpmc_d = DUMMY_DATA report "__ERROR: gpmc_d HAS INCORRECT VALUE. IT SHOULD = DUMMY_DATA" severity ERROR;
		assert gpmc_d /= DUMMY_DATA report "__gpmc_d has correct value" severity NOTE;

		report "time 5 - ARM READS DATA";
    --DAT_I <= "00000000000000000000000000000000";
		gpmc_clk_i <= '0';
		gpmc_n_cs <=  "1111111";
		gpmc_n_oe <= '0';
		wait for gpmc_fclk_period;

		report "time 6 - FPGA RELEASES DATA BUS";
		gpmc_clk_i <= '1';
		gpmc_d <= (others => 'Z'); -- check if this is done by vhdl
		wait for gpmc_fclk_period;

		report "time 7";
		gpmc_clk_i <= '0';

		report "---------------------------------------------------------";



		report "END STIMULATION" severity NOTE;
      wait;
   end process;

END;
