function [grads,Obj] = getGrads(x,y,net,t)
options = net.options;
[v,hidden] = FWP(x,net,1);
[n,p] = size(x);
layers = net.layers;
L = length(layers);
k = size(layers{L}.W,2);
deh = 2*(v-y);
% penalty
L1 = options.L1;
L2 = options.L2;
Obj = mean((v(:)-y(:)).^2);
hgrad = cell(L,1);
for l = L:-1:1
    h = hidden{l};
    w = layers{l}.W;
    m = size(h,2);
    at = layers{l}.activation;
    if l==1
        olast = x;
    else
        olast = hidden{l-1};
    end
    
    if strcmp(at,'relu')
        h1h = h>0;
    elseif strcmp(at,'lrelu')
        h1h = zeros(size(h));
        h1h(h>0) = 1;
        h1h(h<0) = layers{l}.lrelualpha;
    elseif strcmp(at,'sigmoid')
        h1h = h.*(1-h);
    elseif strcmp(at,'tanh')
        h1h = 1 - h.^2;
    elseif strcmp(at,'linear')
        h1h = ones(size(h));
    else
        disp('No idea about the activation function');
    end
    hgrad{l} = h1h;
    
    dehh1h = deh.*h1h;
    
    if options.tanhtransform==1 && l==1
        dw = zeros(size(w));
        for i = 1:size(w,2)
            dw(i,i) = (olast(:,i)'*dehh1h(:,i))./n./k;
%               dw(i,i) = (olast(:,i)'*dehh1h(:,i));
        end
        grads{l}.db = zeros(1,m);
    else
%                  dw = (olast'*dehh1h);
%                  grads{l}.db = mean(dehh1h);
        dw = (olast'*dehh1h)./n./k;
        grads{l}.db = mean(dehh1h)/k;
    end
    
    % backprop
    grads{l}.dw = dw;
%     if isfield(layers{l},'WX')
%         grads{l}.dwx = (x'*deh)./n./k;
%     end
    deh = dehh1h*w';
    %     if l==1
    %        valid = (ceil((t+1)/1000))*10;
    %        grads{l}.dw(:,valid+1:end) = 0;
    %     end
end
if length(L1)==1
    L1 = ones(1,L)*L1;
end
if length(L2)==1
    L2 = ones(1,L)*L2;
end
for l = 1:L
    w = layers{l}.W;
    sw = sign(w);
    l2i = L2(l);
    l1i = L1(l);
    dpenalty = l2i*w + l1i*sw;
    penalty = l2i*sum(w(:).^2)/2 + l1i*sum(abs(w(:)));
    if l==L
%         penalty = 0;
%         dpenalty = 0;
    end
    Obj = Obj + penalty;
    grads{l}.dw = grads{l}.dw + dpenalty;
    if isfield(layers{l},'WX')
        wx = layers{l}.WX;
        swx = sign(wx);
        grads{l}.dwx = grads{l}.dwx + l2i*wx + l1i*swx;
        Obj = Obj + l2i*sum(wx(:).^2)/2 + l1i*sum(abs(wx(:)));
    end
end
if options.tanhtransform==1
    grads{1}.dw = diag(diag(grads{1}.dw));
end
end