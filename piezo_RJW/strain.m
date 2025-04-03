function [stra, x] = strain(width,len,thickness,Qp,Qe,V,d31,layup,dT,ap,ae,F)

%   [stra] = strain(width,len,thickness,Qp,Qe,V,d31,layup,piezoconfig,dT,ap,ae,F)
%
%       For given elastic layer geometries and properties this function
%       calculates the strain for either unimorph or bimorph cantilever 
%       actuators with arbitrary elastic layer layups.
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
%       dT          -   change in temperature (degrees C)
%       ap          -   (3 X 1) vector of thermal expansion coefficients
%                       for the piezoelectric layer
%       ae          -   (3 X 1) vector of thermal expansion coefficients
%                       for the elastic layer
%       F           -   load (in N) applied to the distal end of the
%                       actuator
%
%           outputs:
%       stra        -   (2 X 1) strain vector containing
%                       [piezostrain,elasticstrain]
%       x           -   array of position elements along the actuator
%                       length
if ~isglobal('piezoconfig'),
    % make sure thet 'piezoconfig' is global 
    global piezoconfig
end

if ~exist('piezoconfig'),
    % the global variable 'piezoconfig'
    % has not been initialized, thus assume a unimorph
     piezoconfig = 0;
end

% define constants for convenience
tp = thickness(1);
te = thickness(2);
wnom = width(1);
wr = width(2);
l = len(1);
lr = len(2);
lext = l*lr;

% if a bimorph...
if piezoconfig,
    plyt = [tp;te*ones(size(layup));tp];
else % else, if a unimorph...
    plyt = [te*ones(size(layup));tp];
end

% adjust ply heights and layup to include midplane...
[newz,layup] = processlayers(plyt,layup);

% now get z(n)-z(n-1)...
[zn] = getZN(newz);

% now get A,B,C,D for the sglass and the UHM actuator:
[A,B,D] = getABD(layup,Qe,Qp,zn);
stiffness = [A B;B D];
C = inv(stiffness);

% get piezoelectric forces and moments:
npiezolayers = length(newz) - length(layup) - piezoconfig;
[Np,Mp] = piezoelectric(V,Qp,zn,d31,npiezolayers);
[Nt,Mt] = thermal(dT,Qp,Qe,zn,layup,ap,ae);

% get the moments due to an external load:
x = 0:l/10:l;
for i = 1:length(x),
    % now get Me for an external load
    wid(i) = wnom * ( 2*(1-wr)*x(i)/l + wr);
    Me = -F*(l*(1+lr)-x(i)) / wid(i);
    Me = [Me;0;0];
    % now get mid plane strains and curvature
    NM = -[Np + Nt; Me + Mp + Mt];
    e = C*NM;
    piezostrain = e(1) + newz(length(newz))*e(4);
    elasticstrain = e(1) + newz(1+piezoconfig)*e(4);
    stra(i,:) = [piezostrain,elasticstrain];
end