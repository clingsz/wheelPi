function res = learnnn(id)
addpaths;
if nargin<1
    id = 2144;
end
flst = [1:15];
wlst = [100 200 300 400];
dlst = 1:4;
l2lst = [0.01 0.05 0.1 0.5];
eplst = 10.*[100,200,300,400,500];
lsts = {flst,wlst,dlst,l2lst,eplst};
[inp,t] = getJobOpts(id,lsts);
disp(t);
res = trynn(inp(1),inp(2),inp(3),inp(4),inp(5));
end
function res = trynn(f,w,d,l2,ep)
[Xt,Yt,Xv,Yv] = loadwheeldata(f);
options.batchsize = 120;
options.verbose = 0;
options.dims = repmat(w,[1 d]);
options.L2 = l2;
options.maxepoch = ep;
options.patience = options.maxepoch;
options.activation = 'lrelu';
% options.optimizer = 'SGD';
options.learningrate = 0.001;
options.learningdecayrate = 0.999;
% options.learningdecayrate = 0.99;
r = fitnn(Xt,Yt,Xv,Yv,options);
res = r.verr;
end