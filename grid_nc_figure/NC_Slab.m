function [fig,hp1,hc1,time]=NC_Slab(FileName,lonr,latr,lonN,latN,TimeN,VarN)
% [fig,hp1,hc1,time]=NC_Slab(FileName,lonr,latr,lonN,latN,TimeN,VarN)
% FileName = 'G:\GHRSST\2016\GHRSST_20160320.nc';
% lonr = [105 120];
% latr = [15 25];
% lonN = 'lon';
% latN = 'lat';
% TimeN = 'time';
% varN = 'analysed_sst';

lon = ncread(FileName,lonN);
lat = ncread(FileName,latN);
time = ncread(FileName,TimeN);
var = ncread(FileName,varN);

if isvector(lon)
    lonLen = length(lon);
    latLen = length(lat);
    lonlim = find (lon <= max(lonr) & lon >= min(lonr));
    latlim = find (lat <= max(latr) & lat >= min(latr));
    [N1 N2]=size(var);
    if lonLen == N1
        var = var(lonlim,latlim);
    elseif latLen == N1
        var = var(latlim,lonlim);
    end
    N1 = []; N2 =[];
    lon = lon(lonlim); lat = lat(latlim);
    [x,y]=meshgrid(lon,lat);
    if size(x,1) ~= size(var,1)
        var = var';
    end
else
    if size(lon,1) ~= size(var,1) % Makesure the var/lon/lat have same dimensions
        var = var';
    end
    if lon(2,1) - lon(1,1) == 0  % Make sure the lon change along the first dimension
        lon = lon';
        lat = lat';
        var = var';
    end
    lonlim = find (lon(:,1) <= max(lonr) & lon(:,1) >= min(lonr));
    latlim = find (lat(1,:) <= max(latr) & lat(1,:) >= min(latr));
    var = var(lonlim,latlim);
    x = lon(lonlim,latlim);
    y = lat(lonlim,latlim);
 
end
    
%%
m_proj('Equidistant','lon',lonr,'lat',latr)
fig = figure;
hp1=m_pcolor(x,y,var);
shading interp 
m_grid('FontSize',12,'FontName','Times New Roman');
m_gshhs_i('patch',[0.7 0.7 0.7]);
hc1 = colorbar('FontSize',12,'FontName','Times New Roman');
colormap(jet);

end