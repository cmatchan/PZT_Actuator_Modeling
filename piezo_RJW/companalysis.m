% piezo calculations
% for unidirectional s-glass fibers, 
% and for UHM carbon fiber elastic layers
close all;
clear;
clc;

% unimorph or bimorph
unimorph = 0;
bimorph = 1;
global piezoconfig
piezoconfig = bimorph;

% Actuator geometry
geometry;

% material properties
properties;

% piezoeelectric material type
piezotype = 'PZT';
if piezotype == 'PZT',
    Qp = Qpzt;
    tp = thickness.PZT;
    densityp = density.PZT;
    ap = a.PZT;
    d31 = d31pzt;
else,
    piezotype ='PZNPT';
    Qp = Qpznpt;
    tp = thickness.PZNPT;
    densityp = density.PZNPT;
    ap = a.PZNPT;
    d31 = d31pznpt;
end

% actuator elastic layer layup
layup = [0];

% drive parameters
roomtemp = 20;
curetemp = 120;
V = 200; %300;

% analysis of s-glass, UHM, silicon, and steel 
t = 1e-6:2e-6:2*thickness.PZT;
piezomass = l*wnom*tp*densityp*(1+piezoconfig);

[Gd, GF] = getG(wr,lr);

G = [Gd,GF];

for i = 1:length(t),
    % mechanical energy
    [delta.UHM(i),Fb.UHM(i),k.UHM(i)] = energy(w,lentotal,[tp t(i)],Qp,QUHM,V,d31,layup,G);
    [delta.SGlass(i),Fb.SGlass(i),k.SGlass(i)] = energy(w,lentotal,[tp t(i)],Qp,Qs,V,d31,layup,G);
    [delta.steel(i),Fb.steel(i),k.steel(i)] = energy(w,lentotal,[tp t(i)],Qp,Qst,V,d31,layup,G);
    [delta.silicon(i),Fb.silicon(i),k.silicon(i)] = energy(w,lentotal,[tp t(i)],Qp,Qsi,V,d31,layup,G);
    % mass:
    % extension mass (assuming extension is reinforced with 120um of sglass)...
    % extension reinforcement is slightly wider than wnom*(2-wr)
    wcorrect = 1.5;
    mass_UHM_ext = l*lr*wnom*(2-wr)*t(i)*density.UHM + 240e-6*wnom*(2-wr)*l*lr*density.SGlass*wcorrect;
    mass_s_ext = l*lr*wnom*(2-wr)*t(i)*density.SGlass + 240e-6*wnom*(2-wr)*l*lr*density.SGlass*wcorrect;
    mass_st_ext = l*lr*wnom*(2-wr)*t(i)*density.steel + 240e-6*wnom*(2-wr)*l*lr*density.SGlass*wcorrect;
    mass_si_ext = l*lr*wnom*(2-wr)*t(i)*density.silicon + 240e-6*wnom*(2-wr)*l*lr*density.SGlass*wcorrect;
    % total mass:
    mass.UHM(i) = l*wnom*t(i)*density.UHM + piezomass + mass_UHM_ext;
    mass.SGlass(i) = l*wnom*t(i)*density.SGlass + piezomass + mass_s_ext;
    mass.steel(i) = l*wnom*t(i)*density.steel + piezomass + mass_st_ext;
    mass.silicon(i) = l*wnom*t(i)*density.silicon + piezomass + mass_si_ext;
end

%create a title for each plot which describes the actuator
if piezoconfig,
    fig_title = strcat('Bimorph',sprintf(', l = %g(mm), l_r = %g , w_{nom} = %g(mm), w_r = %g, V = %g',...
        l*1e3,lr,wnom*1e3,wr,V));
else
    fig_title = strcat('Unimorph',sprintf(', l = %g(mm), l_r = %g , w_{nom} = %g(mm), w_r = %g, V = %g',...
        l*1e3,lr,wnom*1e3,wr,V));
end

%plot displacement
figure(1); 
    set(axes,'Fontsize',14);
    plot(t*1e6, delta.UHM*1e6,'r-',... 
        t*1e6, delta.SGlass*1e6,'k:',...
        t*1e6, delta.steel*1e6,'m-.',...
        t*1e6, delta.silicon*1e6,'b--', 'LineWidth',3);
    ylabel('Tip Displacement (\mum)','Fontsize',20);
    xlabel('Passive Layer Thickness (\mum)','Fontsize',20);
    title(fig_title,'Fontsize',18);
    %legend('UHM M60J','S2 glass','Steel','Si');
    grid on
    %print
    name = strcat(piezotype,'delta.jpg');
    %print(1, '-djpeg', name);

