close all;

f = [0 8 10:10:100 100:100:800];
low = [.002 .002 .0025:.0025:.025 0.08:.08:.64]*100;
no = [0 0.0008 .001:.001:.01  0.0333:.0333:.28]*100;

figure()
plot(f,no, 'LineWidth',2, 'MarkerSize',10);
hold on;
plot(f, low, '--', 'LineWidth',2, 'MarkerSize',10);
hold on;
h = fill([f 1000], [no 0], 'b');
set(h,'EdgeColor','none')
alpha(0.15);
h = fill([f flip(f)], [no flip(low)], [1 .7 .7]);
set(h,'EdgeColor','none')
alpha(0.15);
xlabel('Freq (Hz)');
ylabel('Modulation %');
set(gca, 'fontsize', 16)
legend('no risk','low risk', 'location', 'NorthWest');
set(gcf, 'Position', [300+0*50 240+0*20 450 300]);
axis([0 800 0 75]);
grid on;
grid minor;


saveas(gcf,'recommendedmod','epsc');
