function [J,S] = getJacobian(x,net)
[~,hidden] = FWP(x,net);
[n,p] = size(x);
L = length(net.layers);
k = size(hidden{L},2);
Js = cell(1,k);
Jin = cell(1,k);
connectx = net.options.connectx;
for l = L:-1:1
    h = hidden{l};
    w = net.layers{l}.W;
    at = net.layers{l}.activation;
    if strcmp(at,'relu')
        h1h = h>0;
    elseif strcmp(at,'lrelu')
        h1h = zeros(size(h));
        h1h(h>0) = 1;
        h1h(h<0) = net.layers{l}.lrelualpha;
    elseif strcmp(at,'sigmoid')
        h1h = h.*(1-h); 
    elseif strcmp(at,'tanh')
        h1h = 1 - h.^2;
    elseif strcmp(at,'linear')
        h1h = ones(size(h));
    else
        disp('No idea about the activation function');
    end
    for i = 1:k
        if l==L
            if connectx
               wx = net.layers{l}.WX;
               m = size(w,1);
               D = h1h(:,i)*[w(:,i);wx(:,i)]'; 
               Js{i} = D(:,1:m);
               Jin{i} = D(:,m+1:end);
            else
               Js{i} = h1h(:,i)*w(:,i)'; 
            end
        else
            Js{i} = Js{i}.*h1h*w';
            if l==1 && connectx
                Js{i} = Js{i} + Jin{i};
            end
        end
    end
end
J = zeros(n,p,k);
for i = 1:k
    J(:,:,i) = Js{i};
end
S = squeeze(mean(abs(J),1));
V = squeeze(var(J,1));
