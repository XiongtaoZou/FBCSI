function R = ConstructMFBCDT(A, Rho)

[m, n] = size(A);       % m: number of objects, n: number of c---attributes
R = -ones(m, m, n);
for k = 1:n
    Sigma = std(A(:,k));	% standard deviation
%     Sigma
%     avg = mean(A(:,k));
%     avg
%     S = sqrt(sum((A(:,k)-avg).^2)/m);	% standard deviation
%     S
    for i = 1:m
        for j = 1:m
            R(i,j,k) = Rho * max(min((A(j,k)-A(i,k)+Sigma)/Sigma, (A(i,k)-A(j,k)+Sigma)/Sigma), 0);
        end
    end
end    
% R

end