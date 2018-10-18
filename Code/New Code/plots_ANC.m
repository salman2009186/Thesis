clc
close all
clear all


load('NFxLMS.mat','ANR_NFxLMS_Psycho','ANR_NFxLMS_NoPsycho'); 

load('MNFxLMS.mat','ANR_MNFxLMS_Psycho','ANR_MNFxLMS_NoPsycho'); 


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
grid on
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
grid on

%% MNFxLMS vs NFxLMS Psychoacoustic Weighting
figure('units','normalized','outerposition',[0 0 1 1])
plot(ANR_MNFxLMS_Psycho,'LineWidth', 1.5)
hold on
plot(ANR_NFxLMS_Psycho,'LineWidth', 1.5)
hold off
legend({'MNFxLMS Psychoacoustic Weighting', 'NFxLMS Psychoacoustic Weighting'}, 'FontSize', 18,'LineWidth', 1.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('ANR in dB', 'FontSize', 18)
title('MNFxLMS vs NFxLMS Psychoacoustic Weighting', 'FontSize', 30)
grid on