function FBN = RFBNO(B, Beta)% Reflexive fuzzy $\beta$-neighborhood operator 

 X = B';
 [m, n] = size(X);
 
 FBN = -ones(m);
 for i = 1:m
     minclta = ones(1,m);
     for j = 1:n
         if X(i,j) >= Beta
             cltaT = -ones(1,m);
             for k = 1:m
                 cltaT(1,k) = min(1, 1 - X(i,j) + X(k,j));
             end
             minclta = min(minclta,cltaT);
         end
     end
     FBN(i,:) = minclta;
 end

end