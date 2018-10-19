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
[ANR_NFxLMS_Psycho]= NFeLMS(x,p,s,mu,PsychoacousticWeighting,fs);

% %% NFxLMS 
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_NFxLMS_Psycho,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('NFxLMS', 'FontSize', 30)
% grid on