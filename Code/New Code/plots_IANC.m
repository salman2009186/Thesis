clc
 close all
clear all
  
%%Excitation Signal
load('ExcitationSignal_alpha17.mat','x'); % excitation Signal

figure('units','normalized','outerposition',[0 0 1 1]);
plot(x);
legend({'Excitation Signal'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('Amplitude', 'FontSize', 18)
title('Excitation Signal', 'FontSize', 30)
grid on

%% NFxLMP
load('NFxLMP.mat' ,'ANR_NFxLMP_Psycho','ANR_NFxLMP_NoPsycho')

figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NFxLMP_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLMP_NoPsycho,'LineWidth', 1.5)
hold off
legend({'NFxLMP Psychoacoustic Weighting', 'NFxLMP no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLMP', 'FontSize', 30)
grid on



%%NFxLogLMS
load('NFxLogLMS.mat' ,'ANR_NFxLogLMS_Psycho','ANR_NFxLogLMS_NoPsycho')

figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NFxLogLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLogLMS_NoPsycho,'LineWidth', 1.5)
hold off
legend({'NFxLogLMS Psychoacoustic Weighting', 'NFxLogLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLogLMS', 'FontSize', 30)
grid on



%% NSFxLogLMS
load('NSFxLogLMS.mat' ,'ANR_NSFxLogLMS_Psycho' , 'ANR_NSFxLogLMS_NoPsycho' )

figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_NSFxLogLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NSFxLogLMS_NoPsycho,'LineWidth', 1.5)
hold off
legend({'NSFxLogLMS Psychoacoustic Weighting', 'NSFxLogLMS no Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NSFxLogLMS', 'FontSize', 30)
grid on


%% NFXLMP VS NFxLogLMS vs NSFxLogLMS Psychoacoustic Weighting
figure('units','normalized','outerposition',[0 0 1 1])
hold on
plot(ANR_NFxLMP_Psycho,'LineWidth', 1.5)
plot(ANR_NFxLogLMS_Psycho,'LineWidth', 1.5)
plot(ANR_NSFxLogLMS_Psycho,'LineWidth', 1.5)
hold off
legend({'NFxLMP Psychoacoustic Weighting','NFxLogLMS Psychoacoustic Weighting', 'NSFxLogLMS Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('NFxLMP vs NFxLogLMS vs NSFxLogLMS Psychoacoustic Weighting', 'FontSize', 30)
grid on