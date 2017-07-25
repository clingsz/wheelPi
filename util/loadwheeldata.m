function [Xt,Yt,Xv,Yv] = loadwheeldata(fold)
load wheel_pi;
if fold<15
    cv = in.cv{fold};
    tid = cv.tid;
    vid = cv.vid;
else
    tid = 1:size(in.X,1);
    vid = tid;
end
% Y = zscore(in.Y);
[Xt,Yt,Xv,Yv] = splitTrainTest(in.X,in.Y,tid,vid);
% [Xt,Bt,Xv,Bv] = splitTrainTest(in.X,B,tid,vid);
% [~,~,~,LPv] = splitTrainTest(in.X,in.LP,tid,vid);