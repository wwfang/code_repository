function [fig,h]=Sta_map(lon,lat,sta)
% Sta_map(lon,lat,sta);
lon=double(lon);lat=double(lat);
fig = figure;
m_proj('Equidistant','lon',[lon(1) lon(end)],'lat',[lat(1) lat(end)]);
hold on
hp=m_plot(sta(:,1),sta(:,2),'linestyle','none','color','r','marker','p','markerfacecolor','r');
m_gshhs_i('patch',[.7 .7 .7]);
m_grid('linestyle','none','fontname','Times New Roman','fontsize',12);%,'xaxislocation','top')%,'xticklabel',[106;110;114;118;119]);
h=gca;
end