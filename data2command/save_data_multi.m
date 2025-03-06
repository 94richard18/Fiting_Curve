function save_data_multi(command,path)
%將控制指令存成text


% Define column names
column_names = {'time','LH_D', 'LH_V', 'LH_A','RH_D', 'RH_V', 'RH_A','LK_D', 'LK_V', 'LK_A','RK_D', 'RK_V', 'RK_A','ID'};
command_T = command(1:end,1);
command_LHD = command(1:end,2);
command_LHV = command(1:end,3);
command_LHA = command(1:end,4);
command_RHD = command(1:end,5);
command_RHV = command(1:end,6);
command_RHA = command(1:end,7);
command_LKD = command(1:end,8);
command_LKV = command(1:end,9);
command_LKA = command(1:end,10);
command_RKD = command(1:end,11);
command_RKV = command(1:end,12);
command_RKA = command(1:end,13);
command_ID = command(1:end,14);
%time=zeros(length(command_targetD),1);
T = table(command_T,command_LHD,command_LHV,command_LHA,command_RHD,command_RHV,command_RHA,command_LKD,command_LKV,command_LKA,command_RKD,command_RKV,command_RKA,command_ID,'VariableNames',column_names);
writetable(T,path);
end