% project_point_on_line projects an array of points orthogonally on a line.
%
%   projections = project_point_on_line(points, line_mat) calculates the 
%       projections of all the points in the points array on the line defined by
%       line_mat.
%   projections = project_point_on_line(points, line_mat, to_endpoint) moves the
%       projection of any point which projects beyond the line to the nearest 
%       endpoint of the line.
%   [projections, distance] = project_point_on_line(...) additionally returns an
%       array of the distance between each point and its projection.
%   [projections, distance, projections_relative] = project_point_on_line(...)
%       also returns the projection as a fraction of the line length. 
%
%   All input arrays must be given as column vectors of of points, 
%
% project_point_on_line, part of the M>ap library

%    Copyright (C) 2014 Hugo van den Berg
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU Lesser General Public License as 
%    published by the Free Software Foundation, either version 3 of the 
%    License, or (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU Lesser General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.

function [projections, distance, projections_relative] = ...
    project_point_on_line(points, line_mat, to_endpoint)
    
    %% Input validation
    if nargin < 2
        error('migtap:ppol:numArgs', ...
            'Not enough input arguments')
    if size(line_mat, 1) ~= 2
        error('migtap:ppol:numPointsError', ...
            'Line must be defined by exactly two points')
    end
    if size(line_mat, 2) ~= size(points, 2)
        error('migtap:ppol:dimensionMismatch', ...
            'Line and points must be defined in the same number of dimensions')
    end
    if nargin < 3
        to_endpoint = false;
    end
    %% Determine requested outputs
    as_fraction = false;
    with_distance = false;
    if nargout > 1
        with_distance = true;
    end
    if nargout > 2
        as_fraction = true;
    end
    
    %% Project points on line
    % Transform line to start in origin
    vec_0 = line_mat(1, :);
    vec_L = line_mat(2, :) - vec_0;
    
    % For all points calculate projection
    for i = size(points, 1):-1:1
        % Move point to transformed line
        vec_H = points(i, :) - vec_0;
        % Determine projection as fraction of the line length
        rho = sum(vec_H.*vec_L)/sum(vec_L.*vec_L);
        if to_endpoint
            rho = min(1, max(0, rho));
        end
        % Determine coordinates off projection on transformed line
        vec_rho = rho*vec_L;
        % Transform projection to original line
        projections(i, :) = vec_rho+vec_0;
        % Calculate distance between point and projection
        if with_distance
            distance(i, 1) = norm(vec_H-vec_rho);
        end
        if as_fraction
            projections_relative(i, 1) = rho;
        end
    end
end
