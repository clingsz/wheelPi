function fitres = fitit(Xt,Yt,Xv,Yv,method)
if strcmp(method,'ELAS')
    fitres = ELAS(Xt,Yt,Xv,Yv);
elseif strcmp(method,'ELASAP')
    [Xti] = buildAllPairs(Xt);
    [Xvi] = buildAllPairs(Xv);
    fitres = ELAS(Xti,Yt,Xvi,Yv);
elseif strcmp(method,'GLM')
    fitres = GLM(Xt,Yt,Xv,Yv);
elseif strcmp(method,'GLMAP')
    fitres = GLM(Xt,Yt,Xv,Yv,1);
elseif strcmp(method,'HN')
    hnfit = runHN(Xt,Yt,Xv,Yv);
    topint = hnfit.topint;
    Xti = buildFromTopInt(Xt,topint);
    Xvi = buildFromTopInt(Xv,topint);
    fitres = GLM(Xti,Yt,Xvi,Yv);
    fitres.hnfit = hnfit;
end
fitres.method = method;
end