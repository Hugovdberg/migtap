function [projections, distances, line_index] = project_point_on_multiline(points, line_mat)
    if size(line_mat, 2) ~= size(points, 2) || size(line_mat, 1) < 2
        error('Lines ill defined')
    end
    for j = size(points, 1):-1:1
        % first determine projection on each linepart as fraction
        for i = size(line_mat, 1)-1:-1:1
%            project_frac(i) = project_point_on_line(points(j, :), ...
%                line_mat(i:i+1, :), true);
%        end
%	ind = find(project_frac >= 0.0 & project_frac <= 1.0);
%        for i = length(ind):-1:1
            as_fraction = false;
            to_endpoint = true;
            [line_proj(i, :), line_dist(i, 1)] = project_point_on_line(points(j, :), line_mat(ind(i):ind(i)+1, :), as_fraction, to_endpoint);
        end
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
