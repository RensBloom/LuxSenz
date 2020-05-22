% Script that can be used to generate sine arrays for selected frequencies,
% as used in the LuxSenz receiver software, in the decoding algorithm.
% The output of the script can be copied into coefficients.h of the LuxSenz
% receiver code.
% The frequency response of the sine array filters is shown in a graph.
% For both FSK frequencies it shows the minimum, the average and maximum
% response. N (array length) can be adjusted to get slightly different
% graphs.

fs = 18000;   %sample rate of the received signal
f_low = 560;  %lower FSK frequency
f_high =  ; %higher FSK frequency
N = 60:1:100; %length of the decoding filter (smaller than SAMPLES_PER_BIT)

f_plot_min = 1;  %minimum frequency in the plot (Hz)
f_plot_max = 1200*2; %maximum frequency in the plot (Hz)
f_plot_step = 10;  %step size in the frequency plot (Hz)

figure()

colors = ["r", "k", "c","b"];
for n=N
    colori = 1;
    hold off;
    grid on;
    pause(0.15)
    disp(['#if WINDOW_LENGTH == ' num2str(n)]);
    for fr = [f_low f_high]
        s = 200;

        cosine = round(s*cos(2*pi*fr/fs*(1:n)));
        sine   = round(s*sin(2*pi*fr/fs*(1:n)));

        disp(['#define ft_' num2str(floor(fr)) '_re ' strrep(strrep(strrep(mat2str(cosine), ' ', ', '), ']' , '}'), '[', '{') ';']);
        disp(['#define ft_' num2str(floor(fr)) '_im ' strrep(strrep(strrep(mat2str(sine), ' ', ', '), ']' , '}'), '[', '{') ';']);

        resp = [];
        for fsig=f_plot_min:f_plot_step:f_plot_max
            testn = [];
            for offset=0:0.05:6.2
                fn = 400;
                signal   = 400+round(400*sin(offset+2*pi*fsig/fs*(1:n)));

                real = abs(sum(cosine.*signal))/n;
                imag = abs(sum(sine.*signal))/n;
                norm = sqrt(real*real+imag*imag);
                testn = [testn norm];
            end
            resp = [resp; [mean(testn) max(testn) min(testn)]];
        end
        plot(f_plot_min:f_plot_step:f_plot_max, resp, colors(colori))
        colori = colori + 1;
        hold on;

        title(['Frequency response for both filters with N=' num2str(n)])
    end
end
xlabel('Frequency (Hz)');
ylabel('Normalized response');
grid on
grid minor
disp('#endif');
hold off;