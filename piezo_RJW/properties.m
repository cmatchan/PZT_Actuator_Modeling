% this file contains the properties for all materials used in MFI actuators

% PZT properties
    thickness.PZT = 127e-6;  % quoted piezo thickness
    Epzt = 62e9;  % quoted piezo modulus
    apzt = 3e-6;  % CTE of PZT
    vpzt = 0.31;  % poison's ratio
    d31pzt = -320e-12*(1+vpzt);  % piezoelectric constant
    % d31 is multiplied by 1+vp because the width is much 
    % greater than the thickness, this is the plane strain
    % case (ey = 0) as described by weinberg
    G12pzt = Epzt/(2*(1+vpzt));  % shear modulus
    density.PZT = 7.8e3;
    % modified constants for piezoelectric material
    % noting that although the the plane strain state is
    % occuring on a ply by ply basis while not neccessarily on the
    % whole
    if wnom > thickness.PZT*5*(1+piezoconfig),
        ppzt = 1/(1-vpzt^2);
    else
        ppzt = 1;
    end
    Q11pzt = ppzt*Epzt;
    Q22pzt = ppzt*Epzt;
    Q12pzt = ppzt*vpzt*Epzt;
    Q66pzt = G12pzt; 
    emaxpzt = 0.01;
    a.PZT = [apzt;apzt;0];
    cvPZT = 420;
    kappaPZT = 1.8;

% PZNPT properties
    thickness.PZNPT = 100e-6;  % quoted piezo thickness
    Epznpt = 15e9;  % quoted piezo modulus
    apznpt = 4e-6;  % CTE of PZT
    vpznpt = 0.26;  % poison's ratio
    d31pznpt = -950e-12*(1+vpznpt);  % piezoelectric constant
    % d31 is multiplied by 1+vp because the width is much 
    % greater than the thickness, this is the plane strain
    % case (ey = 0) as described by weinberg
    G12pznpt = Epznpt/(2*(1+vpznpt));  % shear modulus
    density.PZNPT = 8e3;
    % modified constants for piezoelectric
    ppznpt = 1/(1-vpznpt^2);
    Q11pznpt = ppznpt*Epznpt;
    Q22pznpt = ppznpt*Epznpt;
    Q12pznpt = ppznpt*vpznpt*Epznpt;
    Q66pznpt = G12pznpt; 
    emaxpznpt = 0.01;
    a.PZNPT = [apznpt;apznpt;0];
    
% Steel properties
    Est = 190e9;  % steel modulus
    ast = 15e-6;  % CTE of steel
    vst = 0.30;  % poison's ratio
    G12st = Est/(2*(1+vst));  % shear modulus
    density.steel = 8e3;
    % modified constants for steel
    pst = 1/(1-vst^2);
    Q11st = pst*Est;
    Q22st = pst*Est;
    Q12st = pst*vst*Est;
    Q66st = G12st;
    a.steel = [ast;ast;0];

% Silicon properties
    Esi = 185e9;  % silicon modulus
    asi = 2.6e-6;  % CTE of silicon
    vsi = 0.25;  % poison's ratio
    G12si = Esi/(2*(1+vsi));  % shear modulus
    density.silicon = 2.33e3;
    % modified constants for silicon
    psi = 1/(1-vsi^2);
    Q11si = psi*Esi;
    Q22si = psi*Esi;
    Q12si = psi*vsi*Esi;
    Q66si = G12si;
    a.silicon = [asi;asi;0];
    
% Composite proprties
    % S-glass
    Es1 = 55e9;  % quoted s-glass modulus
    Es2 = 14e9;
    vs = 0.33;
    as1 = 6.5e-6;  % CTE of s-glass
    as2 = 32e-6;
    density.SGlass = 1.78e3;
    G12s = 5e9;
    % modified constants for S-glass
    ps = 1/(1-vs^2*(Es2/Es1));
    Q11s = ps*Es1;
    Q22s = ps*Es2;
    Q12s = ps*vs*Es2;
    Q66s = G12s;
    a.SGlass = [as1;as2;0];
    emaxs = .065;
    
    % UHM
    EUHM1 = 260e9;  % UHM modulus
    EUHM2 = 7e9;
    vUHM = 0.33;
    aUHM1 = -0.54e-6;  % CTE of UHM
    aUHM2 = 32e-6;
    density.UHM = 1.5e3;
    G12UHM = 5e9;
    % modified constants for UHM
    pUHM = 1/(1-vUHM^2*(EUHM2/EUHM1));
    Q11UHM = pUHM*EUHM1;
    Q22UHM = pUHM*EUHM2;
    Q12UHM = pUHM*vUHM*EUHM2;
    Q66UHM = G12UHM;
    a.UHM = [aUHM1;aUHM2;0];
    emaxUHM = .0053;
    cvUHM = 712;
    kappaUHM = 50;
    
    
    
Qpzt = [Q11pzt Q12pzt 0;Q12pzt Q22pzt 0;0 0 Q66pzt];
Qpznpt = [Q11pznpt Q12pznpt 0;Q12pznpt Q22pznpt 0;0 0 Q66pznpt];
Qs = [Q11s Q12s 0;Q12s Q22s 0;0 0 Q66s];
QUHM = [Q11UHM Q12UHM 0;Q12UHM Q22UHM 0;0 0 Q66UHM];
Qst = [Q11st Q12st 0;Q12st Q22st 0;0 0 Q66st];
Qsi = [Q11si Q12si 0;Q12si Q22si 0;0 0 Q66si];