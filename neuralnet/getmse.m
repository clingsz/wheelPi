function [err,E] = getmse(v,y)
E = (v-y).^2;
err = mean(E,1);
end