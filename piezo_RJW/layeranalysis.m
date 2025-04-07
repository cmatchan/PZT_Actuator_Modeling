% piezo strain calculations
% for unidirectional s-glass fibers, 
% and for UHM carbon fiber elastic layers
% close all;
% clear;
% clc;

% Actuator geometry
geometry;

% material properties
properties;
piezotype = 'PZT';
if piezotype == 'PZT',
    Qp = Qpzt;
    tp = tpzt;
    densityp = densitypzt;
    Ep = Epzt;
    ap = apzt;
    d31 = d31pzt;
else,
    piezotype =='PZNPT';
    Qp = Qpznpt;
    tp = tpznpt
    densityp = densitypznpt;
    Ep = Epznpt;
    ap = apznpt;
    d31 = d31pznpt;
end

roomtemp = 20;
curetemp = 160;
V = 250;

% get the various mechanical energies for each layup
%for [piezo/90/0/90] layup
layup = [90;90;90];
piezomass = l*w*tp*densityp;
[delta909,Fb909,k909] = energy(w,lentotal,tp,t_UHM,Qp,Ep,QUHM,V,d31,layup);
mass909 = (l+lext)*w*t_UHM*densityUHM + piezomass;

%for [piezo/90/0] layup
layup = [90;0];
piezomass = l*w*tp*densityp;
[delta90,Fb90,k90] = energy(w,lentotal,tp,t_UHM,Qp,Ep,QUHM,V,d31,layup);
mass90 = (l+lext)*w*t_UHM*densityUHM + piezomass;

%for [piezo/0] layup
layup = [0];
piezomass = l*w*tp*densityp;
[delta0,Fb0,k0] = energy(w,lentotal,tp,t_UHM,Qp,Ep,QUHM,V,d31,layup);
mass0 = (l+lext)*w*t_UHM*densityUHM + piezomass;

% strain as a function of applied voltage
for n = 1:500,
    V = n;
    layup = [90;0;90];
    [stress909,strain909] = strain(tp,t_UHM,Qp,Ep,QUHM,V,d31,roomtemp-curetemp,ap,aUHM,layup);
    strain909e(n) = strain909(1,size(strain909,2));
    strain909p1(n) = strain909(1,1);
    strain909p2(n) = strain909(2,1);

    layup = [90;0];
    [stress90,strain90] = strain(tp,t_UHM,Qp,Ep,QUHM,V,d31,roomtemp-curetemp,ap,aUHM,layup);
    strain90e(n) = strain90(1,size(strain90,2));
    strain90p1(n) = strain90(1,1);
    strain90p2(n) = strain90(2,1);

    layup = [0];
    [stress0,strain0] = strain(tp,t_UHM,Qp,Ep,QUHM,V,d31,roomtemp-curetemp,ap,aUHM,layup);
    strain0e(n) = strain0(1,size(strain0,2));
    strain0p1(n) = strain0(1,1);
    strain0p2(n) = strain0(2,1);
end

% plot results
V = [1:500];
figure(1);
set(axes,'Fontsize',12);
plot(V,strain909e*100,'b-.',V,strain90e*100,'b-',V,strain0e*100,'b:',...
    V,strain909p1*100,'g-.',V,strain90p1*100,'g-',V,strain0p1*100,'g:',...
    V,strain909p2*100,'r-.',V,strain90p2*100,'r-',V,strain0p2*100,'r:', 'LineWidth',2);
title(strcat(piezotype,sprintf(', l = %g, w = %g, l_e_x_t = %g (mm), t_e = %g ',...
    l*1e3,w*1e3,lext*1e3,t_UHM*1e6),'(\mum)',', \Delta',sprintf('T = %g',(roomtemp-curetemp)),'\circC'),'Fontsize',18);
grid on;
ylabel('% Strain','Fontsize',18);
xlabel('Applied Voltage (V)','Fontsize',18);
legend('\epsilon_e[90/0/90]','\epsilon_e[90/0]','\epsilon_e[0]',...
    '\epsilon_p_,_1[90/0/90]','\epsilon_p_,_1[90/0]','\epsilon_p_,_1[0]',...
    '\epsilon_p_,_2[90/0/90]','\epsilon_p_,_2[90/0]','\epsilon_p_,_2[0]');
%print
name = strcat(piezotype,'voltage.eps');
%print(1, '-deps', name);

clear Ep Es1 Es2 EUHM1 EUHM2 G12p G12s Q11UHM Q11p Q11s Q12UHM Q22p Q22s
clear Q12p Q12s Q22UHM G12UHM Q66p Q66s Q66UHM
clear as1 as2 aUHM1 aUHM2 ap
clear densityp densityUHM densitys
clear pp pUHM ps l w lext piezomass d31 i
clear vp vUHM vs V tp t_UHM t_sglass name
%clear stress0 strain0 stress90 strain90 stress909 strain909 roomtemp curetemp
clear mass0 mass90 mass909 layup emaxp emaxUHM aUHM SUHM Qp QUHM piezotype