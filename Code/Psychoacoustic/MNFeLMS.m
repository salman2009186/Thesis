close all;
clear all
clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% settings
fs                  = 48000;
secs                = 60 * .3;
sampls_duration     = fs*secs;
x                   = rand( sampls_duration ,1)*2-1;

%% primary and secondary path
[p , s]=Primary_Secondary_Paths();


figure('units','normalized','outerposition',[0 0 1 1])

for j=1:2
    
if j==1
PsychoacousticWeighting = true;
mu              =  0.1;
else
PsychoacousticWeighting = false;
mu              =  0.3;
end



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

    
L_x          = length(x);    %length of input signal
w            = zeros(L_w, 1);
x_p_buf      = zeros(L_p, 1);
x_s_buf      = zeros(L_s, 1);
x_w_buf      = zeros(L_w, 1);   
x_strich_buf = zeros(L_w, 1);
y_s_buf      = zeros(L_s, 1);
ANR_MNFxLMS  = zeros(L_s, 1);
itur_x_buff  = zeros(length(itur),1);
itur_ebuff   = zeros(length(itur),1);
lms_buff     = zeros(L_w, 1);

E_ANR      = 1;
D_ANR      = 1;
lemda      = 0.999;


L_fft_buff      = 2048*2 ;
elms_fft_buff   = zeros(L_fft_buff,1);
E_lms_filter    = ones(L_fft_buff/2+1,1);
freq_lms        = fs*(0:(L_fft_buff/2))/L_fft_buff;
offset          = 20*log10(2/L_fft_buff);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run



for i=1:L_x

	%%% Store input signal in buffers
    x_p_buf	= [ x(i) ; x_p_buf(1:end-1)];
    x_s_buf	= [ x(i) ; x_s_buf(1:end-1)];
    x_w_buf	= [ x(i) ; x_w_buf(1:end-1)];

    %%% Compute an store desired signal    
    d    	= p' * x_p_buf;
    
    %%% Compute and store x_s signal for adaption 
    x_strich       = s' * x_s_buf;
    x_strich_buf   = [x_strich ; x_strich_buf(1:end-1)];
    
    % X ITUR 4684 
    itur_x_buff   = [x_strich; itur_x_buff(1:end-1)];
    x_lms        = itur'*itur_x_buff; 

    %%% Compute an store output signal   
    y_w       = w' * x_w_buf ;
    y_s_buf   = [y_w ; y_s_buf(1:end-1)];

    %%% Output signal after passing secundary path       
    y_s1     = s' * y_s_buf;
    y_s2     = y_s1;
    
    %%% Compute and store error signal
    e1       = d - y_s1 ;
    e2       = y_s2 + e1 ;
    
    
    % LMS Update
    u       = w'*x_strich_buf;
    g       = e2 - u  ;
    
   % E ITUR 4684 
   itur_ebuff   = [g; itur_ebuff(1:end-1)];
   g_lms        = itur'*itur_ebuff;
   elms_fft_buff	= [ g_lms ; elms_fft_buff(1:end-1)];
   
    % FxLMS adaption
    lms_buff = [x_lms; lms_buff(1:end-1)];
   
    % 
    MU = mu  / ((lms_buff'*lms_buff ) + 1e-52); 
    w         = w + ( MU * lms_buff * g_lms );
   
    
    E_ANR=lemda* E_ANR+ (1-lemda)* abs(e1);
    D_ANR=lemda* D_ANR+ (1-lemda)* abs(d);
    
    ANR_MNFxLMS(i)= 20*log10(E_ANR/D_ANR);

    
    if mod(i,48000) == 0
     ['Simulation: ',num2str(i/48000),' secs']
             
     % error noise weighting
    Elms_buff       = fft(elms_fft_buff .* hann(L_fft_buff));
    Elms_short      = Elms_buff(1:L_fft_buff/2+1);
    E_lms_filter    = lemda.* E_lms_filter+ (1-lemda).* abs(Elms_short);
    

    
    if PsychoacousticWeighting
        subplot(4,1,1);
        semilogx(freq_lms, 20*log(E_lms_filter)+offset,'b');
        xlabel('Frequency (Hz)', 'FontSize', 10)
        ylabel('Gain (dB)', 'FontSize', 10)
        title('MNFeLMS')
        grid on
    else 
        subplot(4,1,3);
        semilogx(freq_lms, 20*log(E_lms_filter)+offset,'k');
        xlabel('Frequency (Hz)', 'FontSize', 10)
        ylabel('Gain (dB)', 'FontSize', 10)
        title('MNFxLMS')
        grid on
    end
    
    
    
    % ANR 
    if PsychoacousticWeighting
    subplot(4,1,2);
    plot(ANR_MNFxLMS,'b');
    xlabel('Iterations', 'FontSize', 10)
    ylabel('ANR in dB', 'FontSize', 10)
    title('MNFeLMS')
    grid on
    else
    subplot(4,1,4);
    plot(ANR_MNFxLMS,'k');
    xlabel('Iterations', 'FontSize', 10)
    ylabel('ANR in dB', 'FontSize', 10)
    title('MNFxLMS')
    grid on
    end
   

    drawnow
 
    end
    
    
end

end