%plot blocked force
figure(2);
    set(axes,'Fontsize',14);
    plot(t*1e6,Fb.UHM*1e3,'r-',...
        t*1e6,Fb.SGlass*1e3,'k:',...
        t*1e6,Fb.steel*1e3,'m-.',...
        t*1e6,Fb.silicon*1e3,'b--', 'LineWidth',3);
    xlabel('Passive Layer Thickness (\mum)','Fontsize',20);
    ylabel('Blocked Force (mN)','Fontsize',20);
    title(fig_title,'Fontsize',18);
%    legend('UHM M60J','S2 glass','Steel','Si');
    grid on
    %print
    name = strcat(piezotype,'Fb.jpg');
    %print(2, '-djpeg', name);

%plot stiffness
figure(3);
    set(axes,'Fontsize',14);
    plot(t*1e6,k.UHM,'r-',...
        t*1e6, k.SGlass, 'k:',...
        t*1e6,k.steel,'m-.',...
        t*1e6,k.silicon,'b--', 'LineWidth',3);
    xlabel('Passive Layer Thickness (\mum)','Fontsize',20);
    ylabel('Stiffness (Nm^-^1)','Fontsize',20);
    title(fig_title,'Fontsize',18);
   % legend('UHM M60J','S2 glass','Steel','Si');
    grid on
    %print
    name = strcat(piezotype,'stiff.jpg');
    %print(3, '-djpeg', name);

% %plot energy
% figure(4);
%     set(axes,'Fontsize',14);
%     plot(t*1e6,delta.UHM.*Fb.UHM/2*1e6,'r-',...
%         t*1e6,delta.SGlass.*Fb.SGLass/2*1e6,'k:',...
%         t*1e6,delta.steel.*Fb.steel/2*1e6,'m-.',...
%         t*1e6,delta.silicon.*Fb.silicon/2*1e6,'b--', 'LineWidth',3);
%     xlabel('Passive Layer Thickness (\mum)','Fontsize',20);
%     ylabel('Energy (\muJ)','Fontsize',20);
%     title(fig_title,'Fontsize',18);
%     legend('UHM M60J','S2 glass','Steel','Si');
%     grid on
%     %print
%     name = strcat(piezotype,'energy.jpg');
%     %print(4, '-djpeg', name);
% 

%plot energy density
figure(5);
    set(axes,'Fontsize',14);
    plot(t/thickness.PZT,(delta.UHM.*Fb.UHM/2)./mass.UHM,'r-',...
        t/thickness.PZT,(delta.SGlass.*Fb.SGlass/2)./mass.SGlass,'k:',...
        t/thickness.PZT,(delta.steel.*Fb.steel/2)./mass.steel,'m-.',...
        t/thickness.PZT,(delta.silicon.*Fb.silicon/2)./mass.silicon,'b--', 'LineWidth',3);
    xlabel('Passive Layer Thickness Ratio (t_r)','Fontsize',20);
    ylabel('Energy Density(J/Kg)','Fontsize',20);
    title(fig_title,'Fontsize',18);
  %  legend('UHM M60J','S2 glass','Steel','Si');
    grid on
    for i = 1:20:length(t),
        text(t(i)/thickness.PZT,(delta.UHM(i)*Fb.UHM(i)/2)/mass.UHM(i),...
            sprintf('%gmg',round(mass.UHM(i)*1e6*100)/100),'Fontsize',13);
    end
    
    %print
    name = strcat(piezotype,'density.jpg');
    %print(5, '-djpeg', name);
    

clear Ep Es1 Es2 EUHM1 EUHM2 G12p G12s Q11UHM Q11p Q11s Q12UHM Q22p Q22s
clear Q12p Q12s Q22UHM G12UHM Q66p Q66s Q66UHM
clear as1 as2 aUHM1 aUHM2 ap
clear densityp densityUHM densitys
clear pp pUHM ps l w lext piezomass d31 i
clear vp vUHM vs V tp t_UHM t_sglass name fig_title