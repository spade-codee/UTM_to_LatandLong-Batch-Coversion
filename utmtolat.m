% Batch UTM to Lat/Lon Conversion Program

%input and output file names
inputFileName = 'utm_input.csv';  % Input CSV file with UTM coordinates
outputFileName = 'LeftHandsidealignment12.csv';  % Output CSV file with Lat/Lon

% Read the input file
data = readtable(inputFileName);

% Extract UTM coordinates
% Assumes columns: Eastings, Northings
easting = data.Eastings;
northing = data.Northings;

%UTM zone and hemisphere
utmZone = 32;  % Example: Zone 32
isNorthernHemisphere = true;  % True for Northern Hemisphere, False for Southern Hemisphere

% Determine EPSG code
if isNorthernHemisphere
    epsgCode = 32600 + utmZone;  % EPSG code for Northern Hemisphere UTM
else
    epsgCode = 32700 + utmZone;  % EPSG code for Southern Hemisphere UTM
end

% Create a projcrs object for the UTM zone
utmCrs = projcrs(epsgCode);

% Initialize output arrays
latitude = zeros(size(easting));
longitude = zeros(size(northing));

% Conversion for each row
for i = 1:length(easting)
    [lat, lon] = projinv(utmCrs, easting(i), northing(i));
    latitude(i) = lat;
    longitude(i) = lon;
end

% Write the output to a new CSV file
outputTable = table(latitude, longitude);
writetable(outputTable, outputFileName);

disp('Conversion completed. Check the output file: latlon_output.csv');
