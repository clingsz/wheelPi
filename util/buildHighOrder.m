function [Z,lsts] = buildHighOrder(X,k)
p = size(X,2);
c = 0;
for i = 1:k
C = combnk(1:p,i);
for j = 1:size(C,1)
    c = c + 1;
    lsts{c} = C(j,:);
    Z(:,c) = prod(X(:,C(j,:)),2);
end
disp(c);
end
end