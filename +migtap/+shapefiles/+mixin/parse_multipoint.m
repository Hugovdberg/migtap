function shpData = parse_multipoint(fid, shxInfo, selection)
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
            shpData(k).ShapeType = 'NullMultiPoint';
        elseif shpType == 8
            shpData(k).ShapeType = 'MultiPoint';
            bbox = fread(fid, 4, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            numpoints = fread(fid, 1, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            data = fread(fid, [2, numpoints], ...
                         sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            shpData(k).Xmin = bbox(1);
            shpData(k).Ymin = bbox(2);
            shpData(k).Xmax = bbox(3);
            shpData(k).Ymax = bbox(4);
            shpData(k).NumPoints = numpoints;
            shpData(k).Points = data;
        else
            error('SHPREAD:InvalidShapeType', ...
                  ['Expected ShapeType 0 (Null) or 8 (MultiPoint), ' ...
                   'got ''%d'' instead'], ...
                  shpType)
        end
    end
end
