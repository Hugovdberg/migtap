function shpData = parse_polyline_m(fid, shxInfo, selection)
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
        assert(record_header(2) == shxInfo.Lengths(recNum), ...
               'SHPREAD:InvalidRecordLength', ...
               '#%d: Indexed length %d does not match recordheader %d', ...
               recNum, shxInfo.Lengths(recNum), record_header(2))
        shpData(k).RecordNumber = record_header(1);
        shpType = fread(fid, 1, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
        if shpType == 0
            shpData(k).ShapeType = 'NullPolyLineM';
        elseif shpType == 13
            shpData(k).ShapeType = 'PolyLineM';
            bbox = fread(fid, 4, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            nums = fread(fid, 2, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            numparts = nums(1);
            numpoints = nums(2);
            partnums(numparts+1) = numpoints; %#ok<AGROW>
            partnums(1:numparts) = fread(fid, numparts, ...
                                         sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            points = fread(fid, [2, numpoints], ...
                           sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            mrange = fread(fid, 2, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            marray = fread(fid, numpoints, sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            for l = numparts:-1:1
                idx = partnums(l)+1:partnums(l+1);
                parts{l} = points(idx, :);
                mparts{l} = marray(idx);
            end
            shpData(k).Xmin = bbox(1);
            shpData(k).Ymin = bbox(2);
            shpData(k).Mmin = mrange(1);
            shpData(k).Xmax = bbox(3);
            shpData(k).Ymax = bbox(4);
            shpData(k).Mmax = mrange(2);
            shpData(k).NumParts = numparts;
            shpData(k).NumPoints = numpoints;
            shpData(k).Points = parts;
            shpData(k).M = mparts;
        else
            error('SHPREAD:InvalidShapeType', ...
                  ['Expected ShapeType 0 (Null) or 23 (PolyLineM), ' ...
                   'got ''%d'' instead'], ...
                  shpType)
        end
    end
end
