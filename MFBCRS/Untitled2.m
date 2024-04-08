clc; clear; close all;

% load Reduct_ionosphere_MFBCRS53
% Rho = 1;Beta = 0.5;Delta = 0.3;
% load Reduct_ProstateCancer_MFBCRS54
% Rho = 1;Beta = 0.5;Delta = 0.4;
load Reduct_clean1_MFBCRS54
Rho = 1;Beta = 0.5;Delta = 0.4;
data = [reduct class];
    
C = data(:,1:end-1);	% The conditional attribute set $C$
D = data(:,end);        % The decision attribute D

[m, n] = size(C);       % m: number of objects, n: number of c---attributes

DCT = zeros(m);         % Temp of the decision equivalence class $D_i$
for i = 1:m
    for j = 1:m
        if D(i) == D(j)
            DCT(i,j) = 1;
        end
    end
end
% DCT              
DC = unique(DCT,'rows');% The decision equivalence class $D_i$
% DC
r = size(DC,1);

% 0. Normalization
% A = C ./ repmat(sqrt(sum(C.^2)),m,1);	% Vectorial normalization method
A = (C-repmat(min(C),m,1)) ./ repmat(max(C)-min(C),m,1); % Max-Min method
% A
% A = C;

%% 0.Construct the fuzzy $\beta$-covering decision table
% K = ConstructMFBCDT(A, Rho);
K = ConstructMFBCDT1(A, m, n, Rho);
% K

% 1.Calculate the fuzzy $\beta$-neighborhood
ECT = -ones(m,m,n);
for i = 1:n
    ECT(:,:,i) = RFBNO(K(:,:,i), Beta);
end
% ECT
EC = PFBNO(ECT, Delta);
% EC

%% 1.Attribute reduction
flagRed = zeros(1,n);   % One reduct
FDF = zeros(1,n);       % One reduct
for j = 1:n
        % 1. Calculate the fuzzy similarity class(relation) w.r.t. the subset $red ¡È a$.
        %             R = FSRelation3([Red A(:,j)]); % (object*object)
        flagRed(j) = 1;
        R = FBN(EC,flagRed);  % (object*object)
        %             R
        
        % 2. Calculate the lower approximation of $D_i$ w.r.t.the subset $red ¡È a$.
        LAD = zeros(r,m); % class * object
        for ii = 1:r
            % DC(ii,:) = [1 1 0 0]; % The decision class $D_i$
            LAT = zeros(m); % Temp of the lower approximation of $D_i$
            for i = 1:m
                LAT(i,:) = max(1 - R(i,:), DC(ii,:));
            end
            LAD(ii,:) = min(LAT'); % The lower approximation of $D_i$
        end
        LAD = LAD .* DC;
        %             LAD
        
        % 3. Calculate the fuzzy positive region of D w.r.t. the subset $red ¡È a$.
        if r == 1
            POS = LAD;
        else
            POS = max(LAD);
        end
        %             POS
        
        % 4. Calculate the fuzzy dependency function of D w.r.t. the subset $red ¡È a$.
        DD = sum(POS) / m;
%         DD
        FDF(j) = DD;
end
FDF
