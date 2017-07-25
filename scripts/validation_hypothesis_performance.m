clear;
addpaths;
wheelvalid = load('data/wheel_validation_pi');
preds = load('result/Predictions.mat');
pairlst = get_valid_switches();
L = size(pairlst.INFO,1);
ID = pairlst.INFO(:,3:6);
vX = wheelvalid.in.X;
vY = wheelvalid.in.Y;
for i = 1:L
    id = ID(i,:);
    y1 = vY(vX(:,2)==0 & vX(:,3)==0 & vX(:,3+id(1))==1 & vX(:,3+id(2))==1);
    y2 = vY(vX(:,2)==0 & vX(:,3)==0 & vX(:,3+id(3))==1 & vX(:,3+id(4))==1);
    MD(i,1) = mean(y2) - mean(y1);
    [~,pval] = ttest2(y1,y2);
    rawpval = pval;
    if MD(i,1)<0
       OPV(i,1) = -log10(pval);
       pval = 1; 
    else
       OPV(i,1) = log10(pval);
    end
    PV(i,1) = log10(pval);
    RAWPV(i) = rawpval;
    for j = 1:3
        tm = preds.modelpred{j}.info;
        ij = find(tm(:,1)==0 & tm(:,2)==0 & tm(:,3)==id(1) & tm(:,4)==id(2) & tm(:,5)==id(3) & tm(:,6)==id(4));
        MD(i,j+1) = tm(ij,7);
        if MD(i,j+1)>0
            OPV(i,j+1) = tm(ij,8);
            PV(i,j+1) = tm(ij,8);
        else
            OPV(i,j+1) = -tm(ij,8);
            PV(i,j+1) = 0;
        end
    end
end
%%
SH = fdr_bh(10.^PV);
SOH = fdr_bh(RAWPV);
% SH = PV<log10(0.05);
% OSH = -abs(OPV)<log10(0.05);
% OSH = 
PVAL = 10.^(PV);
DR = [];
TP = [];
TN = [];
FP = [];
FN = [];
for i = 1:4
    DR(:,i) = sign(MD(:,i))==sign(MD(:,1));
    TP(:,i) = (SH(:,1)==1 & SH(:,i)==1);
    TN(:,i) = (SH(:,1)==0 & SH(:,i)==0);
    FP(:,i) = (SH(:,1)==0 & SH(:,i)==1);
    FN(:,i) = (SH(:,1)==1 & SH(:,i)==0);
    MSE(:,i) = (MD(:,i) - MD(:,1)).^2;
end

for k = 1:3
[~,slst{k}] = sort(PV(:,k+1));
FP_sorted(:,k) = FP(slst{k},k+1); 
MD_sorted(:,k) = MD(slst{k},k+1);
SH_sorted(:,k) = SH(slst{k},k+1);
for t = 1:73
    TOP = t;
    tlst = slst{k}(1:TOP);
    FPs = sum(FP(tlst,k+1));
    FNs = sum(FN(tlst,k+1));
    PCPs = sum(SH(tlst,k+1));
    FDR(t,k) = FPs/PCPs;
    FPR(t,k) = sum(FP(tlst,k+1))/sum(SH(tlst,k+1));
    MSER(t,k) = mean(MSE(tlst,k+1));
end
end
%% Generate validation result tables
bs = {'P1','P2','P3','I1','I2','I3','N1','N2','N3'};
clc;
for j = 1:25
      i = slst{3}(j);
%     s1 = pairlst.hypnms{i,1};
%     s2 = pairlst.hypnms{i,2};
      sback = bs{ID(i,1)};
      sref = bs{ID(i,2)};
      sper = bs{ID(i,4)};
%     s1 = [bs{ID(i,1)} bs{ID(i,2)}];
%     s2 = [bs{ID(i,3)} bs{ID(i,4)}];
    fprintf('%s \t %s \t %s',sback,sref,sper);
    for k = [1,4]
        fprintf('\t %.4f',MD(i,k));
    end
    for k = [1,4]
        fprintf('\t %.4f',PV(i,k));
    end
    fprintf('\n');
end
%% Plot the true validation change and predicted change
met = {'LM','INT','NN'};
figure(992);clf;
for i = 3:3
%     subplot(1,3,i);
%     toplst = 1:size(MD,1);
    toplst = 1:25;
    y = MD(slst{i}(toplst),1);
    x = MD_sorted(toplst,i);
    h = SOH(slst{i}(toplst));
    cl = '';
    for j = 1:length(y)
       if y(j)>0 && h(j)==1
           clr = 'g';
           gp(j) = 1;
       elseif y(j)>0 && h(j)==0
            clr = 'y';
            gp(j) = 2;
       elseif y(j)<0 && h(j)==0
            clr = 'm';
            gp(j) = 3;
       elseif y(j)<0 && h(j)==1
            clr = 'r';
            gp(j) = 4;
       end
       cl(j) = clr;
    end
%     clr = {'g','y','m','r'};
    clr = [0 1 0;1 1 0;1 0 1;1 0 0];
    gscatter(x,y,gp,clr,'.',30);
    legend('+S','+NS','-NS','-S','location','northwest');
%     for j = 1:4
%         gi = find(gp==j);
%         scatter(x()
%     scatter(x,y,5,cl);
    ylabel('Observed change'); xlabel([met{i} ' predicted change']);
    [c,p] = corr(x,y);
    grid; 
%     title(sprintf('Spearman correlation %.2f, p-value %.4f',c,p));
%     xlim([0 2]);
%     for j = 1:5
%        s1 = [bs{ID(j,1)} bs{ID(j,2)}];
%        s2 = [bs{ID(j,3)} bs{ID(j,4)}];
%        text(x(j)+0.01,y(j),sprintf('%s=>%s',s1,s2)); 
%     end
    disp([c,p]);
%     lsline;
end

%% mean prediction error

figure(2342);clf;
sverr = MSE(:,2:4);
met = {'LM','INT','NN'};
me = mean(sverr);
ve = std(sverr);
[h,pval1] = ttest(sverr(:,1),sverr(:,3));
[h,pval2] = ttest(sverr(:,2),sverr(:,3));
disp(pval1);
disp(pval2);
boxplot(sverr,met);
hold on;
jitterPlot(sverr);
% barh(verr);
set(gca,'XTick',1:3);
set(gca,'XTickLabel',met);
ylabel('Mean Difference Prediction Error');
%title('Pi-Content Prediction');
% disp([me;ve]);
grid off;


