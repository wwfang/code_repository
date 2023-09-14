function [fig,hg,hc,xx,yy]=pcolor_All(xx,yy,zz,figSW,figout,clmp)
% [fig,hg,hc]=pcolor_All(xx,yy,zz,figSW,figout,clmp)
% xx : vector or matrix for meshgrid(x)
% yy : vector or matrix for meshgrid(y)
% zz : The data of figure
% figSW : 'on' or 'off' for 'fig = figure'
% figout : if figSW is 'off', figout = 1 else figout = 0;
% clmp : the colormap of figure

if isvector(xx)
    xx=reshape(xx,[numel(xx) 1]);
    cc = setdiff(size(zz),length(xx));
    xx = repmat(xx,[1 cc]);
end
if size(xx,1) ~= size(zz,1)
    xx = xx';
end
if isvector(yy)
    yy=reshape(yy,[numel(yy) 1]);
    cc = setdiff(size(zz),length(yy));
    yy = repmat(yy,[1 cc]);
end
if size(yy,1) ~= size(zz,1)
    yy = yy';
end

if strcmp(figSW,'on')
    fig = figure;
else
    fig = figout;
end

pcolor(xx,yy,zz);
shading interp

hc = colorbar;
colormap(clmp);

hc.FontName = 'Times New Roman';
hc.FontSize = 12;

hg = gca;
hg.FontName = 'Times New Roman';
hg.FontSize = 12;



end