clear all;
close all;
clc;

load pztsat
newdpzt = interp(d,20);
newfieldpzt = interp(field,20);
slope = max(diff(newdpzt))/max(diff(newfieldpzt));
idealpzt = newfieldpzt*slope;
scale = max(idealpzt);
idealpzt = idealpzt/scale;
newdpzt = newdpzt/scale;
satpzt = idealpzt-newdpzt;

load pznptsat
newdpznpt = interp(d,20);
newfieldpznpt = interp(field,20);
slope = max(diff(newdpznpt))/max(diff(newfieldpznpt));
idealpznpt = newfieldpznpt*slope;
scale = max(idealpznpt);
idealpznpt = idealpznpt/scale;
newdpznpt = newdpznpt/scale;
satpznpt = idealpznpt-newdpznpt;

% now normalize for differences in max field...
dt = newfieldpznpt(10)-newfieldpznpt(9);
markerpznpt = round(length(newfieldpznpt) - (max(newfieldpznpt)-max(newfieldpzt))/dt);
scale = 1/idealpznpt(markerpznpt);
newdpznpt = newdpznpt*scale;

figure(1);
set(axes,'Fontsize',12);
plot(newfieldpzt*1e-6,idealpzt,newfieldpzt*1e-6,newdpzt,newfieldpznpt*1e-6,newdpznpt, 'LineWidth',2)
grid on;
ylabel('Normalized Strain', 'Fontsize',18);
xlabel('Applied Field (MVm^-^1)','Fontsize',18);
axis([0 max(newfieldpzt)*1e-6 0 1]);
legend('Ideal', 'PZT','PZNPT');

figure(2);
set(axes,'Fontsize',12);
plot(newfieldpzt*1e-6,satpzt*100,newfieldpznpt*1e-6,satpznpt*100, 'LineWidth',2)
grid on;
ylabel('Saturation Percentage', 'Fontsize',18);
xlabel('Applied Field (MVm^-^1)','Fontsize',18);
axis([0 max(newfieldpzt)*1e-6 0 max(satpzt)*100]);
legend('PZT','PZNPT');
