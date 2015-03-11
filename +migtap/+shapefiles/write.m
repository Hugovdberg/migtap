function [ varargout ] = write(filename, data, crs)
    %WRITE Summary of this function goes here
    %   Detailed explanation goes here

    % WRITESHP needs filename without extension
    if strcmp(filename(end-3:end), '.shp')
        filename = filename(end-3:end);
    end

    % Call writeshp to do the dirty work
    varargout = writeshp(filename, data);
    
    % If a CRS is provided try to provide the projection file as well
    if nargin > 2
        prj_source = fullfile(fileparts(mfilename('fullpath')), ...
                               'resources', [crs '.prj']);
        if exist([filename '.shp'], 'file') == 2 && ...
                exist(prj_source, 'file') == 2
            copyfile(prj_source, [filename '.prj']);
        end
    end
end