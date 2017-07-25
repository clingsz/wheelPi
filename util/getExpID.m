function ID = getExpID(pre,pos,i,j)

if j<i
    c = j;
    j = i;
    i = c;
end
prestr = {'minusP','plusP'};
posstr = {'30uM','100uM'};
bs = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
ID = [prestr{pre} ',' posstr{pos} ',' bs{i} bs{j}];
end