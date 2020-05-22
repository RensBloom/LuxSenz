%{

    /*******************************\
    |                               |
    |       Casper van Wezel        |
    |       2018-12-11              |
    |                               |
    \*******************************/
%}

% Power consumption of the system
Pconsumption = 0.06; %W

% Solar panel specs
Ppv_stc = 1; %Wp @ STC (1000W/m2 %25C)
irradiance_stc = 1000; % W/m2 @25C

% irradiance needed to power the system
irradiance = Pconsumption * (irradiance_stc/Ppv_stc);

lux1 = 200; %lux
lux2 = 23000; %lux

% Lux to W/m^2 conversion factor
lux2wm2 = 0.015; % https://physics.stackexchange.com/questions/135618/rm-lux-and-w-m2-relationship

i1 = lux1 * lux2wm2;
i2 = lux2 * lux2wm2;
