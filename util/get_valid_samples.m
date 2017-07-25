function ys = get_valid_samples(sid)
load data/wheel_validation_pi;
X = in.X;
Y = in.Y;
[i,j] = convertid2pair(sid);
lst = find(X(:,i+3)==1 & X(:,j+3)==1);
ys = Y(lst,:);