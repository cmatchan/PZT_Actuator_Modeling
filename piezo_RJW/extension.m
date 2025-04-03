close all
clear

lr = [0:.01:4]';
L = (1+2*lr).^2./(1+3*lr+3*lr.^2);

figure(1);
    set(axes,'Fontsize',14);
    plot(lr,L,'k', 'LineWidth',2);
    grid on;
    xlabel('Extension Ratio, l_r','Fontsize',20);
    ylabel('Extension Factor, L','Fontsize',20);
