function [X, Y] = wgs2rd(phi, lambda)
%WGS2RD converts WGS84 coordinates to Dutch Rijksdriehoek coordinates
%
%   Based on Schreutelkamp, F.H., G.L. Strang van Hees, 
%   "Benaderingsformules voor de transformatie tussen RD- en
%   WGS84-kaartcoördinaten".
%
%   Copyright ©Hugo van den Berg, 2014
    x0 = 155000.00;
    y0 = 463000.00;
    phi0 = 52.15517440;
    lambda0 = 5.38720621;
    
    dphi0 = 0.36*(phi(:)-phi0);
    dlambda0 = 0.36*(lambda(:)-lambda0);
    
    p = [0 1 2 0 1 3 1 0 2];
    q = [1 1 1 3 0 1 3 2 3];
    R = [190094.945 -11832.228 -114.221 -32.391 -.705 -2.340 -.608 -.008 .148];
    
    [dphi, p] = meshgrid(dphi0, p);
    [dlambda, q] = meshgrid(dlambda0, q);
    [~, R] = meshgrid(dphi0, R);
    
    X = x0+sum(R.*dphi.^p.*dlambda.^q);

    p = [1 0 2 1 3 0 2 1 0 1];
    q = [0 2 0 2 0 1 2 1 4 4];
    S = [309056.544 3638.893 73.077 -157.984 59.788 .433 -6.439 -.032 .092 -.054];
    
    [dphi, p] = meshgrid(dphi0, p);
    [dlambda, q] = meshgrid(dlambda0, q);
    [~, S] = meshgrid(dphi0, S);
    
    Y = y0+sum(S.*dphi.^p.*dlambda.^q);
end
