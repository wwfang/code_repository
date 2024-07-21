function filteredContours = get_contourline(x,y,z,contour_levels,minNumPoints)
% 计算等值线数据，不绘制图形
% contour_levels = -6:0.5:8; % 可以根据需要设置等值线的级别
fig = figure('visible','off')
[contours,~] = contour(x, y, z, contour_levels);

% % 设置要保留的最小等值线点数
% minNumPoints = 10;

% 筛选等值线数据
i = 1;
filteredContours = [];
while i < size(contours, 2)
    level = contours(1, i);
    numPoints = contours(2, i);
    
    if numPoints >= minNumPoints
        filteredContours = [filteredContours, contours(:, i:i+numPoints)];
    end
    
    i = i + numPoints + 1;
end

% % 可视化筛选后的等值线
% figure;
% hold on;
% i = 1;
% while i < size(filteredContours, 2)
%     level = filteredContours(1, i);
%     numPoints = filteredContours(2, i);
%     
%     xData = filteredContours(1, i+1:i+numPoints);
%     yData = filteredContours(2, i+1:i+numPoints);
%     
%     plot(xData, yData, 'k'); % 'k'表示黑色等值线，您可以根据需要更改颜色
%     i = i + numPoints + 1;
% end
% colorbar;
close(fig)
end
