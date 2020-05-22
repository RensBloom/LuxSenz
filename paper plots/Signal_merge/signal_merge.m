clc;
clear all;
close all;
%observed signal--- editied time scale to get only one 8 bit sequence
load 'video_22_160hz_12v.dat'
load 'miller_160hz_12v.dat'
load 'mod_miller_160hz_12v.dat'
load 'ppm1_160hz_12v.dat'
load 'ppm2_160hz_12v.dat'
Fs = 50e3;            % Sampling frequency                    
T = 1/Fs ;          % Sampling period       
L = length(video_22_160hz_12v)  % Length of signal
t = (0:L-1)*T;      % Time vector
f = Fs*(0:(L/2))/L;

a = (video_22_160hz_12v - min(video_22_160hz_12v))/(max(video_22_160hz_12v)-min(video_22_160hz_12v));
c = (mod_miller_160hz_12v - min(mod_miller_160hz_12v))/(max(mod_miller_160hz_12v)-min(mod_miller_160hz_12v));
e = (ppm2_160hz_12v - min(ppm2_160hz_12v))/(max(ppm2_160hz_12v)-min(ppm2_160hz_12v));

%manchester and PPM expected
input=[0 0 0 1 0 1 1 0]; % change the input data bits to visualize any other data sequence
initial_state=0;
inv_state=initial_state;
len=length(input);
time_period = 0;
i=1;
% initialize null matrices to store the signals
manchester_code=[];
PPM_4=[];
base_signal=[];
input(len+1)=0;


while j<=1
    while i<=len
        if input(i)== 1 %If the bit is 1
            baseband_signal=[ones(1,100)];%baseband signal
            m=[0*ones(1,50) ones(1,50)]; %manchester
            n4 =[0*ones(1,25) ones(1,25) 0*ones(1,50)]; % new 4 scheme PPM
            inv_state=inv_state*0;%switch signal state
            
        else %If the bit is 0
            baseband_signal=[0*ones(1,100)];%baseband signal
            m=[ones(1,50) 0*ones(1,50)]; % manchester
            n4 =[0*ones(1,50) ones(1,25) 0*ones(1,25)]; % PPM minimum width between peaks 50%

            if input(i+1)==0 %If the next bit is 0
                inv_state=inv_state*0; %switch signal state
            end
            
        end
        
        %store the generated signals
        manchester_code= [manchester_code m];
        PPM_4= [PPM_4 n4];
        i=i+1;%Increment of the cycle
        s=[];%Reset temporal matrix s.
        m=[];
        n4=[];
    end
    j = j+1;
end

%modified miller expected
initial_state_mod_miller=1;
inv_state_mod_miller=initial_state_mod_miller;
mod_miller_code=[];%Null matrix to code signal.
base_signal=[];%Null matrix to original signal.

while i<=len
    if input(i)==1 %If the bit is 1
        baseband_signal=[ones(1,100)];%baseband signal
        s_mod= [0*inv_state_mod_miller*ones(1,50) inv_state_mod_miller*ones(1,25) 0*inv_state_mod_miller*ones(1,25)]; %modified miller coding   
    else %If the bit is 0
        baseband_signal=[0*ones(1,100)];%baseband signal
        s_mod=[inv_state_mod_miller*ones(1,25) 0*inv_state_mod_miller*ones(1,75)]; % modified miller
        if (i>1 && input(i-1)==1) || i == 1%If the next bit is 0
           s_mod=[0*inv_state_mod_miller*ones(1,100)]; %switch signal state
        else
           s_mod=[inv_state_mod_miller*ones(1,25) 0*inv_state_mod_miller*ones(1,75)];
        end 
    end
    mod_miller_code=[mod_miller_code s_mod];%store miller signals
    base_signal=[base_signal baseband_signal];%store base signal
    i=i+1;%Increment of the cycle
    s_mod=[];%Reset temporal matrix s.
end

 % THIS IS THE PLOT SECTION
 
X = 1:800;

%MANCHESTER CODE
plot(X*0.0000625+0.0098, manchester_code,'--', 'Linewidth',1.5)%expected
axis([0 100*(length(input)-1) 0 1.1])%
hold on
plot(t,a, 'Linewidth',1.5) % observed
axis([0.011 0.06 0 1.25]) %timescale


% %modified miller
% plot(X*0.0000625+0.04, mod_miller_code,'--', 'Linewidth',1.5)%expected
% plot(mod_miller_code,'LineWidth',2)%expected
% axis([0 100*(length(input)-1) 0 1.1])%
% hold on
% plot(t,c) %observed
% axis([0.04 0.09 0 1.1])


%PPM CODE
% plot(X*0.0000625+0.0131, PPM_4,'--', 'Linewidth',1.5)%expected
% axis([0 100*(length(input)-1) 0 1.1])%
% hold on
% plot(t,e) %observed
% axis([0.014 0.066 0 1.25]) 

legend('expected','observed');


ylabel('signal amplitude')
xlabel('time (s) ')  
plotnumber =0;
set(gca, 'fontsize', 16)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 450 300]);% set(gca,'fontsize', 25);
grid on 
ylabel('Normalized amplitude')

