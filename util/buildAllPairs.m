function [XI,pairs] = buildAllPairs(X)

[n,p] = size(X);
XI = [];
c = 0;
pairs = repmat((1:p)',[1 2]);
for i = 1:p-1
    for j = i+1:p 
        c = c + 1;
        XI(:,c) = X(:,i).*X(:,j);
        pairs(c+p,:) = [i;j];
    end
end
XI = [X XI];