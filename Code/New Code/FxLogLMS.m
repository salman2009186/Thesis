clc 
close all
clear all

t=-10:10;

imp= exp(-abs(t).^1.8);

plot(imp)
hold on
plot(log(imp))
hold off