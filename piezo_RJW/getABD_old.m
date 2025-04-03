function    [A, B, D, Ex] = getlayup(layup,Qelastic,Qpiezo,zn,piezoconfig)

%   [A, B, D, Ex] = getlayup(layup,Qelastic,Qpiezo)
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
%       Ex          -   effective x-direction elastic layer modulus
%

len = length(layup);
difference = size(zn,1)-len;

A = zeros(3,3);
B = zeros(3,3);
D = zeros(3,3);

tempA = zeros(3,3);
Qp = [Qpiezo(1) Qpiezo(3) 0;Qpiezo(3) Qpiezo(2) 0;0 0 Qpiezo(4)];
Qelastic = [Qelastic(1) Qelastic(3) 0;Qelastic(3) Qelastic(2) 0;0 0 Qelastic(4)];
% if the actuator is a unimorph...
if piezoconfig,
    % include piezo layer first...
    for i = 1:difference,
        A = A + Qp*zn(i,1);
	    B = B + Qp*zn(i,2);
	    D = D + Qp*zn(i,3);
    end
else
    % for a bimorph...
    A = Qp*zn(1,1);
    B = Qp*zn(1,2);
	D = Qp*zn(1,3);
    difference = 1;
end
   


% ... then all other layers
for m = 1:len,
    angle = layup(m)*pi/180;  % ply angle
    % now get Qbar for this layer
    Q11bar = Qelastic(1)*(cos(angle))^4 + ...
        Qelastic(2)*(sin(angle))^4 + ...
        (2*Qelastic(3) + 4*Qelastic(4))*(sin(angle))^2*(cos(angle))^2;
    Q22bar = Qelastic(1)*(sin(angle))^4 + ...
        Qelastic(2)*(cos(angle))^4 + ...
        (2*Qelastic(3) + 4*Qelastic(4))*(sin(angle))^2*(cos(angle))^2;
    Q12bar = Qelastic(1)*(sin(angle))^2*(cos(angle))^2 + ...
        Qelastic(2)*(sin(angle))^2*(cos(angle))^2 + ...
        Qelastic(3)*((cos(angle))^4 + (sin(angle))^4) - ...
        4*Qelastic(4)*((sin(angle))^2*(cos(angle))^2);
    Q66bar = (Qelastic(1) + Qelastic(2) - 2*Qelastic(3))*(sin(angle))^2*(cos(angle))^2 + ...
        Qelastic(4)*((cos(angle))^2 - (sin(angle))^2)^2;
    Q16bar = Qelastic(1)*cos(angle)^3*sin(angle) - ...
	 	Qelastic(2)*cos(angle)*sin(angle)^3 - ...
		(Qelastic(3)+2*Qelastic(4))*(cos(angle)^3*sin(angle) - ...
		cos(angle)*sin(angle)^3);
	Q26bar = Qelastic(1)*sin(angle)^3*cos(angle) - ...
		Qelastic(2)*sin(angle)*cos(angle)^3 + ...
		(Qelastic(3)+2*Qelastic(4))*(cos(angle)^3*sin(angle) - ...
		cos(angle)*sin(angle)^3);

    Qbar = [Q11bar Q12bar Q16bar; Q12bar Q22bar Q26bar; Q16bar Q26bar Q66bar];
    
    A = A + Qbar*zn(m+difference,1);
    B = B + Qbar*zn(m+difference,2);
    D = D + Qbar*zn(m+difference,3);
    
    tempA = tempA + Qbar*zn(m+difference,1);
end

% if this is a bimorph, then add the bottom piezo layer...
if ~piezoconfig,
    tempA = tempA + Qp*zn(size(zn,1),1);
    A = A + Qp*zn(size(zn,1),1);
    B = B + Qp*zn(size(zn,1),2);
    D = D + Qp*zn(size(zn,1),3);
end

B = B/2;
D = D/3;

tempt = sum(abs(zn(difference + 1:size(zn,1),1)));

delta = tempA(1,1)*tempA(2,2) - tempA(1,2)^2;
Ex = delta/tempA(2,2)/tempt;