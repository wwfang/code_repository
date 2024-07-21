
function h=fig_selectedContour(filteredContours)

i = 1;
while i < size(filteredContours, 2)
    level = filteredContours(1, i);
    numPoints = filteredContours(2, i);
    
    xData = filteredContours(1, i+1:i+numPoints);
    yData = filteredContours(2, i+1:i+numPoints);
    
    h(i) = plot(xData, yData, 'k'); % 'k'表示黑色等值线，您可以根据需要更改颜色
    i = i + numPoints + 1;
end
colorbar;
end