function [ ANR_NFxLMS ]= NFxLMS(x,p,s,mu,fs )



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
x_strich_buf = zeros(L_w, 1);
y_buf        = zeros(L_s, 1); 

E_ANR           = 1;
D_ANR           = 1;
lemda           = 0.999;

ANR_NFxLMS      = zeros(L_s, 1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run

L_fft_buff      = 60 *5 ;
e_fft_buff   = zeros(L_fft_buff,1);
E_filter    = ones(L_fft_buff/2+1,1);

offset_v = 20*log10(2/L_fft_buff);

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
    x_strich_buf   = [x_strich ; x_strich_buf(1:end-1)];

    %%% Compute an store output signal   
    y       = w'*x_w_buf;
    y_buf   = [y ; y_buf(1:end-1)];

    %%% Output signal after passing secundary path       
    y_s     = s' * y_buf;

    %%% Compute and store error signal
    e       = d - y_s;

    
	%%% Adaption with FXLMS    
    prefactor = mu / ((x_strich_buf'*x_strich_buf )  + 1e-52 );  
    w         = w + (prefactor*x_strich_buf*e);
    
    % ANR Curves 
    E_ANR=lemda* E_ANR+ (1-lemda)* abs(e);
    D_ANR=lemda* D_ANR+ (1-lemda)* abs(d);
    
    ANR_NFxLMS(i)= 20*log10(E_ANR/D_ANR);
    
    
    if mod(i,48000) == 0
     ['Simulation: ',num2str(i/48000),' secs']
             
     
     
    e_fft_buff	= [ e ; e_fft_buff(1:end-1)];
      % error noise weighting
    E_buff = fft(e_fft_buff .* hann(L_fft_buff));
    E_short = E_buff(1:L_fft_buff/2+1);
    freq = 0:fs/L_fft_buff:fs/2;
     
    E_filter = lemda.* E_filter+ (1-lemda).* abs(E_short);
    subplot(2,1,1); 
    semilogx(freq, 20*log(E_filter)+offset_v);
    xlabel('Frequency (Hz)', 'FontSize', 18)
    ylabel('Gain (dB)', 'FontSize', 18)
    title('NFxLMS', 'FontSize', 30)
    legend('Noise weighting error')
    grid on
    
    
    % ANR 
    subplot(2,1,2);
    plot(ANR_NFxLMS,'LineWidth', 1.5);
    xlabel('Iterations', 'FontSize', 18)
    ylabel('ANR in dB', 'FontSize', 18)
%   title('NFeLMS', 'FontSize', 30)
    grid on

    drawnow
 
    sec=sec+1
    
    end
     
        
        
end


end