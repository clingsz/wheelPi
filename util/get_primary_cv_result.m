function [cv_error,final_model] = get_primary_cv_result()
load result/ELAS_cv_primary;
load result/NN_cv_primary;
for i = 1:15
    for j = 1:3
        if j<3
            verr(i,j) = fitres{j,i}.verr;
        elseif j==3
            verr(i,j) = res.verr(i);
        end
        if i==15
            if j==3
                model{j} = res;
            else
                model{j} = fitres{j,i};
            end
        end
    end
end
cv_error = verr;
final_model = model;
end