function shpData = parse_point(fid, shxInfo, selection)
%PARSE_POINT Parse point-type shapefile using preparsed header/index
%   Detailed explanation goes here
    sc = migtap.shapefiles.mixin.ShapeConsts;

    numRecs = length(selection);
    shpData(numRecs) = struct();
    for k = 1:numRecs
        recNum = selection(k);
        offset = shxInfo.Offsets(recNum)*sc.WORD_LENGTH;
        fseek(fid, offset, sc.BEGIN_OF_FILE);
        record_header = fread(fid, 2, sc.INTEGER, 0, sc.BIG_ENDIAN);
        assert(record_header(2) == shxInfo.Lengths(k), ...
               'SHPREAD:InvalidRecordLength', ...
               '#%d: Indexed length %d does not match recordheader %d', ...
               recNum, shxInfo.Lengths(recNum), record_header(2))
        shpData(k).RecordNumber = record_header(1);
        shpType = fread(fid, 1, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
        if shpType == 0
            shpData(k).ShapeType = 'NullPoint';
        elseif shpType == 1
            shpData(k).ShapeType = 'Point';
            data = fread(fid, 2, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            shpData(k).X = data(1);
            shpData(k).Y = data(2);
        else
            error('SHPREAD:InvalidShapeType', ...
                  'Expected ShapeType Null or Point, got ''%s''', ...
                  sc.SHAPE_TYPE_INFO{shpType, 1})
        end
    end
end

