library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cutter is
	port(
		
			in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			out1:	out std_logic_vector (23 downto 0)  --FORMAT 1.23

		);
end entity cutter;

architecture behavioral of cutter is

	signal tmp1 : std_logic_vector(24 downto 0);
	signal tmp2 : std_logic_vector(24 downto 0) := X"000000"&'1';

begin

	tmp1 <= std_logic_vector(signed(in1(37 downto 13)) + signed(tmp2)); --TAKE ONLY 1 LSB FROM THE INT PART AND 24 MSB FROM THE REAL PART, ADD 1 FOR ROUNDING
	out1 <= tmp1(24 downto 1); --CUT OFF THE LSB FOR ROUNDING

end architecture behavioral;