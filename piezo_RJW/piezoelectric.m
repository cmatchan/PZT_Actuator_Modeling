function		[Np,Mp] = piezoelectric(V,Qp,zn,d31,npiezolayers)

% function		[Np,Mp] = piezoelectric(V,Qp,zn,d31,npiezolayers)
%		extracts the thermal forces and moments (per unit
%		width) as a function of the voltage (V), the 3 X 3 
%       matrix Qp containing the physical properties 
% 		of the elastic layer, the thicknesses, z, of the n layers, 
% 		and the coeffiecients of piezoelectric expansion, a 3 X 1
% 		matrix d31.
% if ~isglobal('piezoconfig'),
%     % make sure thet 'piezoconfig' is global 
     global piezoconfig
% end

if ~exist('piezoconfig'),
    % the global variable 'piezoconfig'
    % has not been initialized, thus assume a unimorph
    piezoconfig = 0;
end

% if there is more than one piezo layer, then the midplane 
% cuts through the piezo layer and part of it is above and 
% part below the midplane.
Np = [0;0;0];
Mp = [0;0;0];

len = size(zn,1);
Np = Qp*[d31;d31;0]*V;

% if the actuator is a bimorph, then the top and bottom
% layers are piezoelectric...
if piezoconfig,
    Mp = Qp*[d31;d31;0]*V*(abs(zn(len,2)/zn(len,1)))/2;
else
    for n = 1:npiezolayers,
        Mp = Mp + Qp*[d31;d31;0]*V*(zn(len-n+1,2)/zn(len-n+1,1))/2;
    end
end

zn
Qp
abs(zn(len,2)/zn(len,1))
Np
Mp