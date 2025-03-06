clear
clc

ReadPath = ".csv";
Savepath = '.txt';
Savepath_LH = '.txt';
Savepath_RH = '.txt';
Savepath_LK = '.txt';
Savepath_RK = '.txt';


%%
[SampleTime,LHSU_ANGLE,RHSU_ANGLE,LKCU_ANGLE,RKCU_ANGLE] = ReadHCData(ReadPath);
rate = 0.65;
s2min = 1/60;
deg2rev = 1/360;
timerate = 10;
timestep = timerate/6000;%unit:min
LHSU_ANGLE = LHSU_ANGLE*deg2rev*rate;%unit:deg-->rev
RHSU_ANGLE = RHSU_ANGLE*deg2rev*rate;%unit:deg-->rev
LKCU_ANGLE = LKCU_ANGLE*deg2rev*rate;%unit:deg-->rev
RKCU_ANGLE = RKCU_ANGLE*deg2rev*rate;%unit:deg-->rev
SampleTime = SampleTime*timerate*s2min ; %unit:s-->min


%%

LHSU_V = gradient(LHSU_ANGLE,timestep);
RHSU_V = gradient(RHSU_ANGLE,timestep);
LKCU_V = gradient(LKCU_ANGLE,timestep);
RKCU_V = gradient(RKCU_ANGLE,timestep);
initial_degree = 0;
lambda = 0.5;
%gap = 1.5*100/timerate;
gap=5;

[LHSU_smooth_D,LHSU_smooth_V,LHSU_smooth_A] = smooth_curve(LHSU_V,lambda,timestep);
[RHSU_smooth_D,RHSU_smooth_V,RHSU_smooth_A] = smooth_curve(RHSU_V,lambda,timestep);
[LKCU_smooth_D,LKCU_smooth_V,LKCU_smooth_A] = smooth_curve(LKCU_V,lambda,timestep);
[RKCU_smooth_D,RKCU_smooth_V,RKCU_smooth_A] = smooth_curve(RKCU_V,lambda,timestep);



deg2rad = pi/180;

%%
gap = 10;
[LHSU_characteristic] = Find_characteristic(SampleTime,LHSU_smooth_D,LHSU_smooth_V,LHSU_smooth_A,gap);
LHSU_characteristic_index = LHSU_characteristic(:,1);
LHSU_characteristic_time = LHSU_characteristic(:,2);
LHSU_characteristic_Degree = LHSU_characteristic(:,3);
LHSU_characteristic_Velo = LHSU_characteristic(:,4);
LHSU_characteristic_Acc = LHSU_characteristic(:,5);

[LHSU_command,LHSU_V] = Curve2command_changeValue(LHSU_characteristic_index,LHSU_smooth_D,SampleTime,2);



%%
gap = 10;
[RHSU_characteristic] = Find_characteristic(SampleTime,RHSU_smooth_D,RHSU_smooth_V,RHSU_smooth_A,gap);
RHSU_characteristic_index = RHSU_characteristic(:,1);
RHSU_characteristic_time = RHSU_characteristic(:,2);
RHSU_characteristic_Degree = RHSU_characteristic(:,3);
RHSU_characteristic_Velo = RHSU_characteristic(:,4);
RHSU_characteristic_Acc = RHSU_characteristic(:,5);

[RHSU_command,RHSU_V] = Curve2command_changeValue(RHSU_characteristic_index,RHSU_smooth_D,SampleTime,3);



%%
gap = 10;
[LKCU_characteristic] = Find_characteristic(SampleTime,LKCU_smooth_D,LKCU_smooth_V,LKCU_smooth_A,gap);
LKCU_characteristic_index = LKCU_characteristic(:,1);
LKCU_characteristic_time = LKCU_characteristic(:,2);
LKCU_characteristic_Degree = LKCU_characteristic(:,3);
LKCU_characteristic_Velo = LKCU_characteristic(:,4);
LKCU_characteristic_Acc = LKCU_characteristic(:,5);

[LKCU_command,LKCU_V] = Curve2command_changeValue(LKCU_characteristic_index,LKCU_smooth_D,SampleTime,1);


%%
gap =10;
[RKCU_characteristic] = Find_characteristic(SampleTime,RKCU_smooth_D,RKCU_smooth_V,RKCU_smooth_A,gap);
RKCU_characteristic_index = RKCU_characteristic(:,1);
RKCU_characteristic_time = RKCU_characteristic(:,2);
RKCU_characteristic_Degree = RKCU_characteristic(:,3);
RKCU_characteristic_Velo = RKCU_characteristic(:,4);
RKCU_characteristic_Acc = RKCU_characteristic(:,5);

[RKCU_command,RKCU_V] = Curve2command_changeValue(RKCU_characteristic_index,RKCU_smooth_D,SampleTime,4);

%%
time = [LHSU_command(:,1);LKCU_command(:,1);RHSU_command(:,1);RKCU_command(:,1)];
time = sort(unique(time));

%time LHSU_Dtarget  LHSU_V LHSU_A LKSU_Dtarget  LKSU_V LKSU_A ...

command = ones(length(time),14);

for i =1:length(time)
    command(i,1) = time(i);
end

for i=1:length(time)
    command(i,14) = 0;
end

%將LHSU指令放入command
j=1;
for i=1:length(time)
    if time(i) ==  LHSU_command(j,1)
        command(i,2) = LHSU_command(j,5);
        command(i,3) = LHSU_command(j,3);
        command(i,4) = LHSU_command(j,4);  
        command(i,14) = command(i,14)*10+(LHSU_command(j,6));
        j =j+1;
    end

end

%將RSHU指令放入command
j=1;
for i=1:length(time)
    if time(i) ==  RHSU_command(j,1)
        command(i,5) = RHSU_command(j,5);
        command(i,6) = RHSU_command(j,3);
        command(i,7) = RHSU_command(j,4);  
        command(i,14) = command(i,14)*10+(RHSU_command(j,6));
        j =j+1;
    end

end

%將LKHU指令放入command
j=1;
for i=1:length(time)
    if time(i) ==  LKCU_command(j,1)
        command(i,8) = LKCU_command(j,5);
        command(i,9) = LKCU_command(j,3);
        command(i,10) = LKCU_command(j,4);  
        command(i,14) = command(i,14)*10+(LKCU_command(j,6));
        j =j+1;
    end

end



%將RKHU指令放入command
j=1;
for i=1:length(time)
    if time(i) ==  RKCU_command(j,1)
        command(i,11) = RKCU_command(j,5);
        command(i,12) = RKCU_command(j,3);
        command(i,13) = RKCU_command(j,4);  
        command(i,14) = command(i,14)*10+(RKCU_command(j,6));
        j =j+1;
    end

end

for i=1:length(time)
    command(i,1) = (round(time(i),0));
end

%%
Savepath = 'E:\研究所/motor/matlab/motor_data/command_matlab/HC_SQT100_1.txt';
% save_data(LHSU_command,Savepath_LH)
% save_data(RHSU_command,Savepath_RH)
% save_data(LKCU_command,Savepath_LK)
% save_data(RKCU_command,Savepath_RK)
save_data_multi(command,Savepath)
