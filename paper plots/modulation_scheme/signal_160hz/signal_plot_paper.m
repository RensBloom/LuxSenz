% dc lamp 365 lux at 30 cm - lamp behind the transmittter
% receiver at 30cm
% manchester 22

load 'video_22_160hz_12v.dat'
load 'miller_160hz_12v.dat'
load 'mod_miller_160hz_12v.dat'
load 'ppm1_160hz_12v.dat'
load 'ppm2_160hz_12v.dat'
% load 'video_pwm1_160hz_12v.dat'
Fs = 50e3;            % Sampling frequency                    
T = 1/Fs ;          % Sampling period       
L = length(video_22_160hz_12v)  % Length of signal
t = (0:L-1)*T;      % Time vector
f = Fs*(0:(L/2))/L;

%50hz notch filtering
q =35;
f0 =50;
bw =(f0/(Fs/2))/q;
[b,a] = iircomb(Fs/f0, bw, 'notch');

a = (video_22_160hz_12v - min(video_22_160hz_12v))/(max(video_22_160hz_12v)-min(video_22_160hz_12v));
b = (miller_160hz_12v - min(miller_160hz_12v))/(max(miller_160hz_12v)-min(miller_160hz_12v));
c = (mod_miller_160hz_12v - min(mod_miller_160hz_12v))/(max(mod_miller_160hz_12v)-min(mod_miller_160hz_12v));
% d = (ppm1_160hz_12v - min(ppm1_160hz_12v))/(max(ppm1_160hz_12v)-min(ppm1_160hz_12v));
e = (ppm2_160hz_12v - min(ppm2_160hz_12v))/(max(ppm2_160hz_12v)-min(ppm2_160hz_12v));
% f = (video_pwm1_160hz_12v - min(video_pwm1_160hz_12v))/(max(video_pwm1_160hz_12v)-min(video_pwm1_160hz_12v));





% normal unfiltered signal
% subplot(3,2,1)
plot(t,a)
axis([0.011 0.06 0 1.1]) 
%title(' Manchester code')
% 
% % subplot(3,2,2)
% plot(t,b) 
% axis([0.03 0.085 0 1.1])
% % title(' Miller ')
% % 
% % subplot(3,2,3)
% plot(t,c) 
% axis([0.04 0.09 0 1.1])   
% % title(' Mod miller ')
% % 
% % subplot(3,2,5)
% plot(t,e) 
% axis([0.014 0.066 0 1.1]) 
ylabel('signal amplitude')
xlabel('time (s) ')  
% % title(' PPM  ')
plotnumber =0;
set(gca, 'fontsize', 18)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 600 400]);% set(gca,'fontsize', 25);
grid on 
ylabel('Normalized amplitude')

