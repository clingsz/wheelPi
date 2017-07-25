function [i,j,b,pre,pos] = getInfoX(X)
b = X(:,1)+1;
pre = X(:,2)+1;
pos = X(:,3)+1;
S = find(X(4:end)==1);
i = S(1);
j = S(2);
end