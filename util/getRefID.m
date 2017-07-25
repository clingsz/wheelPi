function ID = getRefID(i,j)

if j<i
    c = j;
    j = i;
    i = c;
end
bs = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
ID = [bs{i} bs{j}];
end