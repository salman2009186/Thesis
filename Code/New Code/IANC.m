close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% settings
fs      = 48000;
secs    = 60*0.1;
sampls_duration = fs*secs;

 alpha = 1.7;
 x	= 1 * stablernd(alpha,0,1,0,sampls_duration/4,1) ;

 plot(x);


%% primary and secondary path
[p , s]=Primary_Secondary_Paths();


%% NFxLMP Psycho Weighting
PsychoacousticWeighting = true;
error_power     = alpha-0.1;
mu  = 0.03; 
[ANR_FxLMP_Psycho] = NFxLMP(x,p,s,mu,error_power,PsychoacousticWeighting,fs);

%% NFxLMP No Psycho Weighting
PsychoacousticWeighting = false;
mu  = 0.3;  
[ANR_FxLMP_NoPsycho] = NFxLMP(x,p,s,mu,error_power,PsychoacousticWeighting,fs);

% %% MNFxLMS Psycho Weighting
% PsychoacousticWeighting = true;
% mu = 0.03;
% [ANR_MNFxLMS_Psycho] = MNFxLMS(x,p,s,mu,PsychoacousticWeighting,fs) ;
% 
% %% MNFxLMS No Psycho Weighting
% PsychoacousticWeighting = false;
% mu = 0.3;
% [ANR_MNFxLMS_NoPsycho] = MNFxLMS(x,p,s,mu,PsychoacousticWeighting,fs) ;

%% Plots

%% NFxLMP 
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_FxLMP_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_FxLMP_NoPsycho,'LineWidth', 1.5)
hold off
legend({'NFxLMP Psychoacoustic Weighting', 'NFxLMP no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLMP', 'FontSize', 30)

% %% MNFxLMS 
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_MNFxLMS_Psycho,'LineWidth', 1.5)
% hold on
% plot(ANR_MNFxLMS_NoPsycho,'LineWidth', 1.5)
% hold off
% legend({'MNFxLMS Psychoacoustic Weighting', 'MNFxLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('MNFxLMS', 'FontSize', 30)
% 
% 
% %% MNFxLMS vs NFxLMS Psychoacoustic Weighting
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_MNFxLMS_Psycho,'LineWidth', 1.5)
% hold on
% plot(ANR_NFxLMS_Psycho,'LineWidth', 1.5)
% hold off
% legend({'MNFxLMS Psychoacoustic Weighting', 'NFxLMS Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('MNFxLMS', 'FontSize', 30)
