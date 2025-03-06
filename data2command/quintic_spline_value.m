function [D,V,A,J] = quintic_spline_value(a,new_t,old_t)

part_1=zeros(1,length(new_t));
part_2=zeros(1,length(new_t));
part_3=zeros(1,length(new_t));
part_4=zeros(1,length(new_t));
part_5=zeros(1,length(new_t));
part_6=zeros(1,length(new_t));

part_2_V=zeros(1,length(new_t));
part_3_V=zeros(1,length(new_t));
part_4_V=zeros(1,length(new_t));
part_5_V=zeros(1,length(new_t));
part_6_V=zeros(1,length(new_t));

part_3_A=zeros(1,length(new_t));
part_4_A=zeros(1,length(new_t));
part_5_A=zeros(1,length(new_t));
part_6_A=zeros(1,length(new_t));

part_4_J=zeros(1,length(new_t));
part_5_J=zeros(1,length(new_t));
part_6_J=zeros(1,length(new_t));

mode=1;
for i =1:length(new_t)
   if new_t(i)>old_t(mode+1)
      mode = mode+1;
   end

   a_place=6*(mode-1);
   part_1(i) = a(a_place+1);
   part_2(i) = a(a_place+2)*new_t(i);
   part_3(i) = a(a_place+3)*new_t(i)^2;
   part_4(i) = a(a_place+4)*new_t(i)^3;
   part_5(i) = a(a_place+5)*new_t(i)^4;
   part_6(i) = a(a_place+6)*new_t(i)^5;
   
   part_2_V(i) = a(a_place+2);
   part_3_V(i) = 2*a(a_place+3)*new_t(i);
   part_4_V(i) = 3*a(a_place+4)*new_t(i)^2;
   part_5_V(i) = 4*a(a_place+5)*new_t(i)^3;
   part_6_V(i) = 5*a(a_place+6)*new_t(i)^4;  
   
   part_3_A(i) = 2*a(a_place+3);
   part_4_A(i) = 6*a(a_place+4)*new_t(i);
   part_5_A(i) = 12*a(a_place+5)*new_t(i)^2;
   part_6_A(i) = 20*a(a_place+6)*new_t(i)^3;     
   
   part_4_J(i) = 6*a(a_place+4);
   part_5_J(i) = 24*a(a_place+5)*new_t(i);
   part_6_J(i) = 60*a(a_place+6)*new_t(i)^2;    
   
end

D = part_1+part_2 +part_3+part_4+part_5+part_6;
V = part_2_V + part_3_V + part_4_V + part_5_V + part_6_V;
A = part_3_A + part_4_A + part_5_A + part_6_A;
J = part_4_J + part_5_J + part_6_J;
end

