function [Xit,Xiv] = constructAP(Xt,Xv)
c = 0;
p = size(Xt,2);
Xit = Xt;
Xiv = Xv;
for i = 1:p
    for j = i:p
        c = c + 1;
        Xit(:,p+c) = Xt(:,i).*Xt(:,j);
        Xiv(:,p+c) = Xv(:,i).*Xv(:,j);
    end
end
Xt = Xit;
Xv = Xiv;
end