function [delta,Fb,k] = energy(width,len,thickness,Qp,Qe,V,d31,layup,G)

%   [delta,Fb,k] = energy(width,len,thickness,Qp,Ep,Qe,V,d31,layup,piezoconfig,G)
%
%       For given elastic layer geometries and properties this function
%       calculates the displacement, blocked force, and stiffness for either
%       unimorph or bimorph cantilever actuators with arbitrary elastic layer layups.
%
%           inputs:
%       width       -   (2 X 1) vector of the actuator nominal width
%                       and width ratio
%       len         -   (2 X 1) vector of the actuator length and the
%                       length ratio
%       thickness   -   (2 X 1) vector of piezo thickness and elastic layer
%                       thickness
%       Qp          -   (3 X 3) vector of piezo material elastic constants
%       Qe          -   (3 X 3) vector of elastic layer material elastic constants
%       V           -   drive voltage
%       d31         -   transverse piezoelectric constant
%       layup       -   (n X 1) elastic layer layup angles (in degrees)
%
%           outputs:
%       delta       -   free displacement
%       Fb          -   blocked force
%       k           -   stiffness
% if ~isglobal('piezoconfig'),
%     % make sure thet 'piezoconfig' is global 
    global piezoconfig
% end

if ~exist('piezoconfig'),
    % the global variable 'piezoconfig'
    % has not been initialized, thus assume a unimorph
    disp('piezoconfig variable does not exist, assuming unimorph configuration');
    piezoconfig = 0;
end

% for now, just give ply thicknesses and calculate the
% sitfnesses , etc...or make this a function
% and call it from a loop to return the stifnesses as a 
% function of single ply thickness
tp = thickness(1);
te = thickness(2);

wnom = width(1);
wr = width(2);
l = len(1);
lr = len(2);

% if a bimorph...
if piezoconfig,
    plyt = [tp;te*ones(size(layup));tp];
else % else, if a unimorph...
    plyt = [te*ones(size(layup));tp];
end

[newz,layup] = processlayers(plyt,layup);

% now get z(n)-z(n-1)...
[zn] = getZN(newz);

% now get A,B,C,D for the sglass and the UHM actuator:
[A,B,D] = getABD(layup,Qe,Qp,zn);

% get piezoelectric forces and moments:
npiezolayers = length(newz) - length(layup) - piezoconfig;
[Np,Mp] = piezoelectric(V,Qp,zn,d31,npiezolayers);

% now get mid plane strains and curvature
stiffness = [A B;B D];
C = inv(stiffness);
P = ( C(4,1)*Np(1) + C(4,2)*Np(2) + C(4,4)*Mp(1) + C(4,5)*Mp(2) );

% extract actuator displacement from radius of curvature
delta = -(P*l^2/2) * G(1) * (1+piezoconfig);

% get the blocked force 
Fb = -(3*P*wnom)/(2*l*C(4,4)) * G(2) *(1+piezoconfig);

k = abs(Fb/delta);