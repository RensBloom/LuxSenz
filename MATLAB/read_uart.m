% Read samples from a connected device using UART..
% COM-port and number of samples to receive can be set.
% The samples will be plotted when received.

numsamples = 1000;
port       = 'COM9';
baudrate   = 57600;

out = [];
instrreset
s = serial(port);
set(s,'BaudRate',baudrate);
fopen(s);
out = zeros(1,numsamples);
for i=1:numsamples
    a = fscanf(s);
    if (mod(i, floor(numsamples/10)) == 0)
        disp([num2str(i),'/', num2str(numsamples)])
    end
    if (length(a) > 1)
        out(i) = sscanf(a, '%d');
    end
end
fclose(s)
delete(s)
clear s

plot(out);
grid(gca,'minor'); grid on