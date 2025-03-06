function [command,V] = Curve2command_changeValue(characteristic_index,smooth_D,SampleTime,motor_ID)

%test constrant
constraintindex = [];
constraintValue = [];
%將smmoth_D --> 2階spline
control_points = characteristic_index';
%spline2command
[command_D,command_t] = fitcurve_spline2_changeValue(control_points,smooth_D,SampleTime,constraintindex,constraintValue,motor_ID);
coef = spline_2(command_D,command_t);
[D,V,A] = spline_2_value(coef,SampleTime,command_t);



[command] = SplineToCommand2(characteristic_index,SampleTime,command_t,D,V,A,motor_ID);



figure(motor_ID+10)
subplot(1,3,1)
plot(SampleTime,D,'red',command_t,command_D,'ro')
title('Rev')
xlabel('time(min)')
ylabel('Degree(rev)')
subplot(1,3,2)
plot(SampleTime,V,'red')
title('Velocity')
xlabel('time(s)')
ylabel('Velocity(rev/min)')
subplot(1,3,3)
plot(SampleTime,A,'red')
title('Acceleration')
xlabel('time(s)')
ylabel('Acceleration(rev/min^2)')

figure(111)
plot(SampleTime,D,'red',command_t,command_D,'ro')
title('Rev')
xlabel('time(min)')
ylabel('Degree(rev)')

end