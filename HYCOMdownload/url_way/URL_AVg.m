clear;clc
fdir = 'G:\HYCOM\url\File\2015\E\';
cd (fdir)
list = dir('*.nc');
Dire = '_E';
%%
t_start = '2015-01-01';  % Need to Change with the forcast base time.
t_end = '2016-01-01';
IND = get_IND ( t_start, t_end, fdir, list) ; 
%%
parfor j = 1:size(IND,2)
    disp(j)
    AB = IND(~isnan(IND(:,j)),j) ;
    surf_el = []; salinity = []; water_temp = []; water_u = [];
    water_v = [];
    for i =  1:length(AB)
        filename = list(AB(i)).name ;
        surf_el_tmp=ncread(strcat(fdir,filename),'surf_el');
        time_tmp=ncread(strcat(fdir,filename),'time');
        llat_tmp=ncread(strcat(fdir,filename),'lat');
        llon_tmp=ncread(strcat(fdir,filename),'lon');
        salinity_tmp=ncread(strcat(fdir,filename),'salinity');
        depth=ncread(strcat(fdir,filename),'depth');
        water_temp_tmp=ncread(strcat(fdir,filename),'water_temp');
        water_u_tmp=ncread(strcat(fdir,filename),'water_u');
        water_v_tmp=ncread(strcat(fdir,filename),'water_v');

        [lon,lat]=meshgrid(llon_tmp,llat_tmp);
        surf_el_tmp=permute(surf_el_tmp,[2 1]);
        salinity_tmp=permute(salinity_tmp,[3 2 1]);
        water_temp_tmp=permute(water_temp_tmp,[3 2 1]);
        water_u_tmp=permute(water_u_tmp,[3 2 1]);
        water_v_tmp=permute(water_v_tmp,[3 2 1]);
        ITime=time_tmp/24 + datenum(2000,1,1);

        Time1 = datestr(ITime,'yyyymmdd');
        if length(AB) < 8
        disp(length(AB))
        disp(Time1)
        end
        if isempty(surf_el)
            surf_el = surf_el_tmp/length(AB) ; 
            salinity = salinity_tmp/length(AB) ; 
            water_temp = water_temp_tmp/length(AB) ; 
            water_u = water_u_tmp/length(AB) ; 
            water_v = water_v_tmp/length(AB) ;   
        else
            surf_el = surf_el + surf_el_tmp/length(AB) ; 
            salinity = salinity + salinity_tmp/length(AB) ; 
            water_temp = water_temp + water_temp_tmp/length(AB) ; 
            water_u = water_u + water_u_tmp/length(AB) ; 
            water_v = water_v + water_v_tmp/length(AB) ;             
        end
    end
    %%
    parsave([fdir,Time1,Dire,'.mat'],salinity,water_temp,water_u,water_v,surf_el,lon,lat,depth,ITime)
end

%%
% IND 是比较理论上的日期，和下载的日期，从而找到他们的索引
function IND = get_IND ( t_start, t_end, fdir, list)
t_s1 = datenum(strcat(t_start,'T00'),'yyyy-mm-ddTHH');
t_e1 = datenum(strcat(t_end,'T00'),'yyyy-mm-ddTHH');

for i = 1:(t_e1-t_s1)/0.125
    date_1(i) = t_s1+0.125*i - 0.125;
end


parfor i = 1 : length(list)
% 定义输入字符串
% inputStr = 'var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=144.5&east=145.5&south=-24.5&disableProjSubset=on&horizStride=1&time=2011-01-01T03%3A00%3A00Z&vertCoord=&accept=netcdf4 _E';
 inputStr = strcat(fdir,list(i).name) 
% 使用正则表达式匹配日期部分
pattern = 'time=(\d{4}-\d{2}-\d{2}T\d{2})';
matches = regexp(inputStr, pattern, 'tokens');

% 如果匹配到日期，提取并显示
if ~isempty(matches)
    dateStr = matches{1}{1};
    time_File(i) = datenum(dateStr,'yyyy-mm-ddTHH');
end
end


n = 1;
for i = 1 : length(date_1)
    tmp = date_1(i) ;
    ind = find(tmp == time_File) ;
    if isempty(ind)
        A(n) = i;
        n = n + 1;
    end
end

date_1 = reshape(date_1, [8, length(date_1)/8])  ;

IND = nan*zeros(size(date_1));
for i = 1 : length(time_File)
    tmp = time_File(i) ;
    [r,c] = find(tmp == date_1);
    IND(r,c) = i;
end
end

function parsave(fname,salinity,water_temp,water_u,water_v,surf_el,lon,lat,depth,ITime)
    save(fname,'salinity','water_temp','water_u','water_v','surf_el','lon','lat','depth','ITime') ;
end