clc; clear; close all;

% data = [  0 0.6 0.5 1;
%         0.3 0.2 0.5 1;
%         0.3   0   0 1;
%         0.7 0.4 0.5 0;
%         0.7 0.8 0.5 0;
%           1   1   1 0];
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
DC = unique(DCT,'rows');
% DC
r = size(DC,1);

% 0.Normalization
A = (C-repmat(min(C),m,1)) ./ repmat(max(C)-min(C),m,1); % Max-Min method
A
% A = C; % Normalization

Rho = 1;  % 0.5:0.05:1
Beta = 0.6;
Delta = 0.1;% 0.1:0.1:0.5

%% 0.Construct the fuzzy $\beta$-covering decision table
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
Red = [];	
reduct = [];
redIndex = [];
flagB = ones(1,n);      % The subset B of C

LMinRDNSI = realmax;	% minimal NSI in B
LMinRDNSIj = 0;         % Index of minimal NSI in B
for j = 1:n
    if flagB(j) == 1
        % 1.计算邻域粗糙集上下近似
        tempflagRed = flagRed;
        tempflagRed(j) = 1;
        [LAD,UAD] = computingFBCRS(EC,tempflagRed,DC,m,r);
%         LAD
%         UAD
        % 2.计算相对决策邻域自信息
        RDNSI = 0;
        for i = 1:r
            RDNSI = RDNSI - (1-sum(LAD(i,:))/sum(UAD(i,:)))...
                *log2((sum(LAD(i,:))+0.00001)/(sum(UAD(i,:))+0.00001));
        end
        RDNSI
        
        if RDNSI < LMinRDNSI
            LMinRDNSI = RDNSI;
            LMinRDNSIj = j;
        end
    end
end
flagRed(LMinRDNSIj) = 1;
Red = [Red A(:,LMinRDNSIj)];
reduct = [reduct C(:,LMinRDNSIj)];
redIndex = [redIndex LMinRDNSIj];
flagB(LMinRDNSIj) = 0;
% LMinRDNSI

while(isNotEmpty(flagB))
    MinRDNSI = realmax;	% minimal NSI in B
    MinRDNSIj = 0;      % Index of minimal NSI in B
    for j = 1:n
        if flagB(j) == 1
            % 1.计算邻域粗糙集上下近似
            tempflagRed = flagRed;
            tempflagRed(j) = 1;
            [LAD,UAD] = computingFBCRS(EC,tempflagRed,DC,m,r);
%             LAD
%             UAD
            % 2.计算相对决策邻域自信息
            RDNSI = 0;
            for i = 1:r
                RDNSI = RDNSI - (1-sum(LAD(i,:))/sum(UAD(i,:)))...
                    *log2((sum(LAD(i,:))+0.00001)/(sum(UAD(i,:))+0.00001));
            end
            RDNSI
            
            if RDNSI < MinRDNSI
                MinRDNSI = RDNSI;
            	MinRDNSIj = j;
            end
        end
    end
    
    RDNSI = LMinRDNSI;
    LMinRDNSI = MinRDNSI;
    SIG = RDNSI - MinRDNSI;% Calculate the significance
%     MinRDNSI
    
    if SIG > 0.001
    	flagRed(MinRDNSIj) = 1;
        Red = [Red A(:,MinRDNSIj)];
        reduct = [reduct C(:,MinRDNSIj)];
        redIndex = [redIndex MinRDNSIj];
        flagB(MinRDNSIj) = 0;
    else
    	break;
    end
end

flagRed
% reduct
redIndex
% flagB
% save wine_NFARNRS reduct class;

