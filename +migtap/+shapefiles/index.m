function shpIndex = index(filename)
% INDEX Reads indexfile for ESRI shapefile
%   Complementary function for reading shapefiles, on its own not very
%   useful.
%
%   Inputs:
%   - filename (char or handle):
%       Filename or handle to opened file. If filename is given  as char
%       the file is closed upon completion, otherwise the handle is left
%       open.
%
%   See: <a href="matlab:help('migtap.shapefiles.read')">read</a>

    sc = migtap.shapefiles.mixin.ShapeConsts;

    standalone = ischar(filename);
    if standalone
        fid = fopen(filename, sc.READ_BINARY);
    else
        fid = filename;
        filename = fopen(fid);
    end

    shpInfo = migtap.shapefiles.info(fid);
    numrecords = (shpInfo.FileLength-50)/4;

    fseek(fid, ...
          sc.FILE_HEADER_LENGTH+sc.INDEX_OFFSETS_OFFSET, ...
          sc.BEGIN_OF_FILE);
    offsets = fread(fid, [numrecords, 1], ...
                    sc.INTEGER, sc.INDEX_OFFSETS_SIZE, sc.BIG_ENDIAN);
    fseek(fid, ...
          sc.FILE_HEADER_LENGTH+sc.INDEX_LENGTH_OFFSET, ...
          sc.BEGIN_OF_FILE);
    lengths = fread(fid, [numrecords, 1], ...
                    sc.INTEGER, sc.INDEX_LENGTH_SIZE, sc.BIG_ENDIAN);

    shpIndex.FileName = filename;
    shpIndex.NumRecords = numrecords;
    shpIndex.Offsets = offsets;
    shpIndex.Lengths = lengths;

    if standalone
        fclose(fid);
    end
end
