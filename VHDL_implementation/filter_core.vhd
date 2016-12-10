library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity filter_core is
	port(
		
			clk:	in std_logic;
			ce: 	in std_logic;
			rst: 	in std_logic;
			sample_in:	in  std_logic_vector (23 downto 0); --FORMAT 1.23
			sample_out:	out std_logic_vector (23 downto 0)  --FORMAT 1.23
			

		);
end entity filter_core;

architecture structural of filter_core is

	COMPONENT full_filter_core
	PORT(
		clk:	in std_logic;
		ce: 	in std_logic;
		rst: 	in std_logic;
		sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

		);
	END COMPONENT;
	
	COMPONENT expand
	PORT(		
		in1:	in  std_logic_vector (23 downto 0); --FORMAT 1.23
		out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

	);
	END COMPONENT;
	
	COMPONENT cutter
	PORT(
		in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		out1:	out std_logic_vector (23 downto 0)  --FORMAT 1.23

	);
	END COMPONENT;

	signal sexp, sfullf: std_logic_vector(37 downto 0) := X"000000000"&"00";
	signal scut: std_logic_vector(23 downto 0) := X"000000";

begin

	FULL_FILTER: full_filter_core PORT MAP (

			clk => clk,
			ce => ce,
			rst => rst,
			sample_in => sexp,
			sample_out => sfullf

		);

	EXP: expand PORT MAP (

			in1 => sample_in,
			out1 => sexp

		);
		
	CUT: cutter PORT MAP (

			in1 => sfullf,
			out1 => scut

		);

	sample_out <= scut;

end architecture structural;