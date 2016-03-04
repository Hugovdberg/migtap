function shpInfo = info(filename)
% INFO Reads fileheader for ESRI shapefile
%   Complementary function for reading shapefiles, can be used to determine
%   some general information of a shapefile without parsing the complete
%   file.
%
%   Inputs:
%   - filename (char or handle):
%       Filename or handle to opened file. If filename is given  as char
%       the file is closed upon completion, otherwise the handle is left
%       open.
%
%   See: <a href="matlab:help('migtap.shapefiles.read')">read</a>


    sc = migtap.shapefiles.mixin.ShapeConsts();

    standalone = ischar(filename);
    if standalone
        fid = fopen(filename, sc.READ_BINARY);
    else
        fid = filename;
        filename = fopen(fid);
    end

    fseek(fid, sc.FILE_CODE_OFFSET, sc.BEGIN_OF_FILE);
    file_code = fread(fid, ...
                      sc.FILE_CODE_NUMVALS, ...
                      sc.INTEGER, ...
                      sc.READ_CONTIGUOUS, ...
                      sc.BIG_ENDIAN);

    assert(file_code == sc.FILE_CODE_VALUE, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_FILECODE', ...
        'File %s is not a valid shapefile (file code: %d)', ...
        filename, file_code)

    fseek(fid, sc.FILE_LENGTH_OFFSET, sc.BEGIN_OF_FILE);
    file_length = fread(fid, ...
                        sc.FILE_LENGTH_NUMVALS, ...
                        sc.INTEGER, ...
                        sc.READ_CONTIGUOUS, ...
                        sc.BIG_ENDIAN);
    assert(file_length*sc.WORD_LENGTH > sc.FILE_HEADER_LENGTH, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_FILELENGTH', ...
        'File %s corrupted (file length %d less than header length)', ...
        filename, file_length)

    fseek(fid, sc.VERSION_OFFSET, sc.BEGIN_OF_FILE);
    shp_version = fread(fid, ...
                        sc.VERSION_NUMVALS, ...
                        sc.INTEGER, ...
                        sc.READ_CONTIGUOUS, ...
                        sc.LITTLE_ENDIAN);
    assert(shp_version == sc.VERSION_VALUE, ...
        'MIGTAP:SHAPEFILE:READ:INVALID_VERSION', ...
        'File %s is not a valid shapefile (version: %d)', ...
        filename, shp_version)

    fseek(fid, sc.SHAPE_TYPE_OFFSET, sc.BEGIN_OF_FILE);
    shp_type = fread(fid, ...
                     sc.SHAPE_TYPE_NUMVALS, ...
                     sc.INTEGER, ...
                     sc.READ_CONTIGUOUS, ...
                     sc.LITTLE_ENDIAN);
    [shp_type_name, shp_type_parser] = ...
        sc.SHAPE_TYPE_INFO{sc.SHAPE_TYPES == shp_type, :};

    fseek(fid, sc.FILE_BBOX_OFFSET, sc.BEGIN_OF_FILE);
    bbox = fread(fid, ...
                 [1, sc.FILE_BBOX_NUMVALS], ...
                 sc.DOUBLE, ...
                 sc.READ_CONTIGUOUS, ...
                 sc.LITTLE_ENDIAN);

    shpInfo = struct( ...
        'FileName', filename, ...
        'FileLength', file_length, ...
        'ShapeTypeNum', shp_type, ...
        'ShapeType', shp_type_name, ...
        'ShapeTypeParser', shp_type_parser, ...
        'BoundingBox', struct(...
            'X', bbox([1 3]), ...
            'Y', bbox([2 4]), ...
            'Z', bbox([5 6]), ...
            'M', bbox([7 8])) ...
        );

    if standalone
        fclose(fid);
    end
end
