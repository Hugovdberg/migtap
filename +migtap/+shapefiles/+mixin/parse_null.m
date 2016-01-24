function shpData = parse_null(~, ~, selection)
%PARSE_NULL Fakes parsing NULL-type shapefile
    numRecs = length(selection);
    shpData(1:numRecs) = struct('ShapeType', 'Null');
end

