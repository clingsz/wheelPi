%% calculate the prediction residual added predictions
clear;
% ds = {'LMpredction','INTpredction','NNprediction'};
ds = {'LM','INT','NN'};
pred = get_model_predictions_from_primary();
Zpair = get_residual_modelling();
load wheel_primary_pi;
oX = in.X;
Y = in.AY;
% Residual_Method = 'techrep_mean';
WRITE2CSV = 0;
Residual_Method = 'predict_mean';
for dataid = 1:3
    pX = pred.X;
    V = pred.V{dataid};
    Preds = [];
    for pre = 1:2
        for pos = 1:2
            for i = 1:9
                for j = 1:9
                    if i==j
                        continue;
                    end
                    ps = Zpair(i,j,pre,pos,:);
                    p1 = ps(1); p2 = ps(2);
                    Resfix_samples = cell(1,2);
                    for b = 1:2
                        id_predict = locateX(pX,i,j,b,pre,pos);
                        id_primary_zpair = locateX(oX,p1,p2,b,pre,pos);
                        raw_samples = Y{id_primary_zpair};
                        id_predict_zpair = locateX(pX,p1,p2,b,pre,pos);
                        if strcmp(Residual_Method,'techrep_mean')
                            Resfix_samples{b} = V(id_predict) + raw_samples - mean(raw_samples);
                        elseif strcmp(Residual_Method,'predict_mean')
                            Resfix_samples{b} = V(id_predict) + raw_samples - V(id_predict_zpair);
                        end
                        Resfix_predict_mean(id_predict,dataid) = mean(Resfix_samples{b});
                        Resfix_constant_mean(id_predict) = mean(raw_samples);
                    end
                    Preds(i,j,pre,pos,:) = [Resfix_samples{1};Resfix_samples{2}];
                end
            end
        end
    end
    CandList = [];
    Exps = [];
    Es = [];
    tested = [];
    info = [];
    c = 0;
    for pre = 1:2
        for pos = 1:2
            for i = 1:9
                for j = 1:9
                    if i==j
                        continue;
                    end
                    for k = 1:9
                        if (i==k) || (j==k)
                            continue;
                        end
                        xx = Preds(i,j,pre,pos,:);
                        xx = xx(:);
                        yy = Preds(i,k,pre,pos,:);
                        yy = yy(:);
                        [~,pval] = ttest2(xx,yy);
                        meanDiff = mean(yy) - mean(xx);
                        MD(pre,pos,i,j,k) = meanDiff;
%                         if meanDiff<0
%                             pval = 1;
%                         end
                        logPval = log10(pval);
                        LP(pre,pos,i,j,k) = logPval;
                        c = c + 1;
                        x1 = j; x2 = k;
                        Exps(c,:) = [logPval meanDiff];
                        E_to{c} = getExpID(pre,pos,i,x1);
                        E_from{c} = getRefID(i,x2);
                        [tested{c,1},f1] = getTested(i,x1,in.condstr);
                        [tested{c,2},f2] = getTested(i,x2,in.condstr);
                        if f1*f2==0
                            tested{c,3} = 'No';
                        else
                            tested{c,3} = 'Yes';
                        end
                        info(c,:) = [pre-1 pos-1 i x1 i x2 meanDiff logPval f1 f2 f1*f2];
                    end
                end
            end
        end
    end
    lst = 1:c;
    E_to = E_to(lst);
    Exps = Exps(lst,:);
    E_from = E_from(lst);
    c = length(lst);
    tested = tested(lst,:);
    if WRITE2CSV==1
        fid = fopen(['result/' ds{dataid} 'table.csv'], 'w') ;
        fprintf(fid,'Pre,Treat,Ref,Imprv,LogP,Diff,isRef,isImp,IsAny\n');
        for i = 1:c
            fprintf(fid, '%s,%s,%f,%f,%s,%s,%s\n', E_from{i},E_to{i},Exps(i,1),Exps(i,2),tested{i,1},tested{i,2},tested{i,3});
        end
        fclose(fid);
    end
    modelpred{dataid}.info = info;
    infostr = {'Pre','Pos','i','x1','i','x2','meandiff','logpval','tested1','tested2','anytested?'};
end
save('result/Predictions.mat','modelpred');

