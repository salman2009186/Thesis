function [ ANR_NFeLMS ]= NFeLMS(x,p,s,mu,PsychoacousticWeighting,fs )

%% Psychoacoustic weighting
if PsychoacousticWeighting
    %ITU-R 468-4 Weighting Filter
    ITUR4684Designer = fdesign.audioweighting('WT','ITUR4684',fs);
    ITUR4684IIR = design(ITUR4684Designer,'iirlpnorm','SystemObject',true);
    itur = impz(ITUR4684IIR);
    % z-plane
    % figure; zplane(ITUR4684IIR)
else
    itur = [1;0];
end



L_w         = 128; %length of w
L_s         = 128;  %length of s
L_p         = 256; %length of p

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% init

L_x             = length(x);    %length of input signal
w               = zeros(L_w, 1);
x_p_buf         = zeros(L_p, 1);
x_s_buf         = zeros(L_s, 1);
x_w_buf         = zeros(L_w, 1);   
y_w_buf         = zeros(L_s, 1);
x_s_itur_xbuff  = zeros(length(itur),1);
itur_ebuff      = zeros(length(itur),1);
lms_buff        = zeros(L_w, 1);

E_ANR           = 1;
D_ANR           = 1;
lemda           = 0.999;

ANR_NFeLMS      = zeros(L_s, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run
L_fft_buff      = 60 *5 ;
elms_fft_buff   = zeros(L_fft_buff,1);
e_fft_buff      = zeros(L_fft_buff,1);
E_filter        = ones(L_fft_buff/2+1,1);
E_lms_filter    = ones(L_fft_buff/2+1,1);

figure('units','normalized','outerposition',[0 0 1 1])
sec = 0;
for i=1:L_x

	%%% Store input signal in buffers
    x_p_buf	= [ x(i) ; x_p_buf(1:end-1)];
    x_s_buf	= [ x(i) ; x_s_buf(1:end-1)];
    x_w_buf	= [ x(i) ; x_w_buf(1:end-1)];

    %%% Compute an store desired signal    
    d    	= p' * x_p_buf;

    
    %%% Compute and store x_s signal for adaption 
    x_strich       = s' * x_s_buf;
    
    % X ITUR 4684 
    x_s_itur_xbuff  = [x_strich; x_s_itur_xbuff(1:end-1)];
    x_lms           = itur'*x_s_itur_xbuff; 

    %%% Compute an store output signal   
    y_w       = w'*x_w_buf;
    y_w_buf   = [y_w ; y_w_buf(1:end-1)];

    %%% Output signal after passing secundary path       
    y_s     = s' * y_w_buf;

    %%% Compute and store error signal
    e       = d - y_s;
    
   % E ITUR 4684 
   itur_ebuff   = [e; itur_ebuff(1:end-1)];
   e_lms        = itur'*itur_ebuff;
   
   % FxLMS adaption
   lms_buff = [x_lms; lms_buff(1:end-1)];
   
	%%% Adaption with FXLMS    
    MU = mu / ((lms_buff'*lms_buff )  + 1e-52); 
    w         = w + (MU * lms_buff * e_lms );
    
    
    %%Calculating Average Noise Reduction
    E_ANR=lemda* E_ANR+ (1-lemda)* abs(e);
    D_ANR=lemda* D_ANR+ (1-lemda)* abs(d);   
    ANR_NFeLMS(i)= 20*log10(E_ANR/D_ANR);
    
    
      
     elms_fft_buff	= [ e_lms ; elms_fft_buff(1:end-1)];
     e_fft_buff	= [ e ; e_fft_buff(1:end-1)];
     
    if mod(i,L_fft_buff)==0
     
      % error noise weighting
    Elms_buff = fft(elms_fft_buff .* hann(L_fft_buff));
    Elms_short = Elms_buff(1:L_fft_buff/2+1);
    freq_lms = 0:fs/L_fft_buff:fs/2;
     
    E_lms_filter = lemda.* E_lms_filter+ (1-lemda).* abs(Elms_short);
    subplot(3,1,1); 
    semilogx(freq_lms, 20*log(E_lms_filter));
    xlabel('Frequency (Hz)', 'FontSize', 18)
    ylabel('Gain (dB)', 'FontSize', 18)
    title('NFeLMS', 'FontSize', 30)
    legend('Noise weighting error')
    grid on
    
     % error
     E_buff = fft(e_fft_buff .* hann(L_fft_buff));
     E_short = E_buff(1:L_fft_buff/2+1);
     freq = 0:fs/L_fft_buff:fs/2;
     E_filter = lemda.* E_filter+ (1-lemda).* abs(E_short);
    
     subplot(3,1,2);
    semilogx(freq,20*log(E_filter));
    xlabel('Frequency (Hz)', 'FontSize', 18)
    ylabel('Gain (dB)', 'FontSize', 18)
    legend('error before noise weighting')
    grid on
    
    
    % ANR 
    subplot(3,1,3);
    plot(ANR_NFeLMS,'LineWidth', 1.5);
    xlabel('Iterations', 'FontSize', 18)
    ylabel('ANR in dB', 'FontSize', 18)
%   title('NFeLMS', 'FontSize', 30)
    grid on

    drawnow
 
    sec=sec+1
    
     end
   


     
end


end