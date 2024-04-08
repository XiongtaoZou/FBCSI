function ret = isNotEmpty(flagB)

n = size(flagB, 2);
ret = 1;
flag = 0;
for j = 1:n
    if flagB(j) == 0
        flag = flag + 1;
    end
end
if flag == n
    ret = 0;
end

end