% PLOT_PROJECTION_POINT_ON_LINE  A wrapper around project_point_on_line to plot
%   the points and line, with connecting lines between the points and their 
%   projections.
%   
%   plot_projection_point_on_line(..., fig) takes the same input arguments as
%       project_point_on_line, and additionally specifies an existing figure to
%       add the plot to. Hold is set automatically to preserve existing items in
%       the figure.
%   [h, ...] = plot_projection_point_on_line(...) returns an array containing
%       handles to all plot items added to the figure for later configuration,
%       and all output arguments of project_point_on_line.
%
%   h contains an (n+1)x3 array containing in the first n rows the handles to
%       the separate points (h(i, 2)), projections (h(i, 3)), and connecting 
%       lines (h(i, 1)), with n the number of points. The last row of the array
%       contains the axes handle, figure handle, and a NaN (by design).
% 
% plot_projection_point_on_line is part of the M>ap library
    
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
function [h, projections, distance, projections_relative, line_index] = ...
    plot_projection_point_on_line(points, line_mat, to_endpoint, fig)
    
    %% Verify input
    narginchk(2, 4)
    assert(size(line_mat, 2) == 2, ...
           'migtap:plot:dimensionError', ...
           'supports only two dimensional lines');
    assert(size(line_mat, 1) > 1, ...
           'migtap:plot:lineparts', ...
           'not enough lineparts to project on')
    
    if size(line_mat, 1) == 2
        single_linepart = true;
    else % Always more than two because of assertion size > 1
        single_linepart = false;
    end
    if nargin < 3
        to_endpoint = false;
    end
    
    %% Calculate projected points
    if single_linepart
        [projections, distance, projections_relative] = ...
            migtap.project_point_on_line(points, line_mat, to_endpoint);
        % Add line_index for compatibility with multiline variant
        line_index = 1;
    else
        [projections, distance, projections_relative, line_index] = ...
            migtap.project_point_on_multiline(points, line_mat);
    end
    
    %% Plot components
    % Determine figure to draw plots in
    if nargin < 4
        fig = figure();
    else
        try
            set(0, 'currentfigure', fig);
        catch
            if isnumeric(fig)
                fig = figure(fig);
            else
                fig = figure();
            end
        end
    end
    hold on;
    % Prepare an array to hold all handles
    handles = NaN(size(points, 1)+1, 3);
    % Add figure handle to output
    handles(end, 2) = fig;
    % Plot line
    handles(end, 1) = plot(line_mat(:, 1), line_mat(:, 2));
    % Plot connecting lines
    for i=1:size(points, 1)
        % Plot connecting line
        handles(i, 1) = plot([points(i, 1), projections(i, 1)], ...
                             [points(i, 2), projections(i, 2)], ...
                             '--', ...
                             'Color', [0.2, 0.2, 0.2]);
        % Plot original point
        handles(i, 2) = plot(points(i, 1), ...
                             points(i, 2), ...
                             '.', ...
                             'Color', [0.1, 0.1, 0.1], ...
                             'MarkerSize', 11);
        % Plot projection
        handles(i, 3) = plot(projections(i, 1), ...
                             projections(i, 2), ...
                             '.', ...
                             'Color', [0.1, 0.1, 0.1], ...
                             'MarkerSize', 10);
    end
    
    % Return handles if requested, makes function quiet if no output is
    % required
    if nargout > 0
        h = handles;
    end
end
