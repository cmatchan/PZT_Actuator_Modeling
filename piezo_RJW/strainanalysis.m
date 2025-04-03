% piezo calculations
% for unidirectional s-glass fibers, 
% and for UHM carbon fiber elastic layers
close all
clear

% unimorph or bimorph
unimorph = 0;
bimorph = 1;
global piezoconfig
piezoconfig = unimorph;

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
    piezotype =='PZNPT';
    Qp = Qpznpt;
    tp = thickness.PZNPT
    densityp = density.PZNPT;
    ap = a.PZNPT;
    d31 = d31pznpt;
end

% actuator elastic layer layup
layup = [0];

% drive parameters
roomtemp = 20;
curetemp = 120;
V = 250+50*piezoconfig;
Fext = 100e-3;

% analysis of internally and externally induced strains 

% strain in each layer
[strn, x] = strain(w,lentotal,[tp thickess.elastic],Qp,Qsi,V,d31,layup,roomtemp-curetemp,ap,a.UHM,Fext);
[strn_external, x] = strain(w,lentotal,[tp thickess.elastic],Qp,Qsi,0,d31,layup,0,ap,a.UHM,Fext);
[strn_piezo, x] = strain(w,lentotal,[tp thickess.elastic],Qp,Qsi,V,d31,layup,0,ap,a.UHM,0);
[strn_thermal, x] = strain(w,lentotal,[tp thickess.elastic],Qp,Qsi,0,d31,layup,roomtemp-curetemp,ap,a.UHM,0);


%create a title for each plot which describes the actuator
if piezoconfig,
    fig_title = strcat('Bimorph', sprintf(', l_r = %g , w_{nom} = %g(mm), w_r = %g, V = %g',...
        lr,wnom*1e3,wr,V));
else
    fig_title = strcat('Unimorph', sprintf(', l_r = %g , w_{nom} = %g(mm), w_r = %g, V = %g',...
        lr,wnom*1e3,wr,V));
end

%plot strain
figure(1); 
    set(axes,'Fontsize',14);
    plot(x/l, strn(:,1)*1e6,'kd',...
        x/l, strn_external(:,1)*1e6,'ko',... 
        x/l, strn_piezo(:,1)*1e6,'ks',... 
        x/l, strn_thermal(:,1)*1e6,'kv',... 
        x/l, strn(:,1)*1e6,'k-',... 
        x/l, strn_external(:,1)*1e6,'k:',... 
        x/l, strn_piezo(:,1)*1e6,'k-.',... 
        x/l, strn_thermal(:,1)*1e6,'k--',... 
        'LineWidth',2);
    ylabel('Strain (\mum\cdotm^{-1})','Fontsize',20);
    xlabel('Normalized position along x','Fontsize',20);
    title(fig_title,'Fontsize',18);
    legend('PZT: (total)','         (external)',...
        '         (piezoelectric)','         (thermal)')
    %grid on
    %print
    name = strcat(piezotype,'delta.jpg');
    %print(1, '-djpeg', name);

figure(2); 
    set(axes,'Fontsize',14);
    plot(x/l, strn(:,2)*1e6,'rd',...
        x/l, strn_external(:,2)*1e6,'ro',...
        x/l, strn_piezo(:,2)*1e6,'rs',...
        x/l, strn_thermal(:,2)*1e6,'rv',...
        x/l, strn(:,2)*1e6,'r-',...
        x/l, strn_external(:,2)*1e6,'r:',...
        x/l, strn_piezo(:,2)*1e6,'r-.',...
        x/l, strn_thermal(:,2)*1e6,'r--',...
        'LineWidth',2);
    ylabel('Strain (\mum\cdotm^{-1})','Fontsize',20);
    xlabel('Normalized position along x','Fontsize',20);
    title(fig_title,'Fontsize',18);
    legend('CF:   (total)','         (external)',...
        '         (piezoelectric)','         (thermal)')
    %grid on
    %print
    name = strcat(piezotype,'delta.jpg');
    %print(1, '-djpeg', name);

clear Ep Es1 Es2 EUHM1 EUHM2 G12p G12s Q11UHM Q11p Q11s Q12UHM Q22p Q22s
clear Q12p Q12s Q22UHM G12UHM Q66p Q66s Q66UHM
clear as1 as2 aUHM1 aUHM2 ap
clear densityp densityUHM densitys
clear pp pUHM ps l w lext piezomass d31 i
clear vp vUHM vs V tp t_UHM t_sglass name fig_title