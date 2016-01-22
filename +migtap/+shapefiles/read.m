function shapes = read(filename, selection)
%READ Reads ESRI shapefile and returns structarray with shapes and records

    % Declare constants
    RECORD_LENGTH_OFFSET = 0;
    RECORD_CONTENT_LENGTH_OFFSET = 4;

    [path, fname, ~] = fileparts(filename);
    prefix = fullfile(path, fname);
    shpfile = [prefix '.shp'];
    shxfile = [prefix '.shx'];
    dbffile = [prefix '.dbf'];
    
    shpInfo = migtap.shapefiles.info(shpfile);
    shxInfo = migtap.shapefiles.index(shxfile);
    dbfInfo = dbfread(dbffile);

    shapes.shp = shpInfo;
    shapes.idx = shxInfo;
    shapes.rec = dbfInfo;
end

