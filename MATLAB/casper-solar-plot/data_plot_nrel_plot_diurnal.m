%{

    /*******************************\
    |                               |
    |       Casper van Wezel        |
    |       2018-12-11              |
    |                               |
    \*******************************/
%}

clc
clear all
close all

EXPORT_PLOTS = 0;

system_parameters;

%%
load('data_nrel_2012.mat');
time_data = time_start_data + seconds(time_data);

N = size(GHI,1);
N_per_day = 12*24;
N_days = N/N_per_day;

r = reshape(GHI,[N_per_day N_days]);
time_r = time_data(1:N_per_day);
%%

day_treshold = 1;
day = GHI>day_treshold;
night = ~day;


figure;
hold on;
plot(time_data,GHI,'DisplayName','data');
ylabel('Irradiation [W/m^2]');
title('N. Carolina, Fs = 15min');
hold on;
plot([time_data(1),time_data(end)],[irradiance irradiance],'DisplayName','Power');
plot([time_data(1),time_data(end)],[i1 i1],'DisplayName','1-5m');
plot([time_data(1),time_data(end)],[i2 i2],'DisplayName','>70m');
legend('Location','Best');

figure;
hold on;
plot(r,'-');

hold on;
plot([1,N_per_day],[irradiance irradiance],'DisplayName','Power');
plot([1,N_per_day],[i1 i1],'DisplayName','1-5m');
plot([1,N_per_day],[i2 i2],'DisplayName','>70m');
% legend('Location','Best');


%%
season_names = {'spring';'summer';'fall';'winter'};
time_season = season(time_data);
figure;
hold on;
colors = get(gcf,'defaultAxesColorOrder');
% S = cell(4,1);
markers = {'--','-','-.',':'};
for s = 1:4
% for s = [2 1 3 4]
    r = reshape(GHI(time_season==s),N_per_day,[]);
%     S{s} = r;
    mins(s,:) = min(r')';
    maxs(s,:) = max(r')';
    handles = plot(time_r,r,'Color',[1 1 1]*0.9,'LineWidth',0.02);
    handles_first(s) = handles(1);
%     plot(time_r,mean(r,2),'*-','Color',colors(s,:),'LineWidth',2);
%     plot(time_r,mean(r,2),'Color',[0 0 0],'LineWidth',2);
%     plot(maxs(s,:),'+-','Color',colors(s,:),'LineWidth',2);
%     plot(mins(s,:),'*-','Color',colors(s,:),'LineWidth',2);
end
for s = 1:4
    r = reshape(GHI(time_season==s),N_per_day,[]);
    
    handles_first(s) = plot(time_r,mean(r,2),markers{s},'Color',[0 0 0],'LineWidth',1);
%     handles_first(s) = plot(time_r,mean(r,2),'.-','Color',colors(s,:),'LineWidth',2);
end
legend(handles_first,season_names);
legend('Location','Best');
ylabel('Irradiation [W/m^2]');
set(gca, 'fontsize', 14)
set(gcf, 'Position', [300+0*50 240+0*20 500 300]);
hold on;
gca.ColorOrderIndex = 1;
plot([time_r(1) time_r(end)],[irradiance irradiance],'Color','c','DisplayName','Power','LineWidth',2);
plot([time_r(1) time_r(end)],[i1 i1],'--','Color',colors(1,:),'DisplayName','1-5m','LineWidth',2);
plot([time_r(1) time_r(end)],[i2 i2],'.-','Color',colors(1,:),'DisplayName','>50m','LineWidth',2);

grid on;
grid minor;

if (EXPORT_PLOTS)
    saveas(gcf,'diurnal_energy.fig');
    saveas(gcf,'diurnal_energy.png');
    % matlab2tikz('./diurnal_energy.tikz','height','\figureheight','width','\figurewidth','showInfo',false);
end

%% Create logical vectors for 'on' times for specific cases
system_on = GHI>irradiance;
system_on_day = system_on & day;
system_1 = GHI>i1;
system_2 = GHI>i2;
system_1_day = system_1 & day;
system_2_day = system_2 & day;


disp('system_on');
sum(system_on)/N
disp('system_on_day');
sum(system_on_day)/sum(day)

disp('system_1');
sum(system_1)/N
disp('system_1_day');
sum(system_1_day)/sum(day)

disp('system_2');
sum(system_2)/N
disp('system_2_day');
sum(system_2_day)/sum(day)

disp('Not enough power, but enough light to comm. 200Lux')
sum(system_1 & ~system_on)/N

battery_operation = system_1 & ~system_on;

% https://nl.mathworks.com/matlabcentral/answers/281373-longest-sequence-of-1s
measurements = regionprops(battery_operation, 'Area');
battery_time_max = max([measurements.Area]);

disp('duration of longest period [in hours]')
battery_time_max = battery_time_max/12

figure;
hold on;
plot(time_data(battery_operation),GHI(battery_operation),'DisplayName','data');
ylabel('Radiation [W/m^2]');
title('N. Carolina, Fs = 15min');
hold on;

%%
% Calculate on percentages per season
for s = 1:4
    disp('-----------------------------------');
    disp(['Season' num2str(s)]);
    Ns = sum((time_season==s));
    dayS = day &(time_season==s)';

    system_on = GHI>irradiance & (time_season==s)';
    system_on_day = system_on & dayS;
    system_1 = GHI>i1 & (time_season==s)';
    system_2 = GHI>i2 & (time_season==s)';
    system_1_day = system_1 & dayS;
    system_2_day = system_2 & dayS;


    system_onp(s) = sum(system_on)/Ns;
    system_on_dayp(s) = sum(system_on_day)/sum(dayS);

    system_1p(s) = sum(system_1)/Ns;
    system_1_dayp(s) = sum(system_1_day)/sum(dayS);

    system_2p(s) = sum(system_2)/Ns;
    system_2_dayp(s) = sum(system_2_day)/sum(dayS);
end

    disp('system_on');
    disp(system_onp);
    disp('system_on_day');
    disp(system_on_dayp);


    disp('system_1');
    disp(system_1p);
    disp('system_1_day');
    disp(system_1_dayp);

    disp('system_2');
    disp(system_2p);
    disp('system_2_day');
    disp(system_2_dayp);

%% Display seasonal percentages
figure;
hold on;
plot(system_onp,'DisplayName','system\_on');
plot(system_on_dayp,'DisplayName','system\_on\_day');
plot(system_1p,'DisplayName','system\_1');
plot(system_1_dayp,'DisplayName','system\_1\_day');
plot(system_2p,'DisplayName','system\_2');
plot(system_2_dayp,'DisplayName','system\_2\_day');
legend('Location','Best');
