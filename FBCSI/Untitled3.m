clc; clear; close all;

% load Reduct_ionosphere_FBCSI55
% Rho = 1;Beta = 0.5;Delta = 0.5;
% load Reduct_ProstateCancer_FBCSI54
% Rho = 1;Beta = 0.5;Delta = 0.4;
load Reduct_clean1_FBCSI52
Rho = 1;Beta = 0.5;Delta = 0.2;

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
DC = unique(DCT,'rows');
% DC
r = size(DC,1);

% 0.Normalization
A = (C-repmat(min(C),m,1)) ./ repmat(max(C)-min(C),m,1); % Max-Min method
% A
% A = C; % Normalization

%% 0.Construct the fuzzy $\beta$-covering decision table
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
DSI = zeros(1,n);   % One reduct
for j = 1:n
    % 1.计算邻域粗糙集上下近似
    flagRed(j) = 1;
    [LAD,UAD] = computingFBCRS(EC,flagRed,DC,m,r);
    %             LAD
    %             UAD
    % 2.计算相对决策邻域自信息
    RDNSI = 0;
    for i = 1:r
        RDNSI = RDNSI - (1-sum(LAD(i,:))/sum(UAD(i,:)))...
            *log2((sum(LAD(i,:))+0.00001)/(sum(UAD(i,:))+0.00001));
    end
    %             RDNSI
    DSI(j) = RDNSI;
end

DSI

