function [Xstd] = standardize(X)
if nargin<1
    X = rand(10,5);
end
[~,p] = size(X);
Xstd = X;
for i = 1:p
    xt = X(:,i);
    xt = xt - mean(xt);
    xt = xt/std(xt);
    Xstd(:,i) = xt;
end
end

