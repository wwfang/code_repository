function [variable,dim,ngattri,vname]=get_nc(filename)
% [variable,dim,ngattri,vname]=get_nc(filename)
% inputs : filename, e.g. 'TS.nc'
% outputs : struct data
%           variable
%           dim : dimensions
%           ngattri : global attributes
%           vname : variable name
% Author: Weiwei Fang
% E-mail : wweifang@outlook.com

ncid = netcdf.open(filename);
[ndims,nvars,ngatts,unlimdimid] = netcdf.inq(ncid);

if ngatts>0
for i = 1:ngatts
    gattname = netcdf.inqAttName(ncid,netcdf.getConstant('NC_GLOBAL'),i-1);
    gattval = netcdf.getAtt(ncid,netcdf.getConstant('NC_GLOBAL'),gattname);
    ngattri{i}.name = gattname;
    ngattri{i}.value = gattval;
end
else
    ngattri = {};
end

for i = 1:ndims
    [dimname,dimlen] = netcdf.inqDim(ncid,i-1);
    dim{i}.name = dimname;
    dim{i}.value = dimlen;
end

for i = 1:nvars
    [varname,xtype,dimids,natts] = netcdf.inqVar(ncid,i-1);
    data = netcdf.getVar(ncid,i-1);
    vname{i} = varname;
    variable{i}.name = varname;
    variable{i}.value = data;
    variable{i}.xtype = xtype;
    variable{i}.dimids = dimids;
    
    for k = 1:natts
        attname = netcdf.inqAttName(ncid,i-1,k-1);
        attval = netcdf.getAtt(ncid,i-1,attname);
        variable{i}.attr{k}.name = attname;
        variable{i}.attr{k}.value = attval;
    end
   
end
netcdf.close(ncid)
end