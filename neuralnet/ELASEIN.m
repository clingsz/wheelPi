function fitres = ELASEIN(Xt,Yt,Xv,Yv,ein)
k = size(Yt,2);
    for i = 1:k
        Xti = buildIntFeature(Xt,ein(i).flst);
        Xvi = buildIntFeature(Xv,ein(i).flst);
        f = ELAS(Xti,Yt(:,i),Xvi,Yv(:,i));        
        fitres.verr(i) = f.verr;
    end
end

function Xi = buildIntFeature(X,flst)
    k = length(flst);
    Xi = X;
    for i = 1:k
        Xi = [Xi prod(X(:,flst{i}),2)];
    end
end