datapath1 = 'E:\研究所/motor/matlab/motor_data/command_matlab_data/HC_SQT100_2';

data1 = readmatrix(datapath1);
time1 = data1(1:end,1);
Place1 = data1(1:end,2)./(2*501923);
Velocity1 = data1(1:end,3);

Place2 = data1(1:end,4)./(2*501923);
Velocity2 = data1(1:end,5);

Place3 = data1(1:end,6)./(2*501923);
Velocity3 = data1(1:end,7);

Place4 = data1(1:end,8)./(2*501923);
Velocity4 = data1(1:end,9);

figure(10)
subplot(2,2,1)
plot(time1,Place3,'Blue',SampleTime*60000,-RHSU_smooth_D,'red')
subplot(2,2,2)
plot(time1,Place2,'Blue',SampleTime*60000,LHSU_smooth_D,'red')
subplot(2,2,3)
plot(time1,Place4,'Blue',SampleTime*60000,LKCU_smooth_D,'red')
subplot(2,2,4)
plot(time1,Place1,'Blue',SampleTime*60000,-RKCU_smooth_D,'red')