function [Gd,GF] = getG(wr,lr);

syms temp;
ga = 6*(wr-1)*(-3-2*lr+2*wr+2*lr*wr);
gb = 3*(wr-2)*(-2-2*lr+wr+2*lr*wr)*eval(limit(log((2-temp)/temp),temp,wr));
gc = 8*(1-wr)^3;
gd = 6*(wr-1)*(3+4*lr-2*wr-4*lr*wr);
ge = 3*(-2-2*lr+wr+2*lr*wr)^2*eval(limit(log((2-temp)/temp),temp,wr));

Glext = (gd+ge)/gc;
Gl = (ga+gb)/gc;
GF = (1+2*lr)/Glext;
Gd = (1+2*lr);
