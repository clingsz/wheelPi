function [grads, vr, hess] = getFiniteDiff(x,net,eps)
% [~,hidden] = FWP(x,net);
if nargin<3
eps = 1e-6;
end
[n,p] = size(x);
x1 = x;  x2=x;
k = length(net.layers{end}.b);
grads = zeros(n,p,k);
for i = 1:p
    x1(:,i) = x1(:,i) + eps;
    x2(:,i) = x2(:,i) - eps;
    y1 = FWP(x1,net);
    y2 = FWP(x2,net);
    grads(:,i,:) = reshape((y1-y2)./(eps*2),[n 1 k]);
    x1(:,i) = x1(:,i) - eps;
    x2(:,i) = x2(:,i) + eps;
end
x3 = x;
x4 = x;

for i = 1:p
    for j = i:p
        x1(:,i) = x1(:,i) + eps;
        x1(:,j) = x1(:,j) + eps;
        x2(:,i) = x2(:,i) - eps;
        x2(:,j) = x2(:,j) - eps;
        x3(:,i) = x3(:,i) + eps;
        x3(:,j) = x3(:,j) - eps;
        x4(:,i) = x4(:,i) - eps;
        x4(:,j) = x4(:,j) + eps;        
        y1 = FWP(x1,net);
        y2 = FWP(x2,net);
        y3 = FWP(x3,net);
        y4 = FWP(x4,net);
        hess(:,i,j,:) = reshape((y1+y2-y3-y4)./(eps*eps*4),[n 1 1 k]);
        x1 = x;
        x2 = x;
        x3 = x;
        x4 = x;
    end
end

for i = 1:k
    vr(i,:) = std(grads(:,:,i));
end
