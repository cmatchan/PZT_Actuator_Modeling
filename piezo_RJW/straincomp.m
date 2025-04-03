% this file calculates the strain in the various layers of a 
% composite unimorph actuator for varying elastic layer thicknesses
% and varying materials

% Actuator geometry
geometry;
    
% material properties
properties;

% piezoeelectric material type
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
    Qp = Ppznpt;
    tp = tpznpt
    densityp = densitypznpt;
    Ep = Epznpt;
    ap = apznpt;
    d31 = d31pznpt;
end

% actuator elastic layer layup
layup = [0];

% drive parameters
roomtemp = 20;
curetemp = 120;
V = 250;

% analysis of s-glass, UHM, silicon, and steel 
t = 1e-6:2e-6:200e-6;
piezomass = l*w*tp*densityp;
for i = 1:length(t),
    %V = 0;
    %roomtemp = curetemp;
    [stress_UHM,strain_UHM] = strain(tp,t(i),Qp,Ep,QUHM,V,d31,roomtemp-curetemp,ap,aUHM,layup);
    strain_UHM_e(i) = strain_UHM(1,3);
    strain_UHM_p(i) = strain_UHM(1,1);
    [stress_s,strain_s] = strain(tp,t(i),Qp,Ep,Qs,V,d31,roomtemp-curetemp,ap,as,layup);
    strain_s_e(i) = strain_s(1,3);
    strain_s_p(i) = strain_s(1,1);
    [stress_st,strain_st] = strain(tp,t(i),Qp,Ep,Qst,V,d31,roomtemp-curetemp,ap,ast,layup);
    strain_st_e(i) = strain_st(1,3);
    strain_st_p(i) = strain_st(1,1);
    [stress_si,strain_si] = strain(tp,t(i),Qp,Ep,Qst,V,d31,roomtemp-curetemp,ap,asi,layup);
    strain_si_e(i) = strain_si(1,3);
    strain_si_p(i) = strain_si(1,1);
end

figure(1);
set(axes,'Fontsize',14);
subplot(2,1,1);
plot(t*1e6,strain_s_p*100,'k',t*1e6,strain_UHM_p*100,'r',t*1e6,strain_st_p*100,'g',t*1e6,strain_si_p*100,'b', 'LineWidth',3);
legend('Piezo (S2 glass)','Piezo (UHM M60J)','Piezo (Steel)','Piezo (Si)');
title(strcat(piezotype,sprintf(', l = %g, w = %g, l_e_x_t = %g (mm), V = %g',...
    l*1e3,w*1e3,lext*1e3,V),', \Delta',sprintf('T = %g',(roomtemp-curetemp))),'Fontsize',18);
ylabel('% Strain','Fontsize',20);
grid on;
subplot(2,1,2);
plot(t*1e6,strain_s_e*100,'k',t*1e6,strain_UHM_e*100,'r',t*1e6,strain_st_e*100,'g',t*1e6,strain_si_e*100,'b', 'LineWidth',3);%,...
xlabel('Elastic Layer Thickness (\mum)','Fontsize',20);
ylabel('% Strain','Fontsize',18);
legend('S2 glass','UHM M60J','Steel','Si');
grid on
%print
name = strcat(piezotype,'strain.jpg');
%print(1, '-djpeg', name);

bestindex = round(length(t)/2);

% strain as a function of applied voltage
for V = 1:500,
    [stress_UHM,strain_UHM] = strain(tp,t(bestindex),Qp,Ep,QUHM,V,d31,roomtemp-curetemp,ap,aUHM,layup);
    strain_UHM_e(V) = strain_UHM(1,3);
    strain_UHM_p(V) = strain_UHM(1,1);
    [stress_s,strain_s] = strain(tp,t(bestindex),Qp,Ep,Qs,V,d31,roomtemp-curetemp,ap,as,layup);
    strain_s_e(V) = strain_s(1,3);
    strain_s_p(V) = strain_s(1,1);
    [stress_st,strain_st] = strain(tp,t(bestindex),Qp,Ep,Qst,V,d31,roomtemp-curetemp,ap,ast,layup);
    strain_st_e(V) = strain_st(1,3);
    strain_st_p(V) = strain_st(1,1);
    [stress_si,strain_si] = strain(tp,t(bestindex),Qp,Ep,Qsi,V,d31,roomtemp-curetemp,ap,asi,layup);
    strain_si_e(V) = strain_si(1,3);
    strain_si_p(V) = strain_si(1,1);
end

V = [1:500];
figure(2);
set(axes,'Fontsize',14);
subplot(2,1,1);
plot(V,strain_s_p*100,'k',V,strain_UHM_p*100,'r',V,strain_st_p*100,'g',V,strain_si_p*100,'b', 'LineWidth',3);
legend('Piezo (S2 glass)','Piezo (UHM M60J)','Piezo (Steel)','Piezo (Si)');
title(strcat(piezotype,sprintf(', l = %g, w = %g, l_e_x_t = %g (mm), t = %g (\mu m)',...
    l*1e3,w*1e3,lext*1e3,t(bestindex)*1e6),', \Delta',sprintf('T = %g',(roomtemp-curetemp))),'Fontsize',16);
ylabel('% Strain','Fontsize',20);
grid on;
subplot(2,1,2);
plot(V,strain_s_e*100,'k',V,strain_UHM_e*100,'r',V,strain_st_e*100,'g',V,strain_si_e*100,'b', 'LineWidth',3);%,...
xlabel('Applied Voltage (V)','Fontsize',20);
ylabel('% Strain','Fontsize',20);
legend('S2 glass','UHM M60J','Steel','Si');
grid on
%print
name = strcat(piezotype,'voltage.jpg');
%print(2, '-djpeg', name);