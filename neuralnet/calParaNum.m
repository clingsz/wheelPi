function t = calParaNum(net)
t = 0;
for i = 1:length(net)
    t = t + length(net{i}.b(:));
    t = t + length(net{i}.W(:));
end
end