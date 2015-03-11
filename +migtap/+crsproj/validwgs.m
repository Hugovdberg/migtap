function [tf, N, E] = validwgs(N, E)
%VALIDWGS Summary of this function goes here
%   Detailed explanation goes here
    if N >= -90 && N <= 90 && E >= -180 && E <= 180
        tf = true;
    else
        tf = false;
    end
    if nargout == 3
        N = rem(N, 90);
        E = rem(E, 180);
    end
end

