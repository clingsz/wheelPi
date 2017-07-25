% generate wheel_primary_pi data
clear;
folder = './data/primary_data/Pi-content/';
flst = dir([folder '*.xlsx']);
phenotype = 'pi';
%% load raw data
pretreat = {};
phosphate = {};
syncom = {};
batchid = [];
ys = [];
for i = 1:length(flst)
    disp([i length(flst)]);
    [num,txt,raw] = xlsread([folder flst(i).name]);    
    K = size(num,1);
    pretreat = [pretreat;txt(2:end,2)];
    phosphate = [phosphate;txt(2:end,3)];
    syncom = [syncom;txt(2:end,4)];
    ys = [ys;num(1:end,5)];
    btemp = zeros(K,1);
    if strfind(flst(i).name,'R2')
        btemp = ones(K,1);
    end
    batchid = [batchid;btemp];
end
N = length(syncom);
for i = 1:N
   syncom{i} = strrep(syncom{i},' ',''); 
end
bacStates = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
% condstr = unique(syncom);
% disp(length(condstr));
% for i = 1:N
%    [~,condid(i)] = ismember(syncom{i},condstr);
% end
P = length(bacStates);
bac = zeros(N,P);
phos = zeros(N,1);
pre = phos;
for i = 1:N
   % bacState
   if ~strcmp(syncom{i},'NB')
       for j = 1:P     
           if strcmp(bacStates{j},syncom{i}(1:2)) || strcmp(bacStates{j},syncom{i}(3:4))
               bac(i,j) = 1;
           end
       end
   end
   ph = phosphate{i};
   pr = pretreat{i};
   
   if strcmp(ph,'100 Pi')
       phos(i) =  1;
   end
   if strcmp(pr(1:3),' +P')
       pre(i) =  1;
   end
end

X = [batchid pre phos bac];
X_label = {'batchid','pretreat','phosphate'};
X_label = [X_label bacStates];
meanY = mean(ys);
stdY = std(ys);
Yraw = ys;
Y = zscore(ys);
% Y = ys;
Y_label = phenotype;
in.unroll.Y = Y;
in.unroll.X = X;
%% extract condition specific information and variances
oX = X;
d = bi2de(oX);
nxs = unique(d);
tY = Y;
for j = 1:length(nxs)
    lst = find(d==nxs(j));
    Ysg = tY(lst);
    mY(j,:) = mean(tY(lst),1);
    in.Yraw(j,:) = mean(Yraw(lst),1);
    sY(j,:) = std(tY(lst),1);
    AY{j} = Ysg;
end
X = de2bi(nxs,12);
Y = mY;
%% build cross-vadliation sets
bacStates = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
Xs = X(:,4:end);
d = bi2de(Xs);
nd = unique(d);
L = length(nd);
for i = 1:L
    lst = find(d==nd(i));
    condid(lst) = i;
    if nd(i)==0
        condstr{i} = 'NB';
    else
        xx = de2bi(nd(i),9);
        ll = find(xx);
        condstr{i} = [bacStates{ll(1)} bacStates{ll(2)}];
    end
end

C = length(condstr)-1;
cv = cell(C,1);
for i = 1:C
    cv{i}.tid = find(condid~=(i+1));
    cv{i}.vid = find(condid==(i+1));
end
in.cv = cv;
in.condid = condid;
in.condstr = condstr;
in.X = X;
in.X_label = X_label;
in.Y = Y;
in.Y_label = Y_label;
in.AY = AY;
in.stdY = stdY;
in.meanY = meanY;
save('data/wheel_primary_pi','in');