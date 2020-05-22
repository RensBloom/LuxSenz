% -------Response time calculation for 1Hz ---------------------
% 

load 'r3d_1hz_5.dat'

x = r3d_1hz_5;
Fs = 50e3;            % Sampling frequency                    
T = 1/Fs ;          % Sampling period       
L = length(x)  % Length of signal
t = (0:L-1)*T;      % Time vector
f = Fs*(0:(L/2))/L;

falltime(r3d_1hz_5(1:L-1),t(1:L-1),'PercentReferenceLevels',[10 90]);
% risetime(r3d_1hz_5(1:L-1),t(1:L-1),'PercentReferenceLevels',[10 90]);
plotnumber =0;
legend('off')

set(gca, 'fontsize', 20)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 600 400]);% set(gca,'fontsize', 25);
