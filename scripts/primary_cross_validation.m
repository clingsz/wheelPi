load wheel_primary_pi;
[verr,~] = get_primary_cv_result();
%% Check significance
sverr = verr(1:14,:);
[c,pv1] = ttest(sverr(:,1),sverr(:,3));
[c,pv2] = ttest(sverr(:,2),sverr(:,3));
disp(pv1)
disp(pv2)
%% Plot cross validation boxplot
figure(2342);clf;
sverr = verr(1:14,:);
met = {'LM','INT','NN'};
me = mean(sverr);
ve = std(sverr);
boxplot(sverr,met);
hold on;
jitterPlot(sverr);
% barh(verr);
set(gca,'XTick',1:3);
set(gca,'XTickLabel',met);
ylabel('Cross-Validation Error');
%title('Pi-Content Prediction');
disp([me;ve]);
grid off;
%% plot barplot for each syncom cv error
% %%
% figure(2323);
% met = {'LM','INT','NN'};
% barh(verr(1:14,:));
% set(gca,'YTick',1:14);
% set(gca,'YTickLabel',in.condstr(2:end));
% xlabel('CV Error');
% title('PiContent Prediction');
% legend(met);
