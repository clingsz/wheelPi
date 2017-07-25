function [err,E] = getPredictionErr(x,y,net)
    v = FWP(x,net);
    [err,E] = getmse(v,y);
    