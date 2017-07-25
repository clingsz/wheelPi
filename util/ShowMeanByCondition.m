function C = ShowMeanByCondition(X,Y,tit,j,k)
c = 0;
pre = {'-Pi','+Pi'};
pos = {'30uM','100uM'};
bacStates = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
setMGcmap;
%             sig = -3/Bb(j,k);
%             bb = Bb(j,k);
% c = c + 1;
% subplot(2,2,c);
G = zeros(9,9);
for x = 1:9
    for y = 1:9
        if x==y
            continue
        end
        lst = find(X(:,2)==(j-1) & X(:,3)==(k-1) & X(:,x+3)==1 & X(:,y+3)==1);
        if ~isempty(lst)
            sx = mean(Y(lst));
        else
            sx = 0;
        end
        G(x,y) = sx;
    end
end
imagesc(G); colorbar; caxis([-2 2]);
hold on;
A = G;
A(G==0) = -100;
B = G;
B(G==0) = 100;
b1 = bacStates;
for s = 1:9
    [amax,bmax] = max(A(s,:));
                    text(bmax-0.2,s,'+','Fontsize',15);
    [amin,bmin] = min(B(s,:));
                    text(bmin-0.2,s,'-','Fontsize',15);
    xx = find(A(s,:)==-100);
    text(xx-0.2,repmat(s,[1 length(xx)]),'X','Fontsize',15,'color',0.8*[1 1 1]);
%     text(xx-0.2,repmat(s,[1 length(xx)]),'X','Fontsize',15,'color',0.8*[1 1 1]);
    plot([0 10],s*[1 1]+0.5,'k-');
    plot(s*[1 1]+0.5,[0 10],'k--');
end
set(gca,'YTick',[1:9]);
set(gca,'YTickLabel',b1);
set(gca,'XTick',[0.7:8.7]);
set(gca,'XTickLabel',bacStates);
xticklabel_rotate;
title([tit ' ' pre{j} ',' pos{k}]);
% drawnow;
end