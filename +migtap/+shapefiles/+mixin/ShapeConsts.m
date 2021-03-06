classdef ShapeConsts
% SHAPECONSTS Defines a number of constants for use throughout library

    properties (Constant)
        % File reading constants
        READ_BINARY = 'rb';
        BIG_ENDIAN = 'ieee-be';
        LITTLE_ENDIAN = 'ieee-le';
        BEGIN_OF_FILE = -1;
        CURRENT_POS = 0;
        END_OF_FILE = 1;
        READ_CONTIGUOUS = 0;

        % Data types 
        NO_DATA = -1e38;
        INTEGER = 'int32';
        DOUBLE = 'float64';
        WORD_LENGTH = 2;

        % Header indices
        FILE_HEADER_LENGTH = 100;

        % FILE_CODE
        FILE_CODE_OFFSET = 0;
        FILE_CODE_NUMVALS = 1;
        FILE_CODE_VALUE = 9994;

        % FILE_LENGTH
        FILE_LENGTH_OFFSET = 24;
        FILE_LENGTH_NUMVALS = 1;

        % VERSION
        VERSION_OFFSET = 28;
        VERSION_NUMVALS = 1;
        VERSION_VALUE = 1000;

        % SHAPE_TYPE
        SHAPE_TYPE_OFFSET = 32;
        SHAPE_TYPE_NUMVALS = 1;

        % FILE_BBOX
        FILE_BBOX_OFFSET = 36;
        FILE_BBOX_NUMVALS = 8;

        SHAPE_TYPES = [0, 1, 3, 5, 8, 11, 13, 15, 18, 21, 23, 25, 28, 31];
        SHAPE_TYPE_INFO = { ...
            'Null Shape', @migtap.shapefiles.mixin.parse_null; ...
            'Point', @migtap.shapefiles.mixin.parse_point; ...
            'PolyLine', @migtap.shapefiles.mixin.parse_polyline; ...
            'Polygon', @migtap.shapefiles.mixin.parse_polygon; ...
            'MultiPoint', @migtap.shapefiles.mixin.parse_multipoint; ...
            'PointZ', @migtap.shapefiles.mixin.parse_point_z; ...
            'PolyLineZ', @migtap.shapefiles.mixin.parse_polyline_z; ...
            'PolygonZ', @migtap.shapefiles.mixin.parse_polygon_z; ...
            'MultiPointZ', @migtap.shapefiles.mixin.parse_multipoint_z; ...
            'PointM', @migtap.shapefiles.mixin.parse_point_m; ...
            'PolyLineM', @migtap.shapefiles.mixin.parse_polyline_m; ...
            'PolygonM', @migtap.shapefiles.mixin.parse_polygon_m; ...
            'MultiPointM', @migtap.shapefiles.mixin.parse_multipoint_m; ...
            'MultiPatch', @migtap.shapefiles.mixin.parse_multipatch
            };

        INDEX_OFFSETS_OFFSET = 0;
        INDEX_OFFSETS_SIZE = 4;
        INDEX_LENGTH_OFFSET = 4;
        INDEX_LENGTH_SIZE = 4;

        SHAPE_LENGTH_OFFSET = 0;
        SHAPE_CONTENT_LENGTH_OFFSET = 4;
    end

    methods
    end

end
