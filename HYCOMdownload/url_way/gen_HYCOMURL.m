% clear;clc
function gen_HYCOMURL(fdir, url_N1, url_E1, url_S1, url_2, t_start, t_end, Dire)
global date_1 url_2
% https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_56.3?var=surf_el&var=
% salinity&var=water_temp&var=water_u&var=water_v&north=25&west=105&east=125
% &south=15&disableProjSubset=on&horizStride=1&time=2016-09-30T09%3A00%3A00Z&vertCoord=&accept=netcdf4
% fdir = 'G:\HYCOM\url\File\2015\N\';

% url_N1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=33.5&east=145.5&south=28.5&disableProjSubset=on&horizStride=1&time=';
% url_E1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=144.5&east=145.5&south=-24.5&disableProjSubset=on&horizStride=1&time=';
% url_S1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=-23.5&west=33.5&east=145.5&south=-24.5&disableProjSubset=on&horizStride=1&time=';

% url_2 = '%3A00%3A00Z&vertCoord=&accept=netcdf4'; 

%%
% ============== Acquire the time of the url ==========================
% t_start = '2015-01-01';  % Need to Change with the forcast base time.
% t_end = '2016-01-01';

t_s1 = datenum(strcat(t_start,'T00'),'yyyy-mm-ddTHH');
t_e1 = datenum(strcat(t_end,'T00'),'yyyy-mm-ddTHH');

for i = 1:(t_e1-t_s1)/0.125
    date_1{i} = datestr(t_s1+0.125*i - 0.125,'yyyy-mm-ddTHH');
end

% parpool(4)
% ======== Start to download nc file, and change to the ".mat" =========
% Dire = 'N' ;
f_name = strcat(fdir,'URLHYCOM_',Dire,'1.txt');
fid=fopen(f_name,'wt');
get_URLTXT (fid,eval(strcat('url_',Dire,'1')));
end
%%
function get_URLTXT (fid,url_S1)
global date_1 url_2
% fprintf(fid,'%s \n','#!/bin/bash');
% fclose(fid)
for i = 1:length(date_1)
%     url_N = strcat(url_N1,date_1{i},url_2);
%     url_E = strcat(url_E1,date_1{i},url_2);
    url_S = strcat(url_S1,date_1{i},url_2);

%     fid=fopen(f_name,'wt');
    fprintf(fid,'%s \n',url_S);
   

end
 fclose(fid)
end