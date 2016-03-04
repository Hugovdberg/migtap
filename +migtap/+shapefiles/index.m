function shpIndex = index(filename)
%READ Reads ESRI shapefile and returns structarray with shapes and records

    sc = migtap.shapefiles.mixin.ShapeConsts;

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
    RECORD_OFFSETS_OFFSET = 0;
    RECORD_OFFSETS_SIZE = 4;
    RECORD_LENGTH_OFFSET = 4;
    RECORD_LENGTH_SIZE = 4;

    standalone = ischar(filename);
    if standalone
        fid = fopen(filename, sc.READ_BINARY);
    else
        fid = filename;
        filename = fopen(fid);
    end

    shpInfo = migtap.shapefiles.info(fid);
    numrecords = (shpInfo.FileLength-50)/4;


    fseek(fid, sc.FILE_HEADER_LENGTH+sc.INDEX_OFFSETS_OFFSET, sc.BEGIN_OF_FILE);
    offsets = fread(fid, [numrecords, 1], sc.INTEGER, sc.INDEX_OFFSETS_SIZE, sc.BIG_ENDIAN);
    fseek(fid, sc.FILE_HEADER_LENGTH+sc.INDEX_LENGTH_OFFSET, sc.BEGIN_OF_FILE);
    lengths = fread(fid, [numrecords, 1], sc.INTEGER, sc.INDEX_LENGTH_SIZE, sc.BIG_ENDIAN);

    shpIndex.FileName = filename;
    shpIndex.NumRecords = numrecords;
    shpIndex.Offsets = offsets;
    shpIndex.Lengths = lengths;
    
    if standalone
        fclose(fid);
    end
end

