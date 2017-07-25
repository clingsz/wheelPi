function showPhenotypes(dataname)
if nargin<1
    dataname = 'wheel_combined2';
%     dataname = 'wheel_stable';
end
addpaths;
load(dataname);
K = size(in.Y,2);
for i = 1:K
    figure(273+i); clf;
    set(gcf,'Position',[50 50 800 600]);    
    cond = ploti(i,dataname);
    legend(cond,'Location','Best');
%     savepdf(['figs/pheno' num2str(i)]);
end

% figure(274); clf;
% set(gcf,'Position',[50 50 1000 800]);
% for i = 1:4
% subplot(2,2,i); 
% ploti(i+5);
% end
% legend(cond,'Location','NorthEast');
% savepdf figs/pheno
end

function cond = ploti(i,dataname)
if nargin<2
    dataname = 'wheel_combined';
end
load(dataname);
ps = 2*[-0.1,-0.05,0.05,0.1];
dots = {'rx','mo','gx','bo'};
c = 0;
sx = [];
sy = [];
sg = [];
X = in.X;
Y = in.Y(:,i);
S = in.S(:,i);
pre = {'-P','+P'};
pos = {'30','100'};

hold on;
for j = 1:2
    for k = 1:2
        c = c + 1;
            lst = find(X(:,2)==(k-1) & X(:,3)==(j-1));
            sxk = in.condid(lst)'+ps(c);
            syk = Y(lst);
            sek = S(lst);
            sgk = c*ones(length(lst),1);
            sx = [sx;sxk];
            sy = [sy;syk];
            sg = [sg;sgk];
            cond{c} = [pre{k} ',' pos{j}];
            errorbar(sxk,syk,sek,dots{c});
    end
end
% gscatter(sx,sy,sg,[1 0 0;0 0 1],['o','o','x','x'],5*[1,1]);

set(gca,'XTick',[1:15]);
set(gca,'XTickLabel',in.condstr);
% set(gca,'XTickFontsize',15);

xlim([0 16]);
ylim([-4 4]);
grid;
xticklabel_rotate;
title(in.Y_label{i});
set(gca,'Fontsize',15);
drawnow;
end