f = logspace(0, 6);

C = 47e-9;
R = 47e3;

Z = 1./(1i*2*pi*C*f);

ZR = (f./f)*R;
loglog(f, abs(ZR./(ZR+Z)).^2, '*-');

grid()

