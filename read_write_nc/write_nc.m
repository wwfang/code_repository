function write_nc(filename,variable,dim,ngattri)
% write_nc(filename,variable,dim,ngattri)
% inputs : filename, e.g. 'TS.nc'
%          variable: struct data, variable{}.name; variable{}.xtype; 
%                    variable{}.dimids; variable{}.attr{}.name;
%                    variable{}.attr{}.value;
%          dim: dim{}.name; dim{}.value. The order of this (dimids) is the same as
%               that in variable
%          ngattri: global attribute. ngattri{}.name; ngattri{}.value;
% Author: Weiwei Fang
% Mail : wweifang@outlook.com
% cmode = netcdf.getConstant('NETCDF4');
% cmode = bitor(cmode,netcdf.getConstant('64BIT_OFFSET')); % if the file is not large ,turn off it.
ncid = netcdf.create(filename,'64BIT_OFFSET');
disp('Before using write_nc, Please search the ''area'' in this code!');
num = length(ngattri);
for i =1:num
    netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),ngattri{i}.name,ngattri{i}.value);
end

num = length(dim);
for i =1:num
    dimid(i) = netcdf.defDim(ncid,dim{i}.name,dim{i}.value);
end
netcdf.endDef(ncid)

num = length(variable);
for i = 1:num
    netcdf.reDef(ncid)
    varid = netcdf.defVar(ncid,variable{i}.name,variable{i}.xtype,variable{i}.dimids);
    %-------------------------area--------------------------------
%%If the variable doesn't have attr Just out it  % Check if you need this
%%one
%     for k = 1:length(variable{i}.attr)
%         netcdf.putAtt(ncid,varid,variable{i}.attr{k}.name,variable{i}.attr{k}.value);
%     end
   %-----------------------------end-----------------------------
    netcdf.endDef(ncid)
%     disp(variable{i}.value);
    netcdf.putVar(ncid,varid,variable{i}.value);

end
% netcdf.endDef(ncid)
netcdf.close(ncid)
% num = length(variable);
% for i = 1%:num
%     netcdf.putVar(ncid,varid,variable{i}.value);
% end

end