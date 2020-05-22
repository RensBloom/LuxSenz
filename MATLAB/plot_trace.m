% Open a data file, plot the sample trace together with the result of
% applying a moving average filter of 0.5s on the sample trace.
% The data file can be any file that is readable by MATLAB, for example
% one taken using a BeagleBone by following the LuxSenz manual titled
% "Using a BeagleBone".

fs = 50000; % Set the sample rate here

file = uigetfile('*.dat');
a = importdata(file);

mov_duration = 0.5; %0.5 seconds
b = conv(ones(1,fs*mov_duration)/fs/mov_duration,a);
b = b((fs/2):1200000);
plot((1:length(a))/fs, a);
hold on;
grid on;
plot((1:length(b))/fs+mov_duration/2, b, 'y');
hold off;