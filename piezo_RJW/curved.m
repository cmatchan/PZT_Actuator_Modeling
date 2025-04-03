close all;

% open materials properties
properties;

% piezoeelectric material type
piezotype = 'PZT';
elastictype = 'UHM CF';
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

layup = [0;0];
telastic = length(layup)*t_UHM;
Rmold = .065;
w = 1.75e-3;

% split the bar into two pieces, piezo on top
Re = Rmold - telastic/2;
Rp = Rmold - telastic - tp/2;;
Ie = w*(telastic)^3/12;
Ip = w*(tp)^3/12;
Mp = Ep*Ip/Rp;
Me = EUHM1*Ie/Re;
sigma_maxp = Ep*tp/2/Rp;
sigma_maxe = EUHM1*telastic/2/Re;
z_neg = (-telastic/2:1e-6:telastic/2)';
sigma_xe = -z_neg*sigma_maxe/telastic*2;
z_pos = (-tp/2:1e-6:tp/2)';
sigma_xp = -z_pos*sigma_maxp/tp*2;
z = [(-telastic:1e-6:0)';(0:1e-6:tp)'];
sigma = [sigma_xe;sigma_xp];

% now join the two bars and apply -(M1+M2) to the curved beam
n = Ep/EUHM1;
b1 = n*w;
b2 = w;
r1 = Rmold - (tp+telastic);
r2 = Rmold;
R = (b1*tp + b2*telastic)/(b1*log((r1+tp)/r1)+b2*log(r2/(r1+tp)));
zc = (b1*tp*(telastic+tp/2) + b2*telastic*telastic/2)/(b1*tp + b2*telastic);
I = b1*tp^3/12 + b2*telastic^3/12 + b1*tp*(telastic-zc+tp/2)^2 + b2*telastic*(telastic/2-zc)^2;
r_hat = Rmold - zc;
e = r_hat - R;
M = -(Mp + Me);
zprime = z+telastic-zc;
% this is the stress for the transformed section:
sigma_xnew = -M*zprime./((b1*tp + b2*telastic)*e.*(R-zprime));
% now convert back to the original configuration by multiplying
% the elastic layer stress by the modulus ratio:
% first for a monotonic plot (eliminating the difference
% between the z_interface and zc)
index_plot = find(round(z*1e6)==round(zc*1e6-telastic*1e6));
correction_plot = [ones(1,index_plot),n*ones(1,length(sigma_xnew)-index_plot)]';
% next find the actual stress profile
index_actual = find(round(z*1e6)==0);
correction_actual = [ones(1,index_actual(1)),n*ones(1,length(sigma_xnew)-index_actual(1))]';
sigma_xnew_plot = sigma_xnew.*correction_plot;
sigma_xnew_actual = sigma_xnew.*correction_actual;

% now combine the two stresses
sigma_total = sigma + sigma_xnew_actual;

% setup axis and patch properties
minlimit = 1.2*min(sigma)*1e-6;
maxlimit = 1.2*max(sigma)*1e-6;
upperpatchx = [minlimit; maxlimit; maxlimit; minlimit];
upperpatchy = [0; 0; tp*1e6; tp*1e6];
upperC = [0.8 0.8 0.8];
lowerpatchx = [minlimit; maxlimit; maxlimit; minlimit];
lowerpatchy = [0; 0; -telastic*1e6; -telastic*1e6];
lowerC = [0.4 0.4 0.4];
tensionpatchx = [0 maxlimit maxlimit 0];
tensionpatchy = [-telastic*1e6 -telastic*1e6 tp*1e6 tp*1e6];
tensionC = [1 0 0];

figure(1);
set(axes,'Fontsize',12);
subplot(3,1,1);
plot(sigma*1e-6,z*1e6, 'LineWidth',2)   
axis([minlimit maxlimit -telastic*1e6 tp*1e6]);
grid on;
patch(upperpatchx,upperpatchy,upperC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(lowerpatchx,lowerpatchy,lowerC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(tensionpatchx,tensionpatchy,tensionC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.1);
text(-maxlimit*.75, tp*1e6/2,piezotype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(-maxlimit*.75, -telastic*1e6/2,elastictype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(maxlimit*1.1, 0,'(a)',...
    'HorizontalAlignment','center',...
    'Fontsize',14);
title(strcat('\rho_{mold}=',sprintf('%g',Rmold*1e3),'mm'),'Fontsize',18);
subplot(3,1,2);
plot(sigma_xnew_plot*1e-6, z*1e6,'LineWidth',2);
axis([minlimit maxlimit -telastic*1e6 tp*1e6]);
grid on;
patch(upperpatchx,upperpatchy,upperC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(lowerpatchx,lowerpatchy,lowerC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(tensionpatchx,tensionpatchy,tensionC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.1);
text(-maxlimit*.75, tp*1e6/2,piezotype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(-maxlimit*.75, -telastic*1e6/2,elastictype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(maxlimit*1.1, 0,'(b)',...
    'HorizontalAlignment','center',...
    'Fontsize',14);
ylabel('z height (\mum)','Fontsize',18);
subplot(3,1,3);
plot(sigma_total*1e-6,z*1e6,'LineWidth',2);
axis([minlimit maxlimit -telastic*1e6 tp*1e6]);
grid on;
patch(upperpatchx,upperpatchy,upperC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(lowerpatchx,lowerpatchy,lowerC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.5);
patch(tensionpatchx,tensionpatchy,tensionC,...
    'FaceAlpha',0.5,...
    'EdgeAlpha',0.1);
text(-maxlimit*.75, tp*1e6/2,piezotype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(-maxlimit*.75, -telastic*1e6/2,elastictype,...
    'HorizontalAlignment','center',...
    'EdgeColor','k',...
    'Fontsize',14);
text(maxlimit*1.1, 0,'(c)',...
    'HorizontalAlignment','center',...
    'Fontsize',14);
xlabel('Stress (MPa)','Fontsize',18);

print(1,'-djpeg','moldmodel01');

% figure(2)
%[Z,SIGMA_range] = meshgrid(z,(-4e6:1e5:4e6)');
% [Z,SIGMA_total] = meshgrid(z,sigma_total);
%quiver(SIGMA_total,Z);
%quiver(sigma_total,z);
%patch([-4 4 4 -4],[0 0 h/2*1e6 h/2*1e6],[0.8,0.8,0.8],'FaceAlpha',0.5);
%patch([-4 4 4 -4],[-h/2*1e6 -h/2*1e6 0 0],[0.5,0.5,0.5],'FaceAlpha',0.5);