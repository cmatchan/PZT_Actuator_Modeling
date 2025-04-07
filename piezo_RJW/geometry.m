% this file contains the actuator geometry for MFI actuators

% Actuator geometry
if piezoconfig,
    wnom = 1.125; %85e-3;                % actuator width
    wr = 1.5; %1;                   % width ratio
    l = 9e-3; %12e-3;                   % actuator length
    lr = 0.33; %0.667;                     % extension ratio
    thickess.elastic =  40e-6;   % passive layer thickness
else    
    wnom = 1.75e-3;             % actuator width
    wr = 1.5;                   % width ratio
    l = 5e-3;                   % actuator length
    lr = 0.625;                 % extension ratio
    thickess.elastic = 100e-6;  % passive layer thickness
end     

%thickness.elastic = 100e-6;

w = [wnom;wr];
lentotal = [l;lr];