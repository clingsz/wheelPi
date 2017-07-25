function [idvec] = covertsyncomtoid(syncom)
N = length(syncom);
S = {'G1','G2','G3','N1','N2','N3','B1','B2','B3'};
idvec = zeros(N,9);
for i = 1:N
    if strcmp(syncom{i},'NB')
        continue;
    elseif length(syncom{i})==4
        s1 = syncom{i}(1:2);
        s2 = syncom{i}(3:4);
        l1 = find(strcmp(s1,S));
        l2 = find(strcmp(s2,S));
        idvec(i,l1) = 1;
        idvec(i,l2) = 1;
    else
        disp('error!');
    end
end
