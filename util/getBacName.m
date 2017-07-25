function S = getBacName(x1,x2)
bs = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
if nargin<2
    S = bs{x1};
else
    S = [bs{x1} bs{x2}];
end
 
end