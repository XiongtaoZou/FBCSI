clc; clear; close all;

% data = [0.3 1 0.7 0.8 1;
%         0.4 0.5 0.3 1 1;
%         0   0   1   0 2;
%         1  0.5  0 0.2 3];
% data = [  0 0.6 0.5 1;
%         0.3 0.2 0.5 1;
%         0.3   0   0 1;
%         0.7 0.4 0.5 0;
%         0.7 0.8 0.5 0;
%           1   1   1 0];
% data
data = [0.3 1.1 3.2 1 1;
        1.4 1.5 2.1 1 2;
        2.1 1.9 1.4 2 3;
        2.8 2.3 0.7 2 3];
    
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
A
% A = C;

Rho = 1;  % 0.5:0.05:1
Beta = 0.6;
Delta = 0.1;% 0.1:0.1:0.5

%% 0.Construct the fuzzy $\beta$-covering decision table
% K = ConstructMFBCDT(A, Rho);
K = ConstructMFBCDT1(A, m, n, Rho);
K

% 1.Calculate the fuzzy $\beta$-neighborhood
ECT = -ones(m,m,n);
for i = 1:n
    ECT(:,:,i) = RFBNO(K(:,:,i), Beta);
end
% ECT
EC = PFBNO(ECT, Delta);
EC

%% 1.Attribute reduction
flagRed = zeros(1,n);   % One reduct
reduct = [];        
redIndex = [];
flagB = ones(1,n);      % The subset B of C

LMaxDD = 0; % Last maximum dependency degree
while(isNotEmpty(flagB))
    MaxDD = 0;	% Maximal dependency degree in B
    MaxDDj = 0; % Index of maximal dependency degree in B
    for j = 1:n
        if flagB(j) == 1
% 1. Calculate the fuzzy similarity class(relation) w.r.t. the subset $red ¡È a$.
%             R = FSRelation3([Red A(:,j)]); % (object*object)
            tempflagRed = flagRed;
            tempflagRed(j) = 1;
            R = FBN(EC,tempflagRed);  % (object*object)
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
            DD
            
            if DD > MaxDD
                MaxDD = DD;
            	MaxDDj = j;
            end
        end
    end
%     MaxDD
    
    % 5. Calculate the fuzzy dependency function of D w.r.t. the subset $red$.
    DD = LMaxDD;
%     LMaxDD
    LMaxDD = MaxDD;
    
    % 6. Calculate the significance
    SIG = MaxDD - DD;
%     SIG
    
    if SIG > 0.001 
    	flagRed(MaxDDj) = 1;
        reduct = [reduct C(:,MaxDDj)];
        redIndex = [redIndex MaxDDj];
        flagB(MaxDDj) = 0;
    else
    	break;
    end
end

flagRed
% reduct
redIndex
% flagB
