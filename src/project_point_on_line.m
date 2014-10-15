function [projections, distance] = project_point_on_line(points, line_mat, as_fraction)
    if size(line_mat, 1) ~= 2 || size(line_mat, 2) ~= size(points, 2)
        error('Line ill defined')
    end
    if nargin ~= 3
        as_fraction = false;
    end
        
    vec_0 = line_mat(1, :);
    vec_L = line_mat(2, :) - vec_0;
    for i = size(points, 1):-1:1
        vec_H = points(i, :) - vec_0;
        rho = sum(vec_H.*vec_L)/sum(vec_L.*vec_L);
        if as_fraction
            projections(i) = rho;
            if nargout > 1
                distance = NaN;
            end
        else
            vec_rho = rho * vec_L;
            projections(i,:) = vec_rho + vec_0;
            if nargout > 1
                distance = norm(vec_H - vec_rho);
            end
        end
    end
end
