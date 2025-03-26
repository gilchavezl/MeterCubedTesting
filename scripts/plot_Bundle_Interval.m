function plot_Bundle_Interval (bundle, start_date, end_date, legacyTemps, tic0_temps, tic1_temps)

    % Create directory for storing plots if it doesn't exist
    if ~exist('../plots', 'dir')
        mkdir('../plots');
    end

    % Filter data based on time range
    legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_date & legacyTemps.Timestamp <= end_date, :);
    tic0_filtered = tic0_temps(tic0_temps.Time >= start_date & tic0_temps.Time <= end_date, :);
    tic1_filtered = tic1_temps(tic1_temps.Time >= start_date & tic1_temps.Time <= end_date, :);

    % Extract time data
    legacy_time = legacy_filtered.Timestamp;
    tic0_time = tic0_filtered.Time;
    tic1_time = tic1_filtered.Time;

    % Smooth the data
    tic0_filtered.TC0 = smoothdata(tic0_filtered.TC0, 'movmedian', 60);
    tic0_filtered.TC1 = smoothdata(tic0_filtered.TC1, 'movmedian', 60);
    tic0_filtered.TC2 = smoothdata(tic0_filtered.TC2, 'movmedian', 60);
    tic0_filtered.TC3 = smoothdata(tic0_filtered.TC3, 'movmedian', 60);
    tic0_filtered.TC4 = smoothdata(tic0_filtered.TC4, 'movmedian', 60);

    tic1_filtered.TC0 = smoothdata(tic1_filtered.TC0, 'movmedian', 60);
    tic1_filtered.TC1 = smoothdata(tic1_filtered.TC1, 'movmedian', 60);
    tic1_filtered.TC2 = smoothdata(tic1_filtered.TC2, 'movmedian', 60);
    tic1_filtered.TC3 = smoothdata(tic1_filtered.TC3, 'movmedian', 60);
    tic1_filtered.TC4 = smoothdata(tic1_filtered.TC4, 'movmedian', 60);

    bundle_data = {
        % Bundle 1
        {legacy_filtered.col7, tic0_filtered.TC2, tic1_filtered.TC3, tic1_filtered.TC4}, {'Legacy 0011', 'TC02', 'TC13', 'TC14'}, {[1.0, 0.5, 0.0], [0.8, 0.6, 0.1], [0.6, 0.3, 0.6], [0.5, 0.5, 0.5]};
        % Bundle 2
        {legacy_filtered.col9, tic0_filtered.TC1, tic0_filtered.TC3, tic1_filtered.TC2}, {'Legacy 0014', 'TC01', 'TC03', 'TC12'}, {[0.1, 0.4, 0.8], [0.3, 0.3, 0.3], [0.6, 0.3, 0.6], [0.8, 0.6, 0.1]};
        % Bundle 3
        {legacy_filtered.col4, tic0_filtered.TC0, tic0_filtered.TC4, tic1_filtered.TC1}, {'Legacy 0004', 'TC00', 'TC04', 'TC11'}, {[0.8, 0.2, 0.2], [0.2, 0.6, 0.2], [0.5, 0.5, 0.5], [0.3, 0.3, 0.3]};
    };

    figure;
    hold on;

    % Plot legacy data
    if ~isempty(bundle_data{bundle, 1}{1}) && ~isempty(legacy_time)
        plot(legacy_time, bundle_data{bundle, 1}{1}, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{1});
    end
    % Plot new thermocouple data, handling different combinations of TIC0 and TIC1
    for k = 2:length(bundle_data{bundle, 1})
        current_data = bundle_data{bundle, 1}{k};
        if ~isempty(current_data)
            if contains(bundle_data{bundle, 2}{k}, 'TC0') && ~isempty(tic0_time)
                plot(tic0_time, current_data, 'LineWidth', 2, 'LineStyle','-' , 'Color', bundle_data{bundle, 3}{k});
            elseif contains(bundle_data{bundle, 2}{k}, 'TC1') && ~isempty(tic1_time)
                plot(tic1_time, current_data, 'LineWidth', 2, 'LineStyle','--' , 'Color', bundle_data{bundle, 3}{k});
            end
        end
    end

    legend(bundle_data{bundle, 2}{:}, 'Location', 'best');
    title(sprintf('Bundle %d - Time vs Temperature', bundle));
    xlabel('Time');
    ylabel('Temperature (°C)');
    %saveas(gcf, fullfile('../plots', sprintf('Temp_Interval_%d_%d_Bundle_%d_Time_vs_Temp.png', temp_intervals(i, 1), temp_intervals(i, 2), j)));

    figure()
    if bundle == 1
        diff_1 = bundle_data{bundle, 1}{2} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic0_time, 'linear', 'extrap');
        plot(tic0_time, diff_1, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{2});
        
        hold on;
    
        diff_2 =  bundle_data{bundle, 1}{3} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic1_time, 'linear', 'extrap');
        plot(tic1_time, diff_2, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{3});
    
        diff_3 = bundle_data{bundle, 1}{4} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic1_time, 'linear', 'extrap');
        plot(tic1_time, diff_3, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{4});
    else
        diff_1 = bundle_data{bundle, 1}{2} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic0_time, 'linear', 'extrap');
        plot(tic0_time, diff_1, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{2});
    
        hold on;
    
        diff_2 = bundle_data{bundle, 1}{3} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic0_time, 'linear', 'extrap');
        plot(tic0_time, diff_2, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{3});
    
        diff_3 = bundle_data{bundle, 1}{4} - interp1(legacy_time, bundle_data{bundle, 1}{1}, tic1_time, 'linear', 'extrap');
        plot(tic1_time, diff_3, 'LineWidth', 2, 'Color', bundle_data{bundle, 3}{4});
    end 
    legend(bundle_data{bundle, 2}{2:4}, 'Location', 'best');
    title(sprintf('Bundle %d ΔT - Time vs ΔTemperature', bundle));
    xlabel('Time');
    ylabel('ΔTemperature  (°C)');
end