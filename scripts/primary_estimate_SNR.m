fileName = 'data/phenotypes/wheel_primary_combined.mat';
if exist(fileName,'file')==0
    process_primary_allphenos;
else
    load(fileName);
end
Y = in.Y;
SV = var(Y);
for i = 1:4
    R = [];
    for j = 1:120
        r = in.AY{j,i} - repmat(in.Y(j,i),[size(in.AY{j,i})]);
        R = [R;r];
    end
    NV(i) = var(R);
end
SNR = SV./NV;
for i = 1:4
    fprintf('%s SNR: %.4f\n',in.Y_label{i},SNR(i));
end

        