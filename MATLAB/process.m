close all

%Barcode: 0100101101001100101101010011001010100
%Barcode: 01001101001011001010100

S1 = importdata('20180119carb40kmh2m5.dat');
S2 = importdata('20180119carb40kmh3m.dat');
S3 = importdata('20180119car40kmh3m.dat');
S4 = importdata('20180119car25kmh3m.dat');
S5 = importdata('20180119car55kmh4m.dat');

% disp('Barcode B, 40 km/h 2.5m distance');
% consume(S1);
% disp('Barcode B, 40 km/h 3m distance');
% consume(S2);
% disp('Barcode A, 40 km/h 3m distance');
% consume(S3);
% disp('Barcode A, 25 km/h 3m distance');
% consume(S4);
% disp('Barcode A, 55 km/h 4m distance');
% consume(S5);

disp('Barcode B, 40 km/h 2.5m distance');
consume(S1(1020000:1080000));
disp('Barcode B, 40 km/h 3m distance');
consume(S2(560000:610000));
disp('Barcode A, 40 km/h 3m distance');
consume(S3(490000:530000));
disp('Barcode A, 25 km/h 3m distance');
consume(S4(430000:500000));
disp('Barcode A, 55 km/h 4m distance');
consume(S5(710000:760000));

%01001101001011001010100
%01001101001011001010100
%00101101001011001101001010110011010100
% 0100101101001100101101010011001010100

%Create a beautiful plot
figure();
% plot(S5(710000:760000));
plot(8.6:0.00002:10, S4(430000:500000));
axis([8.7 9.8 1600 3200]);
grid();
title('Received barcode signal at 4m distance');
ylabel('ADC Output');
xlabel('time (s)');
