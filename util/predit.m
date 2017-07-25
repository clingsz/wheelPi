function y = predit(x,fr,method)
if strcmp(method,'ELAS')
     y = fr.a + x*fr.W;
elseif strcmp(method,'ELASAP')
     y = fr.a + buildAllPairs(x)*fr.W;
elseif strcmp(method,'GLM')
     y = fr.a + x*fr.W;
elseif strcmp(method,'GLMAP')
     y = fr.a + buildAllPairs(x)*fr.W;
elseif strcmp(method,'HN')
    topint = fr.hnfit.topint;
    xi = buildFromTopInt(x,topint);
    y = fr.a + xi*fr.W;
end
end