function shpData = parse_multipatch(fid, shxInfo, selection)
%PARSE_MULTIPATCH Parses MultiPatch-type shaperecords
%   Internal function for the M>ap-shapefile reader
%
%   Inputs (all required):
%   - fid (handle):
%       Handle to open file
%   - shxInfo (struct):
%       Struct containing shapefile index as parsed by
%       migtap.shapefiles.index, used for quick access to requested
%       features.
%   - selection (array):
%       Array containing numeric indices of the requested features
%
%   Outputs:
%   - shpData (struct):
%       Array containing parsed data in a struct per feature.
%
%   See: <a href="matlab:help('migtap.shapefiles.read')">read</a>

    sc = migtap.shapefiles.mixin.ShapeConsts;

    part_type_names = {'Triangle Strip', ...
                       'Triangle Fan', ...
                       'Outer Ring', ...
                       'Inner Ring', ...
                       'First Ring', ...
                       'Ring'};

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
            shpData(k).ShapeType = 'NullMultiPatch';
        elseif shpType == 31
            shpData(k).ShapeType = 'MultiPatch';
            bbox = fread(fid, 4, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            nums = fread(fid, 2, sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            numparts = nums(1);
            numpoints = nums(2);
            partnums(numparts+1) = numpoints; %#ok<AGROW>
            partnums(1:numparts) = fread(fid, numparts, ...
                                         sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            parttypenums = fread(fid, numparts, ...
                                 sc.INTEGER, 0, sc.LITTLE_ENDIAN);
            points = fread(fid, [2, numpoints], ...
                           sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            zrange = fread(fid, 2, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            zarray = fread(fid, numpoints, sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            mrange = fread(fid, 2, sc.DOUBLE, 0, sc.LITTLE_ENDIAN);
            marray = fread(fid, numpoints, sc.DOUBLE, 0, sc.LITTLE_ENDIAN)';
            for l = numparts:-1:1
                idx = partnums(l)+1:partnums(l+1);
                parts{l} = points(idx, :);
                zparts{l} = zarray(idx);
                mparts{l} = marray(idx);
                parttypes(l) = struct('Number', ...
                                      parttypenums(l), ...
                                      'Name', ...
                                      part_type_names(parttypenums(l)));
            end
            shpData(k).Xmin = bbox(1);
            shpData(k).Ymin = bbox(2);
            shpData(k).Zmin = zrange(1);
            shpData(k).Mmin = mrange(1);
            shpData(k).Xmax = bbox(3);
            shpData(k).Ymax = bbox(4);
            shpData(k).Zmax = zrange(2);
            shpData(k).Mmax = mrange(2);
            shpData(k).NumParts = numparts;
            shpData(k).PartTypeNames = parttypes;
            shpData(k).NumPoints = numpoints;
            shpData(k).Points = parts;
            shpData(k).Z = zparts;
            shpData(k).M = mparts;
        else
            error('SHPREAD:InvalidShapeType', ...
                  ['Expected ShapeType 0 (Null) or 13 (PolyLineZ), ' ...
                   'got ''%d'' instead'], ...
                  shpType)
        end
    end
end
