close all
clear
clc

E = 200e9;
x = 0:1e-4:10e-3;
F = 100e-3;
l = 10e-3;
h = 200e-6;
wnom = 1e-3;

% for straight actuator
wr = 1;
w = wnom*(2*(1-wr)*x/l + wr);
I = w*h^3/12;
M = F*(l-x);
epsilon_s = M/E./I*(h/2);

% for tapered actuator 1
wr = 0.5;
w = wnom*(2*(1-wr)*x/l + wr);
I = w*h^3/12;
M = F*(l-x);
epsilon_t1 = M/E./I*(h/2);

% for tapered actuator 2
wr = 1.5;
w = wnom*(2*(1-wr)*x/l + wr);
I = w*h^3/12;
M = F*(l-x);
epsilon_t2 = M/E./I*(h/2);

% for tapered actuator 3
wr = 1.99;
w = wnom*(2*(1-wr)*x/l + wr);
I = w*h^3/12;
M = F*(l-x);
epsilon_t3 = M/E./I*(h/2);

midstrain = median(epsilon_t2);
epsilon_t3 = epsilon_t3/midstrain;
epsilon_t2 = epsilon_t2/midstrain;
epsilon_t1 = epsilon_t1/midstrain;
epsilon_s = epsilon_s/midstrain;

figure(1);
set(axes,'Fontsize',12);
plot(x/l,epsilon_t1,'-k', 'LineWidth',2, 'DisplayName','w_r = 0.5');
hold on
plot(x/l,epsilon_s,':k', 'LineWidth',2, 'DisplayName','w_r = 1.0');
plot(x/l,epsilon_t2,'--k', 'LineWidth',2, 'DisplayName','w_r = 1.5');
plot(x/l,epsilon_t3,'-.k', 'LineWidth',2, 'DisplayName','w_r = 2.0');
ylabel('Normalized Strain','Fontsize',18);
xlabel('Normalized Position Along Actuator','Fontsize',18);
% legend('w_r = 0.5','w_r = 1.0','w_r = 1.5','w_r = 2.0');
legend
grid on;

wr = 1:.01:2;
epsilon = 1./wr;
figure(2);
set(axes,'Fontsize',12);
plot(wr,epsilon/max(epsilon),'k', 'LineWidth',2);
ylabel('Normalized Strain (at x = 0)','Fontsize',18);
xlabel('Width Ratio','Fontsize',18);
grid on;