% project_point_on_line, part of the Migtap library
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
function [projections, distance, projections_relative] = project_point_on_line(points, line_mat, to_endpoint)
    if size(line_mat, 1) ~= 2 || size(line_mat, 2) ~= size(points, 2)
        error('Line ill defined')
    end
    as_fraction = false;
    with_distance = false;
    if nargout > 1
        with_distance = true;
    end
    if nargout > 2
        as_fraction = true;
    end
    if nargin < 3
        to_endpoint = false;
    end
        
    vec_0 = line_mat(1, :);
    vec_L = line_mat(2, :) - vec_0;
    for i = size(points, 1):-1:1
        vec_H = points(i, :) - vec_0;
        rho = sum(vec_H.*vec_L)/sum(vec_L.*vec_L);
        if to_endpoint
            rho = min(1, max(0, rho));
        end
        vec_rho = rho * vec_L;
        projections(i, :) = vec_rho+vec_0;
        if with_distance
            distance(i, 1) = norm(vec_H-vec_rho);
        end
        if as_fraction
            projections_relative(i, 1) = rho;
        end
    end
end
