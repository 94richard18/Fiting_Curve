function [characteristic] = Find_characteristic(time_real,smooth_D,smooth_V,smooth_A,gap)

%這個for是強迫abs(V)<0.001 通通設為0
for i =1:length(smooth_V)
    if abs(smooth_V(i))<0.1
        smooth_V(i)=0;
    end
end
%找特徵點
control_points=[1];

for i=1:length(smooth_V)-1
    tempt = smooth_V(i)*smooth_V(i+1);
    if tempt<0
        if abs(smooth_V(i))>abs(smooth_V(i+1))
            control_points=[control_points i+1];
        else
            control_points=[control_points i];
        end
    elseif tempt==0
        if abs(smooth_V(i))==0
            control_points=[control_points i];
        end
    end
end

same=[];
control_points_real=[];

%濾掉兩點加速度同為0的點
for i=1:length(control_points)-1
    
    if control_points(i+1) -control_points(i)==1 &smooth_A(control_points(i+1)) ==smooth_A(control_points(i))
        same = [same i];
    else
        if length(same)>=1
            control_points_real=[control_points_real control_points(same(1))];
            same=[];
        end
        control_points_real=[control_points_real control_points(i)];

    end
end

%如果沒挑出特徵點，那就只取頭尾2點
if length(control_points_real)==0
    control_points_real=[same(1) same(end)];
end
control_points_real=[control_points_real control_points(end)];


%確保兩個特徵點不會太近 需>gap
index_l = 1;
index_r = 2;
control_keep=[];
while index_r < length(control_points_real)
    if control_points_real(index_r) -  control_points_real(index_l) >gap
        control_keep = [control_keep control_points_real(index_l)];
        index_l = index_r;
        index_r = index_r+1;
    else
        index_r = index_r+1;
    end

end
control_points_real = control_keep;

index_l = 1;
index_r = 2;
control_keep=[];
while index_r < length(control_points_real)
    if (abs(smooth_D(control_points_real(index_r)) -  smooth_D(control_points_real(index_l))) >0.005 ) | ((index_r - index_l)>gap*2)
        control_keep = [control_keep control_points_real(index_l)];
        index_l = index_r;
        index_r = index_r+1;
    else
        index_r = index_r+1;
    end

end


control_points_real=[control_keep length(smooth_D)];

for i=1:length(control_points_real)-1
    if control_points_real(i+1) - control_points_real(i) > gap*2
        tempt = round((control_points_real(i+1) + control_points_real(i))/2 ,0);
        control_points_real = [control_points_real tempt];
    end
    
end
control_points_real = sort(unique(control_points_real));

time_smooth=[];
Degree_smooth = [];
velo_smooth = [];
acc_smooth=[];
%從平滑化曲線取得DVA的值
for i=1:length(control_points_real)
    time_smooth = [time_smooth time_real(control_points_real(i))];
    Degree_smooth= [Degree_smooth smooth_D(control_points_real(i))];
    velo_smooth= [velo_smooth smooth_V(control_points_real(i))];
    acc_smooth= [acc_smooth smooth_A(control_points_real(i))];
end

characteristic=[control_points_real' time_smooth' Degree_smooth' velo_smooth' acc_smooth'];

end
