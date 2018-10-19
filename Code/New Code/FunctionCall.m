clc 
close all
clear all

fs      = 48000;
secs    = 60 *5;
sampls_duration = fs*secs;
x	= rand( sampls_duration ,1)*2-1;

%% primary and secondary path
[p , s]=Primary_Secondary_Paths();

%% NFxLMS Psycho Weighting
PsychoacousticWeighting = true;
 mu  = 0.1; 
%  [ANR_NFxLMS_Psycho]= NFeLMS(x,p,s,mu,PsychoacousticWeighting,fs);

 mu  = 0.3;
[ ANR_NFxLMS ]= NFxLMS(x,p,s,mu,fs );

