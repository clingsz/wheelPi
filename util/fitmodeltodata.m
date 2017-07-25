function fitmodeltodata
addpaths;
folds = 6;

%%
% for i = 1:15
i = folds;
[Xt,Yt,Xv,Yv] = loadwheeldata(i);
options.batchsize = 120;
options.verbose = 1;
options.dims = 200.*[1];
options.seed = 2;
options.L2 = 0.05;
options.maxepoch = 20000;
options.patience = options.maxepoch;
options.activation = 'lrelu';
options.learningrate = 0.001;
options.learningdecayrate = 0.999;
res = fitnn(Xt,Yt,Xv,Yv,options);
% load bestnetcverr;
%%
% res.verr = verr;
% save('bestnet','res');