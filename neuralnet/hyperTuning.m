function nnfit = hyperTuning(Xt,Yt,Xv,Yv,options)

% options.width = 20;
% options.depth = 1;
% options.verbose = 1;
% options.L1 = [0.01  0.05];
% options.L2 = 0;
% options.tanhtransform = 0;
% options.learningrate = 0.001;
% options.maxepoch = 100;
% options.connectx = 1;
% options.patience = 500;
% options.verbose = 0;
if options.glmfilter==1
    m = GLM(Xt,Yt,Xv,Yv,1);
    p = size(Xt,2);
    lst = visualAP(m,p);
    Xt = Xt(:,lst);
    Xv = Xv(:,lst);
end
n = size(Xt,1);
validn = ceil(n*0.2);
rlst = randperm(n);
valid_lst = rlst(1:validn);
train_lst = setdiff(1:n,valid_lst);
xtrain = Xt(train_lst,:);
ytrain = Yt(train_lst,:);
xvalid = Xv(valid_lst,:);
yvalid = Yv(valid_lst,:);
L = 20;
L1lst = logspace(-4,-1,L);
bestError = realmax;
bestopts = options;
c = 0;
total = L;
for i = 1:L
    c = c + 1;
    fprintf('Trial %d, Total %d\n',c,total);
    thisopt = options;
    thisopt.L1 = L1lst(i);
    fprintf('Testing ');
    showopts(thisopt)
    nntemp = fitnn(xtrain,ytrain,xvalid,yvalid,thisopt);
    thisverr = nntemp.verr;
    fprintf('ValidationError:%.5f\n',thisverr);
    if thisverr<bestError
        bestError = thisverr;
        bestopts = thisopt;
    end
    fprintf('Nowbest ');
    showopts(bestopts);
    fprintf('ValidationError:%.5f\n',bestError);
    verr(i) = thisverr;
    opts{i} = thisopt;
    nets{i} = nntemp.net;
    [~,V{i},S{i}] = getJacobian(Xt,nets{i});
end
[~,b] = min(verr(:));
bestopt = options;
bestopt.L1 = L1lst(b);
nnfit = fitnn(Xt,Yt,Xv,Yv,bestopt);
nnfit.hypverr = verr;
nnfit.hypopts = opts;
nnfit.allnets = nets;
nnfit.Vs = V;
nnfit.Ss = S;
end

function showopts(thisopt)
fprintf('L1=%.5f ',thisopt.L1);
end