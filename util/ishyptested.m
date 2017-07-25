function b = ishyptested(hyp)
load valid_pred_lst
% I = num2str(INFO(:,1:6));
% h = num2str(hyp(:,1:6));
b = 0;
for i = 1:size(INFO,1)
    ut = unique(INFO(i,3:6));
    if length(intersect(ut,hyp))==3
        b = 1;
        return
    end 
end

end