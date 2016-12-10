LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY filter_core_tb IS
END filter_core_tb;
 
ARCHITECTURE behavior OF filter_core_tb IS 
 
    COMPONENT filter_core
    PORT(
   
        clk:  in std_logic;
        ce:   in std_logic;
        rst:  in std_logic;
        sample_in:  in  std_logic_vector (23 downto 0); --FORMAT 2.30
        sample_out: out std_logic_vector (23 downto 0)  --FORMAT 2.30

      );
    END COMPONENT;
    

   --Inputs
   signal clk_s: std_logic := '0';
   signal ce_s:  std_logic := '0';
   signal rst_s: std_logic := '0';
   signal sample_in_s: std_logic_vector (23 downto 0) := X"000000";

   --Outputs
   signal sample_out_s: std_logic_vector (23 downto 0) := X"000000";
   
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: filter_core PORT MAP (

          clk => clk_s,
          ce => ce_s,
          rst => rst_s,
          sample_in => sample_in_s,
          sample_out => sample_out_s

        ); 

   -- CLK PROCESS
   process is
   begin

      clk_s <= '0', '1' after 100 ns;
      wait for 200 ns;

   end process;

   -- Stimulus process
   stim_proc: process
   begin        
      
      rst_s <= '0', '1' after 200 ns;
      ce_s <= '1';
      sample_in_s <= X"000000", X"7FFFFFF" after 250 ns, X"000000" after 350 ns;
        
      wait;
   end process;

END;