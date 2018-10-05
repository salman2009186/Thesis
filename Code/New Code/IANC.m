close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% settings
fs      = 48000;
secs    = 60*0.1;
sampls_duration = fs*secs;

 alpha = 1.7;
 x	= 1 * stablernd(alpha,0,1,0,sampls_duration/2,1) ;

 plot(x);


%% primary and secondary path
[p , s]=Primary_Secondary_Paths();


%% NFxLMP Psycho Weighting
PsychoacousticWeighting = true;
error_power     = alpha-0.1;
mu  = 0.05; 
[ANR_NFxLMP_Psycho] = NFxLMP(x,p,s,mu,error_power,PsychoacousticWeighting,fs);

% % NFxLMP No Psycho Weighting
% PsychoacousticWeighting = false;
% mu  = 0.3;  
% [ANR_NFxLMP_NoPsycho] = NFxLMP(x,p,s,mu,error_power,PsychoacousticWeighting,fs);



%% NFxLogLMS Psycho Weighting
PsychoacousticWeighting = true;
 mu = 0.6;
[ANR_NFxLogLMS_Psycho] = NFxLogLMS(x,p,s,mu,PsychoacousticWeighting,fs);

% % NFxLogLMS No Psycho Weighting
% PsychoacousticWeighting = false;
%  mu = 6.0;
% [ANR_NFxLogLMS_NoPsycho]= NFxLogLMS(x,p,s,mu,PsychoacousticWeighting,fs);




%% NSFxLogLMS Psycho Weighting
PsychoacousticWeighting = true;
mu1 =0.1;
mu2 =0.03;
[ANR_NSFxLogLMS_Psycho ]= NSFxLogLMS(x,p,s,PsychoacousticWeighting,fs,mu1,mu2);

% % NSFxLogLMS No Psycho Weighting
% PsychoacousticWeighting = false;
% mu1 =0.5;
% mu2 =0.3;
% [ANR_NSFxLogLMS_NoPsycho ]= NSFxLogLMS(x,p,s,PsychoacousticWeighting,fs,mu1,mu2);


% %% Plots
% 
% %% NFxLMP 
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_NFxLMP_Psycho,'LineWidth', 1.5)
% hold on
% plot(ANR_NFxLMP_NoPsycho,'LineWidth', 1.5)
% hold off
% legend({'NFxLMP Psychoacoustic Weighting', 'NFxLMP no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('NFxLMP', 'FontSize', 30)
% grid on
% 
% %% NFxLogLMS 
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_NFxLogLMS_Psycho,'LineWidth', 1.5)
% hold on
% plot(ANR_NFxLogLMS_NoPsycho,'LineWidth', 1.5)
% hold off
% legend({'NFxLogLMS Psychoacoustic Weighting', 'NFxLogLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('NFxLogLMS', 'FontSize', 30)
% grid on
% 
% 
% %% NSFxLogLMS 
% figure('units','normalized','outerposition',[0 0 1 1])
% plot(ANR_NSFxLogLMS_Psycho,'LineWidth', 1.5)
% hold on
% plot(ANR_NSFxLogLMS_NoPsycho,'LineWidth', 1.5)
% hold off
% legend({'NSFxLogLMS Psychoacoustic Weighting', 'NSFxLogLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
% xlabel('Iterations', 'FontSize', 18)
% ylabel('ANR in dB', 'FontSize', 18)
% title('NSFxLogLMS', 'FontSize', 30)
% grid on

%% NFxLogLMS vs NSFxLogLMS Psychoacoustic Weighting
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NFxLMP_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLogLMS_Psycho,'LineWidth', 1.5)
plot(ANR_NSFxLogLMS_Psycho,'LineWidth', 1.5)
hold off
legend({'NFxLMP Psychoacoustic Weighting','NFxLogLMS Psychoacoustic Weighting', 'NSFxLogLMS Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLMP vs NFxLogLMS vs NSFxLogLMS', 'FontSize', 30)
grid on