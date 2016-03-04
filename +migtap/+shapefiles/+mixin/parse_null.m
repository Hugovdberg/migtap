function shpData = parse_null(~, ~, selection)
%PARSE_NULL Imitates parsing Null-type shaperecords
%   Internal function for the M>ap-shapefile reader. Instead of reading
%   nulls this builds struct-array containing requested recordnumbers and
%   shapetype set to Null.
%
%   Inputs (all required):
%   - fid (handle):
%       Ignored, necessary for signature compliance
%   - shxInfo (struct):
%       Ignored, necessary for signature compliance
%   - selection (array):
%       Array containing numeric indices of the requested features
%
%   Outputs:
%   - shpData (struct):
%       Array containing parsed data in a struct per feature.
%
%   See: <a href="matlab:help('migtap.shapefiles.read')">read</a>

    shpData = struct('RecordNumber', num2cell(selection), ...
                     'ShapeType', 'Null');
end
