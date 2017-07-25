function showPairCondition
addpaths;

for i = 8:8
    figure(273+i); clf;
    set(gcf,'Position',[50 50 1000 800]);    
    ploti(i);
%     savepdf(['figs/box' num2str(i)]);
end

end

function ploti(i)
load wheel_combined;
X = in.X;
Y = in.Y(:,i);
ShowMeanByCondition(X,Y,in.Y_label{i});
end 
