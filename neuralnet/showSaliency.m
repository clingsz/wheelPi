function showSaliency(J,nm)
P = size(J,2);
if nargin<2
    for i = 1:P
        nm{i} = num2str(i);
    end
end
S = mean(abs(J));
V = std(J);
scatter(S,V); xlabel('Saliency'); ylabel('Variance');
TOP = 20;
[~,lst] = sort(V,'descend');
lst = lst(1:TOP);
text(S(lst),V(lst),nm(lst));
end