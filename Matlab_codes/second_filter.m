%Sampling frequency in the system
fsr = 48000;
N_fft = 1024;

%%%%%%%%%%%%%%%%%%%DEFINING THE FILTER%%%%%%%%%%%%%%%%%%%

%Second BP IIR filter specification
fp_iir2 = [4900 5100];
fs_iir2 = [4500 5500];
ap_iir2 = 1;
as_iir2 = 68.9;

%Minimum IIR filter order calculations, using elliptic approximation
[n_iir2, Wn_iir2] = cheb2ord (fp_iir2/(fsr/2), fs_iir2/(fsr/2), ap_iir2, as_iir2)
%Second BP IIR filter design, using the first elliptic approximaton
[b_iir2, a_iir2] = cheby2 (n_iir2, as_iir2, Wn_iir2)
%Second BP IIR filter amplitude and phase characteristics calculations
[H_iir2 f] = freqz(b_iir2, a_iir2, N_fft, 'whole', fsr);
Ha_iir2 = abs(H_iir2(1:N_fft/2));
Hp_iir2 = 180*unwrap(angle(H_iir2(1:N_fft/2)))/pi;

%Stability and impulse response calculations
nule_iir2 = roots (b_iir2);
polovi_iir2 = roots (a_iir2);
disp ('Polovi funkcije prenosa drugog filtra su:');
disp (polovi_iir2);
%examining whether the poles are located inside the unit circle
if abs (polovi_iir2) < 1
disp ('System is stable.');
else
disp ('System is unstable.');
end
%drawing the position of zeros and poles in relation to the unit circle
figure;
zplane (b_iir2, a_iir2);
%impulse response calculation and drawing
delta_impuls = [1 zeros(1, 5000)];
g_iir2 = filter (b_iir2, a_iir2, delta_impuls);
figure;
stem (0: length(g_iir2)-1, g_iir2) , title ('Second filter impulse response');

%%%%%%%%%%%%%%%%%%%QUANTIZATION OF THE COEFFICIENTS%%%%%%%%%%%%%%%%%%%

c = 1;
num_bits = 38
%Quantization: fixed point, 9.29 format, using rounding, not cutting
struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [num_bits num_bits-9];
q_iir2 = quantizer(struct);
%Quantization
a_iir2_q(c, :) = quantize (q_iir2, a_iir2);
b_iir2_q(c, :) = quantize (q_iir2, b_iir2);
%Quantized second BP IIR filter amplitude and phase characteristics calculations
[H_iir2_q(c, :), f] = freqz(b_iir2_q(c, :), a_iir2_q(c, :), N_fft, 'whole', fsr);
Ha_iir2_q(c, :) = abs(H_iir2_q(c, 1:N_fft/2));
Hp_iir2_q(c, :) = 180*unwrap(angle(H_iir2_q(c, 1:N_fft/2)))/pi;

n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
%Amplitude characteristics drawing
figure;
subplot (1, 1, 1), plot (w, 20*log10(Ha_iir2), 'r', 'LineWidth', 1); axis ([0 fsr/2 -100 10]);
grid on;
hold on;
subplot (1, 1, 1), plot (w, 20*log10(Ha_iir2_q), 'b', 'LineWidth', 1); axis ([0 fsr/2 -100 10]);
grid on;
legend ('Exact value', sprintf ('38 bits (9+29)'), 3);

%Printing the quantized values of a and b
disp (sprintf('Second BP IIR filter quantized a and b coefficients are:'));
disp (sprintf ('   a[i]   b[i]'));
for i = 1 : length (max(a_iir2_q, b_iir2_q))
disp (sprintf (' %6.3f %6.3f ', a_iir2_q(i), b_iir2_q(i)));
end

%Stability and impulse response calculations for the quantized filter
nule_iir2_q = roots (b_iir2_q);
polovi_iir2_q = roots (a_iir2_q);
disp ('Quantized transfer function poles of the second system are:');
disp (polovi_iir2_q);
%examining whether the quantized poles are located inside the unit circle
if abs (polovi_iir2_q) < 1
disp ('System is stable.');
else
disp ('System is unstable.');
end
%drawing the position of quantized zeros and poles in relation to the unit circle
figure;
zplane (b_iir2_q, a_iir2_q);
%quantized filter impulse response calculation
delta_impuls = [1 zeros(1, 5000)];
g_iir2_q = filter (b_iir2_q, a_iir2_q, delta_impuls);
figure;
stem (0: length(g_iir2_q)-1, g_iir2_q) , title ('Quantized second filter impulse response');

%Calculating and drawing the amplitude and phase characteristics of the ideal second filter using FFT
N_fft = 16384;
H_nf2 = fft (g_iir2, N_fft);
Ha_nf2 = abs(H_nf2(1:N_fft/2));
Hp_nf2 = 180*unwrap(angle(H_nf2(1:N_fft/2)))/pi;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
figure
axes ('FontSize', 14);
plot (w, 20*log10(Ha_nf2), 'r', 'LineWidth', 2);

%%%%%%%%%%%%%%%%%%%%%SIMULINK%%%%%%%%%%%%%%%%%%%%%%%%

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

%dirac impulse
u = [1 zeros(1, 15000)];

%sine signal
f1 = 3000;
f0 = 1000;
u1 = sin(2*pi*n*f1/fsr) + sin(2*pi*n*f0/fsr);
%determining the response to a sine imput
y1 = filter (b_iir2, a_iir2, u);

%defining a specific signal for the needs of Simulink simulation
u_sim = [n;u]';

%RESPONSE IN SIMULINK
figure;
stem (0: length(simout)-1, simout) , title ('Second filter impulse response in Simulink');

%Scaled simulink impulse response, to convert it to unsigned, for the needs of VHDL model 
g_scale = simout*(2^37);

%Amplitude and phase characteristics of the ideal filter using FFT
N_fft = 16384;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
G_iir2 = fft (g_iir2, N_fft);
Ga_iir2 = abs(G_iir2(1:N_fft/2));
Gp_iir2 = 180*unwrap(angle(G_iir2(1:N_fft/2)))/pi;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));

%Amplitude and phase characteristics of the ideal filter using transposed form
N_fft = 16384;
G_tran_q_iir2 = fft (simout, N_fft);
Ga_tran_q_iir2 = abs(G_tran_q_iir2(1:N_fft/2));
Gp_tran_q_iir2 = 180*unwrap(angle(G_tran_q_iir2(1:N_fft/2)))/pi;

%Drawing the amplitude and phase characteristics
figure
axes ('FontSize', 14);
plot (w, 20*log10(Ga_iir2), 'r', 'LineWidth', 2);
hold on;
plot (w, 20*log10(Ga_tran_q_iir2), '--b', 'LineWidth', 2);
title ('Amplitude characteristics');
legend ('Exact value', 'Transposed realization');
grid on;

%%%%%%%%%%%%%%%%%COEFFICIENT BINARY CODING%%%%%%%%%%%%%%%%%

%dec2bin uses only positive integers, so we take the abs of a coefficient,
%and code it, if the coefficient is negative, we find the second compliment
koef_q = dec2bin(round(7.002792846443432e-04* 2^29), 38);
koef_q
