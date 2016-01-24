function shpData = parse_polygon(fid, shxInfo, selection)
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
        assert(record_header(2) == shxInfo.Lengths(recNum), ...
               'SHPREAD:InvalidRecordLength', ...
               '#%d: Indexed length %d does not match recordheader %d', ...
               recNum, shxInfo.Lengths(recNum), record_header(2))
        shpData(k).RecordNumber = record_header(1);
        shpType = fread(fid, 1, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
        if shpType == 0
            shpData(k).ShapeType = 'NullPolygon';
        elseif shpType == 5
            shpData(k).ShapeType = 'Polygon';
            bbox = fread(fid, 4, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            nums = fread(fid, 2, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            partnums = fread(fid, nums(1), sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            partnums = [partnums; nums(2)]; %#ok<AGROW>
            points = fread(fid, [2, nums(2)], sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            for l = nums(1):-1:1
                idx = partnums(l)+1:partnums(l+1);
                parts{l} = points(idx, :);
            end
            shpData(k).Xmin = bbox(1);
            shpData(k).Ymin = bbox(2);
            shpData(k).Xmax = bbox(3);
            shpData(k).Ymax = bbox(4);
            shpData(k).NumParts = nums(1);
            shpData(k).NumPoints = nums(2);
            shpData(k).Parts = parts;
        else
            error('SHPREAD:InvalidShapeType', ...
                  'Expected ShapeType Null or Point, got ''%s''', ...
                  sc.SHAPE_TYPE_INFO{shpType, 1})
        end
    end
end
