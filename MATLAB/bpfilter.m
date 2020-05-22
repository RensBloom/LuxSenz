% Simulate frequency response of a narrow-band frequency filter, as used
% in the circuit of the LuxSenz receiver.
% Resistor and capacitor values can be adjusted in the script. To simulate
% the behaviour with potentiometers (variable resistors), set the value of
% Rpot or Rpot2 and set the value of R6 or R8 to be dependent on Rpot/Rpot2
% and the value of iteration variable n.

f = logspace(1, 4,600);

% for n=0:1:63  %Uncomment if potentiometer is used
for n = 1:10    %Comment if potentiometer is used
    
C21 = 1e-6;    %C21
C20 = 1e-6;    %C20

% Rpot = 2.1e3;         %R6 max value (64 steps)
% R6 = Rpot*n/63;       %R6
% R6 = 1/(2*pi*C1*200); %R6
R6 = 300;               %R6 (lower value = higher amplification)

% R7 = R1/22; %R7
R7 = 47;      %R7

% Rpot2 = 50e3;    %U7 max value (64 steps)
% R8 = Rpot2*n/63; %U7/R8/C22
% R8 = 22*R1;      %U7/R8/C22
R8 = 1.5e3*n;        %U7/R8/C22

%Computations below

ZC1 = 1./(1i*2*pi*C21*f);
ZC2 = 1./(1i*2*pi*C20*f);

ZRC2 = 1./(1./ZC2+1./R7);
Z34  = R8;
Z34C1 = Z34 + ZC1;
Zp = 1./(1./Z34C1+1./ZRC2);

Vp = 1;
Vo = -Vp*Z34./ZC2;
Vin = R6*(Vp/R6 + Vp*Z34./ZC2./ZC1 + Vp./ZC1 + Vp./ZC2 + Vp./R7);

loglog(f, abs(Vo./Vin), '.-');
grid off;
grid(gca,'minor'); grid on; hold on
pause(0.1);
end