clear;
load wheel_primary_pi;
[~,model] = get_primary_cv_result();
X = in.X;
f{1} = @(X) predit(X,model{1},'ELAS');
f{2} = @(X) predit(X,model{2},'ELASAP');
f{3} = @(X) FWP(X,model{3}.net);
for i = 1:3
    D{i} = getDiffInAllSamples(f{i},X);
end
%%
figure(992);clf;
SD = [D];
xlbs = in.X_label(2:end);
xlbs(3:11) = {'P1','P2','P3','I1','I2','I3','N1','N2','N3'};

xlbs(1:2) = {'-Pi=>+Pi','30uM=>100uM'};
tits = {'LM','INT','NN'};
for i = 1:3
   subplot(1,3,i);
   st = SD{i};
   %setMGcmap;
   %imagesc(SD{i}(:,:)'); caxis([-1.5 1.5]); colorbar;
%    boxplot(SD{i}(:,:))
   l1 = find(X(:,3)==0);
   l2 = find(X(:,3)==1);
   jitterPlot(st(l1,2:end),0.05,1,'b.');
   hold on;
   jitterPlot(st(l2,2:end),0.05,1,'b.');
   grid on;
   set(gca,'YTick',1:11);
   set(gca,'YTickLabel',xlbs);
   title(tits{i});
   xlim(2.5*[-1 1]);
   ylim([0 12]);
   xlabel('Change in Pi-content');
   hold on;
   plot([0 0],[0 12],'k');
end