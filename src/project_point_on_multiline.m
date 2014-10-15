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
