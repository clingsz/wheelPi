function [net,optstats] = applyGrads(net,grads,optstats)
options = net.options;
layers = net.layers;
eta = optstats.learningrate;
EG2 = optstats.EG2;
L = length(layers);
eps = 1e-3;
for l = L:-1:1
    if strcmp(options.optimizer,'SGD')
        layers{l}.W = layers{l}.W - eta*grads{l}.dw;
        layers{l}.b = layers{l}.b - eta*grads{l}.db;
        if isfield(layers{l},'WX')
           layers{l}.WX =  layers{l}.WX - eta*grads{l}.dwx;
        end
    elseif strcmp(options.optimizer,'RMSPROP')
        EG2{l}.dw2 = 0.9*EG2{l}.dw2 + 0.1*grads{l}.dw.^2;
        EG2{l}.db2 = 0.9*EG2{l}.db2 + 0.1*grads{l}.db.^2;
        layers{l}.W = layers{l}.W - (eta)./sqrt(EG2{l}.dw2+eps).*grads{l}.dw;
        layers{l}.b = layers{l}.b - (eta)./sqrt(EG2{l}.db2+eps).*grads{l}.db;
        if isfield(layers{l},'WX')
            EG2{l}.dwx2 = 0.9*EG2{l}.dwx2 + 0.1*grads{l}.dwx.^2;
            layers{l}.WX = layers{l}.WX - (eta)./sqrt(EG2{l}.dwx2+eps).*grads{l}.dwx;
        end
    end
end
optstats.learningrate = eta*options.learningdecayrate;
optstats.EG2 = EG2;
net.layers = layers;
end