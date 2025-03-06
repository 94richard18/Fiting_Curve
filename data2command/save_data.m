function save_data(command,path)
%將控制指令存成text


% Define column names
column_names = {'time','D', 'V', 'A', 'D_target','ID'};
command_T = command(1:end,1);
command_D = command(1:end,2);
command_V = command(1:end,3);
command_A = command(1:end,4);
command_targetD = command(1:end,5);
command_ID = command(1:end,6);
%time=zeros(length(command_targetD),1);
T = table(command_T,command_D,command_V,command_A,command_targetD,command_ID,'VariableNames',column_names);
writetable(T,path);
end