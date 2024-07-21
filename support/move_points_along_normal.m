
function [new_lat1, new_lon1, new_lat2, new_lon2] = move_points_along_normal(lat1, lon1, lat2, lon2, distance_km)
    % 将输入的经纬度从度转换为弧度
    lat1_rad = deg2rad(lat1);
    lon1_rad = deg2rad(lon1);
    lat2_rad = deg2rad(lat2);
    lon2_rad = deg2rad(lon2);
    
    % 计算从第一个点到第二个点的方位角（Azimuth）
    dLon = lon2_rad - lon1_rad;
    y = sin(dLon) * cos(lat2_rad);
    x = cos(lat1_rad) * sin(lat2_rad) - sin(lat1_rad) * cos(lat2_rad) * cos(dLon);
    azimuth = atan2(y, x);
    
    % 计算法线方向（垂直方向）
    normal_azimuth1 = azimuth + pi/2;
    normal_azimuth2 = azimuth - pi/2;
    
    % 使用大圆航线公式沿法线方向移动指定的距离
    R = 6371; % 地球半径，单位为千米
    
    % 计算新的点1沿法线方向移动后的坐标
    new_lat1 = asin(sin(lat1_rad) * cos(distance_km / R) + cos(lat1_rad) * sin(distance_km / R) * cos(normal_azimuth1));
    new_lon1 = lon1_rad + atan2(sin(normal_azimuth1) * sin(distance_km / R) * cos(lat1_rad), cos(distance_km / R) - sin(lat1_rad) * sin(new_lat1));
    
    % 计算新的点2沿法线方向移动后的坐标
    new_lat2 = asin(sin(lat2_rad) * cos(distance_km / R) + cos(lat2_rad) * sin(distance_km / R) * cos(normal_azimuth1));
    new_lon2 = lon2_rad + atan2(sin(normal_azimuth1) * sin(distance_km / R) * cos(lat2_rad), cos(distance_km / R) - sin(lat2_rad) * sin(new_lat2));
    
    % 将结果从弧度转换回度
    new_lat1 = rad2deg(new_lat1);
    new_lon1 = rad2deg(new_lon1);
    new_lat2 = rad2deg(new_lat2);
    new_lon2 = rad2deg(new_lon2);
end