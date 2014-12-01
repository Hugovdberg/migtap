function test_result = test_project_point_on_line()
    test_result = false;
    
    %% One dimensional testing
    single_point_1d = 0.5;
    multi_point_1d = [0.5; 2];
    line_1d = [0; 1];
    try
        project_point_on_line();
    catch
        
    end
    err = lasterror;
    assert(strcmp(err.identifier, 'migtap:ppol:numArgs'), ...
        'migtap:test:ppol:numArgs',
        'Accepted incorrect number of input arguments')
    
    single_point_2d = [0, 1];
    multi_point_2d = [0, 1; 1.5, 2];
    line_2d = [0, 0; 1, 1];
    
    single_point_3d = [0, 1, 2];
    multi_point_3d = [];
    line_3d = [0, 0, 0; 1, 1, 1];
    
    test_result = true;
end
