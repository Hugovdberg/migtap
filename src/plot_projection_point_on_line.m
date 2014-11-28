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
function [h, projections, distance, projections_relative] = plot_projection_point_on_line(points, line_mat, to_endpoint, fig)
    if size(line_mat, 2) ~= 2
        error('plot_projection_point_on_line supports only two dimensional lines')
    end
    if nargin < 3
        to_endpoint = false;
    end
    [projections, distance, projections_relative] = project_point_on_line(points, line_mat, to_endpoint);
    
    if nargin < 4
        fig = figure();
    else
        set(0, 'currentfigure', fig);
    end
    hold on;
    handles = NaN(size(points, 1), 2);
    handles(size(points, 1)+1, 1) = plot(line_mat(:, 1), line_mat(:, 2));
    handles(size(points, 1)+1, 2) = fig;
    for i=1:size(points, 1)
        handles(i, 1) = plot([points(i, 1), projections(i, 1)], [points(i, 2), projections(i, 2)], '--');
        handles(i, 2) = plot([points(i, 1), projections(i, 1)], [points(i, 2), projections(i, 2)], '.');
        set(handles(i, 1), 'Color', [0.2, 0.2, 0.2]);
        set(handles(i, 2), 'Color', [0.1, 0.1, 0.1], 'Markers', 13);
    end
    if nargout > 0
        h = handles;
    end
end
