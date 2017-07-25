function D = getDiffInAllSamples(f,X)
[n,p] = size(X);
D = zeros(n,p);
for i = 1:p
   X1 = X;
   X0 = X;
   X1(:,i)=1;
   X0(:,i)=0;
   D(:,i) = f(X1)-f(X0);
end
end