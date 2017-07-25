function [i,j] = convertid2pair(id)
i = floor(id/10);
j = mod(id,10);
end