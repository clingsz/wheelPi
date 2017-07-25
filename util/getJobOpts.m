function [opts,total] = getJobOpts(id,lsts)

for i = 1:length(lsts)
    TO(i) = length(lsts{i});
end
total = prod(TO);
if nargin<1
    disp(prod(TO));
end
temp = id-1;
for i = 1:length(TO)
    ind(i) = floor(temp/prod(TO(i+1:end)));
    temp = temp - ind(i)*prod(TO(i+1:end));
end
ind = ind + 1;

for i = 1:length(TO)
    out(i) = lsts{i}(ind(i));
end

opts = out;