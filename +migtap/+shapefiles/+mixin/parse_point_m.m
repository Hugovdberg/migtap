function shpData = parse_point_m(fid, shxInfo, selection)
%PARSE_POINT Parse point-type shapefile using preparsed header/index
%   Detailed explanation goes here
    sc = migtap.shapefiles.mixin.ShapeConsts;

    numRecs = length(selection);
    shpData(numRecs, 1) = struct();
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
            shpData(k).ShapeType = 'NullPointM';
        elseif shpType == 21
            shpData(k).ShapeType = 'PointM';
            data = fread(fid, 3, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            shpData(k).Points = data(1:2);
            shpData(k).M = data(3);
        else
            error('SHPREAD:InvalidShapeType', ...
                  ['Expected ShapeType 0 (Null) or 21 (PointM), ' ...
                   'got ''%d'' instead'], ...
                  shpType)
        end
    end
end