clc;
close all;
clear all;

input=[0 0 0 1 0 1 1 0];
initial_state=1;
inv_state=initial_state;
len=length(input);
i=1;
mod_miller_code=[];%Null matrix to code signal.
base_signal=[];%Null matrix to original signal.
input(len+1)=1;

while i<=len
    if input(i)==1 %If the bit is 1
        baseband_signal=[ones(1,100)];%baseband signal
        s_mod= [-inv_state*ones(1,50) inv_state*ones(1,25) -inv_state*ones(1,25)]; %modified miller coding   
    else %If the bit is 0
        baseband_signal=[-1*ones(1,100)];%baseband signal
        s_mod=[inv_state*ones(1,25) -inv_state*ones(1,75)]; % modified miller
        if (i>1 && input(i-1)==1) || i == 1%If the next bit is 0
           s_mod=[-inv_state*ones(1,100)]; %switch signal state
        else
           s_mod=[inv_state*ones(1,25) -inv_state*ones(1,75)];
        end 
    end
    mod_miller_code=[mod_miller_code s_mod];%store miller signals
    base_signal=[base_signal baseband_signal];%store base signal
    i=i+1;%Increment of the cycle
    s_mod=[];%Reset temporal matrix s.
end

plot(mod_miller_code,'LineWidth',2)%
% hold on 
% plot(y,'LineWidth',2)
% title('MODIFIED MILLER CODE')
axis([0 100*(length(input)-1) -1 1])%
grid on %
xticks(0:100:100*length(input)-1)%

plotnumber =0;

set(gca, 'fontsize', 25)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 800 400]);% set(gca,'fontsize', 25);
