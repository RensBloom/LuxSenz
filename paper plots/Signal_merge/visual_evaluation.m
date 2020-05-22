v = [60 40 0 0 0; 0 60 40 0 0; 0 0 40 30 30; 0 0 20 10 70; 0 0 0 20 80; 0 0 0 40 60; 0 0 0 30 70];
x=[ 10 30 90 120 160 210 240]


figure; 
ax= axes;
bar(v,0.4, 'stacked')
set(gca,'xticklabel',{'10','30','90','120','160','210','240'},'fontsize', 16);
legend('very severe disturbance','severe disturbance','moderate disturbance','low disturbance','no disturbance')

ytickformat(ax, 'percentage');
xlabel('Frequency (Hz)')
plotnumber =0;
set(gca, 'fontsize', 18)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 800 600]);% set(gca,'fontsize', 25);

%hold on
%bar(v(1), 'b')
%hold off;0 0