function [smooth_D,smooth_V,smooth_A] = smooth_curve(V_data,lambda,timestep)
%此程式用於將原始資料曲線平滑化，輸入為整個曲線的資料點
%lambda 越大代表曲線要越平滑


% 定義總變差正則化的目標函數
tvRegularization = @(x) sum(abs(diff(x)));

% 定義最佳化公式
objectiveFunction = @(x, lambda) norm(x - V_data, 2) + lambda * tvRegularization(x);

% 使用 fminunc 進行最佳化
options = optimset('Display', 'iter', 'TolFun', 1e-6);
smooth_V = fminunc(@(x) objectiveFunction(x, lambda), V_data, options);

% for i=1:length(smooth_V)
%     if abs(smooth_V(i)) < 0.001
%         smooth_V(i) = 0;
%     end
% end

smooth_D = cumtrapz(timestep,smooth_V);
smooth_A = gradient(smooth_V,timestep);

% %這個for是強迫abs(A)<0.02 通通設為0
% for i =1:length(smooth_A)
%     if abs(smooth_A(i))<20
%         smooth_A(i)=0;
%     end
% end
% %這個for是強迫abs(V)<0.001 通通設為0
% for i =1:length(smooth_V)
%     if abs(smooth_V(i))<0.05
%         smooth_V(i)=0;
%     end
% end


end