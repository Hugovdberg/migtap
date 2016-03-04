function shapes = read(filename, selection, attributes)
% READ Reads features from ESRI shapefile, including attributes
%   Base function to read ESRI shapefiles. Requires <a
%   href="matlab:web('https://github.com/Hugovdberg/dbflib')">dbflib</a> to
%   be installed on the matlab path.
%
%   Inputs:
%   - filename (char):
%       Filename of the shapefile to be read. The extension '.shp' can be
%       omitted, actually the given extension is ignored entirely.
%   - selection (array):
%       Array containing numeric indices of the requested features.
%   - attributes (cell):
%       Cell-array containing names of the requested attributes for each
%       feature. Passed directly to <a
%       href="matlab:help('dbflib.read')">dbflib.read</a>.
%
%   Part of the <a
%   href="matlab:web('https://github.com/Hugovdberg/migtap')">M>ap</a>-library. Released under <a
%   href="matlab:web('www.gnu.org/licenses/lgpl-3.0.html')">LGPL v3</a>-license.
%
%   See: <a href="matlab:help('migtap.shapefiles.write')">write</a>, <a
%   href="matlab:help('migtap.shapefiles.info')">info</a>, <a
%   href="matlab:help('migtap.shapefiles.index')">index</a>

    sc = migtap.shapefiles.mixin.ShapeConsts();

    [path, fname, ~] = fileparts(filename);
    prefix = fullfile(path, fname);
    shpfile = fopen([prefix '.shp'], sc.READ_BINARY);
    shxfile = fopen([prefix '.shx'], sc.READ_BINARY);
    dbffile = fopen([prefix '.dbf'], sc.READ_BINARY);

    if nargin < 3
        attributes = [];
    end
    try
        shpInfo = migtap.shapefiles.info(shpfile);
        shxInfo = migtap.shapefiles.index(shxfile);
        shpInfo.NumRecords = shxInfo.NumRecords;

        if nargin > 1 && ~isempty(selection)
            assert(...
                all(selection <= shxInfo.NumRecords), ...
                'SHPREAD:invalidRecordNumber', ...
                'Record# %d does not exist. (#records: %d)', ...
                max(selection), shxInfo.NumRecords ...
                )
        else
            selection = 1:shxInfo.NumRecords;
        end

        shpData = shpInfo.ShapeTypeParser(shpfile, shxInfo, selection);
        [dbfData, dbfInfo] = dbflib.read(dbffile, selection, attributes);

        shapes.Shape = shpData;
        shapes.Record = cell2struct(dbfData, {dbfInfo.FieldInfo.Name}, 2);
        shapes.Meta.Shape = shpInfo;
        shapes.Meta.Index = shxInfo;
        shapes.Meta.Record = dbfInfo;
    catch err
        try
            fclose(dbffile);
        catch
        end
        try
            fclose(shxfile);
        catch
        end
        try
            fclose(shpfile);
        catch
        end
        rethrow(err)
    end

    fclose(dbffile);
    fclose(shxfile);
    fclose(shpfile);
end
