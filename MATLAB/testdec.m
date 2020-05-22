a = (importdata('20180724fsk26.dat'));
for n = 13
    circuit = 'j';
    T = importdata(['t' int2str(n) circuit '.dat']);
    Y = importdata(['y' int2str(n) circuit '.dat']);
    aa = resample(Y,T,10000);
%     a = conv(a, [1 1 1]);
    a = aa;
    % close all;
%     f = fir1(200, [280/25000 390/25000]);
    f = zeros(400,1); f(1) = 1;
    l = fir1(400,[10/25000]);
    a2 = conv(ones(1,50)/50,a);
    a2 = conv(f, a)/sum(f);
    m = conv(l, a)/sum(l);
    % b = (a2 > sqrt(meansqr(a2)));
    % b = (a2 > (mean(a2)));
    power = a2 - m(1:length(a2));
    power = power(10000:(length(power)-10000));
    power = rms(power)
    b = (a2 > m(1:length(a2)));
    c = diff(b);
    d = find(c>0);
    d3 = find (c<0);
    d5 = find(c);
    e = diff(d);
    e3 = diff(d3);
    e5 = diff(d5);
    X = zeros(1, length(e));
    E = X;
    X2 = X;
    E2 = E;
    X3 = X;
    E3 = X;
    X4 = X;
    E4 = X;
    X5 = zeros(1,length(e5));
    E5 = X5;
    for i=1:length(e)
       X(i) = d(i+1);
       E(i) = e(i);
       X3(i) = d3(i+1);
       E3(i) = e3(i);
       smax = 0;
       smin = 100000;
       for j = d(i):d(i+1)
          if (a2(j) > smax)
              smax = a2(j);
              X2(i) = j;
          end
          if (a2(j) < smin)
              smin = a2(j);
              X4(i) = j;
          end
          if (i > 1)
              E2(i) = X2(i) - X2(i-1);
              E4(i) = X4(i) - X4(i-1);
          end
       end
    end
    E3C = E3;
    for i=1:length(e5)
       X5(i) = d5(i+1);
       E5(i) = e5(i);
    end
    
        err_prev = 0;
        err_next = 0;
    for i=2:(length(E3)-1)
        if (E3(i-1) > 211)
            err_prev = E3(i-1)-222;
        else
            err_prev = E3(i-1)-200;
        end
        if (E3(i+1) > 211)
            err_next = E3(i+1)-222;
        else
            err_next = E3(i+1)-200;
        end
        E3C(i) = E3(i) + err_prev/2 + err_next/2;
    end
    
    
    figure()
    plot(a2);
    grid(gca,'minor'); grid on
    hold on
     title(['Trace from LT Spice simulation results: ' int2str(n) circuit])
    plot(m)
  
%     figure()
%     plot(X,E, '.-b');
%     grid(gca,'minor'); grid on
%     hold on
%     figure()
%     plot(X2,E2, '.-r');
%     grid(gca,'minor'); grid on
%     figure()
%     plot(X4,E4, '.-c');
%     grid(gca,'minor'); grid on
    figure()
    plot(X3,E3, '.-k');  %Best option! Zero crossing, time difference between falling edges.
    grid(gca,'minor'); grid on
    title(['Decoding from LT Spice simulation results: ' int2str(n) circuit])
%     hold on
%     plot(X5,E5,'.-r');

%     figure()
%     plot(X3,E3C, '.-b');  %Best option! Zero crossing, time difference between falling edges.
%     grid(gca,'minor'); grid on
%     title(['Decoding from LT Spice simulation results: ' int2str(n)])
    % figure()

    peaks = zeros(length(a2),1);
    maxes = peaks;
    count = 0;
    a3 = floor(a2);
    for i = 2:(length(a2)-1)
        maxes(i) = maxes(i-1);
        if (a3(i) >= maxes(i))
            maxes(i) = a3(i);
            count = 0;
        else
            if (count == 100)
                peaks(i-100) = 1;
                count = -1000;
                maxes(i) = a3(i)+2;
            end

            count = count + 1;
        end
    end
    % plot(a2);
    % hold on
    % plot(peaks*300+2500);
    % plot(maxes);
    q = find(peaks);
    r = diff(q);
    % plot(r, '.-')
    % grid(gca,'minor'); grid on

    % plot(a2)
    % w190 = 190/50000*2*pi;
    % w200 = 200/50000*2*pi;
    % s190 = zeros(length(a2),1);
    % s200 = s190;
    % y190 = s190;
    % y200 = s200;
    % 
    % for i=3:length(a2)
    %     s190(i) = a2(i) + 2*cos(w190)*s190(i-1) - s190(i-2);
    %     s200(i) = a2(i) + 2*cos(w200)*s200(i-1) - s200(i-2);
    %     y190(i) = s190(i) - exp(-1i*w190)*s190(i-1);
    %     y200(i) = s200(i) - exp(-1i*w200)*s200(i-1);
    % end
end