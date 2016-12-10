%TOTAL FILTER

%Sampling frequency in the system
fsr = 48000;

%%%%%%%%%%%%%%%%%%%%%SIMULINK%%%%%%%%%%%%%%%%%%%%%%%%

%ODREÐIVANJE POLOŽAJA TAÈKE U SIMULINKU

%DETERMINING FIXED POINT APPROXIMATION FORMAT

%Signal representation
%Number of bits (total)
x=38;
%Number of bits (for the fraction part)
y=37;

%Gain coefficients representation
%Number of bits (total)
j=38;
%Number of bits (for the fraction part)
k=29;

%descrete time
n = 0:15000;
%defining input signals

%dirac impulse, but multiplied with a constant, because the input in VHDL
%is 24 bits long (fromat 1.24), which an expand blox expands by adding
%zeros to lsb places. So when we excite the filter with X"7FFFFF", the
%expand block expands it to X"7FFFFF000"&"00", but still that is very close
%to 1 in decimal, so the constant we multiply is 1
u = [1 zeros(1, 15000)];

%defining a specific signal for the needs of Simulink simulation
u_sim = [n;u]';

%RESPONSE IN SIMULINK
figure;
stem (0: length(simout)-1, simout) , title ('Total filter impulse response in simulink');

%Scaled simulink impulse response, to convert it to unsigned, for the needs of VHDL model 
g_scale = simout*(2^23);

%Amplitude and phase characteristics of the ideal filter using transposed form
N_fft = 16384;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
G_tran_q_iir2 = fft (simout, N_fft);
Ga_tran_q_iir2 = abs(G_tran_q_iir2(1:N_fft/2));
Gp_tran_q_iir2 = 180*unwrap(angle(G_tran_q_iir2(1:N_fft/2)))/pi;

%Drawing the amplitude and phase characteristics
figure
plot (w, 20*log10(Ga_tran_q_iir2), 'b', 'LineWidth', 2);
title ('Amplitude characteristics');
legend ('Transposed form');
grid on;