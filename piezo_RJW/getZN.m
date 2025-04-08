function    [zn] = getZN(z)

%   [zn1] = getZN(z)
%
%       Returns the individual ply thicknesses for all
%       lamina within a laminate
%
%           inputs:
%       z           -   n X 1 vector of directed ply coordinates
%
%           outputs:
%       zn1         -   z(n) - z(n-1)
%       zn2         -   z(n)^2 - z(n-1)^2
%       zn3         -   z(n)^3 - z(n-1)^3
%

ztemp = [z(find(z<0));0;z(find(z>0))];
for i = 1:length(z),
    zn1(i) = ztemp(i+1)-ztemp(i);
    zn2(i) = ztemp(i+1)^2-ztemp(i)^2;
    zn3(i) = ztemp(i+1)^3-ztemp(i)^3;
end

z
ztemp
zn1
zn2
zn3
zn = [zn1' zn2' zn3']