%    Copyright (C) 2014 Hugo van den Berg
%    project_point_on_line, part of the Migtap library
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

function [h, projections, distance, projections_relative, line_index] = plot_projection_point_on_line(points, line_mat, to_endpoint, fig)
% PLOT_PROJECTION_POINT_ON_LINE  A wrapper around project_point_on_line to plot the points and line, with connecting lines between the points and their projections.
%   
%   plot_projection_point_on_line(..., fig) takes the same input arguments as project_point_on_line, and additionally specifies an existing figure to add the plot to. Hold is set automatically to preserve existing items in the figure.
%   [h, ...] = plot_projection_point_on_line(...) returns an array containing handles to all plot items added to the figure for later configuration, and all output arguments of project_point_on_line.
%
%   h contains an (n+1)x2 array containing in the first n rows the handles to the figure and the added components
    
    %% Verify input
    if size(line_mat, 2) ~= 2
        error('plot_projection_point_on_line supports only two dimensional lines')
    end
    single_linepart = true;
    switch size(line_mat, 1)
        case {0, 1}
            error('not enough lineparts to project on')
        case 2
            single_linepart = true;
        otherwise
            single_linepart = false;
    end
    if nargin < 3
        to_endpoint = false;
    end
    
    %% Calculate projected points
    if single_linepart
        [projections, distance, projections_relative] = project_point_on_line(points, line_mat, to_endpoint);
        % Add line_index for compatibility with multiline variant
        line_index = 1;
    else
        [projections, distance, projections_relative, line_index] = project_point_on_multiline(points, line_mat);
    end
    
    %% Plot components
    % Determine figure to draw plots in
    if nargin < 4
        fig = figure();
    else
        if ishandle(fig)
            set(0, 'currentfigure', fig);
            
        else
            fig = figure(fig);
        end
    end
    hold on;
    % Prepare an array to hold all handles
    handles = NaN(size(points, 1), 2);
    % Add figure handle to output
    handles(size(points, 1)+1, 2) = fig;
    % Plot line
    handles(size(points, 1)+1, 1) = plot(line_mat(:, 1), line_mat(:, 2));
    % Plot connecting lines
    for i=1:size(points, 1)
        handles(i, 1) = plot([points(i, 1), projections(i, 1)], [points(i, 2), projections(i, 2)], '--', 'Color', [0.2, 0.2, 0.2]);
    end
    % Plot original points
    handles(i, 2) = plot([points(:, 1); projections(:, 1)], [points(:, 2); projections(:, 2)], '.', 'Color', [0.1, 0.1, 0.1], 'Markers', 13);
    
    % Return handles if requested, makes function quiet if no output is required
    if nargout > 0
        h = handles;
    end
end
