function [ varargout ] = read( varargin )
%READ Summary of this function goes here
%   Detailed explanation goes here

    if isempty(which('readshp'))
        error('MIGTAP:SHAPEFILES:readshpMissing', ...
              ['M>ap still depends on external non-free GIStools by '...
               '<Bernard.Raterman@kiwa.nl>'])
    end
    
    temp = {readshp(varargin{:})};
    varargout = temp(1:nargout);

end

