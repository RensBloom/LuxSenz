a = (importdata('20180712fsk13n.dat'));

N = 41;
fs = 10000;
a = a((1:N)*10);
a = sin([(0:1:40)*2*pi/16.12])+sin([(0:1:40)*2*pi/17.85]);
a = a - mean(a);
figure()
plot(a);
figure()
plot(abs(fft(a)))

x = 1:N;
y = 1:N;
x2 = 1:(2*N);
y2 = 1:(2*N);

for k=1:N
    x(k) = fs/N*(k-1);
    im = 0;
    re = 0;
    for n=1:N
        re = re + a(n)*cos(2*pi*(k-1)*(n-1)/N);
        im = im + a(n)*sin(2*pi*(k-1)*(n-1)/N);
    end
    y(k) = sqrt(re*re+im*im);
end

R = 7.4;

for k=1:(R*N)
    x2(k) = fs/N*(k-1)/R;
    im = 0;
    re = 0;
    for n=1:N
        re = re + a(n)*cos(2*pi*(k-1)*(n-1)/R/N);
        im = im + a(n)*sin(2*pi*(k-1)*(n-1)/R/N);
    end
    y2(k) = sqrt(re*re+im*im);
end

plot(x, abs(fft(a)))
hold on;
% plot(x,y);
plot(x2,y2);