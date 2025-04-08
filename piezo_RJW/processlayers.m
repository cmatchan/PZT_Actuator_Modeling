function    [newz,layup] = processlayers(plyt,oldlayup)

%   [newz,layup] = processlayers(plyt,oldlayup)
%
%       Processes the layup to acount for which layer the neutral axis
%       cuts through and adjusts the z-heights relative to the zeutral axis.
%
%           inputs:
%       plyt        -   (n X 1) vector of layer thicknesses
%       oldlayup    -   elastic layer layup
%
%           outputs:
%       newz        -   modified z-heights with respect to the neutral axis
%       layup       -   modified layup
%

% for calculations, get midplane level
zmid = sum(plyt)/2;

% get the heights of each layer
for i = 1:length(plyt),
    plyh(i) = sum(plyt(1:i));
end

zmid
plyh

% decide which layer the midplane cuts through
midlayer = min(find(plyh>zmid))
if midlayer==1,
    newplyt = [zmid;plyh(1)-zmid;plyt(2:length(plyt))];
else
    newplyt = [plyt(1:midlayer-1);zmid-plyh(midlayer-1);...
            plyh(midlayer)-zmid;plyt(midlayer+1:length(plyt))];
end

% now get z where z(i) is the directed position of the top surface of 
% layer i with respect to the midlayer
for i = 1:midlayer,
    newz(i) = -sum(newplyt(i:midlayer));
end
for i = midlayer+1:length(newplyt),
    newz(i) = sum(newplyt(midlayer+1:i));
end

% plyt
% zmid
% plyh
% newplyt
% newz
newz = newz';

% now adjust the layup appropriately
% if the neutral axis cuts through the last layer (piezo)
if midlayer==length(plyh),
   % keep the layup the same
   layup = oldlayup;   
% if the neutral axis does not cut through the last layer...
else
   % neutral axis cuts through the elastic layer
   layup = [0;0];%[oldlayup(1)*[1:midlayer];oldlayup(midlayer);oldlayup(midlayer+1:length(oldlayup))];
end

layup