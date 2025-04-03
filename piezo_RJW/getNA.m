function    [zna] = getNA(Epiezo,Selastic,layup,thickness)

if length(thickness)~=(length(layup)+1),
    disp('Incorrect laminate size');
    return
end

for i = 1:length(thickness),
    z(i) = sum(thickness(i:length(thickness)))-thickness(i)/2;
end

% piezo first...
num = z(1)*Epiezo*thickness(1);
den = Epiezo*thickness(1);

% ...then the laminae
for i = 1:length(layup),
    angle = layup(i)*pi/180;
    S11bar = Selastic(1)*cos(angle)^4 + ...
        (2*Selastic(3) + Selastic(4))*sin(angle)^2*cos(angle)^2 + ...
        Selastic(2)*sin(angle)^4;
    
    num = num + z(i+1)*(1/S11bar)*thickness(i+1);
    den = den + (1/S11bar)*thickness(i+1);
end

zna = num/den;