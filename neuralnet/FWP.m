function [v,h] = FWP(x,net,Training)
if nargin<3
    Training = 0;
end

     layers = net.layers;
     L = length(layers);
     rect = @(x) max(0,x);
     sigmoid = @(x) 1./(1+exp(-x));
     last = x;
     n = size(x,1);
     h = cell(L,1);
     dropout = net.options.dropout;
     for i = 1:L
        W = layers{i}.W;
        b = layers{i}.b;
        
        if Training
%             keyboard;
            in = last*W + repmat(b,[n 1]);
            droplst = rand(1,size(in,2))<dropout;
            in(:,droplst) = 0;
        else
            W = W*(1-dropout);
            in = last*W + repmat(b,[n 1]);
        end
        
        if isfield(layers{i},'WX')
           in = in + x*layers{i}.WX ;
        end
        if strcmp(layers{i}.activation,'relu')
            h{i} =  rect(in);
        elseif strcmp(layers{i}.activation,'lrelu')
            fin = in;
            nlst = find(in<0);
            fin(nlst) = in(nlst)*layers{i}.lrelualpha;
            h{i} =  fin;
        elseif strcmp(layers{i}.activation,'sigmoid')
            h{i} =  sigmoid(in);
        elseif strcmp(layers{i}.activation,'tanh')
            h{i} = tanh(in);
        elseif strcmp(layers{i}.activation,'linear')
            h{i} = in;
        else
            disp('No activation function!');
        end
        last = h{i};
     end
     v = h{L};
end