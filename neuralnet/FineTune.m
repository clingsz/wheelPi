function [best_net,verr] = FineTune(Xt,Yt,Xv,Yv,net_init)
options = net_init.options;
% rng(options.seed);
verbose = options.verbose;
net = net_init;
maxepoch = options.maxepoch;
terr = zeros(maxepoch,1);
verr = terr;
obj = terr;
[~,best_obj] = getGrads(Xt,Yt,net,0);
% mean(getPredictionErr(Xt,Yt,net));
best_net = net;
n = size(Xt,1);
batchsize = options.batchsize;
if batchsize>n || batchsize==0
    batchsize = n;
end
n_batches = ceil(n/batchsize);
batch = cell(n_batches,1);
maxpatience = options.patience;
patience = maxpatience;
optstats.learningrate = options.learningrate;
for t = 1:maxepoch    
    % rebatch
    optstats.t = t;
    if n_batches>1
        lst = randperm(n);
        for b = 1:n_batches
            startpos = (b-1)*batchsize+1;
            endpos = min(n,b*batchsize);
            batch{b} = lst(startpos:endpos);
        end
%         if endpos-startpos+1<batchsize
%             batch{n_batches} = lst(endpos-batchsize+1:endpos);
%         end
    else
        batch{1} = 1:n;
    end
    
    for b = 1:n_batches
        lst = batch{b};
        x = Xt(lst,:);
        y = Yt(lst,:);
        grads = getGrads(x,y,net,t);
        if t==1 && b==1
            optstats.EG2 = initEG2(grads);
        end
        [net,optstats] = applyGrads(net,grads,optstats);
    end
    [~,obj(t)] = getGrads(Xt,Yt,net,t);
    terr(t) = mean(getPredictionErr(Xt,Yt,net));
    verr(t) = mean(getPredictionErr(Xv,Yv,net));
%     obj(t) = verr(t);
    [~,H] = FWP(Xt,net);
    if isnan(terr(t))
       disp('train error is not a number, something wrong happened, might be too large learning rate');
       break;
    end 
    if verbose && mod(t,50)==0
       PLOTIT = 1;
       if PLOTIT
           subplot(2,2,4);
           plot(1:t,[terr(1:t) verr(1:t)]);
           title(sprintf('%.5f',verr(t)));
           
           subplot(2,2,1);setRGcmap;
           imagesc([net.layers{1}.b;net.layers{1}.W]);colorbar;
           xlabel('Hidden'); ylabel('Input'); 
           caxis([-1 1]);
           
           subplot(2,2,3);
           %setRGcmap;
           ol = [net.layers{2}.b' net.layers{2}.W'];
%            bar(ol);
                  imagesc(ol);colorbar;
                  caxis([-1 1]);
%            dw = diag(net.layers{1}.W);
           dw = sum(abs(net.layers{1}.W),2);
           subplot(2,2,2);bar(dw(1:min(length(dw),20)));
           drawnow;
       end
       fprintf('EP:%d/%d ETA:%.2e OBJ:%.3f TE:%.5f VE: %.5f\n',t,patience,optstats.learningrate,obj(t),terr(t),verr(t));
       save('temp.mat','net');
    end
    
    if obj(t)>(best_obj*0.99999)
        patience = patience - 1;
    else
        patience = maxpatience;
    end
    
    if obj(t)<best_obj
       best_obj = obj(t);
       best_net = net;
    end
    
    
    if patience==0
        break;
    end
end
end

function EG2 = initEG2(grads)
L = length(grads);
EG2 = cell(L,1);
for l = 1:L
    EG2{l}.dw2 = grads{l}.dw.^2;
    EG2{l}.db2 = grads{l}.db.^2;
    if isfield(grads{l},'dwx')
        EG2{l}.dwx2 = grads{l}.dwx.^2;
    end
end
end
