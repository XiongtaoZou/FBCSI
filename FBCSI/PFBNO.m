function EC = PFBNO(ECT, Lambda)

m = size(ECT,1);
n = size(ECT,3);

EC = ECT;
for k = 1:n
   for i = 1:m
       for j = 1:m
           if ECT(i,j,k) < Lambda
               EC(i,j,k) = 0;
           end
       end
   end
end

end


