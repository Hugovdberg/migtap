%!shared a, tolerance, proj
%!  tolerance = 1e-14;
%!  a = 0.5;
%!  proj = project_point_on_line([0.5], [0; 1]);
%!error project_point_on_line()
%!error project_point_on_line([0]);
%!error project_point_on_line([0], [0]);
%!error project_point_on_line([0], [0, 0; 1, 1]);
%!assert (proj, a, tolerance);


%    %% Build test cases
%    testcases(1).id_dim = 'one dim';
%    testcases(1).id_point = 'one point';
%    testcases(1).id_end = 'not to end';
%    testcases(1).points = 0.5;
%    testcases(1).line = [0; 1];
%    testcases(1).to_end = false;
%    testcases(1).result_proj = 0.5;
%    testcases(1).result_dist = 0;
%    testcases(1).result_proj_rel = 0.5;
%    
%    testcases(2).id_dim = 'one dim';
%    testcases(2).id_point = 'one point';
%    testcases(2).id_end = 'to end';
%    testcases(2).points = 0.5;
%    testcases(2).line = [0; 1];
%    testcases(2).to_end = true;
%    testcases(2).result_proj = 0.5;
%    testcases(2).result_dist = 0;
%    testcases(2).result_proj_rel = 0.5;
%    
%    testcases(3).id_dim = 'one dim';
%    testcases(3).id_point = 'multiple points';
%    testcases(3).id_end = 'not to end';
%    testcases(3).points = [-1; 0.5; 1; 2];
%    testcases(3).line = [0; 1];
%    testcases(3).to_end = false;
%    testcases(3).result_proj = [-1; 0.5; 1; 2];
%    testcases(3).result_dist = [0; 0; 0; 0];
%    testcases(3).result_proj_rel = [-1; 0.5; 1; 2];%
%
%    testcases(4).id_dim = 'one dim';
%    testcases(4).id_point = 'multiple points';
%    testcases(4).id_end = 'to end';
%    testcases(4).points = [-1; 0.5; 1; 2];
%    testcases(4).line = [0; 1];
%    testcases(4).to_end = true;
%    testcases(4).result_proj = [0; 0.5; 1; 1];
%    testcases(4).result_dist = [1; 0; 0; 1];
%    testcases(4).result_proj_rel = [0; 0.5; 1; 1];%%

%    testcases(5).id_dim = 'two dim';
%    testcases(5).id_point = 'one point';
%    testcases(5).id_end = 'not to end';
%    testcases(5).points = [0, 1];
%    testcases(5).line = [0, 0; 1, 1];
%    testcases(5).to_end = false;
%    testcases(5).result_proj = [0.5, 0.5];
%    testcases(5).result_dist = sqrt(2)/2;
%    testcases(5).result_proj_rel = [0.5];
%    
%    testcases(6).id_dim = 'two dim';
%    testcases(6).id_point = 'one point';
%    testcases(6).id_end = 'to end';
%    testcases(6).points = [0, 1];
%    testcases(6).line = [0, 0; 1, 1];
%    testcases(6).to_end = true;
%    testcases(6).result_proj = [0.5, 0.5];
%    testcases(6).result_dist = sqrt(2)/2;
%    testcases(6).result_proj_rel = [0.5];
%    
%    testcases(7).id_dim = 'two dim';
%    testcases(7).id_point = 'multiple points';
%    testcases(7).id_end = 'not to end';
%    testcases(7).points = [-1; 0.5; 1; 2];
%    testcases(7).line = [0; 1];
%    testcases(7).to_end = false;
%    testcases(7).result_proj = [-1; 0.5; 1; 2];
%    testcases(7).result_dist = [0; 0; 0; 0];
%    testcases(7).result_proj_rel = [-1; 0.5; 1; 2];
%
%    testcases(8).id_dim = 'two dim';
%    testcases(8).id_point = 'multiple points';
%    testcases(8).id_end = 'to end';
%    testcases(8).points = [-1; 0.5; 1; 2];
%    testcases(8).line = [0; 1];
%    testcases(8).to_end = true;
%    testcases(8).result_proj = [0; 0.5; 1; 1];
%    testcases(8).result_dist = [1; 0; 0; 1];
%    testcases(8).result_proj_rel = [0; 0.5; 1; 1];
%
%    %% Verify results
%    for i = 1:length(testcases)
%        id = sprintf('migtap:test:ppol:%s:%s:%s', ...
%            strrep(testcases(i).id_dim, ' ', ''), ...
%            strrep(testcases(i).id_point, ' ', ''), ...
%            strrep(testcases(i).id_end, ' ', ''));
%        fprintf('%d: %s', i, id);
%        
%        proj = project_point_on_line(testcases(i).points, ...
%            testcases(i).line, ...
%            testcases(i).to_end);
%        assert(isequal(proj, testcases(i).result_proj), sprintf('%s:proj:proj', id), ...
%            sprintf('Incorrection projection (input %s, %s, %s; output: proj)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));
%        
%        [proj, dist] = project_point_on_line(testcases(i).points, ...
%            testcases(i).line, ...
%            testcases(i).to_end);
%        assert(all(proj./testcases(i).result_proj), sprintf('%s:projdist:proj', id), ...
%            sprintf('Incorrection projection (input %s, %s, %s; output: proj+dist)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));
%        assert(all(dist./testcases(i).result_dist), sprintf('%s:projdist:dist', id), ...
%            sprintf('Incorrection distance (input %s, %s, %s; output: proj+dist)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));%%
%
%        [proj, dist, proj_rel] = project_point_on_line(testcases(i).points, ...
%            testcases(i).line, ...
%            testcases(i).to_end);
%        assert(all(proj./testcases(i).result_proj), sprintf('%s:projdistrel:proj', id), ...
%            sprintf('Incorrection projection (input %s, %s, %s; output: proj+dist_rel)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));
%        assert(all(dist./testcases(i).result_dist), sprintf('%s:projdistrel:dist', id), ...
%            sprintf('Incorrection distance (input %s, %s, %s; output: proj+dist_rel)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));
%        assert(all(proj_rel./testcases(i).result_proj_rel), sprintf('%s:projdistrel:rel', id), ...
%            sprintf('Incorrection relative projection (input %s, %s, %s; output: proj+dist_rel)', ...
%                testcases(i).id_dim, testcases(i).id_point, testcases(i).id_end));
%        
%        fprintf(' -- OK\n')
%    end
%end
