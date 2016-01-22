function shpInfo = info(filename)
%READ Reads ESRI shapefile and returns structarray with shapes and records

    % Declare constants
    READ_BINARY = 'rb';
    BIG_ENDIAN = 'ieee-be';
    LITTLE_ENDIAN = 'ieee-le';

    BEGIN_OF_FILE = -1;
    CURRENT_POS = 0;
    END_OF_FILE = 1;

    NO_DATA = -1e38;
    INTEGER = 'int32';
    DOUBLE = 'float64';

    HEADER_LENGTH = 100;
    FILE_CODE = 0;
    FILE_LENGTH = 24;
    VERSION = 28;
    SHAPE_TYPE = 32;
    BBOX_OFFSET = 36;

    SHAPE_TYPES = [0, 1, 3, 5, 8];
    SHAPE_TYPE_INFO = { ...
        'Null Shape', @migtap.shapefiles.mixin.parse_null; ...
        'Point', @migtap.shapefiles.mixin.parse_point; ...
        'PolyLine', @migtap.shapefiles.mixin.parse_polyline; ...
        'Polygon', @migtap.shapefiles.mixin.parse_polygon; ...
        'MultiPoint', @migtap.shapefiles.mixin.parse_multipoint
        };

    if ~ischar(filename)
        fid = filename;
        filename = fopen(fid);
        try
            fclose(fid);
        catch
            %explicitly silent
        end
    end
    fid = fopen(filename, READ_BINARY, BIG_ENDIAN);
    shpInfo.FileName = filename;

    fseek(fid, FILE_CODE, BEGIN_OF_FILE);
    file_code = fread(fid, 1, INTEGER);

    assert(file_code == 9994, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_FILECODE', ...
        'File %s is not a valid shapefile (file code: %d)', ...
        filename, file_code)

    fseek(fid, FILE_LENGTH, BEGIN_OF_FILE);
    file_length = fread(fid, 1, INTEGER);
    fclose(fid);
    
    assert(file_length > HEADER_LENGTH, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_FILELENGTH', ...
        'File %s seems corrupted (file length %d smaller than header length)', ...
        filename, file_length)
    
    shpInfo.FileLength = file_length;
        
    fid = fopen(filename, READ_BINARY, LITTLE_ENDIAN);
    
    fseek(fid, VERSION, BEGIN_OF_FILE);
    shp_version = fread(fid, 1, INTEGER);
    assert(shp_version == 1000, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_VERSION', ...
        'File %s is not a valid shapefile (version: %d)', ...
        filename, shp_version)
    
    fseek(fid, SHAPE_TYPE, BEGIN_OF_FILE);
    shp_type = fread(fid, 1, INTEGER);
    
    shpInfo.ShapeTypeNum = shp_type;
    [shpInfo.ShapeType, shpInfo.ShapeParser] = SHAPE_TYPE_INFO{SHAPE_TYPES == shp_type, :};
    
    fseek(fid, BBOX_OFFSET, BEGIN_OF_FILE);
    bbox = fread(fid, 8, DOUBLE);
    
    shpInfo.BoundingBox.X = bbox([1, 3])';
    shpInfo.BoundingBox.Y = bbox([2, 4])';
    shpInfo.BoundingBox.Z = bbox([5, 6])';
    shpInfo.BoundingBox.M = bbox([7, 8])';
    
    fclose(fid);
end

