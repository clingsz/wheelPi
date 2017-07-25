function pred = get_model_predictions_from_primary()
load wheel_primary_pi;
[~,model] = get_primary_cv_result();
X = [];
V = [];
Q = [];
c = 0;
bs = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
pre = {'minusP','plusP'};
pos = {'30uM','100uM'};
bid = {'',''};
for i = 1:2
    for j = 1:2
        for k = 1:2
            for l = 1:8
                for m = l+1:9
                    c = c + 1;
                    X(c,:) = [i-1,j-1,k-1,zeros(1,9)];
                    X(c,l+3) = 1;
                    X(c,m+3) = 1;
                    Q{c} =  [bid{i} pre{j} pos{k} bs{l} bs{m}];
                end
            end
            c = c + 1;
            X(c,:) = [i-1,j-1,k-1,zeros(1,9)];
            Q{c} =  [bid{i} pre{j} pos{k} 'NOBA'];
        end
    end
end
pred.X = X;
pred.V = cell(1,3);
pred.V{3} = FWP(X,model{3}.net,0);
% save('result/NNprediction.mat','pred');
V = predit(X,model{1},'ELAS');
pred.V{1} = V;
% save('result/LMpredction.mat','pred');
V = predit(X,model{2},'ELASAP');
pred.V{2} = V;
% save('result/INTpredction.mat','pred');
end
