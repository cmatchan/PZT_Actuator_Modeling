clear
close all

load width;

%experimental data:
W=W';
wr=wr';
wr_temp = [1.5;2];
W_temp = [1.22;1.35];
std_temp = [0.03;0.16];
W_exp = -ones(size(W));
W_exp(151)=W_temp(1);
W_exp(length(W))=W_temp(2);
std = zeros(size(W));
std(151) = std_temp(1);
std(length(W)) = std_temp(2);
figure(1);
set(axes,'Fontsize',14);
errorbar([wr wr], [W W_exp],[zeros(size(W)) std]);
grid on
ylabel('Width Factor','Fontsize',20);
xlabel('Width Ratio, w_r','Fontsize',20);
legend('Predicted','Measured');
%print(1, '-djpeg', 'width01.jpg');
axis([0 2 0 1.6]);