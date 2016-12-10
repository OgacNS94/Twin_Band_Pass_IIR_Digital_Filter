library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity expand is
	port(
		
			in1:	in  std_logic_vector (23 downto 0); --FORMAT 1.23
			out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

		);
end entity expand;

architecture behavioral of expand is

begin

	out1 <= in1&"00000000000000";

end architecture behavioral;