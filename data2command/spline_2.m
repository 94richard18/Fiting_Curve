function [coef] = spline_2(input_x,input_t,bound)

if ~ exist('bound','Var')
    bound=[0];
end
n=length(input_x)-1;
%s(ti) = yi
left_matrix_1 = zeros(n,3*n);
right_matrix_1 = zeros(n,1);
for i =1:n
    matrix_place=3*(i-1);
    left_matrix_1(i,matrix_place+1)=1;
    left_matrix_1(i,matrix_place+2)=double(input_t(i));    
    left_matrix_1(i,matrix_place+3)=double(input_t(i)^2);

    right_matrix_1(i)=input_x(i);
end

%s((t+1)i)=y(i+1)
left_matrix_2 = zeros(n,3*n);
right_matrix_2=zeros(n,1);
for i=1:n
    matrix_place=3*(i-1);
    left_matrix_2(i,matrix_place+1)=1;
    left_matrix_2(i,matrix_place+2)=double(input_t(i+1));
    left_matrix_2(i,matrix_place+3)=double(input_t(i+1)^2);
    
    right_matrix_2(i)=input_x(i+1);
end


%一階微分連續
left_matrix_3 = zeros(n-1,3*n);
right_matrix_3 = zeros(n-1,1);
for i=1:n-1
    matrix_place=3*(i-1);
    
    left_matrix_3(i,matrix_place+2)=1;
    left_matrix_3(i,matrix_place+3)=2*double(input_t(i+1));
   
    

    left_matrix_3(i,matrix_place+5) = -1;
    left_matrix_3(i,matrix_place+6) = -2*double(input_t(i+1));   
    
end

%bound
left_matrix_4 = zeros(1,3*n);
right_matrix_4 = bound;

%s'(t1)=0
left_matrix_4(2)=1;
left_matrix_4(3)=2*double(input_t(1));

left_matrix=[left_matrix_1;left_matrix_2;left_matrix_3;left_matrix_4];
right_matrix=[right_matrix_1;right_matrix_2;right_matrix_3;right_matrix_4];

coef=double(left_matrix\right_matrix);

end