function output = consume(A)
    min_length = 12;
    output = 1;
    s_min = zeros(size(A));
    s_max = zeros(size(A));
    threshold = zeros(size(A));
    symbol = zeros(size(A));

    edge = zeros(size(A));
    s_minmax = zeros(size(A));
    edge_threshold = 100;
    last_edge = 0;
    bc_index = 1;
    bc_timings_black = [];
    bc_timings_white = [];
    quiet_threshold = 10000;
    
    for i = 2:length(A)
        symbol(i) = symbol(i-1);
        s_minmax(i) = s_minmax(i-1);
        if (symbol(i) == 0)
            if (A(i) < s_minmax(i))
                s_minmax(i) = A(i);
            end
            if (A(i) >= s_minmax(i) + edge_threshold)
                edge(i) = 1;
                s_minmax(i) = A(i);
                symbol(i) = 1;
                bc_timings_black(bc_index) = i - last_edge;
                bc_index = bc_index + 1;
                last_edge = i;
            end
        else
            if (A(i) > s_minmax(i))
                s_minmax(i) = A(i);
            end
            if (A(i) <= s_minmax(i) - edge_threshold)
                edge(i) = -1;
                s_minmax(i) = A(i);
                symbol(i) = 0;
                bc_timings_white(bc_index) = i - last_edge;
                last_edge = i;
            end        
        end
        if ((edge(i) ~= 0 || last_edge < i-quiet_threshold) && bc_index > 4)
            %start decoding
            minimum_black = min(bc_timings_black(bc_timings_black>0));
            minimum_white = min(bc_timings_white(bc_timings_white>0));
            average_black_narrow = mean(bc_timings_black(bc_timings_black<(minimum_black*1.5)));
            average_white_narrow = mean(bc_timings_black(bc_timings_black<(minimum_white*1.5)));
            threshold_black = 1.4*average_black_narrow;
            threshold_white = 1.4*average_white_narrow;
            quiet_threshold = (average_black_narrow+average_white_narrow)*1.6;
            output = '';
            if (last_edge < i-quiet_threshold)
                if (edge(last_edge) == -1)
                   bc_timings_black(bc_index) = quiet_threshold;
                   bc_index = bc_index + 1;
                end
                for j = 1:(bc_index-1)
                    if (bc_timings_white(j) > 0)
                        if (bc_timings_white(j) > quiet_threshold)
                            if (length(output) >= min_length)
                                disp(output)
                            end
                            output = '';
                        else
                            output = [output '1'];
                            if (bc_timings_white(j) > threshold_white)
                                output = [output '1'];
                            end
                        end
                    end
                    if (bc_timings_black(j) > 0)
                        output = [output '0'];
                        %length of first bar can be detected incorrectly
                        %we always start with a narrow stripe
                        if (length(output) > 1 && bc_timings_black(j) > threshold_black)
                            output = [output '0'];
                        end
                    end              
                end
                if (length(output) >= min_length)
                    disp(output)
                end
                quiet_threshold = 10000;
                bc_index = 1;
                bc_timings_black = [];
                bc_timings_white = [];
            end
            
            
%         elseif (last_edge < i-quiet_threshold)
%             %Nothing to decode, but perform a reset
%             quiet_threshold = 10000;
%             bc_index = 1;
%             bc_timings_black = [];
%             bc_timings_white = [];
        end
    end

    figure();
    xmin = 1;
    xmax = length(A);

    p3 = subplot(313);
    hold on
    h3 = get(p3, 'position');
    h3(4) = h3(4) * 2/3;
    % set(p3, 'position', h3);
    xlabel('Sample number (time)');
    ylabel('Decoded signal');
    plot(symbol)
    grid()
    axis([xmin xmax -0.1 1.1]);

    p2 = subplot(312);
    hold on;
    h2 = get(p2, 'position');
    h2(4) = h2(4) *2/3;
    h2(2) = h2(2)-h2(4)/2;
    % set(p2, 'position', h2);
    plot(edge);
    ylabel('Edges');
    xlabel('Sample number (time)');
    grid()
    axis([xmin xmax -1.1 1.1]);


    p1 = subplot(311);
    h1 = get(p1, 'position');
    h1(2) = h1(2)-h1(4)*2/3;
    h1(4) = h1(4)*5/3;
    % set(p1, 'position', h1);
    plot(A);
    ylabel('ADC Output');
    xlabel('Sample number (time)');
    title('Received barcode signal and decoding');
    grid()
    axis([xmin xmax min(A)-50 max(A)+50]);




    %set(h, 'position');
    % hold on
    % plot(threshold);
    % plot(630 + 10*symbol)
    % plot(620 + 6*edge);
    % plot(s_min, '--')
    % plot(s_max, '--')
    %plot(s_minmax, '--');
