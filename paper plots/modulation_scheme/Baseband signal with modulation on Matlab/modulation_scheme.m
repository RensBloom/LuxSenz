%---------- Modulation for 8 bit binary sequence representing --------
%----------  ASCII synchronization character 22 --------
close all;
clear all;
input=[0 0 0 1 0 1 1 0]; % change the input data bits to visualize any other data sequence
initial_state=-1;
inv_state=initial_state;
len=length(input);
time_period = 0;
i=1;
% initialize null matrices to store the signals
miller_code=[];
manchester_code=[];
PPM_2=[];
PPM_2_inv=[];
PPM_4=[];
PPM_4_inv=[];
pwm_code= [];
base_signal=[];
input(len+1)=0;


while j<=1
    while i<=len
        if input(i)==1 %If the bit is 1
            baseband_signal=[ones(1,100)];%baseband signal
            s=[inv_state*ones(1,50) -inv_state*ones(1,50)]; %miller coded
            m=[ones(1,50) -1*ones(1,50)]; %manchester
            n2 =[ones(1,25) -1*ones(1,75)]; % new 2 scheme PWM
            n3 =[-1*ones(1,25) ones(1,75)]; % new 3 scheme -- inverted new 2 PWM
            n4 =[-1*ones(1,25) ones(1,25) -1*ones(1,50)]; % new 4 scheme PPM
            n5 =[ones(1,25) -1*ones(1,25) ones(1,50)]; % new 5 scheme -- inverted new 4 PPM
            p1 =[ones(1,30) -1*ones(1,70)]; % pwm encoding
            inv_state=inv_state*-1;%switch signal state
            
        else %If the bit is 0
            baseband_signal=[-1*ones(1,100)];%baseband signal
            s=[inv_state*ones(1,100)]; %miller
            m=[-1*ones(1,50) ones(1,50)]; % manchester
            n2=[-1*ones(1,50) ones(1,25) -1*ones(1,25)]; % PPM minimum width between peaks 25%
            n3=[ones(1,50) -1*ones(1,25) ones(1,25)]; % PPM minimum width between peaks 50% -- inverted
            n4 =[-1*ones(1,50) ones(1,25) -1*ones(1,25)]; % PPM minimum width between peaks 50%
            n5 =[ones(1,50) -1*ones(1,25) ones(1,25)]; % PPM minimum width between peaks 50% -- inverted
            p1 =[ones(1,25) -1*ones(1,75)]; % pwm encoding
            if input(i+1)==0 %If the next bit is 0
                inv_state=inv_state*-1; %switch signal state
            end
            
        end
        
        %store the generated signals
        miller_code=[miller_code s];
        base_signal=[base_signal baseband_signal];
        manchester_code= [manchester_code m];
        PPM_2= [PPM_2 n2];
        PPM_2_inv= [PPM_2_inv n3];
        PPM_4= [PPM_4 n4];
        PPM_4_inv= [PPM_4_inv n5];
        pwm_code= [pwm_code p1];
        i=i+1;%Increment of the cycle
        s=[];%Reset temporal matrix s.
        m=[];
        n2=[];
        n3=[];
        n4=[];
        n5=[];
        p1=[];
    end
    j = j+1;
end

plot(PPM_4,'LineWidth',2)% %manchester_code, miller_code, PPM_4
axis([0 100*(length(input)-1) -1.1 1.1])%
grid on %
xticks(0:100:100*length(input)-1)%


plotnumber =0;

set(gca, 'fontsize', 25)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 800 400]);% set(gca,'fontsize', 25);
