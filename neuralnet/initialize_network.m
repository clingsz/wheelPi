function net = initialize_network(Xt,Yt,options)
dims = options.dims;
P = size(Xt,2);
rng(options.seed);
if options.tanhtransform==1
    dim = [size(Xt,2) size(Xt,2) dims size(Yt,2)];
else
    dim = [size(Xt,2) dims size(Yt,2)];
end
act = options.activation;
L = length(dim);
layers = cell(L-1,1);
for i = 1:L-1
    a = dim(i);
    b = dim(i+1);
    if i==1 && options.tanhtransform==1
        layers{i}.W = eye(a);
        layers{i}.activation = 'linear';
        layers{i}.b = zeros(1,b);
    else
        layers{i}.W = 0.5*sqrt(2/a)*randn(a,b);
        layers{i}.activation = act;
        layers{i}.b = zeros(1,b);
    end
    
    if strcmp(act,'lrelu')
        layers{i}.lrelualpha = options.lrelualpha;
    end
    if i==L-1
        layers{i}.activation = 'linear';
        if options.connectx==1
            layers{i}.WX = 0*sqrt(2/P)*randn(P,b);
            if options.initialfit==1
                layers{i}.WX = options.initialW;
            end
        end
    end
end
net.layers = layers;
net.options = options;
end