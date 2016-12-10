library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity full_filter_core is
	port(
		
			clk:	in std_logic;
			ce: 	in std_logic;
			rst: 	in std_logic;
			sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
			

		);
end entity full_filter_core;

architecture structural of full_filter_core is

	COMPONENT first_filter_core
	PORT(
		clk:	in std_logic;
		ce: 	in std_logic;
		rst: 	in std_logic;
		sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

		);
	END COMPONENT;

	COMPONENT second_filter_core
	PORT(	
		clk:	in std_logic;
		ce: 	in std_logic;
		rst: 	in std_logic;
		sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
		
		);
	END COMPONENT;

	COMPONENT adder_2_in
	PORT(	
		in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		in2:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

	);
	END COMPONENT;

	signal sf1o, sf2o, sfuko: std_logic_vector(37 downto 0) := X"000000000"&"00";

begin

	FIRST_FILTER: first_filter_core PORT MAP (

			clk => clk,
			ce => ce,
			rst => rst,
			sample_in => sample_in,
			sample_out => sf1o

		);

	SECOND_FILTER: second_filter_core PORT MAP (

			clk => clk,
			ce => ce,
			rst => rst,
			sample_in => sample_in,
			sample_out => sf2o

		);

	ADDER: adder_2_in PORT MAP (	

			in1 => sf1o,
			in2 => sf2o,
			out1 => sfuko

	);

	sample_out <= sfuko;

end architecture structural;