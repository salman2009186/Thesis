clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% settings
fs      = 48000;
secs    = 60*1;
sampls_duration = fs*secs;
x	= rand( sampls_duration ,1)*2-1;



%% primary and secondary path
[p s]=Primary_Secondary_Paths();


%% Normalized
 mu  = 0.01;   % alpha 1.8
[ANR_NFxLMS]= NFxLMS(x,p,s,mu);



%% NFxLMS 
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NFxLMS,'LineWidth', 1.5)

xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)

 title('NFxLMS', 'FontSize', 30)



