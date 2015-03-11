function [ phi, lambda ] = rd2wgs(x, y)
%RD2WGS Transform Dutch Rijksdriehoeks coordinates to WGS84
%   Usage:
%       [phi, lambda] = rd2wgs(x, y) returns the northing and easting as
%       phi and lambda
%
%   Based on Schreutelkamp, F.H., G.L. Strang van Hees, 
%   "Benaderingsformules voor de transformatie tussen RD- en
%   WGS84-kaartcoördinaten".
%
%   Copyright ©Hugo van den Berg, 2014
    if ~all(size(x) == size(y))
        MException('migtap:rd2wgs:InputSizeIncompatible', ...
            'Input sizes must be the same');
    end
    
    x0 = 155000.00;
    y0 = 463000.00;
    phi0 = 52.15517440;
    lambda0 = 5.38720621;
    
    dx0 = (x(:)-x0)*1e-5;
    dy0 = (y(:)-y0)*1e-5;
    
    p = [1 1 1 3 1 3 0 3 1 0 2 5];
    q = [0 1 2 0 3 1 1 2 4 2 0 0];
    L = [5260.52916 105.94684 2.45656 -.81885 .05594 -.05607 .01199 -.00256 .00128 .0002 -.0002 .00026];
    
    [dX, p] = meshgrid(dx0, p);
    [dY, q] = meshgrid(dy0, q);
    [~, L] = meshgrid(dx0, L);
    
    lambda = reshape(lambda0+sum(L.*dX.^p.*dY.^q)/3600, size(x));
    
    p = [0 2 0 2 0 2 1 4 2 4 1];
    q = [1 0 2 1 3 2 0 0 3 1 1];
    K = [3235.65389 -32.58297 -.24750 -.84978 -.06550 -.01709 -.00738 .00530 -.00039 .00033 -.00012];
    
    [dY, p] = meshgrid(dy0, p);
    [dX, q] = meshgrid(dx0, q);
    [~, K] = meshgrid(dy0, K);
    
    phi = reshape(phi0+sum(K.*dX.^p.*dY.^q)/3600, size(y));
end

