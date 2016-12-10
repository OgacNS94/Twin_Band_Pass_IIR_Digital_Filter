%Sampling frequency in the system
fsr = 48000;
N_fft = 1024;

%%%%%%%%%%%%%%%%%%%DEFINING THE FILTER%%%%%%%%%%%%%%%%%%%

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

%Stability and impulse response calculations
nule_iir1 = roots (b_iir1);
polovi_iir1 = roots (a_iir1);
disp ('Transfer function poles of the first system are:');
disp (polovi_iir1);
%examining whether the poles are located inside the unit circle
if abs (polovi_iir1) < 1
disp ('System is stable.');
else
disp ('System is unstable.');
end
%drawing the position of zeros and poles in relation to the unit circle
figure;
zplane (b_iir1, a_iir1);
%impulse response calculation and drawing
delta_impuls = [1 zeros(1, 15000)];
g_iir1 = filter (b_iir1, a_iir1, delta_impuls);
figure;
stem (0: length(g_iir1)-1, g_iir1) , title ('First filter impulse response');

%%%%%%%%%%%%%%%%%%%QUANTIZATION OF THE COEFFICIENTS%%%%%%%%%%%%%%%

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

%Printing the quantized values of a and b
disp (sprintf('First BP IIR filter quantized a and b coefficients are:'));
disp (sprintf ('   a[i]   b[i]'));
for i = 1 : length (max(a_iir1, b_iir1))
disp (sprintf (' %6.3f %6.3f ', a_iir1_q(i), b_iir1_q(i)));
end

%Stability and impulse response calculations for the quantized filter
nule_iir1_q = roots (b_iir1_q);
polovi_iir1_q = roots (a_iir1_q);
disp ('Quantized transfer function poles of the first system are:');
disp (polovi_iir1_q);
%examining whether the quantized poles are located inside the unit circle
if abs (polovi_iir1_q) < 1
disp ('System is stable.');
else
disp ('System is unstable.');
end
%drawing the position of quantized zeros and poles in relation to the unit circle
figure;
zplane (b_iir1_q, a_iir1_q);
%quantized filter impulse response calculation 
delta_impuls = [1 zeros(1, 15000)];
g_iir1_q = filter (b_iir1_q, a_iir1_q, delta_impuls);
figure;
stem (0: length(g_iir1_q)-1, g_iir1_q) , title ('Quantized first filter impulse response');

%Calculating and drawing the amplitude and phase characteristics of the ideal first filter using FFT
N_fft = 16384;
H_nf2 = fft (g_iir1, N_fft);
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
u = [1 zeros(1, 15000)];

f1 = 3000;
f0 = 1000;
u1 = sin(2*pi*n*f1/fsr) + sin(2*pi*n*f0/fsr);
%determining the response to a sine imput
y1 = filter (b_iir1, a_iir1, u1);

%defining a specific signal for the needs of Simulink simulation
u_sim = [n;u]';

%RESPONSE IN SIMULINK
figure;
stem (0: length(simout)-1, simout) , title ('First filter impulse response in Simulink');

%Scaled simulink impulse response, to convert it to unsigned, for the needs of VHDL model 
g_scale = simout*(2^37);

%Amplitude and phase characteristics of the ideal filter using FFT
N_fft = 16384;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));
G_iir1 = fft (g_iir1, N_fft);
Ga_iir1 = abs(G_iir1(1:N_fft/2));
Gp_iir1 = 180*unwrap(angle(G_iir1(1:N_fft/2)))/pi;
n = 0:N_fft/2-1;
w = n*fsr/(2*(N_fft/2-1));

%Amplitude and phase characteristics of the ideal filter using transposed form
N_fft = 16384;
G_dir_q_iir1 = fft (simout, N_fft);
Ga_dir_q_iir1 = abs(G_dir_q_iir1(1:N_fft/2));
Gp_dir_q_iir1 = 180*unwrap(angle(G_dir_q_iir1(1:N_fft/2)))/pi;

%Drawing the amplitude and phase characteristics
figure
axes ('FontSize', 14);
plot (w, 20*log10(Ga_iir1), 'r', 'LineWidth', 2);
hold on;
plot (w, 20*log10(Ga_dir_q_iir1), '--b', 'LineWidth', 2);
title ('Amplitude characteristics');
legend ('Exact value', 'Transposed realization');
grid on;

%%%%%%%%%%%%%%%%COEFFICIENT BINARY CODING%%%%%%%%%%%%%%%%%

%dec2bin uses only positive integers, so we take the abs of a coefficient,
%and code it, if the coefficient is negative, we find the second compliment
koef_q = dec2bin(round(1* 2^37), 38);
koef_q
