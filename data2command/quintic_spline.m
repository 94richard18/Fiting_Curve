function [a] = quintic_spline(input_x,input_t)

n=length(input_x)-1;

%s(ti)=y(i)
left_matrix_1 = zeros(n,6*n);
right_matrix_1=zeros(n,1);
for i=1:n
    matrix_place=6*(i-1);
    left_matrix_1(i,matrix_place+1)=1;
    left_matrix_1(i,matrix_place+2)=input_t(i);
    left_matrix_1(i,matrix_place+3)=input_t(i)^2;
    left_matrix_1(i,matrix_place+4)=input_t(i)^3;
    left_matrix_1(i,matrix_place+5)=input_t(i)^4;
    left_matrix_1(i,matrix_place+6)=input_t(i)^5;
    
    right_matrix_1(i)=input_x(i);
end

%s((t+1)i)=y(i+1)
left_matrix_2 = zeros(n,6*n);
right_matrix_2=zeros(n,1);
for i=1:n
    matrix_place=6*(i-1);
    left_matrix_2(i,matrix_place+1)=1;
    left_matrix_2(i,matrix_place+2)=input_t(i+1);
    left_matrix_2(i,matrix_place+3)=input_t(i+1)^2;
    left_matrix_2(i,matrix_place+4)=input_t(i+1)^3;
    left_matrix_2(i,matrix_place+5)=input_t(i+1)^4;
    left_matrix_2(i,matrix_place+6)=input_t(i+1)^5;
    
    right_matrix_2(i)=input_x(i+1);
end

%一階微分連續
left_matrix_3 = zeros(n-1,6*n);
right_matrix_3 = zeros(n-1,1);
for i=1:n-1
    matrix_place=6*(i-1);
    
    left_matrix_3(i,matrix_place+2)=1;
    left_matrix_3(i,matrix_place+3)=2*input_t(i+1);
    left_matrix_3(i,matrix_place+4)=3*input_t(i+1)^2;
    left_matrix_3(i,matrix_place+5)=4*input_t(i+1)^3;
    left_matrix_3(i,matrix_place+6)=5*input_t(i+1)^4;    
    

    left_matrix_3(i,matrix_place+8) = -1;
    left_matrix_3(i,matrix_place+9) = -2*input_t(i+1);
    left_matrix_3(i,matrix_place+10)= -3*input_t(i+1)^2;
    left_matrix_3(i,matrix_place+11)= -4*input_t(i+1)^3;
    left_matrix_3(i,matrix_place+12)= -5*input_t(i+1)^4;    
    
end

%二階微分連續
left_matrix_4 = zeros(n-1,6*n);
right_matrix_4 =zeros(n-1,1);
for i=1:n-1
    matrix_place=6*(i-1);
    
    left_matrix_4(i,matrix_place+3)= 2;
    left_matrix_4(i,matrix_place+4)= 6*input_t(i+1);
    left_matrix_4(i,matrix_place+5)= 12*input_t(i+1)^2;
    left_matrix_4(i,matrix_place+6)= 20*input_t(i+1)^3;    
    
    left_matrix_4(i,matrix_place+9) = -2;
    left_matrix_4(i,matrix_place+10)= -6*input_t(i+1);
    left_matrix_4(i,matrix_place+11)= -12*input_t(i+1)^2;
    left_matrix_4(i,matrix_place+12)= -20*input_t(i+1)^3;    
    
end

%三階微分連續
left_matrix_5 = zeros(n-1,6*n);
right_matrix_5 =zeros(n-1,1);
for i=1:n-1
    matrix_place=6*(i-1);
    
    left_matrix_5(i,matrix_place+4)=6;
    left_matrix_5(i,matrix_place+5)=24*input_t(i+1);
    left_matrix_5(i,matrix_place+6)=60*input_t(i+1)^2;    
    
    left_matrix_5(i,matrix_place+10)=-6;
    left_matrix_5(i,matrix_place+11)=-24*input_t(i+1);
    left_matrix_5(i,matrix_place+12)=-60*input_t(i+1)^2;    
    
end

%四階微分連續
left_matrix_6 = zeros(n-1,6*n);
right_matrix_6 =zeros(n-1,1);
for i=1:n-1
    matrix_place=6*(i-1);
    
    left_matrix_6(i,matrix_place+5)=24;
    left_matrix_6(i,matrix_place+6)=120*input_t(i+1);    

    left_matrix_6(i,matrix_place+11)=-24;
    left_matrix_6(i,matrix_place+12)=-120*input_t(i+1);    
    
end


left_matrix_7 = zeros(4,6*n);
right_matrix_7 =zeros(4,1);
%s(t1)=0
left_matrix_7(1,2)=1;
left_matrix_7(1,3)=2*input_t(1);
left_matrix_7(1,4)=3*input_t(1)^2;
left_matrix_7(1,5)=4*input_t(1)^3;
left_matrix_7(1,6)=5*input_t(1)^4;   
%s'(t1)=0
left_matrix_7(2,3)=2;
left_matrix_7(2,4)=6*input_t(1);
left_matrix_7(2,5)=12*input_t(1)^2;
left_matrix_7(2,6)=20*input_t(1)^3;  
%s(tn+1)=0
left_matrix_7(3,6*n-4)=1;
left_matrix_7(3,6*n-3)=2*input_t(n+1);
left_matrix_7(3,6*n-2)=3*input_t(n+1)^2;
left_matrix_7(3,6*n-1)=4*input_t(n+1)^3;
left_matrix_7(3,6*n)=5*input_t(n+1)^4;  
%s'(tn+1)=0
left_matrix_7(4,6*n-3)=2;
left_matrix_7(4,6*n-2)=6*input_t(n+1);
left_matrix_7(4,6*n-1)=12*input_t(n+1)^2;
left_matrix_7(4,6*n)=20*input_t(n+1)^3; 




left_matrix=[left_matrix_1;left_matrix_2;left_matrix_3;left_matrix_4;left_matrix_5;left_matrix_6;left_matrix_7];
right_matrix=[right_matrix_1;right_matrix_2;right_matrix_3;right_matrix_4;right_matrix_5;right_matrix_6;right_matrix_7];

a=left_matrix\right_matrix;

end

