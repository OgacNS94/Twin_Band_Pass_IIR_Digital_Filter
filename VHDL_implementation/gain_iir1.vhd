library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gain_iir1 is
	port(
			
			in1:	in  std_logic_vector (37 downto 0);    --FORMAT 1.37
			gain:	in  std_logic_vector (37 downto 0);    --FORMAT 9.29, GAIN INPUT
			out1:		out std_logic_vector (37 downto 0) --FORMAT 1.37

		);
end entity gain_iir1;

architecture behavioral of gain_iir1 is

	signal tmp1 : signed(75 downto 0);
	signal tmp2: std_logic_vector(38 downto 0);
	signal tmp3 : std_logic_vector(38 downto 0) := X"000000000"&"001";

begin

	tmp1 <= signed(gain)*signed(in1); --FORMAT 10.66
	tmp2 <= std_logic_vector(tmp1(66 downto 28) + signed(tmp3)); --TAKE ONLY 1 LSB FROM THE INT PART AND 38 MSB FROM THE REAL PART, ADD 1 FOR ROUNDING
	out1 <= tmp2(38 downto 1); --CUT OFF THE LSB FOR ROUNDING

end architecture behavioral;

