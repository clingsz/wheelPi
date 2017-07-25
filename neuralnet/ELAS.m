function res = ELAS(Xt,Yt,Xv,Yv)
if nargin<3
    Xv = Xt;
    Yv = Yt;
end
k = size(Yv,2);
for i = 1:k
%     keyboard;
    [ba,fitinfoa] = lasso(Xt,Yt(:,i),'CV',20,'Alpha',.5);
    
    [B,S] = lasso(Xt,Yt(:,i),'Lambda',fitinfoa.LambdaMinMSE);
    a = S.Intercept;
    terr = mean((Xt*B+a - Yt(:,i)).^2);
    allerr = (Xv*B+a - Yv(:,i)); 
    verr = mean(allerr.^2);    
    fit{i}.W = B;
    fit{i}.a = a;
    fit{i}.verr = verr;
    fit{i}.allerr = allerr;
    disp([i k terr verr]);
end
W = [];
verr = [];
allerr = [];
for i = 1:k
    verr(i) = fit{i}.verr;
    allerr(i,:) = fit{i}.allerr;
    W(:,i) = fit{i}.W;
    a(1,i) = fit{i}.a;
    res.verr = verr;
    res.W = W;
    res.a = a;
    res.allerr = allerr;
end
end

