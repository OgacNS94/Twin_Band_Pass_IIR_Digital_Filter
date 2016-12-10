library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity second_filter_core is
	port(
		
--			--test signals
--			
--			s1t, s2t, s3t, s4t, s5t, s6t, s7t, s8t, s9t, s10t, s11t, s12t, s13t, s14t, s15t, s16t, s17t, s18t, s19t, s20t: out std_logic_vector(37 downto 0);
--			s21t, s22t, s23t, s24t, s25t, s26t, s27t, s28t, s29t, s30t, s31t, s32t, s33t, s34t, s35t, s36t, s37t, s38t, s39t, s40t, s41t: out std_logic_vector(37 downto 0);
--		
			--regular outputs
		
			clk:	in std_logic;
			ce: 	in std_logic;
			rst: 	in std_logic;
			sample_in:	in  std_logic_vector (37 downto 0); --FORMAT 1.37
			sample_out:	out std_logic_vector (37 downto 0)  --FORMAT 1.37
			

		);
end entity second_filter_core;

architecture structural of second_filter_core is

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

	COMPONENT gain_iir2
	PORT(	
		in1:	in  std_logic_vector (37 downto 0);    --FORMAT 1.37
		gain:	in  std_logic_vector (37 downto 0);    --FORMAT 9.29, GAIN INPUT
		out1:		out std_logic_vector (37 downto 0) --FORMAT 1.37
		
	);
	END COMPONENT;

	signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20: std_logic_vector(37 downto 0) := X"000000000"&"00";
	signal s21, s22, s23, s24, s25, s26, s27, s28, s29, s30, s31, s32, s33, s34, s35, s36, s37, s38, s39, s40, s41, s42: std_logic_vector(37 downto 0) := X"000000000"&"00";

begin

	SHIFTER1: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s40,
			out1 => s41

		);

	SHIFTER2: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s37,
			out1 => s38

		);

	SHIFTER3: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s34,
			out1 => s35

		);
	
	SHIFTER4: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s31,
			out1 => s32

		);

	SHIFTER5: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s28,
			out1 => s29

		);

	SHIFTER6: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s25,
			out1 => s26

		);

	SHIFTER7: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s22,
			out1 => s23

		);

	SHIFTER8: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s19,
			out1 => s20

		);

	SHIFTER9: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s16,
			out1 => s17

		);

	SHIFTER10: shifter PORT MAP (

			clk => clk,
			clk_en => ce,
			reset => rst,
			in1 => s13,
			out1 => s14

		);

	ADDER1: adder_2_in PORT MAP (	

			in1 => s1,
			in2 => s41,
			out1 => s42

	);

	ADDER2: adder_3_in PORT MAP (	
		
			in1 => s2,
			in2 => s38,
			in3 => s39,
			out1 => s40
		
	);

	ADDER3: adder_3_in PORT MAP (	

			in1 => s3,
			in2 => s35,
			in3 => s36,
			out1 => s37

	);

	ADDER4: adder_3_in PORT MAP (	

			in1 => s4,
			in2 => s32,
			in3 => s33,
			out1 => s34

	);

	ADDER5: adder_3_in PORT MAP (	

			in1 => s5,
			in2 => s29,
			in3 => s30,
			out1 => s31

	);

	ADDER6: adder_3_in PORT MAP (	

			in1 => s6,
			in2 => s26,
			in3 => s27,
			out1 => s28

	);

	ADDER7: adder_3_in PORT MAP (	

			in1 => s7,
			in2 => s23,
			in3 => s24,
			out1 => s25

	);

	ADDER8: adder_3_in PORT MAP (	

			in1 => s8,
			in2 => s20,
			in3 => s21,
			out1 => s22

	);

	ADDER9: adder_3_in PORT MAP (	

			in1 => s9,
			in2 => s17,
			in3 => s18,
			out1 => s19

	);

	ADDER10: adder_3_in PORT MAP (	

			in1 => s10,
			in2 => s14,
			in3 => s15,
			out1 => s16

	);

	ADDER11: adder_2_in PORT MAP (	
		
			in1 => s11,
			in2 => s12,
			out1 => s13
		
	);

	GAINB0: gain_iir2 PORT MAP (	
		
			in1 => sample_in,

			gain => "00000000000000000000001110100011100000",
			out1 => s1
		
	);

	GAINB1: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111110100100001101101000",
			out1 => s2
		
	);

	GAINB2: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000100000100010110111010",
			out1 => s3
		
	);

	GAINB3: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111001100101011100111001",
			out1 => s4
		
	);

	GAINB4: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000101001110110011010101",
			out1 => s5
		
	);

	GAINB5: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000000000000000000000000",
			out1 => s6
		
	);

	GAINB6: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111010110001001100101011",
			out1 => s7
		
	);

	GAINB7: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000110011010100011000111",
			out1 => s8
		
	);

	GAINB8: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111011111011101001000110",
			out1 => s9
		
	);

	GAINB9: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "00000000000000000001011011110010011000",
			out1 => s10
		
	);

	GAINB10: gain_iir2 PORT MAP (	
		
			in1 => sample_in,
			gain => "11111111111111111111110001011100100000",
			out1 => s11
		
	);

	GAINA1: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "00000011111010100111100101100011100011",
			out1 => s39
		
	);

	GAINA2: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "11110001010011100111010010111010110100",
			out1 => s36
		
	);

	GAINA3: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "00100010011010101000101110111001001000",
			out1 => s33
		
	);

	GAINA4: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "11001000100001101000010110000100000110",
			out1 => s30
		
	);

	GAINA5: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "01000000001001000101110000100100000011",
			out1 => s27
		
	);

	GAINA6: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "11001010001010000111010010000100000011",
			out1 => s24
		
	);

	GAINA7: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "00100000011010111001101101001101011111",
			out1 => s21
		
	);

	GAINA8: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "11110010100100001101111110010001110100",
			out1 => s18
		
	);

	GAINA9: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "00000011011110011001001101000100001000",
			out1 => s15
		
	);

	GAINA10: gain_iir2 PORT MAP (	
		
			in1 => s42,
			gain => "11111111100100011100001000000001000111",
			out1 => s12
			
	);

	sample_out <= s42;
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
--	s18t <= s18;
--	s19t <= s19;
--	s20t <= s20;
--	s21t <= s21;
--	s22t <= s22;
--	s23t <= s23;
--	s24t <= s24;
--	s25t <= s25;
--	s26t <= s26;
--	s27t <= s27;
--	s28t <= s28;
--	s29t <= s29;
--	s30t <= s30;
--	s31t <= s31;
--	s32t <= s32;
--	s33t <= s33;
--	s34t <= s34;
--	s35t <= s35;
--	s36t <= s36;
--	s37t <= s37;
--	s38t <= s38;
--	s39t <= s39;
--	s40t <= s40;
--	s41t <= s41;

end architecture structural;