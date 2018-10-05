close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% settings
fs      = 48000;
secs    = 60*1;
sampls_duration = fs*secs;
x	= rand( sampls_duration ,1)*2-1;



%% primary and secondary path
[p , s]=Primary_Secondary_Paths();


%% NFxLMS Psycho Weighting
PsychoacousticWeighting = true;
 mu  = 0.03; 
[ANR_NFxLMS_Psycho]= NFxLMS(x,p,s,mu,PsychoacousticWeighting,fs);

%% NFxLMS No Psycho Weighting
PsychoacousticWeighting = false;
 mu  = 0.3;  
[ANR_NFxLMS_NoPsycho]= NFxLMS(x,p,s,mu,PsychoacousticWeighting,fs);

%% MNFxLMS Psycho Weighting
PsychoacousticWeighting = true;
mu = 0.03;
[ANR_MNFxLMS_Psycho] = MNFxLMS(x,p,s,mu,PsychoacousticWeighting,fs) ;

%% MNFxLMS No Psycho Weighting
PsychoacousticWeighting = false;
mu = 0.3;
[ANR_MNFxLMS_NoPsycho] = MNFxLMS(x,p,s,mu,PsychoacousticWeighting,fs) ;

%% Plots

%% NFxLMS 
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NFxLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLMS_NoPsycho,'LineWidth', 1.5)
hold off
legend({'NFxLMS Psychoacoustic Weighting', 'NFxLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLMS', 'FontSize', 30)

%% MNFxLMS 
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_MNFxLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_MNFxLMS_NoPsycho,'LineWidth', 1.5)
hold off
legend({'MNFxLMS Psychoacoustic Weighting', 'MNFxLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('MNFxLMS', 'FontSize', 30)


%% MNFxLMS vs NFxLMS Psychoacoustic Weighting
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_MNFxLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLMS_Psycho,'LineWidth', 1.5)
hold off
legend({'MNFxLMS Psychoacoustic Weighting', 'NFxLMS Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('MNFxLMS', 'FontSize', 30)
