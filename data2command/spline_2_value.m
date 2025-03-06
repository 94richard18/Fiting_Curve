function [D,V,A] = spline_2_value(coef,new_t,old_t)
len = length(new_t);
part_1_D = zeros(1,len);
part_2_D = zeros(1,len);
part_3_D = zeros(1,len);

part_2_V = zeros(1,len);
part_3_V = zeros(1,len);

part_3_A = zeros(1,len);

mode =1 ;
for i =1:len
   if new_t(i)>old_t(mode+1)
      mode = mode+1;
   end
   
   if new_t(i)>old_t(end)
      mode = mode-1;
   end

   a_place=3*(mode-1); 
   part_1_D(i) = coef(a_place+1);
   part_2_D(i) = coef(a_place+2)*new_t(i);
   part_3_D(i) = coef(a_place+3)*new_t(i)^2;

   part_2_V(i) = coef(a_place+2);
   part_3_V(i) = 2*coef(a_place+3)*new_t(i);   

   part_3_A(i) = 2*coef(a_place+3);  
end

D = part_1_D+part_2_D +part_3_D;
V = part_2_V + part_3_V;
A = part_3_A;

end