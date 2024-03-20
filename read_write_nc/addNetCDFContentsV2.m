function addNetCDFContentsV2(ncFileName, dimNames, dimLengths, varName, varDims, varData, varargin)
% addNetCDFContentsV3 添加新的维度、变量到一个现有的NetCDF文件，并根据选择添加属性
% 现在支持多维数据
%
% 参数：
% ncFileName - NetCDF文件的名称
% dimNames - 要添加的维度的名称数组，如果为空，则不添加维度
% dimLengths - 对应于dimNames的每个维度的长度数组
% varName - 要添加的变量的名称
% varDims - 新变量所依赖的维度（维度的名称数组）
% varData - 要写入新变量的多维数据
% varargin - 可选，变量属性的名称和值的对，以'AttributeName',AttributeValue形式传入
%       example -----------------------------------------
% % % addpath(genpath('D:\code_repository'))
% % % 
% % % % NetCDF文件路径
% % % ncFileName = 'NewBio_90.nc';
% % % 
% % % % 维度名称和长度
% % % dimNames = {'nSCHISM_hgrid_face', 'time'};
% % % dimLengths = [175886, 4];
% % % 
% % % % 新变量的名称和依赖的维度
% % % varName = 'COS_sedcon';
% % % varDims = {'nSCHISM_hgrid_face', 'time'};
% % % 
% % % % 生成一些模拟数据
% % % varData = rand(175886, 4);
% % % 
% % % % 调用函数，添加变量和属性
% % % addNetCDFContentsV2(ncFileName, dimNames, dimLengths, varName, varDims, varData, ...
% % %     'units', 'mg/L', 'long_name', 'sediment POM concentration');
% 打开NetCDF文件以便添加内容
ncid = netcdf.open(ncFileName, 'NC_WRITE');

try
    netcdf.reDef(ncid);
    
    % 处理每个新维度，如果维度不存在，则添加
    for i = 1:length(dimNames)
        dimName = dimNames{i};
        dimLength = dimLengths(i);
        try
            dimids(i) = netcdf.inqDimID(ncid, dimName); % 尝试获取维度ID
        catch
            dimids(i) = netcdf.defDim(ncid, dimName, dimLength); % 定义新维度
        end
    end
    
   % 获取新变量所依赖的维度ID数组
    varDimIDs = arrayfun(@(index) netcdf.inqDimID(ncid, varDims{index}), 1:length(varDims));

    
    % 定义新变量，使用获取到的维度ID数组
    varid = netcdf.defVar(ncid, varName, 'NC_DOUBLE', varDimIDs);
    
    % 添加变量属性
    for i = 1:2:length(varargin)
        attributeName = varargin{i};
        attributeValue = varargin{i+1};
        netcdf.putAtt(ncid, varid, attributeName, attributeValue);
    end
    
    % 结束定义模式
    netcdf.endDef(ncid);
    
    % 写入多维数据到新变量
    netcdf.putVar(ncid, varid, varData);
catch ME
    disp('Error adding content to NetCDF file:');
    disp(ME.message);
    netcdf.close(ncid);
end
% 无论是否有异常，都执行的清理操作
netcdf.close(ncid);
disp('Added new contents to NetCDF file successfully.');
end
