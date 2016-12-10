library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder_2_in is
	port(
		
			in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			in2:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

		);
end entity adder_2_in;

architecture behavioral of adder_2_in is

	signal tmp1 : std_logic_vector(38 downto 0);

begin

	tmp1 <= std_logic_vector(signed(in1(37)&in1) + signed(in1(37)&in2)); --FORMAT 2.37, FILL UP WITH SIGN
	out1 <= tmp1(37 downto 0); --TAKE ONLY 1 LSB FROM THE INT PART AND 37 MSB FROM THE REAL PART, NO CARRY

end architecture behavioral;