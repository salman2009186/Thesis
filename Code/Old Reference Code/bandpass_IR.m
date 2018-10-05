function IR_Out = bandpass_IR(fstart,fend,IR_in)
zeropadded_signal=[zeros(24000,1);IR_in;zeros(24000,1)];
% filtering HF noise content         
d=fdesign.lowpass('Fp,Fst,Ap,Ast',fend-300,fend+00,0.1,10,48000);
Hd=design(d,'butter','MatchExactly','stopband');
SOS=Hd.sosMatrix;G=Hd.ScaleValues;
zp_input=filtfilt(SOS,G,zeropadded_signal);
IR_Out_LP = zp_input(24001:end-24000); 

zeropadded_signal=[zeros(24000,1);IR_Out_LP;zeros(24000,1)];
% filtering LF noise content         
d=fdesign.highpass('Fst,Fp,Ast,Ap',25,fstart,20,0.1,48000);
Hd=design(d,'butter','MatchExactly','stopband');
SOS=Hd.sosMatrix;G=Hd.ScaleValues;
zp_input=filtfilt(SOS,G,zeropadded_signal);
IR_Out = zp_input(24001:end-24000); 

