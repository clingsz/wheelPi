function [out,flag] = getTested(i,j,condstr)
thisid = getRefID(i,j);
if ismember(thisid,condstr)
    out = 'yes';
    flag = 1;
else
    out = 'no';
    flag = 0;
end