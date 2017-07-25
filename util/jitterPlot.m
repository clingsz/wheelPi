function jitterPlot(y,eps,T,sym)
if nargin<2
    eps = 0.07;
end
if nargin<3
    T = 0;
end
if nargin<4
    sym = 'bo';
end
[n,p] = size(y);
xs = repmat(1:p,[n 1]);
xs = xs + randn(n,p)*eps;
if T==0
    scatter(xs(:),y(:),20,sym);grid;
else
    scatter(y(:),xs(:),20,sym);grid;
end