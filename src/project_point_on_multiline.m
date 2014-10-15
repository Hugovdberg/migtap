% project_point_on_multiline, part of the Migtap library
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
function [projections, distances, line_index] = project_point_on_multiline(points, line_mat)
    if size(line_mat, 2) ~= size(points, 2) || size(line_mat, 1) < 2
        error('Lines ill defined')
    end
    as_fraction = false;
    to_endpoint = true;
    for j = size(points, 1):-1:1
        % Determine projection on each line part, set to endpoint of linepart if beyond line
        for i = size(line_mat, 1)-1:-1:1
            [line_proj(i, :), line_dist(i, 1)] = project_point_on_line(points(j, :), line_mat(i:i+1, :), as_fraction, to_endpoint);
        end
        % Find shortest distance to linepart, including index of that part
        [min_dist, min_indx] = min(line_dist);
        projections(j, :) = line_proj(min_indx, :);
        if nargout > 1
            distances(j, 1) = min_dist;
        end
        if nargout > 2
            line_index(j, 1) = ind(min_indx);
        end
        clear project_frac line_proj line_dist
    end
end
