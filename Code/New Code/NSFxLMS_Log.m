function [ANR_NSFxLogLMS, E ]= NSFxLMS_Log(x,p,s)

% L_x = 40000;
L_w         = 128; %length of w
L_s         = 128;  %length of s
L_p         = 256; %length of p


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% init

L_x         = length(x);    %length of input signal

w            = zeros(L_w, 1);
x_p_buf      = zeros(L_p, 1);
x_s_buf      = zeros(L_s, 1);
x_w_buf      = zeros(L_w, 1);   
x_strich_buf = zeros(L_w, 1);
y_buf        = zeros(L_s, 1);

E_ANR      = 1;
D_ANR      = 1;
lemda      = 0.995;

E   = [];
D   = [];
ANR_NSFxLogLMS= [];
Ee=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% run


for i=1:L_x

	%%% Store input signal in buffers
    x_p_buf	= [ x(i) ; x_p_buf(1:end-1)];
    x_s_buf	= [ x(i) ; x_s_buf(1:end-1)];
    x_w_buf	= [ x(i) ; x_w_buf(1:end-1)];

    %%% Compute an store desired signal    
    d    	= p' * x_p_buf;
    D       = [D d];
    
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
    
    E       = [E e];
    
    E_ANR=lemda* E_ANR+ (1-lemda)* abs(e);
    D_ANR=lemda* D_ANR+ (1-lemda)* abs(d);
    
    ANR_NSFxLogLMS = [ANR_NSFxLogLMS 20*log10(E_ANR/D_ANR)];
    Ee= lemda* Ee + (1-lemda)* e^2;
    
    if abs(e) >  20
        
        e = log10(abs(e)) / (e);
        mu= 0.1 ; %alpha 1.8

    else
         mu= 0.3;  %alpha 1.8
         

     end
    
    
	%%% Adaption with FXLMS    
    prefactor = mu / ((x_strich_buf'*x_strich_buf )+ 0.0001); % add eps 
    w         = w + ( prefactor * x_strich_buf * e);
    


    
end

end