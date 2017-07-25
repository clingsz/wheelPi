function h = setMGcmap(PRISM)

if nargin<1
    
rg = zeros(64,3);
M = 125;
rg(1:32,1) = M;
rg(1:32,3) = M;

rg(33:64,2) = M;

rg(1:32,2) = round(linspace(0,M,32));
% rg(1:32,3) = round(linspace(0,M,32));

rg(33:64,1) = round(linspace(M,0,32));
rg(33:64,3) = round(linspace(M,0,32));

rg = rg/M;
% scatter(1:64,1:64,30,rg,'filled');
h = rg;
colormap(rg);
% imagesc(1:10);
% keyboard;
elseif PRISM ==2
   h = colormap('colorcube');
   h(end-7:end,3) = 0.2;
   colormap(h);
elseif PRISM == 3
    load RGBcmap.mat;
    colormap(h);
end


end