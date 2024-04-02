function write_nc(filename,variable,dim,ngattri,varargin)
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
p = inputParser; % 函数的输入解析器；
addParameter(p,'VarAttr','off');
parse(p,varargin{:});  % 对输入变量进行解析，如果检测到前面的变量被赋值，则更新变量取值
% parse(p,'bndN',1:length(OBND_COMPO));parse(p,'Ti',1);parse(p,'figSW','on');parse(p,'clmp','jet');
VarAttr = p.Results.VarAttr;

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
    if strcmp(VarAttr,'on')
    for k = 1:length(variable{i}.attr)
        netcdf.putAtt(ncid,varid,variable{i}.attr{k}.name,variable{i}.attr{k}.value);
    end
    end
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