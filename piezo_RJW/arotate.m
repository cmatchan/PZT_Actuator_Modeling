function    [abar] = arotate(a,angle)

% function [abar] = trotate(a,angle)
%   takes the 3X1 ply constant matrix aold and 
%   rotates it by angle (rad)

T = [cos(angle)^2 sin(angle)^2 2*sin(angle)*cos(angle); ...
        sin(angle)^2 cos(angle)^2 -2*sin(angle)*cos(angle); ...
        -sin(angle)*cos(angle) sin(angle)*cos(angle) (cos(angle)^2-sin(angle)^2)];
R = [1 0 0;0 1 0;0 0 2];

abar = inv(T)*R*a;
        