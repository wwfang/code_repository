% clear;clc
function gen_MissingURL(filepath,url_1,url_2,t_start,t_end,tag)
cd(filepath)
% cd G:\HYCOM\url\File\2015\E
% Dire = 'E';
% tag = 'E';
% % Main routine;
list = dir('*.nc');
% % get the potential downloading file list by time;0
% t_start = '2015-01-01';  % Need to Change with the forcast base time.
% t_end = '2016-01-01';
T_out = getFileListTime(t_start, t_end);
% get the downloaded file by time;
T = getDownloadTime(list);

% get the missing date
[T_missing, date_1] = getMissing(T,T_out);
 
% Generate txt file
% url_N1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=33.5&east=145.5&south=28.5&disableProjSubset=on&horizStride=1&time=';
% url_E1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=144.5&east=145.5&south=-24.5&disableProjSubset=on&horizStride=1&time=';
% url_S1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=-23.5&west=33.5&east=145.5&south=-24.5&disableProjSubset=on&horizStride=1&time=';
% url_1 = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=surf_el&var=salinity&var=water_temp&var=water_u&var=water_v&north=29.5&west=33.5&east=145.5&south=28.5&disableProjSubset=on&horizStride=1&time=';

% url_2 = '%3A00%3A00Z&vertCoord=&accept=netcdf4'; 

f_name = ['URLHYCOM_',tag,'_Missing4.txt'] ;
% WriteFile(f_name,date_1,eval(['url_',Dire,'1']),url_2)
WriteFile(f_name,date_1,url_1,url_2)

end
%% Functions
function T = getDownloadTime(list)
n = 1;
for i = 1:length(list)
    try
        fn = list(i).name ;
        tim = ncread(fn,'time');
        T(n) = tim/24 + datenum(2000,1,1);
        n = n+1;
    catch
        continue;
    end
end
end

function T_out = getFileListTime(t_start, t_end);
% ============== Acquire the time of the url ==========================
% t_start = '2011-01-01';  % Need to Change with the forcast base time.
% t_end = '2012-01-01';

t_s1 = datenum(strcat(t_start,'T00'),'yyyy-mm-ddTHH');
t_e1 = datenum(strcat(t_end,'T00'),'yyyy-mm-ddTHH');

for i = 1:(t_e1-t_s1)/0.125
    date_1{i} = datestr(t_s1+0.125*i - 0.125,'yyyy-mm-ddTHH');
    T_out(i) = t_s1+0.125*i - 0.125 ;
end
end

function [T_missing, date_1] = getMissing(T,T_out)
n = 1;
for i = 1:length(T_out)
    IND = find(T_out(i) == T);
    if isempty(IND)
       T_missing(n) = T_out(i);
       n = n+1;
    end
end
for i = 1:length(T_missing)
    date_1{i} = datestr(T_missing(i),'yyyy-mm-ddTHH');
end
end

function WriteFile(f_name,date_1,url_S1,url_2)
fid=fopen(f_name,'wt');
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
