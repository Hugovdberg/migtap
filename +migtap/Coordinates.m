classdef Coordinates < handle & matlab.mixin.Copyable
    %COORDINATES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private, Constant = true)
        crs_config = {'WGS84', {'WGS'}, @migtap.crsproj.validwgs, [2 1], [], []; ...
                      'RD', {'Rijksdriehoek'}, @migtap.crsproj.validrd, [1 2], @migtap.crsproj.rd2wgs, @migtap.crsproj.wgs2rd};
    end
    properties (Access = private)
        crs_num = 1;
        coords = [];
    end
    properties (Dependent)
        x
        y
        z
        N
        E
        crs
    end
    
    methods
        function obj = Coordinates(crs, varargin)
            no_crs = false;
            if nargin > 0
                try
                    obj.crs = crs;
                catch err
                    if strcmp(err.identifier, 'migtap:coord:InvalidCRSType')
                        no_crs = true;
                    else
                        rethrow(err)
                    end
                end
            end
            if no_crs
                varargin = [{crs} varargin];
            else
                switchargs = obj.crs_config{obj.crs_num, 4};
                varargin(sort(switchargs)) = varargin(switchargs);
            end
            for i = length(varargin):-1:1
                obj.setCoordinate(i, varargin{i});
            end
        end
        
        function setCoordinate(obj, dim, val)
            if ~rem(dim, 1)==0 || dim <= 0
                throw(MException('migtap:coord:InvalidDimension', 'Dimension number must be a positive integer'))
            elseif ~isnumeric(val)
                throw(MException('migtap:coord:InvalidCoordType', 'Coordinate must be numeric'))
            else
                obj.coords(dim) = val;
            end
        end
        function newCoords = convertCoordinates(objs, crs)
            if ~all(objs.validateCoordinates)
                throw(MException('migtap:coord:CoordinatesOutOfBounds', ...
                    'Coordinates are outside their valid range, cannot be converted'))
            end
            if nargout > 0
                new = true;
                objs = objs.copy();
            else
                new = false;
            end 
            for obj=objs
                try
                    currcrs = obj.crs_num;
                    currcoords = obj.coords;
                    oldcoords = obj.coords;
                    obj.crs = crs;
                    newcrs = obj.crs_num;
                    if ~isempty(obj.crs_config{currcrs, 5})
                        fun = obj.crs_config{currcrs, 5};
                        coord = num2cell(currcoords(obj.crs_config{currcrs, 4}));
                        [coord{:}] = fun(coord{:});
                        currcoords(obj.crs_config{1, 4}) = cell2mat(coord);
                    end
                    if ~isempty(obj.crs_config{newcrs, 6})
                        fun = obj.crs_config{newcrs, 6};
                        coord = num2cell(currcoords(obj.crs_config{1, 4}));
                        [coord{:}] = fun(coord{:});
                        currcoords(obj.crs_config{newcrs, 4}) = cell2mat(coord);
                    end
                    obj.coords = currcoords;
                catch err
                    obj.crs_num = currcrs;
                    obj.coords = oldcoords;
                    rethrow(err)
                end
            end
            if new
                newCoords = objs;
            end
        end                
        function val = getCoordinate(objs, dim, silent)
            if nargin < 3
                silent = false;
            end
            if ~rem(dim, 1)==0 || dim <= 0
                throw(MException('migtap:coord:InvalidDimension', 'Dimension number must be a positive integer'))
            end
            for i = length(objs):-1:1
                obj = objs(i);
                if dim > length(obj.coords)
                    if silent
                        val(i) = NaN;
                    else
                        throw(Mexception('migtap:coord:InvalidDimension', 'Dimension %d is not set', dim))
                    end
                else
                    val(i) = obj.coords(dim);
                end
            end
        end
        function tf = validateCoordinates(objs, transform)
            if nargin < 2
                transform = false;
            end
            for i = length(objs):-1:1
                obj = objs(i);
                fun = obj.crs_config{obj.crs_num, 3};
                val = num2cell(obj.coords(obj.crs_config{obj.crs_num, 4}));
                if transform
                    [tf(i), val{:}] = fun(val{:});
                    obj.coords(obj.crs_config{obj.crs_num, 4}) = cell2mat(val);
                else
                    tf(i) = fun(val{:});
                end
            end
        end
            
        function set.x(obj, x)
            obj.setCoordinate(1, x);
        end
        function x = get.x(obj)
            x = obj.getCoordinate(1, true);
        end
        
        function set.y(obj, y)
            obj.setCoordinate(2, y);
        end
        function y = get.y(obj)
            y = obj.getCoordinate(2, true);
        end
        
        function set.z(obj, z)
            obj.setCoordinate(3, z);
        end
        function z = get.z(obj)
            z = obj.getCoordinate(3, true);
        end
        
        function set.N(obj, N)
            obj.setCoordinate(2, N);
        end
        function N = get.N(obj)
            N = obj.getCoordinate(2, true);
        end
        
        function set.E(obj, E)
            obj.setCoordinate(1, E);
        end
        function E = get.E(obj)
            E = obj.getCoordinate(1, true);
        end
        
        function set.crs(obj, crs)
            if ~ischar(crs) 
                throw(MException('migtap:coord:InvalidCRSType', 'CRS must be of type char'))
            end
            [valid, valididx] = ismember(upper(crs), obj.crs_config(:, 1));
            if valid
                obj.crs_num = valididx;
            else
                crs_found = false;
                for i = 1:size(obj.crs_config, 1)
                    if strcmpi(crs, obj.crs_config{i, 2})
                        obj.crs_num = i;
                        crs_found = true;
                        break
                    end
                end
                if ~crs_found
                    throw(MException('migtap:coord:InvalidCRS', 'CRS name is neither valid name nor synonym.'))
                end
            end
        end
        function crs = get.crs(obj)
            crs = obj.crs_config{obj.crs_num, 1};
        end
    end
end

