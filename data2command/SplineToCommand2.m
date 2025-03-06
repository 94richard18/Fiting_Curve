function [command] = SplineToCommand2(control_points,time,spline_t,spline_D,spline_V,spline_A,motorID)
%目的:將spline得到的資料轉成馬達指令
%input:特徵點編號/時間/特徵點時間/spline_D/spline_V/spline_A/馬達ID
%output:馬達指令(time,更改指令D,V,A,目標D,motorID)
%馬達ID要手動更新，馬達ID請至 DYNAMIXEL Wizard 2.0 查看或修改

%獲取要用在spline的特徵點之V&A
command_T=zeros(length(control_points),1);
command_D=zeros(length(control_points),1);
command_V=zeros(length(control_points),1);
command_A=zeros(length(control_points),1);
command_ID=zeros(length(control_points),1);
for i=1:length(control_points)
    command_T(i)=(time(control_points(i)))*60*1000;%min-->ms
    command_D(i)=(spline_D(control_points(i)))*501923*2;%rev--->pulse
    command_V(i)=(spline_V(control_points(i)))*100;%rev/min -->100*rev/min
    command_A(i)=(spline_A(control_points(i)));%rev/min^2
    command_ID(i)= motorID;

end
command_targetD = command_D;

for i=1:length(command_A)
    if command_A(i) > 700
        command_A(i) = 700;
    end
end

%將速度上升時的目標位置調整成最大位置，確保能到想要的速度值
i_index=[];
for i=2:length(spline_t)
    v1 = round(command_V(i),0);
    v0 = round(command_V(i-1),0);

    if  (v1>v0)
        i_index=[i_index i];
        command_targetD(i) = 480000;
    elseif (v1<v0)
        i_index=[i_index i];
        command_targetD(i) = -480000;
    end
   
end
command_targetD(end) = command_D(end);
command_V(end) = command_V(length(command_V)-1);

%找到速度降低的點並計算虛擬的目標位置
%虛擬的目標位置是為了讓馬達跑出想要的曲線而設
change=[];
change_target_D=[0];
%計算虛擬位置，利用斜率相等計算出何時速度會為0，利用此時間可得到虛擬位置
for i=2:length(command_V)
    tempt_targetD=0;
    v1 = command_V(i);
    v0 = command_V(i-1);

    if ((v1<=0 && v0 <=0) && v1-v0>0) || ((v1>=0 && v0 >=0) && v1-v0<0)
        change=[change i];
        x1=spline_t(i-1);
        x2=spline_t(i);
        y1=abs(command_V(i-1));
        y2=abs(command_V(i));
        x3=(-y2*(x2-x1))/(y2-y1) + x2;
        move = ((x3-x2)*y2/2/(100/(2*501923)));
        if command_V(i)>0
            tempt_targetD = command_D(i)+move;
        elseif command_V(i)<0
            tempt_targetD = command_D(i)-move; 
        end
        if tempt_targetD>501923 
           tempt_targetD=480000;
        elseif tempt_targetD<-501923 
           tempt_targetD=-480000;
        end
        %command_V(i) = command_V(i-1);
    end     

    change_target_D=[change_target_D tempt_targetD];
     
end

%將虛擬目標位置輸入至目標位置中
for i=1:length(change)
    command_targetD(change(i)) = round(change_target_D(change(i)),0);
    command_V(change(i)) = command_V(change(i)-1);
end


command_targetD(end) = command_D(end);
%將spline轉換成馬達指令
command=[round(command_T,3) round(command_D,0) abs(round(command_V,0)) abs(round(command_A,0)) round(command_targetD,0) command_ID];
%command=[round(command_T,3) round(command_D,0) abs(round(command_V,0)) abs(round(command_A,0)) round(command_targetD,0)];
%將a為0的列都設為1
%由於如果將A設為0代表馬達加速度會以最大值至V之上限，因此1為最小加速度
[target_row,target_col]=size(command);
for i=1:target_row
    if command(i,4)==0
        command(i,4)=1;
    end
end

for i=1:target_row
    if command(i,3)==0
        % command(i,2)=0;
        % command(i,5)=0;
        command(i,3)=1;
    end
end

command(1:target_row-1,2:end) = command(2:target_row,2:end);

%command = command(2:end,1:end);




end