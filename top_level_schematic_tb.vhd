-- Vhdl test bench created from schematic /home/brad/Dropbox/2016/Thesis/rhino/WISHBONE_GPMC/top_level_schematic.sch - Fri Sep 30 13:07:57 2016
--
-- Notes:
-- 1) This testbench template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the unit under test.
-- Xilinx recommends that these types always be used for the top-level
-- I/O of a design in order to guarantee that the testbench will bind
-- correctly to the timing (post-route) simulation model.
-- 2) To use this template as your testbench, change the filename to any
-- name of your choice with the extension .vhd, and use the "Source->Add"
-- menu in Project Navigator to import the testbench. Then
-- edit the user defined section below, adding code to generate the
-- stimulus for your design.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
LIBRARY UNISIM;
USE UNISIM.Vcomponents.ALL;
ENTITY top_level_schematic_top_level_schematic_sch_tb IS
END top_level_schematic_top_level_schematic_sch_tb;
ARCHITECTURE behavioral OF top_level_schematic_top_level_schematic_sch_tb IS

   COMPONENT top_level_schematic
   PORT( gpmc_clk_i	:	IN	STD_LOGIC;
          gpmc_n_we	:	IN	STD_LOGIC;
          gpmc_n_oe	:	IN	STD_LOGIC;
          gpmc_n_adv_ale	:	IN	STD_LOGIC;
          sys_clk_P	:	IN	STD_LOGIC;
          gpmc_a	:	IN	STD_LOGIC_VECTOR (10 DOWNTO 1);
          gpmc_n_cs	:	IN	STD_LOGIC_VECTOR (6 DOWNTO 0);
          gpio_in	:	IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
          gpmc_d	:	INOUT	STD_LOGIC_VECTOR (15 DOWNTO 0);
          gpio_o	:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
          PRT_O	:	OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);
          DAT_I	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 8));
   END COMPONENT;

   SIGNAL gpmc_clk_i	:	STD_LOGIC;
   SIGNAL gpmc_n_we	:	STD_LOGIC;
   SIGNAL gpmc_n_oe	:	STD_LOGIC;
   SIGNAL gpmc_n_adv_ale	:	STD_LOGIC;
   SIGNAL sys_clk_P	:	STD_LOGIC;
   SIGNAL gpmc_a	:	STD_LOGIC_VECTOR (10 DOWNTO 1);
   SIGNAL gpmc_n_cs	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
   SIGNAL gpio_in	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL gpmc_d	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
   SIGNAL gpio_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL PRT_O	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
   SIGNAL DAT_I	:	STD_LOGIC_VECTOR (31 DOWNTO 8);

  signal gpmc_fclk : std_logic; -- runs at 2x speed of gpmc_clk
  -- Clock period definitions
  constant gpmc_fclk_period : time := 20 ns;
  constant sys_clk_period		: time := 5 ns;


  -- Constants for dummy data
	constant ADDRESS_A 	: std_logic_vector (9 downto 0)	:= "0000000000"; -- address 0 (reg_count)
	constant ADDRESS_D 	: std_logic_vector (15 downto 0) := "0000000000000000";
	constant ADDRESS		: std_logic_vector (25 downto 0) := ADDRESS_A & ADDRESS_D;
	constant DUMMY_DATA	: std_logic_vector (15 downto 0) := "0000000010100011";

BEGIN

   UUT: top_level_schematic PORT MAP(
		gpmc_clk_i => gpmc_clk_i,
		gpmc_n_we => gpmc_n_we,
		gpmc_n_oe => gpmc_n_oe,
		gpmc_n_adv_ale => gpmc_n_adv_ale,
		sys_clk_P => sys_clk_P,
		gpmc_a => gpmc_a,
		gpmc_n_cs => gpmc_n_cs,
		gpio_in => gpio_in,
		gpmc_d => gpmc_d,
		gpio_o => gpio_o,
		PRT_O => PRT_O,
		DAT_I => DAT_I
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

	tb : PROCESS
	BEGIN
		sys_clk_P <= '0';
		wait for sys_clk_period/2;
		sys_clk_P <= '1';
		wait for sys_clk_period/2;
	end process;

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
		 DAT_I <= (others => '0');
     -- hold reset state for 50 ns.
       wait for 50 ns;

     gpio_in <= "00000000";
       wait for gpmc_fclk_period*10;

     --pull RST high for a cycle
     report "Asserting RST for 20 ns" severity NOTE;
     gpio_in(0) <= '1';
     wait for 5 ns;
     --assert RST = '1' report "FAIL: WB RST OUTPUT NOT HIGH" severity ERROR;
     --assert RST = '0'  report "__PASS" severity NOTE;
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
     --DAT_I <= "000000000000000000000000";
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

      WAIT; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
