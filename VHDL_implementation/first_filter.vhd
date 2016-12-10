library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity first_filter_core is
	port(
		
--			--test signals
--			
--			s1t, s2t, s3t, s4t, s5t, s6t, s7t, s8t, s9t, s10t, s11t, s12t, s13t, s14t, s15t, s16t, s17t: out std_logic_vector(37 downto 0);
--		
			--regular outputs
		
			clk:	in std_logic;
			ce: 	in std_logic;
			rst: 	in std_logic;
			sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
			

		);
end entity first_filter_core;

architecture structural of first_filter_core is

	COMPONENT shifter
	PORT(
		clk:	in std_logic;
		clk_en: in std_logic;
		reset:  in std_logic;
		in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

		);
	END COMPONENT;


	COMPONENT adder_2_in
	PORT(	
		in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		in2:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37

	);
	END COMPONENT;

	COMPONENT adder_3_in
	PORT(	
		in1:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		in2:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		in3:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
		out1:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
		
	);
	END COMPONENT;

	COMPONENT gain_iir1
	PORT(	
		in1:	in  std_logic_vector (37 downto 0);    --FORMAT 1.37
		gain:	in  std_logic_vector (37 downto 0);    --FORMAT 9.29, GAIN INPUT
		out1:		out std_logic_vector (37 downto 0) --FORMAT 1.37
		
	);
	END COMPONENT;

	signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18: std_logic_vector(37 downto 0) := X"000000000"&"00";

begin

	SHIFTER1: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s16,
			out1 => s17

		);

	SHIFTER2: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s13,
			out1 => s14

		);

	SHIFTER3: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s10,
			out1 => s11

		);
	
	SHIFTER4: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s7,
			out1 => s8

		);

	ADDER1: adder_2_in PORT MAP (	

			in1 => s1,
			in2 => s17,
			out1 => s18

	);

	ADDER2: adder_3_in PORT MAP (	
		
			in1 => s2,
			in2 => s14,
			in3 => s15,
			out1 => s16
		
	);

	ADDER3: adder_3_in PORT MAP (	

			in1 => s3,
			in2 => s11,
			in3 => s12,
			out1 => s13

	);

	ADDER4: adder_3_in PORT MAP (	

			in1 => s4,
			in2 => s8,
			in3 => s9,
			out1 => s10

	);

	ADDER5: adder_2_in PORT MAP (	
		
			in1 => s5,
			in2 => s6,
			out1 => s7
		
	);

	GAINB0: gain_iir1 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000001101000011000101011",
			out1 => s1
		
	);

	GAINB1: gain_iir1 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111001100011111111101010",
			out1 => s2
		
	);

	GAINB2: gain_iir1 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000001001100111010001010001",
			out1 => s3
		
	);

	GAINB3: gain_iir1 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111001100011111111101010",
			out1 => s4
		
	);

	GAINB4: gain_iir1 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000001101000011000101011",
			out1 => s5
		
	);

	GAINA1: gain_iir1 PORT MAP (	
		
			in1 => s18,
			gain => "00000001111110110001001010101101000011",
			out1 => s15
		
	);

	GAINA2: gain_iir1 PORT MAP (	
		
			in1 => s18,
			gain => "11111101000010100101101110001111000100",
			out1 => s12
		
	);

	GAINA3: gain_iir1 PORT MAP (	
		
			in1 => s18,
			gain => "00000001111110011111101101001110110100",
			out1 => s9
		
	);

	GAINA4: gain_iir1 PORT MAP (	
		
			in1 => s18,
			gain => "11111111100000001000110011100011100111",
			out1 => s6
		
	);

	sample_out <= s18;
--	s1t <= s1;
--	s2t <= s2;
--	s3t <= s3; 
--	s4t <= s4;
--	s5t <= s5;
--	s6t <= s6;
--	s7t <= s7;
--	s8t <= s8;
--	s9t <= s9;
--	s10t <= s10;
--	s11t <= s11;
--	s12t <= s12;
--	s13t <= s13;
--	s14t <= s14;
--	s15t <= s15;
--	s16t <= s16;
--	s17t <= s17;

end architecture structural;