clear
close all

load widthext

wrmax = 2;
lrmax = 4;

wr = 0:wrmax/(size(Gnew,2)-1):wrmax;
lr = 0:lrmax/(size(Gnew,1)-1):lrmax;

[WR,LR] = meshgrid(wr,lr);
figure(1);
    set(axes,'Fontsize',14);
    [c,h] = contourf(WR,LR,Gnew,[0,0.2,0.4,0.6,0.8,1.0,1.2,1.3,1.33]);
    clabel(c,h,'fontsize',14);
    colormap('gray');
    
    xlabel('w_r','Fontsize',18);
    ylabel('l_r','Fontsize',18);
    zlabel('G_U','Fontsize',18);

figure(2);
    set(axes,'Fontsize',14);
    mesh(WR,LR,Gnew);
    colormap('gray');
    
    xlabel('w_r','Fontsize',18);
    ylabel('l_r','Fontsize',18);
    zlabel('G_U','Fontsize',18);