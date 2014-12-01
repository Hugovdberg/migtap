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
    end
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
    
    %% Project points on line
    num_points = size(points, 1);
    % Transform line to start in origin
    vec_0 = line_mat(1, :);
    vec_L = line_mat(2, :) - vec_0;
    % Calculate line length squared
    vec_L2 = norm(vec_L)^2;
    % Replicate line to match number of points
    vec_L = repmat(vec_L, num_points, 1);
    vec_0 = repmat(vec_0, num_points, 1);
    % Move points to transformed system
    vec_H = points - vec_0;
    rho = sum(vec_H.*vec_L, 2)/vec_L2;
    if to_endpoint
        rho = min(1, max(0, rho));
    end
    vec_rho= rho.*vec_L;
    
    %% Produce output
    projections = vec_rho+vec_0;
    if nargout > 1
        distance = sqrt(sum((vec_H-vec_rho).^2, 2));
    end
    if nargout > 2
        projections_relative = rho;
    end
end
