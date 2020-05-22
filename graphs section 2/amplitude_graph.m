% amplitude
amplitude = [1985 1985 1985 1468 1398 1022 830 891 260 581 446 69 131 123 127 104 322 323 193 193 193];
frequency = [1 100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000];
amplitude= (amplitude -min(amplitude))/(max(amplitude)-min(amplitude))
p = polyfit(frequency,amplitude,3); 
f = polyval(p, frequency); 
plot(frequency,amplitude,'o',frequency,f, 'Markersize',10, 'Linewidth', 3) 
hold on
grid on
ylim([0 1])
plotnumber =0;
set(gca, 'fontsize', 16)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 600 400]);
%set(gca,'fontsize', 25);
xlabel('Operating frequency (Hz)')
ylabel('Normalized signal amplitude')
legend('Signal Amplitude', 'Amplitude Estimate')
