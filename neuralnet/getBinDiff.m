function VD = getBinDiff(X,net)
    [N,P] = size(X);
    K = size(net{end}.W,2);
    VD = zeros(N,P,K);
    X1 = X;
    X2 = X;
    for i = 1:P
%         disp([i P]);
        X1(:,i) = -0.5;
        X2(:,i) = 0.5;
        VD(:,i,:) = reshape(FWP(X2,net) - FWP(X1,net),[N 1 K]);
        X1 = X;
        X2 = X;
    end


