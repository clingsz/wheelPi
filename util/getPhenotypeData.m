function getPhenotypeData
    dirname = {
        'totalRootNetwork/', ...
        'Pi-content/', ...
        'shoot area/', ...
        'MainRootElongation/'
        };
    pnames = {'rootlength','picontent','shootarea', ...
        'mainrootelongation'};
    for i = 1:4
        getPhenotype(['data/primary_data/' dirname{i}],pnames{i});    
    end
end
function getPhenotype(dirname,phenotype)
folder = dirname;
flst = dir([folder '*.xlsx']);
%%
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
%%
N = length(syncom);
for i = 1:N
   syncom{i} = strrep(syncom{i},' ',''); 
end
bacStates = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
condstr = unique(syncom);
disp(length(condstr));
for i = 1:N
   [~,condid(i)] = ismember(syncom{i},condstr);
end
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
%%
X = [batchid pre phos bac];
X_label = {'batchid','pretreat','phosphate'};
X_label = [X_label bacStates];
Y = ys;
Y_label = phenotype;
%%
in.X = X;
in.X_label = X_label;
in.Y = Y;
in.Y_label = {Y_label};
in.condstr = condstr;
in.condid = condid;

C = length(condstr)-1;
cv = cell(C,1);
for i = 1:C
    cv{i}.tid = find(condid~=i);
    cv{i}.vid = find(condid==i);
end
in.cv = cv;
save(['data/phenotypes/wheel_primary_' phenotype],'in');
end