function [time,LH_D,RH_D,LK_D,RK_D] = ReadHCData(datapath)
%time:s D:degree
R_Data = readmatrix(datapath,'Sheet','Right_angle');
L_Data = readmatrix(datapath,'Sheet','Left_angle');

RH_D = R_Data(1:end,1);
RK_D = R_Data(1:end,2);
LH_D = L_Data(1:end,1);
LK_D = L_Data(1:end,2);
Len = length(RH_D);
time = (1:Len)'/300;
end