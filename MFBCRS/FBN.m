function E = FBN(EC, flagB)
% Calculate the fuzzy similarity class
m = size(EC,1);
n = size(EC,3);
E = ones(m);
for i = 1:n
    if flagB(i) == 1
        E = min(E, EC(:,:,i));
    end
end

end


