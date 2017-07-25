% permutation test
% calculate the significance of the hypothesis generation
function permutation_test()
fileName = 'result/permutation_test_result.mat';
if exist(fileName,'file')==0
    
    pairlst = get_valid_switches();
    TOP = 25;
    claims = zeros(TOP,2);
    for i = 1:TOP
        pairid = pairlst.INFO(end-i+1,3:4);
        s1 = convertpair2id(pairid(1),pairid(2));
        pairid = pairlst.INFO(end-i+1,5:6);
        s2 = convertpair2id(pairid(1),pairid(2));
        claims(i,:) = [s1,s2];
    end
    c = validate_claims(claims);
    disp(c);
    i2s = unique(claims(:));
    s2i = zeros(max(i2s),1);
    L = length(i2s);
    for i = 1:L
        s2i(i2s(i)) = i;
    end
    T = 1000;
    cs1 = zeros(T,1);
    cs2 = zeros(T,1);
    for t = 1:T
        pc = gen_perm_claims(claims,s2i,i2s,t);
        [cs1(t),cs2(t)] = validate_claims(pc);
        disp([t,cs1(t),cs2(t)]);
    end
    save(fileName,'cs1','cs2');
else
    load(fileName);
    plot(sort([cs1,cs2]));
    legend('Positive','Significant Positive');  
    hold on;
    plot([0,1000],[16,16],'k--');
    plot([0,1000],[23,23],'k--');    
    disp(mean(cs1>=23));
    disp(mean(cs2>=16));
    xlabel('Test cases sorted');
    ylabel('Valid claims');
end
end

function perm_claims = gen_perm_claims(claims,s2i,i2s,rng)
randseed(rng);
L = length(i2s);
lst = randperm(L);
i2s_new = i2s(lst);
perm_claims = claims;
for i = 1:size(claims,1)
    for j = 1:2
        perm_claims(i,j) = i2s_new(s2i(claims(i,j))); 
    end
end
end

function [hc1,hc2] = validate_claims(claims)
hc1 = 0;
hc2 = 0;
for i = 1:size(claims,1)
    [M,P] = validate_claim(claims(i,:));
    if M>0 
        hc1 = hc1 + 1;
        if P<0.05
            hc2 = hc2 + 1;
        end
    end
end

end
function [M,P] = validate_claim(c)
y1 = get_valid_samples(c(1));
y2 = get_valid_samples(c(2));
M = mean(y2) - mean(y1);
[~,P] = ttest2(y1,y2);
end