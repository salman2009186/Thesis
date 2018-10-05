NFFT = 8192;
fs   = 48000;

fp1 = 200;  fp1 = 400;  
cp1 = 0.99486; cp1 = 0.970486;
fz1 = 400;  fz1 = 600;  
cz1 = 0.91985;
max_seen_mag_dB = 12.14;    %for looking at the original, make this 0
g_norm  = 10^(-max_seen_mag_dB/20);%4

z1      = cz1*exp(1i*2*pi*fz1/fs);
p1      = cp1*exp(1i*2*pi*fp1/fs);
b_vec      = poly([z1 conj(z1)])*g_norm;
a_vec      = poly([p1 conj(p1)]);
minus_a_vec= -a_vec;
ir      = impz(b_vec,a_vec,NFFT,48000);

fw  = fs/2*linspace(0,1,NFFT/2+1);
IR   = fft(ir,NFFT);
figure;
subplot(2,1,1)
semilogx(fw,20*log10(abs(IR(1:NFFT/2+1))))
grid on
xlim([20,20000])
xlabel('Frequency in Hz')
ylabel('Amplitude in dB')
subplot(2,1,2)
semilogx(fw,180/pi*(angle(IR(1:NFFT/2+1))))
xlim([20,20000])
grid on
xlabel('Frequency in Hz')
ylabel('Phase in degrees')