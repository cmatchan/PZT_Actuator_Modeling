function		[Nt,Mt] = thermal(dT,Qp,Qe,zn,layup,ap,ae)

% function		[Nt,Mt] = thermal(dT,Qp,Qe,z,layup,ap,ae)
%		extracts the thermal forces and moments (per unit
%		width) as a function of the temperature change (dT),
%		the 4 X 1 matrix Q containing the physical properties 
% 		of the elastic layer, the thicknesses, t, of the n layers, 
% 		and the coeffiecients of thermal expansion, a 3 X 1
% 		matrix a.
if ~isglobal('piezoconfig'),
    % make sure thet 'piezoconfig' is global 
    global piezoconfig
end

if ~exist('piezoconfig'),
    % the global variable 'piezoconfig'
    % has not been initialized, thus assume a unimorph
    piezoconfig = 0;
end

Nt = zeros(3,1);
Mt = zeros(3,1);

nelasticlayers = length(layup);
npiezolayers = size(zn,1) - nelasticlayers;

% if the actuator is a bimorph...
if piezoconfig,
    % include piezo layers first...
    Nt = Qp*(zn(1,1)+zn(size(zn,1),1))*ap*dT;
	Mt = Qp*(zn(1,2)+zn(size(zn,1),2))*ap*dT/2;
else
    % the actuator is a unimorph add each piezoelectric
    % layers first...
    for n = nelasticlayers+1:nelasticlayers+npiezolayers,
        Nt = Nt + Qp*zn(n,1)*ap*dT;
        Mt = Mt + Qp*zn(n,2)*ap*dT/2;
    end
end

% ... then all other layers
for m = 1:nelasticlayers,
    angle = layup(m)*pi/180;  % ply angle
    Qbarelastic = trotate(Qe,angle);
    Nt = Nt + Qbarelastic*zn(m+piezoconfig,1)*arotate(ae,angle)*dT;
    Mt = Mt + Qbarelastic*zn(m+piezoconfig,2)*arotate(ae,angle)*dT/2;
end