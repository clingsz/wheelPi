function t = convertSDA(theta,k)
    L = length(theta);
    L = L/2;
    nt = initialize_network([size(theta{L}.W,2) k]);
    t = [theta(1:L) nt];
end
    