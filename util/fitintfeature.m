function res = fitintfeature(id)
addpaths;
if nargin<1
    id = 2;
end
lsts = {1:100,1:5};
[inp,t] = getJobOpts(id,lsts);
disp(t);
it = inp(1);
int = inp(2);
load data/intexp

X = Xi{int};
Y = V(:,it);
res = GLM(X,Y,X,Y);
end