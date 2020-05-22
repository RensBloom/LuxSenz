fs = 50000;

filename = '20180725test1.dat';
block = 500000;
b = importdata(filename);
a = b;
figure()
X = fft(a-mean(a)); % Obtain the DFT using the FFT algorithm
Xabs = abs(X); % Obtain the magnitude
N = length(Xabs);
fgrid = fs*(0:(N-1))/(N);
plot(fgrid,Xabs);
grid(gca,'minor'); grid on
title(filename);

axis([0 2000 0 max(Xabs)]);