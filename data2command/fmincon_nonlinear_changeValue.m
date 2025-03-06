function [c,ceq] = fmincon_nonlinear_changeValue(command_D,command_t,time,constraintindex,constraintValue)
%限制曲線在指定的時間點(index)必須大於指定值

coef = spline_2(command_D,command_t);
[spline_Degree,spline_V,spline_A] = spline_2_value(coef,time,command_t);
acc_constraint = max(spline_A)-2000;
if min(spline_Degree)<0
    position_constraint = abs(min(spline_Degree))-0.03;
    c=[acc_constraint;position_constraint];
else
    c=[acc_constraint];
end


l = length(constraintindex);
if l>0
nonlcon = zeros(l,1);
for i =1:length(nonlcon)
    nonlcon(i) = constraintValue(i) - spline_Degree(constraintindex(i));
end

c = [c;nonlcon'];
end

ceq = [];
end