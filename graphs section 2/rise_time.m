
rt =[13.7 17.6; 45 8.7; 3.3 2.7; 2.7 3]
ft = [35 11; 12.4 3.5; 4.8 1.6; 5.5 3.8]

sz=120;
y=[0:50]
x=[0:50]



scatter(13.7,35,sz,'g','d','linewidth',2)
hold on
scatter(45,12.4,sz,'g','c','linewidth',2)
hold on
scatter(3.3,4.8,sz,'g','s','linewidth',2)
hold on
scatter(2.7,5.5,sz,'g','v','linewidth',2)
hold on
scatter(17.6,11,sz,'k','d','filled')
hold on
scatter(8.7,3.5,sz,'k','c','filled')
hold on
scatter(2.7,1.6,sz,'k','s','filled')
hold on
scatter(3,3.8,sz,'k','v','filled')
hold on
plot(x,y,'r','linewidth',2)



grid on
% plotnumber=0;
% set(gca, 'fontsize', 22)
% set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 900 600]);
plotnumber =0;
set(gca, 'fontsize', 16)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 600 400]);
xlabel('Rise time (ms)')
ylabel('Fall time (ms)')
%title('Rise and fall time of the shutters')
legend('3.3V- Circ.','3.3V- Rect', '3.3V- Vid.', '3.3V- 3D','5V- Circ.','5V- Rect', '5V- Vid.', '5V- 3D', 'Location','northeast')
xlim([0 50])
ylim([0 50])
