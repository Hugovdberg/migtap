function shapes = read(filename, selection, attributes)
%READ Reads ESRI shapefile and returns structarray with shapes and records

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
