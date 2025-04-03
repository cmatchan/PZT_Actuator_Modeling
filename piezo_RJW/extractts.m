% pzt calculations
% for unidirectional s-glass fibers, 
% and for UHM carbon fiber elastic layers
close all;
clear;

% Actuator geometry
    l = 7.5e-3;   % actuator length
    w = 2.5e-3;  % actuator width
    lext = 3.5e-3;  % extension length

% PZT properties
    tp = 100e-6;  % quoted piezo thickness
    Ep = 50e9;  % quoted piezo modulus
    ap = 4e-6;  % CTE of PZT
    vp = 0.30;  % poison's ratio
    d31 = -320e-12*(1+vp);  % piezoelectric constant
    G12p = Ep/(2*(1+vp));  % shear modulus
    densityp = 8e3;
    %modified constants for piezoelectric
    pp = 1/(1-vp^2);
    Q11p = pp*Ep;
    Q22p = pp*Ep;
    Q12p = pp*vp*Ep;
    Q66p = G12p;
    
% Elastic layer proprties
    % S-glass
    Es1 = 55e9;  % quoted s-glass modulus
    Es2 = 14e9;
    vs = 0.33;
    as1 = 6.5e-6;  % CTE of s-glass
    as2 = 32e-6;
    densitys = 1.8e3;
    G12s = 5e9;
    t_sglass = 40e-6;
    % modified constants for S-glass
    ps = 1/(1-vs^2*(Es2/Es1));
    Q11s = ps*Es1;
    Q22s = ps*Es2;
    Q12s = ps*vs*Es2;
    Q66s = G12s;
    as = [as1;as2;0];
    
    % UHM
    EUHM1 = 300e9;  % UHM modulus
    EUHM2 = 10e9;
    vUHM = 0.33;
    aUHM1 = -.54e-6;  % CTE of UHM
    aUHM2 = 32e-6;
    densityUHM = 1.66e3;
    G12UHM = 5e9;
    t_UHM = 40e-6;
    % modified constants for UHM
    pUHM = 1/(1-vUHM^2*(EUHM2/EUHM1));
    Q11UHM = pUHM*EUHM1;
    Q22UHM = pUHM*EUHM2;
    Q12UHM = pUHM*vUHM*EUHM2;
    Q66UHM = G12UHM;
    aUHM = [aUHM1;aUHM2;0];
    
Qp = [Q11p;Q22p;Q12p;Q66p];
Qs = [Q11s;Q22s;Q12s;Q66s];
Ss = [1/Es1;1/Es2;-vs/Es1;1/G12s];
QUHM = [Q11UHM;Q22UHM;Q12UHM;Q66UHM];
SUHM = [1/EUHM1;1/EUHM2;-vUHM/EUHM1;1/G12UHM];
    
% layup description...
% layup is [PIEZO / layup] where 'layup' is 
% a vector of the ply7 angles in the elastic 
% layer, for example layup = [0;0;90]
layup_sglass = [0;0;0;0];
layup_UHM = [0];

% for now, just give ply thicknesses and calculate the
% sitfnesses , etc...or make this a function
% and call it from a loop to return the stifnesses as a 
% function of single ply thickness
plyt_sglass = [tp;t_sglass*ones(size(layup_sglass))];
plyt_UHM = [tp;t_UHM*ones(size(layup_UHM))];

% for calculations, get z-neutral axis
zneutral_s = getNA(Ep,Ss,layup_sglass,plyt_sglass);
zneutral_UHM = getNA(Ep,SUHM,layup_UHM,plyt_UHM);

% for calculations, get midplane level
zmid_s = sum(plyt_sglass)/2;
zmid_UHM = sum(plyt_UHM)/2;

[newzs,layup_sglass] = processlayers(plyt_sglass,layup_sglass,zmid_s);
[newzUHM,layup_UHM] = processlayers(plyt_UHM,layup_UHM,zmid_UHM);

% now get z(n)-z(n-1)...
[zns] = getZN(newzs);
[znUHM] = getZN(newzUHM);

% now get A,B,C,D for the sglass and the UHM actuator
[As,Bs,Ds,Exs] = getABD(layup_sglass,Qs,Qp,zns);
[AUHM,BUHM,DUHM,ExUHM] = getABD(layup_UHM,QUHM,Qp,znUHM);

% now calculate stiffness (without extension)
k_s = 3*Ds(1,1)*w/(l^3);
k_UHM = 3*DUHM(1,1)*w/(l^3);

% now include the extension (assume extension is rigid)
ktot_s = Ds(1,1)*w/(l*(l^2/3 + l*lext/2 + l*lext/2 + lext^2))
ktot_UHM = DUHM(1,1)*w/(l*(l^2/3 + l*lext/2 + l*lext/2 + lext^2))

% THIS ALL WORKS TO THIS POINT!!!

% calculate thermal expansion
% first get thermal forces/moments

roomtemp = 21;
curetemp = 210;
[Nts,Mts] = thermal(curetemp-roomtemp,Qp,Qs,newzs,layup_sglass,[ap;ap;0],as);
[NtUHM,MtUHM] = thermal(curetemp-roomtemp,Qp,QUHM,newzUHM,layup_UHM,[ap;ap;0],aUHM);

% get piezoelectric forces/moments
V = 250;
[Nps,Mps] = piezoelectric(V,Qp,newzs,d31);
[NpUHM,MpUHM] = piezoelectric(V,Qp,newzUHM,d31);

% now get mid plane strains and curvature
Cs = [As Bs;Bs Ds];
CUHM = [AUHM BUHM;BUHM DUHM];

NMs = [Nts+Nps;Mts+Mps];
NMUHM = [NtUHM+NpUHM;MtUHM+MpUHM];

%NMs = [.02;.02;0;1e-3;1e-3;0]; 
%NMUHM = [.02;.02;0;1e-3;1e-3;0]; 
es = inv(Cs)*NMs;
eUHM = inv(CUHM)*NMUHM;

% extract actuator displacement from radius of curvature
delta_s = (1/es(4))*(1-cos(l*es(4)));
delta_UHM = (1/eUHM(4))*(1-cos(l*eUHM(4)));

% now derive tip displacement
delta_s_tip = delta_s + es(4)*l*lext
delta_UHM_tip = delta_UHM + eUHM(4)*l*lext

% get the blocked force
tstemp = t_sglass*length(layup_sglass);
tUHMtemp = t_UHM*length(layup_UHM);
Fbs = abs((3/4)*w*Ep*tp/(l+lext)*((Exs/Ep)*(tstemp/tp)*((tstemp/tp)+1)) / ...
    ((Exs/Ep)*(tstemp/tp)+1)*d31*V)
FbUHM = abs((3/4)*w*Ep*tp/(l+lext)*((ExUHM/Ep)*(tUHMtemp/tp)*((tUHMtemp/tp)+1)) / ...
    ((ExUHM/Ep)*(tUHMtemp/tp)+1)*d31*V)

energys = abs(Fbs*delta_s_tip/2)
energyUHM = abs(FbUHM*delta_UHM_tip/2)

clear Ep Es1 Es2 EUHM1 EUHM2 G12p G12s Q11UHM Q11p Q11s Q12UHM Q22p Q22s
clear Q12p Q12s Q22UHM G12UHM Q66p Q66s Q66UHM
clear as1 as2 aUHM1 aUHM2 ap
clear densityp densityUHM densitys
clear pp pUHM ps l w lext
clear vp vUHM vs V tstemp tUHMtemp