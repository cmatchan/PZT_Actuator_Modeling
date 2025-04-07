function    [A, B, D] = getlayup(layup,Qelastic,Qpiezo,zn)

%   [A, B, D, Ex] = getlayup(layup,Qelastic,Qpiezo,zn)
%
%       Returns the laminate matrices for a given layup with
%       plys oriented with the angles in the vector
%       laminate.
%
%           inputs:
%       layup       -   (n-m) X 1 vector of ply angles
%       Qelastic    -   elastic layer constants
%       Qpiezo      -   piezo layer constants
%       zn          -   n X 3 matrix of thickenesses
%       piezoconfig -   1 for unimorph, 0 for bimorph
%
%           outputs:
%       A,B,D       -   laminate matrices
%

% if ~isglobal('piezoconfig'),
%     % make sure thet 'piezoconfig' is global 
     global piezoconfig
% end

if ~exist('piezoconfig'),
    % the global variable 'piezoconfig'
    % has not been initialized, thus assume a unimorph
    piezoconfig = 0;
end

nelasticlayers = length(layup);
npiezolayers = size(zn,1) - nelasticlayers;

size(zn, 1)
% nelasticlayers
% npiezolayers

A = zeros(3,3);
B = zeros(3,3);
D = zeros(3,3);

% if the actuator is a bimorph...
if piezoconfig,
    % include piezo layers first...
    A = Qpiezo*(zn(1,1)+zn(size(zn,1),1));
	B = Qpiezo*(zn(1,2)+zn(size(zn,1),2));
    D = Qpiezo*(zn(1,3)+zn(size(zn,1),3));
else
    % the actautor is a unimorph add each piezoelectric
    % layers first...
    for n = nelasticlayers+1:nelasticlayers+npiezolayers,
        A = A + Qpiezo*zn(n,1);
        B = B + Qpiezo*zn(n,2);
        D = D + Qpiezo*zn(n,3);
    end
end

% A
% B
% D

% ... then all other layers
for m = 1:nelasticlayers,
    angle = layup(m)*pi/180;  % ply angle
    Qbarelastic = trotate(Qelastic,angle);
    A = A + Qbarelastic*zn(m+piezoconfig,1);
    B = B + Qbarelastic*zn(m+piezoconfig,2);
    D = D + Qbarelastic*zn(m+piezoconfig,3);
end

B = B/2;
D = D/3;

% A
% B
% D
% 
% A