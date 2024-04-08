function [LAD,UAD] = computingFBCRS(EC,flagRed,DC,m,r)

% 1. Calculate the fuzzy similarity class w.r.t. the subset $red ¡È a$.
R = FBN(EC,flagRed);  % (object*object)
% R

% 2. Calculate the lower and upper approximation of $D_i$
LAD = zeros(r,m); % The lower approximation of $D_i$(class * object)
UAD = zeros(r,m); % The upper approximation of $D_i$(class * object)
for ii = 1:r
    LAT = -ones(m); % Temp of the lower approximation of $D_i$
    UAT = -ones(m); % Temp of the upper approximation of $D_i$
    for i = 1:m
        LAT(i,:) = max(1 - R(i,:), DC(ii,:));
        UAT(i,:) = min(R(i,:),DC(ii,:));
    end
    LAD(ii,:) = min(LAT'); % The lower approximation of $D_i$
    UAD(ii,:) = max(UAT'); % The upper approximation of $D_i$
end

for ii = 1:r
    for i = 1:m
        if DC(ii,i) == 1
            UAD(ii,i) = 1; % The upper approximation of $D_i$
        else
            LAD(ii,i) = 0; % The lower approximation of $D_i$
        end
    end
end

end
