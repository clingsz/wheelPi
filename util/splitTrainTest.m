function [Xt,Yt,Xv,Yv] = splitTrainTest(X,Y,train_id,test_id)
Yt = Y(train_id,:);
Xt = X(train_id,:);
Xv = X(test_id,:);
Yv = Y(test_id,:);
end