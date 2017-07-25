function flst = chooseFeaturesFromNN(X,J,nm)
P = size(J,2);
if nargin<3
    for i = 1:P
        nm{i} = num2str(i);
    end
end

S = mean(abs(J));
V = std(J);

figure(1); clf;

subplot(2,2,1);
scatter(S,V); xlabel('Saliency'); ylabel('Variance');
text(S,V,nm);

flst = find(V>0);
setRGcmap;
if ~isempty(flst)
subplot(2,2,2); imagesc(J(:,flst)); colorbar; title('J');
% B = J(:,flst)\X(:,flst);
C = corr(J(:,flst),X(:,flst));
subplot(2,2,3); imagesc(C); colorbar; caxis([-1 1]);
title('Corr between J and X'); xlabel('X'); ylabel('J');
% W = net.layers{1}.W(flst,:);
subplot(2,2,4); 

% imagesc(corr(abs(W)')); colorbar; caxis([0 1]);
% title('Corr between Wh');
end
% subplot(2,1,1); imagesc(J(:,1:5)); colorbar; caxis([-2 2]);
% % subplot(2,1,2); imagesc(W(:,1:5));colorbar; caxis([-2 2]);
% subplot(2,1,2); 
% subplot(2,2,4); scatter(S,V); xlabel('Saliency'); ylabel('Variance');
end