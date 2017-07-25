function id = convertpair2id(i,j)
if i>j
    temp = j;
    j = i;
    i = temp;
end
id = i*10+j;
end