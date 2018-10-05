    close all
    clear all
    fs      = 48000;
    secs    = 60*5;
    sampls_duration = fs*secs;
    psycho  = true;
    Lw      = 1024; 
    x       = rand(sampls_duration,1)*2-1;

%% Secondary path
    delay   = 0;
    load('15_11_16_prototype2_dspace_poweramp_A1_fstart5_fend24k1_fadein_main.mat')
    s       = double(s_ls);
    s       = [zeros(delay,1);s];
    
%% Primary path

    load('8030B_31-08-2016_dummy_middle_A05_d50cm_fstart_45_fend_24100_fadein_Lp8192.mat')
    p = bandpass_IR(50,22000,p_ls);
    NFFT= length(p)+length(x)-1;
    P   = fft(p,NFFT);
    X   = fft(x,NFFT);
    D_mag   = P.*X;
    d   = ifft(D_mag);

%% Psychoacoustic weighting
if psycho
    %ITU-R 468-4 Weighting Filter
    ITUR4684Designer = fdesign.audioweighting('WT','ITUR4684',fs);
    ITUR4684IIR = design(ITUR4684Designer,'iirlpnorm','SystemObject',true);
    itur = impz(ITUR4684IIR);
    % z-plane
    % figure; zplane(ITUR4684IIR)
else
    itur = [1;0];
end

%% Simulation
s_hat   = s;
s_lms   = s;
Ls      = length(s); 
s_buff  = zeros(Ls,1);
s_hat_buff  = zeros(Ls,1);
s_lms_buff  = zeros(Ls,1);
w       = zeros(Lw,1);%w(1)=0.1;w(2)=-0.1;%(rand(Lw,1)*2-1)/100; 
fw      = fs*(0:(Lw/2))/Lw;
w_buff  = zeros(Lw,1); 
lms_buff= zeros(Lw,1);
itur_xbuff= zeros(length(itur),1);
itur_ebuff= zeros(length(itur),1);
Lv      = 2048*2;
e_vis   = zeros(Lv,1);
d_vis   = zeros(Lv,1);
fv      = fs*(0:(Lv/2))/Lv;
E_mag   = zeros(Lv/2+1,1);
D_mag   = zeros(Lv/2+1,1);
mu      = 0.0001/2;
phi     = eps*10;
alpha   = 1e-2;
figure
y       = 0;
y_hat   = 0;
offset_v = 20*log10(2/Lv);
offset_w = 20*log10(2/Lw);

for n = 1:length(x)
   %% Processing 
   % E
   e = d(n)-y;
   e_vis = [e_vis(2:end);e];
   d_vis = [d_vis(2:end);d(n)];
   
   % W
   w_buff = [x(n); w_buff(1:end-1)];
   y_strich  = w'*w_buff;
   
   % S
   s_buff       = [y_strich; s_buff(1:end-1)];
   y            = s'* s_buff;
   
   %% Adaption
   % S_lms  
   s_lms_buff   = [x(n); s_lms_buff(1:end-1)];
   x1_lms        = s_lms'*s_lms_buff;   
   
   % X ITUR 4684 
   itur_xbuff   = [x1_lms; itur_xbuff(1:end-1)];
   x_lms        = itur'*itur_xbuff;   

   
   % E ITUR 4684 
   itur_ebuff   = [e; itur_ebuff(1:end-1)];
   e_lms        = itur'*itur_ebuff; 
   
   % FxLMS adaption
   lms_buff = [x_lms; lms_buff(1:end-1)];   
   %w = w + mu/(phi+lms_buff'*lms_buff)*lms_buff*e_lms;
   w = w + mu*lms_buff*e_lms; % dSpace sim
   
   %% Visualization
   if mod(n,48000) == 0
        ['Simulation: ',num2str(n/48000),' secs']

        subplot(2,2,1)
        E_now   = fft(e_vis);
        E_mag   = (1-alpha)*E_mag + alpha*abs(E_now(1:Lv/2+1));
        E_dB    = 20*log10(E_mag)+offset_v;
        D_now   = fft(d_vis);
        D_mag   = (1-alpha)*D_mag + alpha*abs(D_now(1:Lv/2+1));
        D_dB    = 20*log10(D_mag)+offset_v;
        semilogx(fv,D_dB,'b');
        hold on
        semilogx(fv,E_dB,'k');
        hold off
        grid on
        xlim([fv(1),fv(end)])
        xlabel('Frequency in Hz')
        legend('D(z)','E(z)')
        
        subplot(2,2,2)
        semilogx(fv,E_dB-D_dB,'g'); 
        legend(['Attenuation=' num2str(10*log10((e_vis'*e_vis)/(d_vis'*d_vis)))])
        grid on
        ylim([-20 10])
        xlim([fv(1),fv(end)])
        xlabel('Frequency in Hz')

        subplot(2,2,3)
        semilogx(w,'*') 
        xlim([0 Lw])
        grid on
        xlabel('Samples')
        legend('w(n)')
        
        subplot(2,2,4)
        W = fft(w);
        semilogx(fw,20*log(abs(W(1:Lw/2+1)))+offset_w)
        grid on
        xlim([fw(1),fw(end)])
        legend('W(z)')
        xlabel('Frequency in Hz')
        
        drawnow
   end
end

%clear X x D d P
%save('simulation_results_5_min_delay_9')