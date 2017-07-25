%% Processing wheel_valid data
% take input: 
% data/validation_data/
% output:
% matlab accessible wheel_valid_pi.mat
clear;
X = [];
Y = [];
for rep = 1:2
    if rep==1
        d = importdata('data/validation_data/Validation-1.xlsx');
    else
        d = importdata('data/validation_data/Validation-2.xlsx');
    end
    syncom = d.textdata(2:end,4);
    phos = d.data(:,5);
    Y = [Y;phos];
    idvec = covertsyncomtoid(syncom);
    n = length(syncom);
    X = [X;(rep-1).* ones(n,1) zeros(n,2) idvec];
end
in.X = X;
in.Y = Y;
in.Y_label = {'Picontent'};
save('data/wheel_validation_pi.mat','in');