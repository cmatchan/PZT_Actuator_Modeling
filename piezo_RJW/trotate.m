function    [Qbar] = trotate(Qold,angle)

% function [Qbar] = trotate(Qold,angle)
%   takes the 3X3 ply constant matrix Qold and 
%   rotates it by angle (rad)

T = [cos(angle)^2 sin(angle)^2 2*sin(angle)*cos(angle); ...
        sin(angle)^2 cos(angle)^2 -2*sin(angle)*cos(angle); ...
        -sin(angle)*cos(angle) sin(angle)*cos(angle) (cos(angle)^2-sin(angle)^2)];
R = [1 0 0;0 1 0;0 0 2];

Qbar = inv(T)*Qold*R*T*inv(R);       