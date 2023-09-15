function create_nc(ncFileName, gAttr, dim, variable, SW_value)
% create_nc(ncFileName, gAttr, dim, variable, SW_value)

    % 打开或创建 netCDF 文件
    ncid = netcdf.create(ncFileName, 'NETCDF4');
    
    % 添加全局属性
    gAttrNames = fieldnames(gAttr);
    for i = 1:numel(gAttrNames)
        attrName = gAttrNames{i};
        attrValue = gAttr.(attrName);
        netcdf.putAtt(ncid, netcdf.getConstant('NC_GLOBAL'), attrName, attrValue);
    end
    
    % 添加维度
    dimNames = fieldnames(dim);
    for i = 1:numel(dimNames)
        dimName = dimNames{i};
        dimSize = dim.(dimName);
        netcdf.defDim(ncid, dimName, dimSize);
    end
    netcdf.endDef(ncid);
    % 添加变量
    varNames = fieldnames(variable);
    for i = 1:numel(varNames)
        netcdf.reDef(ncid);
        varName = varNames{i};
        varInfo = variable.(varName);
        varDataType = varInfo.dataType;
        varDimensions = varInfo.dim;
        
        
        % 定义变量
        varid = netcdf.defVar(ncid, varName, varDataType, varDimensions);
        
        % 添加变量属性
        if isfield(varInfo, 'attr')
            varAttrNames = fieldnames(varInfo.attr);
            for j = 1:numel(varAttrNames)
                attrName = varAttrNames{j};
                attrValue = varInfo.attr.(attrName);
                netcdf.putAtt(ncid, varid, attrName, attrValue);
            end
        end
        netcdf.endDef(ncid);
        % 写入变量数据
        if strcmp(SW_value,'on')
            varData = varInfo.data;
            netcdf.putVar(ncid, varid, varData);
        end
    end
    
    % 关闭 netCDF 文件
    netcdf.close(ncid);
end