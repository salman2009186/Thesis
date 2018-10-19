clc
 close all 
 clear all

fs      = 48000;
secs    = 60 *1;
sampls_duration = fs*secs;




lemda= 0.999;
E_shor_Sim=1;

L_x = 100000000;
lemda =0.999;
E_ANR = zeros(L_x,1);
x = 1:L_x ;

 
 
fft_buff= 100;
E_simul_short = zeros(fft_buff/2+1,1);
e_buff= zeros(fft_buff,1);

for i=1:length(x)
    
 e_buff	= [ x(i) ; e_buff(1:end-1)];
    
 if mod(i,fft_buff)==0
     E_buff = fft(e_buff .* hann(length(e_buff)));
     E_short = E_buff(1:length(e_buff)/2+1);
     freq = 0:fs/length(e_buff):fs/2;
     
     E_simul_short = lemda.* E_simul_short+ (1-lemda).* abs(E_short);
     
     semilogx(freq,20*log(abs(E_short)));
        
     drawnow
 end
end






% E_buff = fft(x .* hann(length(x)));
% 
% E_short = E_buff(1:length(x)/2+1)
% 
% E_short_buff= zeros(length(E_short),1);
% 
% 
% 
% for i=1:length(E_short)
%    E_shor_Sim = lemda * E_shor_Sim +(1-lemda)*abs(E_short(i));
%     E_short_buff(i)= E_shor_Sim;
% end
% 
% 
% freq = 0:Fs/length(x):Fs/2;
% 
% figure('units','normalized','outerposition',[0 0 1 1])
% semilogx(freq,20*log(E_short_buff));
% xlabel('Frequancy (Hz)', 'FontSize', 18)
% ylabel('Gain(dB)', 'FontSize', 18)
% title('NFeLMS', 'FontSize', 30)
% grid on










