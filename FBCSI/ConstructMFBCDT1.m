function R = ConstructMFBCDT1(A,m,n,Rho)

% R = -ones(m, m, n);
% for k = 1:n
%     for i = 1:m
%         for j = 1:m
%             R(i,j,k) =  Rho * (1 - abs(A(i,k)-A(j,k)));
%         end
%     end
% end
R = -ones(m, m, n);
for k = 1:n
    Sigma = std(A(:,k));	% standard deviation
    for i = 1:m
        for j = 1:m
            R(i,j,k) = Rho * max(min((A(j,k)-A(i,k)+Sigma)/Sigma, (A(i,k)-A(j,k)+Sigma)/Sigma), 0);
        end
    end
end   
% R

end