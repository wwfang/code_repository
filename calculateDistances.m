function distances = calculateDistances(point, lon,lat)
    % calculateDistances: calculate the distance from a point to each point in a grid
    %
    % input:
    %   point = [latitude, longitude] in degrees
    %   grid = MxNx2 matrix, where M and N are the grid dimensions and
    %          grid(:,:,1) contains latitudes and grid(:,:,2) contains longitudes
    %
    % output:
    %   distances = MxN matrix containing distances from point to each grid point
    
    % Extract latitudes and longitudes
    latitudes = lat;
    longitudes = lon;
    
    % Convert degrees to radians
    lat1 = deg2rad(point(1));
    lon1 = deg2rad(point(2));
    lat2 = deg2rad(latitudes);
    lon2 = deg2rad(longitudes);
    
    % Haversine formula
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    a = sin(dlat/2).^2 + cos(lat1) * cos(lat2) .* sin(dlon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    % Radius of Earth in kilometers
    R = 6370.856;
    
    % Calculate distances
    distances = R * c;
end