function [p s]=Primary_Secondary_Paths()


pri_num = load('p_z.asc');              % Primary path, numerator
pri_den = load('p_p.asc');              % Primary path, denominator
sec_num = load('s_z.asc');              % Secondary path, numerator
sec_den = load('s_p.asc');              % Secondary path, denominator

ir_sec = impz(sec_num,sec_den);         % Actual secondary path 
s = ir_sec(1:128);                      % Estimated secondary path

% d = filter(pri_num,pri_den,noise);    % Desired signal

ir_p = impz(pri_num,pri_den);         % Actual secondary path 
p = ir_p(1:256);                      % Estimated secondary path
    
end