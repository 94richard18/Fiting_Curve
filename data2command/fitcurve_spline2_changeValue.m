function [control_points_D,command_t] = fitcurve_spline2_changeValue(control_points,D,time,constraintindex,constraintValue,motor_ID)
%input:要下指令的index,原始曲線位置,時間,間隔,馬達ID
%output:新的spline,下指令的時間

%fmincon 變更的值為位置
l = length(control_points);
command_D = zeros(l,1);
command_t = zeros(l,1);
for i=1:l
       command_D(i) = D(control_points(i));
       command_t(i) = time(control_points(i));
end

coef = spline_2(command_D,command_t);
[spline_Degree,spline_V,spline_A] = spline_2_value(coef,time,command_t);

figure(motor_ID+1000)
plot(time,spline_Degree,'red',time,D,'Blue',command_t,command_D,'ro')
title('Rev spline')
xlabel('time(s)')
ylabel('Degree(rev)')
legend('spline','raw data')

A=[];
B=[];
Aeq=[];
Beq=[];
t0 = command_D(2:end-1);
lb=[];
ub=[];
%[lb,ub] = lb_ub_function(control_points,gap);

fun = @(control_points_D) fmincon_commend_fun_changeValue([D(1);control_points_D;D(end)],command_t,D,time,motor_ID);
nonlcon =@(control_points_D) fmincon_nonlinear_changeValue([D(1);control_points_D;D(end)],command_t,time,constraintindex,constraintValue);
options = optimoptions('fmincon', ...
'Algorithm','interior-point', ...
'Display','final-detailed' ,...
'ConstraintTolerance',1e-6, ...
'StepTolerance',1e-4, ...
'MaxFunctionEvaluations',3000, ...
'FiniteDifferenceStepSize',eps^(1/1000),...
'FiniteDifferenceType','central', ...
'DiffMaxChange',0.5, ...
'DiffMinChange',0, ...
'InitBarrierParam',0.3, ...
'OptimalityTolerance',1e-6, ...
'MaxIterations',2000, ...
'FunctionTolerance',1e-2,...
'UseParallel',true,...
'HonorBounds',true);


[control_points_D,fval] = fmincon(fun,t0,A,B,Aeq,Beq,lb,ub,nonlcon,options);

control_points_D = [D(1);control_points_D;D(end)];


"fval"
fval
coef = spline_2(control_points_D,command_t);
[spline_Degree,spline_V,spline_A] = spline_2_value(coef,time,command_t);
figure(motor_ID)
plot(time,spline_Degree,'red',time,D,'Blue',command_t,control_points_D,'ro')
title('Rev spline')
xlabel('time(s)')
ylabel('Degree(rev)')
legend('spline','raw data')


end