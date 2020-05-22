data = xlsread('performance4matlab.xlsx');
colnames = ["id", "set", "FSK f1", "FSK f2", "Duty Cycle (%)", "Balanced?", "Receiver", "MCU", "Surface", "f", "Location", "Location", "Surface (cm2)", "Battery voltage Transmitter", "Distance (m)", "offset (cm)", "Receiver light intensity", "Transmitter light intensity", "Receiver light intensity", "Transmitter light intensity", "error bits", "total bits", "BER", "error packets", "total packets", "PLR", "S1", "S2", "P3", "S1 no shutter", "S1 amplitude/lux","S1 delta", "S1 delta per lux", "X (cm)", "Y (cm)", "Sideways offset (m)", "Distance (m)", "lux sets", "Bit succes rate", "Packet succes rate"];
%important column numbers:
%15 distance
%23 BER, 39 BSR
%26 PLR, 40 PSR
%27 S1
close all

for plotnumber = 0:10
filename = ['plot' num2str(plotnumber)]; %default filename for the output eps file.
plotstyle = "full";
setAxis = []; %automatic axis

switch plotnumber
    case 0
%plot PSR/distance grouped by light intensity.
plotsets = [-1 -2 -3 -4]; %negative numbers refer to column "lux sets"
setnames = ["150-390 lux","400-800 lux","0.9-9 klux", "10-26 klux"]; %names
columnx = 15; %distance
columny = 40;
graphtitle = "Performance";
plotstyle = "points";
filename = "PLR_light";

    case 1
%plot BER/distance for 2x 3D glass shutter at 560/640 Hz, outdoors
plotsets = [11 2 8 12]; %Set data series sources (numers from colum set)
setnames = ["1klux","6-13klux","8klux","20-26klux"]; %names
columnx = 15; %distance
columny = 23;
graphtitle = "?";
    case 2
%plot PSR/distance for 2x and 4 3D glass shutter at 560/640 Hz, outdoors late
plotsets = [10 11]; %Set data series sources (numers from colum set)
setnames = ["4 shutters", "2 shutters"]; %names
columnx = 15; %distance
columny = 40;
graphtitle = "Performance outdoors (sunset)";
filename = "sunset_2_4_shutter";
    case 3
%plot PLR/distance for 1x and 2x 3D glass shutter at 560/640 Hz, sunny
plotsets = [12 13]; %Set data series sources (numers from colum set)
setnames = ["2 shutters", "1 shutters"]; %names
columnx = 15; %distance
columny = 40;
graphtitle = "Performance outdoors (sunny)";
filename = "sunny_1_2_shutter";
    case 4
%plot Amplitude vs PSR
plotsets = 1:15; %Set data series sources (numers from colum set)
setnames = []; %names
columnx = 29;
columny = 40; %PSR
graphtitle = "Amplitude vs PSR";
    case 5
%plot Amplitude vs distance indoor
plotsets = 16; %Set data series sources (numers from colum set)
setnames = []; %names
columnx = 15; %distance
columny = 31;
graphtitle = "Social Data Lab (400 hz LED)";
            case 6
%plot BER/distance, compare with polarizer and without polarizer
plotsets = [21 23]; %Set data series sources (numers from colum set)
setnames = ["Polarizer on transmitter","Polarizer on receiver"]; %names
columnx = 15; %distance
columny = 23;
graphtitle = "BER Indoor (+/- 400 Lux)";
            case 7
%plot PLR/distance, compare with polarizer and without polarizer
plotsets = [21 23]; %Set data series sources (numers from colum set)
setnames = ["Polarizer on transmitter","Polarizer on receiver"]; %names
columnx = 15; %distance
columny = 40;
graphtitle = "Performance Indoor (± 400 Lux)";
filename = "polarizer_effect";
        
            case 8
%plot PLR/distance, compare with polarizer and without polarizer
plotsets = [27 26]; %Set data series sources (numers from colum set)
setnames = ["Outdoor","Indoor"]; %names
columnx = 36;
columny = 37;
graphtitle = "Coverage";
plotstyle = "line";
setAxis = [-10 10 0 70];
filename = "coverage_plot";

            case 9
%plot PLR/distance, compare with polarizer and without polarizer
plotsets = [27]; %Set data series sources (numers from colum set)
setnames = ["Outdoor"]; %names
columnx = 36;
columny = 37;
graphtitle = "Coverage";
plotstyle = "line";
setAxis = [-10 10 0 70];
filename = "coverage_plot_outdoor";

            case 10
%plot PLR/distance, compare with polarizer and without polarizer
plotsets = [26]; %Set data series sources (numers from colum set)
setnames = ["Indoor"]; %names
columnx = 36;
columny = 37;
graphtitle = "Coverage";
plotstyle = "line";
setAxis = [-1 1 0 7];
filename = "coverage_plot_indoor";

end

if plotstyle == "full"
    drawstyles = ["xk-" "+g--" "dr:" "^m-" "ob--" "sc:" "pk-." "xg:" "+r-" "dm--" "^b:" "oc-" "vk:" "pg-." "xr--" "+m:" "db-" "^c-."];
elseif plotstyle == "line"
    drawstyles = [ "k--" "g-"  "r:" "m-" "b--" "c:" "k-." "g:" "r-" "m--" "b:" "c-" "k:" "g-." "r--" "m:" "b-" "c-."];
elseif plotstyle == "points"
    drawstyles = ["xk" "+g" "dr" "^m" "ob" "sc" "pk" "xg" "+r" "dm" "^b" "oc" "vk" "pg" "xr" "+m" "db" "^c"];    
end
j = 1;
figure()
for p = plotsets %for all data series
	X = [];
    Y = [];
    for i=1:size(data,1) %scan rows in spreadsheet
        if data(i,2) == p || (p < 0 && -p == data(i,38))
            X = [X data(i,columnx)];
            Y = [Y data(i,columny)];
        end
    end
    plot(X,Y,drawstyles(j),'LineWidth',1.5, 'MarkerSize',10)
    hold on;
    j = j + 1;
end
hold off;
xlabel(colnames(columnx));
ylabel(colnames(columny));
if length(setAxis) > 0
    axis(setAxis)
end
if  ismember(columny, [23 26])
    legend(setnames, 'Location', 'northwest')
elseif  ismember(columny, [39 40])
    if plotnumber == 0
    legend(setnames, 'Location', 'south')
    else
    legend(setnames, 'Location', 'southwest')
    end
else 
    legend(setnames)
end
% title(graphtitle)
grid()
grid minor
set(gca, 'fontsize', 16)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 450 300]);

%save the figure as plot.eps
saveas(gcf,filename,'epsc')

end
