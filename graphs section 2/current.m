
c_v_5v = [
3.2
9.2
17.9
26.7
35.4
41.2
47.3
52.8
61.4
69.7];
c_v_5v=c_v_5v';

c_v_10v =[5.9
15.9
29
43
58.8
66.6
77
84
99
109.8
];
c_v_10v =c_v_10v';

c_3_5v =[1.6
4.5
8.8
12
15.6
17.5
20
22
25.5
28.5
];
c_3_5v=c_3_5v';

freq =[10
30
60
90
120
140
160
180
210
240];

plot(freq,c_v_5v,'-o','Markersize',10,'Linewidth', 2)
hold on
plot(freq,c_v_10v,'-s','Markersize',10,'Linewidth', 2) 
hold on
plot(freq,c_3_5v,'-^','Markersize',10,'Linewidth', 2) 
plotnumber=0;
grid on
plotnumber =0;
set(gca, 'fontsize', 16)
set(gcf, 'Position', [300+plotnumber*50 240+plotnumber*20 600 400]);% set(gca,'fontsize', 25);
xlabel('Operating frequency (Hz)')
ylabel('Current (\muA)')
% title('Current conusmption')
legend('Video shutter 5 V', 'Video shutter 10 V', '3D shutter 5 V','Location','northwest')
