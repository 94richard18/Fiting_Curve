function [score] = fmincon_commend_fun_changeValue(command_D,command_t,D,time,motor_ID)
%input:特徵點的位置/時間,下指令的時間,原始曲線位置,馬達ID
%output:使用index產生的spline曲線的D與input D的MSE


coef = spline_2(command_D,command_t);
[spline_Degree,spline_V,spline_A] = spline_2_value(coef,time,command_t);


D = reshape(D,[1 length(D)]);
time = reshape(time,[1 length(time)]);

score = sum((spline_Degree - D).^2)*0.4 +  max((spline_Degree - D).^2)*0.6*10;

score = score*1e4

end
