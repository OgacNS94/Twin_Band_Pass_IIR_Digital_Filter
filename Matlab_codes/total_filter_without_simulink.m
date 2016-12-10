%TOTAL FILTER
fsr = 48000;
N_fft = 1024;

%%%%%%%%%%%%%%%%%%%DEFINING THE FIRST FILTER%%%%%%%%%%%%%%%%%%%

%First BP IIR filter specification
fp_iir1 = [985 1015];
fs_iir1 = [500 1500];
ap_iir1 = 1;
as_iir1 = 62;

%Minimum IIR filter order calculations, using elliptic approximation
[n_iir1, Wn_iir1] = ellipord (fp_iir1/(fsr/2), fs_iir1/(fsr/2), ap_iir1, as_iir1)
%First BP IIR filter design, using the first elliptic approximaton
[b_iir1, a_iir1] = ellip (n_iir1, ap_iir1, as_iir1, Wn_iir1)
%First BP IIR filter amplitude and phase characteristics calculations 
[H_iir1 f] = freqz(b_iir1, a_iir1, N_fft, 'whole', fsr);
Ha_iir1 = abs(H_iir1(1:N_fft/2));
Hp_iir1 = 180*unwrap(angle(H_iir1(1:N_fft/2)))/pi;

%%%%%%%%%%%%%%%%%%%QUANTIZATION OF THE COEFFICIENTS%%%%%%%%%%%%%%%%%%%

c = 1;
num_bits = 38
%Quantization: fixed point, 9.29 format, using rounding, not cutting
struct.mode = 'fixed';
struct.roundmode = 'round';
struct.overflowmode = 'saturate';
struct.format = [num_bits num_bits-9];
q_iir1 = quantizer(struct);
%Quantization
a_iir1_q(c, :) = quantize (q_iir1, a_iir1);
b_iir1_q(c, :) = quantize (q_iir1, b_iir1);
%Quantized first BP IIR filter amplitude and phase characteristics calculations 
[H_iir1_q(c, :), f] = freqz(b_iir1_q(c, :), a_iir1_q(c, :), N_fft, 'whole', fsr);
Ha_iir1_q(c, :) = abs(H_iir1_q(c, 1:N_fft/2));
Hp_iir1_q(c, :) = 180*unwrap(angle(H_iir1_q(c, 1:N_fft/2)))/pi;

n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
%Amplitude characteristics drawing
figure;
subplot (1, 1, 1), plot (w, 20*log10(Ha_iir1), 'r', 'LineWidth', 1); axis ([0 fsr/2 -100 10]);
grid on;
hold on;
subplot (1, 1, 1), plot (w, 20*log10(Ha_iir1_q), 'b', 'LineWidth', 1); axis ([0 fsr/2 -100 10]);
grid on;
legend ('Exact value', sprintf ('38 bits (9+29)'), 3);

%quantized filter impulse response calculation 
delta_impuls = [1 zeros(1, 15000)];
g_iir1_q = filter (b_iir1_q, a_iir1_q, delta_impuls);
figure;
stem (0: length(g_iir1_q)-1, g_iir1_q) , title ('Quantized first filter impulse response');

%%%%%%%%%%%%%%%%%%%DEFINING THE SECOND FILTER%%%%%%%%%%%%%%%%%%%

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

%quantized filter impulse response calculation
delta_impuls = [1 zeros(1, 15000)];
g_iir2_q = filter (b_iir2_q, a_iir2_q, delta_impuls);
figure;
stem (0: length(g_iir2_q)-1, g_iir2_q) , title ('Quantized second filter impulse response');

%%%%%%%%%%%%%%%%%%%DEFINING THE TOTAL FILTER%%%%%%%%%%%%%%%%%%%

g_uk_q = g_iir1_q + g_iir2_q;
g_scale = g_uk_q*(2^23);
figure;
stem (0: length(g_uk_q)-1, g_uk_q) , title ('Impulsni odziv kvantizovanog ukupnog filtra');

%Calculating and drawing the amplitude and phase characteristics of the quantized total filter using FFT
N_fft = 16384;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
G_uk = fft (g_uk_q, N_fft);
Ga_uk = abs(G_uk(1:N_fft/2));
Gp_uk = 180*unwrap(angle(G_uk(1:N_fft/2)))/pi;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));

%Drawing the amplitude and phase characteristics
figure
axes ('FontSize', 14);
plot (w, 20*log10(Ga_uk), 'r', 'LineWidth', 2);
title ('Amplitude characteristics');
legend ('Exact value');
grid on;