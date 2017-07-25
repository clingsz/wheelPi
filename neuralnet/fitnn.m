function nnfit = fitnn(Xt,Yt,Xv,Yv,options)
% Xt,Yt,Xv,Yv: train and test set
% options: see setoptions
options = setoption(options);
net = initialize_network(Xt,Yt,options);
% if isfield(options,'initfit')
%     net = initialize_network_LRfit(net,options.initfit);
% end
% [Xa,Ya,Xb,Yb] =
% getvalidationset(Xt,Yt,options.validationratio,options.seed);
if options.layerwisefinetune == 1
    L = length(options.dims);
    for l = 1:L
        tempnet = net;
        tempnet.layers(l+1:L) = [];
        %    keyboard;
        tempnet = FineTune(Xt,Yt,Xv,Yv,tempnet);
        for i = 1:l
            net.layers{i} = tempnet.layers{i};
            if i==L
                net.layers{L+1} = tempnet.layers{L+1};               
            end
        end
    end
else
    [net] = FineTune(Xt,Yt,Xv,Yv,net);
end
[verr,E] = getPredictionErr(Xv,Yv,net);
nnfit.net = net;
nnfit.verr = verr;
nnfit.E = E;
% nnfit.verrhis = verrhis;
end
