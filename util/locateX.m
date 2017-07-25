function id = locateX(X,i,j,b,pre,pos)
pre = pre - 1;
pos = pos - 1;
b = b - 1;
i = i + 3;
j = j + 3;
id = find(X(:,1)==b & X(:,2)==pre & X(:,3)==pos & X(:,i)==1 & X(:,j)==1);
end