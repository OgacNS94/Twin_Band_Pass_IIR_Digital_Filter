# Twin_Band_Pass_IIR_Digital_Filter

A digital IIR filter, designed using Matlab and implemented in VHDL.

The filter has the following entity:

entity filter_core is
    port (  sample_in  : in   std_logic_vector (23 downto 0);
            sample_out : out  std_logic_vector (23 downto 0);
            clk        : in   std_logic;
            ce         : in   std_logic;
            rst        : in   std_logic);
end filter_core;

Sampling frequency is 48000 kHz.
The filter has two pass frequencies: 1000 Hz i 5000 Hz.
Frequencies up to 500 Hz, between 1500 Hz and 4500 Hz and above 5500 Hz
are suppressed by 60 dB.
