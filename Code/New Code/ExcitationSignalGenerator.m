clc
close all
clear all

% fs      = 48000;
% secs    = 60*5;
% sampls_duration = fs*secs;
% 
%  alpha = 1.7;
%  x	= 1 * stablernd(alpha,0,1,0,sampls_duration,1) ;

 load('ExcitationSignal_alpha17.mat','x')

figure('units','normalized','outerposition',[0 0 1 1]);
plot(x);
legend({'Excitation Signal'}, 'FontSize', 18,'LineWidth', 2.5)
xlabel('Iterations', 'FontSize', 18)
ylabel('Amplitude', 'FontSize', 18)
title('Excitation Signal', 'FontSize', 30)
grid on

% save('ExcitationSignal_alpha17.mat','x')
