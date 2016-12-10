library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity shifter is
	port(
		
			clk:	in std_logic;
			clk_en: in std_logic;
			reset:  in std_logic;
			in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
		);
end entity shifter;

architecture behavioral of shifter is

begin

	process (clk, reset) is
	begin

		if (reset = '1') then

			if (clk='1' and clk'event) then

				if (clk_en = '1') then

					out1 <= in1;

				end if;

			end if;

		else
			
			out1 <= X"000000000"&"00";

		end if;

	end process;

end architecture behavioral;