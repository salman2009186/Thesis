function [ANR_NSFxLogLMS ]= NSFxLogLMS(x,p,s,PsychoacousticWeighting,fs,mu1,mu2)

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

L_x           = length(x);    %length of input signal
w             = zeros(L_w, 1);
x_p_buf       = zeros(L_p, 1);
x_s_buf       = zeros(L_s, 1);
x_w_buf       = zeros(L_w, 1);   
x_strich_buf  = zeros(L_w, 1);
y_buf         = zeros(L_s, 1);
ANR_NSFxLogLMS = zeros(L_x, 1);
itur_xbuff     = zeros(length(itur),1);
itur_ebuff     = zeros(length(itur),1);
lms_buff       = zeros(L_w, 1);

E_ANR      = 1;
D_ANR      = 1;
lemda      = 0.999;

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
    itur_xbuff   = [x_strich; itur_xbuff(1:end-1)];
    x_lms        = itur'*itur_xbuff; 

    %%% Compute an store output signal   
    y       = w'*x_w_buf;
    y_buf   = [y ; y_buf(1:end-1)];

    %%% Output signal after passing secundary path       
    y_s     = s' * y_buf;

    %%% Compute and store error signal
    e       = d - y_s;
    
    
    E_ANR=lemda* E_ANR+ (1-lemda)* abs(e);
    D_ANR=lemda* D_ANR+ (1-lemda)* abs(d);
    
    ANR_NSFxLogLMS(i) =  20*log10(E_ANR/D_ANR);
    
    if abs(e) >  20
        
        e = log10(abs(e)) / (e);
        mu= mu1 ; 

    else
         mu= mu2;  
         

    end
    
        % E ITUR 4684 
   itur_ebuff   = [e; itur_ebuff(1:end-1)];
   e_lms        = itur'*itur_ebuff;
   
   % FxLMS adaption
   lms_buff = [x_lms; lms_buff(1:end-1)];
    
	%%% Adaption with FXLMS    
    prefactor = mu / ((x_strich_buf'*x_strich_buf )+ 1e-52); 
    w         = w + ( prefactor * lms_buff * e_lms);
    


    
end

end