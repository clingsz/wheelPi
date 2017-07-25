clear;
addpaths;
getPhenotypeData;
%%
nms = {'_shootarea','_rootlength','_picontent','_mainrootelongation'};
L = length(nms);
Y = [];
S = [];
c = 0;
c1 = 0;
nm = {'LogShootArea','LogRootLength','PiContent','ExpMainRoot'};
ylb = [];
rawY = [];
for i = 1:L
   load(['data/phenotypes/wheel_primary' nms{i} '.mat']);
   oX = in.X;
   d = bi2de(oX);
   nxs = unique(d);
   nx{i} = nxs;
   size(nx{i})
   if find(isnan(in.Y))
      in.Y(isnan(in.Y)) = 1;
   end
   rY = in.Y;
   if i==1 || i==2 
       rY = log(rY);
   end
   tY = standardize(rY);
   mY = [];
   sY = [];
   for j = 1:length(nxs)
      lst = find(d==nxs(j));
      Ysg = tY(lst,:);
      mY(j,:) = mean(tY(lst,:),1);
      sY(j,:) = std(tY(lst,:),1);
      AY{j,i} = Ysg;
   end
   Y = [Y mY];
   S = [S sY];
   for j = 1:size(mY,2)
       c = c + 1;
       ylb{c} = in.Y_label{j};
   end
end
ylb{end} = 'mainroot';
X = de2bi(nxs,12);

oldin = in;
in = [];
in.X = X;
in.Y = Y;
in.S = S;
in.X_label = oldin.X_label;
in.Y_label = ylb;
in.AY = AY;
save('data/phenotypes/wheel_primary_combined.mat','in');
