function pairlst = get_valid_switches()
%% Get all predictable list
load wheel_validation_pi;
load Predictions;
INFO = modelpred{3}.info;
lst = find(INFO(:,1)==0 & INFO(:,2)==0 & INFO(:,11)==0);
INFO = INFO(lst,:);
[~,lst] = sort(INFO(:,8).*(-sign(INFO(:,7))));
INFO = INFO(lst,:);

X = in.X;
ID = bi2de(X(:,4:end));
ID = unique(ID);
L = size(INFO,1);
C = zeros(L,1);
c = 0;
for i = 1:L
   x1 = zeros(1,9);
   a = INFO(i,3);
   b = INFO(i,4);
   x1(a) = 1;
   x1(b) = 1;
   idx1 = bi2de(x1);
   x1 = zeros(1,9);
   a = INFO(i,5);
   b = INFO(i,6);
   x1(a) = 1;
   x1(b) = 1;
   idx2 = bi2de(x1);
   if ismember(idx1,ID) && ismember(idx2,ID)
       C(i) = 1;
       s1 = getRefID(INFO(i,3),INFO(i,4));
       s2 = getRefID(INFO(i,5),INFO(i,6));
%        fprintf('%s \t %s \n',s1,s2);
       c = c + 1;
       hypnms{c,1} = s1;
       hypnms{c,2} = s2;
   end
end
lst = find(C==1);
INFO = INFO(lst,:);
pairlst.INFO = INFO;
pairlst.hypnms = hypnms;
end
% save('result/valid_pred_lst','INFO','hypnms');