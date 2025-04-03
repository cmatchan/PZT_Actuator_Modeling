function    [z, zbar] = laminaz(laminanum,cthickness,pthickness)

%   [z, zbar] = laminaz(laminanum,thickness,symetric)
%
%       Returns the heights for all lamina within a
%       laminate, as well as the mid planes of all
%       laminates, regardless of symetry conditions.
%
%           inputs:
%       laminanum   -   number of plys in the laminate
%       cthickness  -   individul ply thickness
%       pthickness  -   piezo thickness
%
%           outputs:
%       z           -   ply heights
%       zbar        -   mid plane height of plys
%

z(1) = pthickness;
zbar(1) = pthickness/2;

for n = 2:laminanum+1,
    z(n) = z(n-1) + cthickness;
    zbar(n) = z(n) - cthickness/2;
end