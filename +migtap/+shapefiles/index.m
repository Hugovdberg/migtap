function shpIndex = index(filename)
%READ Reads ESRI shapefile and returns structarray with shapes and records

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

    shpInfo = migtap.shapefiles.info(filename);
    numrecords = (shpInfo.FileLength-50)/4;

    fid = fopen(filename, READ_BINARY, BIG_ENDIAN);

    fseek(fid, HEADER_LENGTH+RECORD_OFFSETS_OFFSET, BEGIN_OF_FILE);
    offsets = fread(fid, [numrecords, 1], INTEGER, RECORD_OFFSETS_SIZE);
    fseek(fid, HEADER_LENGTH+RECORD_LENGTH_OFFSET, BEGIN_OF_FILE);
    lengths = fread(fid, [numrecords, 1], INTEGER, RECORD_LENGTH_SIZE);

    shpIndex.FileName = filename;
    shpIndex.NumRecords = numrecords;
    shpIndex.Offsets = offsets;
    shpIndex.Lengths = lengths;
end

