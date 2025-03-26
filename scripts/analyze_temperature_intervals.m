function analyze_temperature_intervals(temp_intervals, start_dates, end_dates, sch_time, sch_temperature, legacy_time_match, tic0_time_match, tic1_time_match)
    % Analyze temperature intervals and plot data against the ideal schedule.
    % 
    % Parameters:
    %   temp_intervals: Nx2 array - Temperature ranges for each interval.
    %   start_dates: datetime array - Start times for each interval.
    %   end_dates: datetime array - End times for each interval.
    %   sch_time: datetime array - Time points of the ideal schedule.
    %   sch_temperature: double array - Temperature points of the ideal schedule.
    %   legacy_time_match: table - Legacy system temperature data with timestamps.
    %   tic0_time_match: table - TIC0 data with timestamps.
    %   tic1_time_match: table - TIC1 data with timestamps.

    % Ensure unique times for ideal schedule interpolation
    [sch_time_unique, unique_idx] = unique(sch_time);
    sch_temperature_unique = sch_temperature(unique_idx);

    % Create directory for storing plots if it doesn't exist
    if ~exist('../plots', 'dir')
        mkdir('../plots');
    end

    % Loop through each temperature interval
    for i = 1:size(temp_intervals, 1)
        % Filter data based on time range
        legacy_filtered = legacy_time_match(legacy_time_match.Timestamp >= start_dates(i) & legacy_time_match.Timestamp <= end_dates(i), :);
        tic0_filtered = tic0_time_match(tic0_temps.Time >= start_dates(i) & tic0_time_match.Time <= end_dates(i), :);
        tic1_filtered = tic1_time_match(tic0_temps.Time >= start_dates(i) & tic1_time_match.Time <= end_dates(i), :);

        % Extract time data
        legacy_time = legacy_filtered.Timestamp;
        tic0_time = tic0_filtered.Time;
        tic1_time = tic1_filtered.Time;

        % Filter ideal schedule data to match the current interval
        sch_time_interval = sch_time_unique(sch_time_unique >= start_dates(i) & sch_time_unique <= end_dates(i));
        sch_temperature_interval = sch_temperature_unique(sch_time_unique >= start_dates(i) & sch_time_unique <= end_dates(i));

        % Define bundle data and legends
        bundle_data = {
            % Bundle 1
            {legacy_filtered.col7, tic0_filtered.TC2, tic1_filtered.TC3, tic1_filtered.TC4}, {'Legacy 0011', 'TC02', 'TC13', 'TC14'};
            % Bundle 2
            {legacy_filtered.col9, tic0_filtered.TC1, tic0_filtered.TC3, tic1_filtered.TC2}, {'Legacy 0014', 'TC01', 'TC03', 'TC12'};
            % Bundle 3
            {legacy_filtered.col4, tic0_filtered.TC0, tic0_filtered.TC4, tic1_filtered.TC1}, {'Legacy 0004', 'TC00', 'TC04', 'TC11'};
        };

        % Loop through each bundle and plot with ideal schedule
        for j = 1:size(bundle_data, 1)
            % Combined Time vs Temperature Plot
            figure;
            hold on;

            % Plot legacy data
            if ~isempty(bundle_data{j, 1}{1}) && ~isempty(legacy_time)
                plot(legacy_time, bundle_data{j, 1}{1}, 'LineWidth', 2);
            end

            % Plot new thermocouple data, handling different combinations of TIC0 and TIC1
            for k = 2:length(bundle_data{j, 1})
                current_data = bundle_data{j, 1}{k};
                if ~isempty(current_data)
                    if contains(bundle_data{j, 2}{k}, 'TC0') && ~isempty(tic0_time)
                        plot(tic0_time, current_data, 'LineWidth', 2);
                    elseif contains(bundle_data{j, 2}{k}, 'TC1') && ~isempty(tic1_time)
                        plot(tic1_time, current_data, 'LineWidth', 2);
                    end
                end
            end

            % Plot ideal schedule
            if ~isempty(sch_time_interval) && ~isempty(sch_temperature_interval)
                plot(sch_time_interval, sch_temperature_interval, '--k', 'LineWidth', 1.5); % Filtered ideal schedule
            end

            legend(bundle_data{j, 2}{:}, 'Ideal Schedule', 'Location', 'best');
            title(sprintf('Temperature Interval %d - %d C Bundle %d - Time vs Temperature', temp_intervals(i, 1), temp_intervals(i, 2), j));
            xlabel('Time');
            ylabel('Temperature (°C)');
            saveas(gcf, fullfile('../plots', sprintf('Temp_Interval_%d_%d_Bundle_%d_Time_vs_Temp.png', temp_intervals(i, 1), temp_intervals(i, 2), j)));

            % % Combined Error Plot (Difference from Ideal Schedule)
            % figure;
            % hold on;
            % 
            % % Calculate and plot errors
            % mean_errors = [];
            % rmse_values = [];
            % std_devs = [];
            % 
            % if ~isempty(legacy_time) && ~isempty(bundle_data{j, 1}{1})
            %     diff_legacy = interp1(sch_time_interval, sch_temperature_interval, legacy_time, 'linear', 'extrap') - bundle_data{j, 1}{1};
            %     plot(legacy_time, diff_legacy, 'LineWidth', 1.5);
            %     % Calculate statistics for legacy data
            %     mean_errors = [mean_errors; mean(diff_legacy)];
            %     rmse_values = [rmse_values; sqrt(mean(diff_legacy.^2))];
            %     std_devs = [std_devs; std(diff_legacy)];
            % end
            % 
            % for k = 2:length(bundle_data{j, 1})
            %     current_data = bundle_data{j, 1}{k};
            %     if ~isempty(current_data)
            %         if contains(bundle_data{j, 2}{k}, 'TC0') && ~isempty(tic0_time)
            %             diff_data = interp1(sch_time_interval, sch_temperature_interval, tic0_time, 'linear', 'extrap') - current_data;
            %             plot(tic0_time, diff_data, 'LineWidth', 1.5);
            %         elseif contains(bundle_data{j, 2}{k}, 'TC1') && ~isempty(tic1_time)
            %             diff_data = interp1(sch_time_interval, sch_temperature_interval, tic1_time, 'linear', 'extrap') - current_data;
            %             plot(tic1_time, diff_data, 'LineWidth', 1.5);
            %         end
            %         % Calculate statistics for new thermocouple data
            %         mean_errors = [mean_errors; mean(diff_data)];
            %         rmse_values = [rmse_values; sqrt(mean(diff_data.^2))];
            %         std_devs = [std_devs; std(diff_data)];
            %     end
            % end
            % 
            % legend(bundle_data{j, 2}{:}, 'Location', 'best');
            % title(sprintf('Temperature Interval %d - %d C Bundle %d - Tracking Error vs Ideal Schedule', temp_intervals(i, 1), temp_intervals(i, 2), j));
            % xlabel('Time');
            % ylabel('Error (°C)');
            % saveas(gcf, fullfile('plots', sprintf('Temp_Interval_%d_%d_Bundle_%d_Error_vs_Ideal.png', temp_intervals(i, 1), temp_intervals(i, 2), j)));
            % 
            % % Display statistics for each bundle
            % fprintf('Statistics for Temperature Interval %d - %d C Bundle %d:\n', temp_intervals(i, 1), temp_intervals(i, 2), j);
            % for k = 1:length(bundle_data{j, 2})
            %     fprintf('  Sensor: %s\n', bundle_data{j, 2}{k});
            %     fprintf('    Mean Error: %.3f °C  -  ', mean_errors(k));
            %     fprintf('    Std Dev: %.3f °C  -  ', std_devs(k));
            %     fprintf('    RMSE: %.3f °C\n', rmse_values(k));
            % end
        end
    end
end
