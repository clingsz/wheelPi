function Zpair = get_residual_modelling()
load wheel_primary_pi;
oX = in.X;
Y = in.AY;
Delta = [];
MaxV = [];
MaxVi = [];
Vary = [];
Preds = [];
for pre = 1:2
    for pos = 1:2
        for i = 1:9
            for j = 1:9
                if i==j
                    continue;
                end
                for b = 1:2
                    oid = locateX(oX,i,j,b,pre,pos);
                    if ~isempty(oid)
                        Delta(i,j,b,pre,pos,:) = Y{oid};
                    end
                end
                if ~isempty(oid)
                    oid1 = locateX(oX,i,j,1,pre,pos);
                    oid2 = locateX(oX,i,j,2,pre,pos);
                    Ys = [Y{oid1};Y{oid2}];
%                     Delta(i,j,pre,pos,:) = Ys - mean(Ys);
                    Vary(i,j,pre,pos) = std(Ys);
                end
            end
            [MaxV(i,pre,pos),MaxVi(i,pre,pos)] = max(squeeze(Vary(i,:,pre,pos)));
            for b = 1:2
                bdelta = squeeze(Delta(i,MaxVi(i,pre,pos),b,pre,pos,:));
                Resi(i,b,pre,pos,:) = [bdelta];
            end
        end
        for i = 1:9
            for j = 1:9
                if i==j
                    continue;
                end
                v1 = MaxV(i,pre,pos); % max variance related to i
                v2 = MaxV(j,pre,pos); % max variance related to j
                if v1<v2 % j is larger, look at this
                    ci = MaxVi(j,pre,pos); % the corresponding pair is (j,ci)
                    aa = j;
                else
                    ci = MaxVi(i,pre,pos);
                    aa = i;
                end
                VS(i,j,pre,pos) = MaxV(aa,pre,pos);
                
                Zpair(i,j,pre,pos,:) = [aa ci];
                for b = 1:2
                    RES(i,j,b,pre,pos,:) = Resi(ci,b,pre,pos,:);
                end
            end
        end
    end
end
%save('result/residual_modelling_result','Zpair');
%% PLOT CHECK
PLOTCHECK=0;
if PLOTCHECK==1
figure(299);
c = 0;
for i = 1:2
    for j = 1:2
        c = c + 1;
        subplot(2,4,c);
        G = Vary(:,:,i,j);
        plot_box_condition_mean(G,i,j,'RAWSTD');
        subplot(2,4,c+4);
        G = VS(:,:,i,j);
        plot_box_condition_mean(G,i,j,'MAXSTD');
    end
end
end
