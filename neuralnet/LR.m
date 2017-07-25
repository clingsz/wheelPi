function res = LR(Xt,Yt,Xv,Yv)
W = [ones(size(Xt,1),1) Xt] \ Yt;
terr = mean(([ones(size(Xt,1),1) Xt]*W - Yt).^2);
yhat = [ones(size(Xv,1),1) Xv]*W;
verr = mean((yhat - Yv).^2);
ei = (yhat - Yv).^2;
res.W = W(2:end,:);
res.b = W(1,:);
res.terr = terr;
res.verr = verr;
res.ei = ei;
res.yhat = yhat;
end