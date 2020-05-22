% clear all;
close all;
% load('simulated.mat');
load('simulation_car.mat');
blue = 'c';
red = 'k';

carTrace = importdata('20180119carb40kmh3m.dat');
carTrace = carTrace(582001:589500);
a = 1;

carX = (1:7500)/4.83+180; %(1:(72000+a))/89.2+109.3;
carTrace = conv(ones(a,1)/a, carTrace)/1176-1.395; %*0.7+0.16;
carTrace = carTrace/1.05;
module = 3.5; %cm

kernel_s = L_y_vals;
X_s = y_M_vals;

kernel_s = [zeros(1,80) kernel_s zeros(1,20)];
% X_s = [-50 X_s 100];
[M,I] = max(kernel_s);
kernel_s = kernel_s/M;
cc = zeros(I, 1);
cc(I) = 1;


dx = X_s(2) - X_s(1);

m_d = round(module/dx);
module = dx*m_d

barcode = barcodewave(m_d);

signal_s = conv(barcode, kernel_s);
signal_bc = conv(cc,barcode);
kernel_s = kernel_s/max(signal_s);
signal_s = signal_s/max(signal_s);
figure(2);
hold off;
xsc = 50;
xoff = -4.45;
plot(carX/xsc+xoff, carTrace, '-b');
hold on;
plot((1:length(signal_s))/xsc+xoff, signal_s, '--r');
plot((1:length(signal_bc))/xsc+xoff, signal_bc, ':k');
A = axis();colormap([[1 1 1];  [1 1 0.8];  [0.8 0.8 0.8]; [0.7 0.7 0.8]; [0.6 0.6 0.8]; [0.5 0.5 0.8]; [0.4 0.4 0.8]; [0.3 0.3 0.8] ])
A(1) = 0;
A(2) = 30;
A(3) = -0.05;
A(4) = 1.42;
axis(A);
grid();
legend('received signal', 'simulated signal', 'input signal');
xlabel('Time (ms)');
ylabel('received signal');
title('Signal from barcode at 3 m');
set(gca,'fontsize', 12);

l = ones(1,m_d);
figure();
plot([-100 -100],[-100 -100], blue, [-100 -100],[-100 0], red);
hold on;

pre  = 250:285;
sig  = 285:320;
post = 320:355;

off = 0;
pre = pre+off;
sig = sig+off;
post=post+off;

wave = conv([l l l l l l], kernel_m);
min1 = wave(sig);
wave = conv([l l l 0*l l l], kernel_m);
max0 = wave(sig);
min1 = max0 + 1;

xsc = 10.2941;
xoff = -29.43;

for a=0:1
    for b=0:1
        for c=0:1
            for d=0:1
                for e=0:1
                    for f=0:1
                        wave = conv([a*l b*l c*l d*l e*l f*l], kernel_s);
                        if (c == 1)
                            plot(pre/xsc+xoff, wave(pre), blue);
                        else
                            plot(pre/xsc+xoff, wave(pre), red);
                        end
                        if (e == 1)
                            plot(post/xsc+xoff, wave(post), blue);
                        else
                            plot(post/xsc+xoff, wave(post), red);
                        end
                        
                        if (d == 1)
                            min1 = bsxfun(@min, min1, wave(sig));
                            plot(sig/xsc+xoff, wave(sig), blue);
                        else
                            plot(sig/xsc+xoff, wave(sig), red);
                            max0 = bsxfun(@max, max0, wave(sig));
                        end
                    end
                end
            end
        end
    end
end
title('Simulated eye pattern at 3 m');

tmin = min(find(max0 <= min1));
tmax = max(find(max0 <= min1));
t = tmin:tmax;


axis([268/xsc+xoff 338/xsc+xoff -0.05 1.42]);
ylabel('Normalized signal intensity');
xlabel('Time'); grid()
legend('White stripe', 'Black stripe', 'Location', 'north')

p = polyshape([sig(t) sig(fliplr(t))]/xsc+xoff, [max0(t)+0.012 min1(fliplr(t))-0.012]);
pl = plot(p, 'FaceColor', 'k', 'FaceAlpha',0.1, 'LineStyle', ':', 'LineWidth', 0.5, 'DisplayName', 'Eye');

set(gca,'fontsize', 15);

carTrace = carTrace/1.05;

figure();
plot([-100 -100],[-100 0], blue, [-100 -100],[-100 0], red);
hold on;
delta = round(m_d*4.83*0.5);

min1 = ones(1, 2*delta+1)';
max0 = zeros(1, 2*delta+1)';

xsc = 50;
xoff = -3.4;
for j=231:m_d:1630
    i = round((j-180)*4.83);
     if (signal_bc(j-m_d) == 1)
        plot((0:delta)/xsc+xoff, carTrace(i-2*delta:i-delta), blue);
     else
        plot((0:delta)/xsc+xoff, carTrace(i-2*delta:i-delta), red);
     end
     if (signal_bc(j+m_d) == 1)
        plot((delta*3:4*delta)/xsc+xoff, carTrace(i+delta:i+2*delta), blue);
     else
        plot((delta*3:4*delta)/xsc+xoff, carTrace(i+delta:i+2*delta), red);
     end 
     if signal_bc(j) == 1
        plot((delta:delta*3)/xsc+xoff, carTrace(i-delta:i+delta), blue);
        min1 = bsxfun(@min, min1,carTrace(i-delta:i+delta));
     else
        plot((delta:delta*3)/xsc+xoff, carTrace(i-delta:i+delta), red);
        max0 = bsxfun(@max, max0, carTrace(i-delta:i+delta));
     end
end

axis([0/xsc+xoff delta*4/xsc+xoff -0.05 1.42]);
title('Eye pattern from measurements at 3 m');
ylabel('Normalized signal intensity');
xlabel('Time (ms)'); grid()
legend('White stripe', 'Black stripe', 'Location', 'north')
max0 = max0'+0.011;
min1 = min1'-0.011;
tmin = min(find(max0 <= min1));
tmax = max(find(max0 <= min1));
t = tmin:tmax;

p = polyshape([delta+(t) delta+(fliplr(t))]/xsc+xoff, [max0(t) min1(fliplr(t))]);
pl = plot(p, 'FaceColor', 'k', 'FaceAlpha',0.1, 'LineStyle', ':', 'LineWidth', 0.5, 'DisplayName', 'Eye');


set(gca,'fontsize', 15);
% plot(kernel_m);
% hold on;
% plot(kernel_s);