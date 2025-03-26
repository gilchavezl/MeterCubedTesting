%% Plotting with Selection Logic

% Define colors
legacy_colors = {[0.8, 0.2, 0.2], [1.0, 0.5, 0.0], [0.1, 0.4, 0.8]}; % Red, orange, and blue colors for legacy data
new_tc_colors = {[0.2, 0.6, 0.2], [0.3, 0.3, 0.3], [0.8, 0.6, 0.1], [0.6, 0.3, 0.6], [0.5, 0.5, 0.5]}; % Green, dark gray, mustard yellow, purple, and gray for new TCs
baby_blue = [137, 207, 240] / 255;

% Define markers for each bundle9
bundle_markers = {'.', 'x', 'p'}; % Circle, square, diamond for legacy TCs


%%
% Room Temp
%start_dates = [datetime(2024, 12, 13, 10, 21, 00); ...
%               datetime(2024, 12, 13, 10, 28, 00); ...
%               datetime(2024, 12, 13, 10, 38, 00)];
%end_dates = [datetime(2024, 12, 13, 10, 26, 00) ...
%             datetime(2024, 12, 13, 10, 37, 00) ...
%             datetime(2024, 12, 13, 10, 43, 00)];

% High temp
start_dates = [datetime(2025, 01, 17, 09, 41, 00); ...
               datetime(2025, 01, 17, 09, 52, 00); ...
               datetime(2025, 01, 17, 10, 45, 00)];
end_dates = [datetime(2025, 01, 17, 09, 51, 00) ...
             datetime(2025, 01, 17, 10, 44, 00) ...
             datetime(2025, 01, 17, 10, 55, 00)];

% Loop through each temperature interval
for i = 1:1

    % Plot 1.1 pre-swap data

    % Filter data based on time range
    legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_dates(i) & legacyTemps.Timestamp <= end_dates(i), :);
    tic0_filtered = tic0_temps(tic0_temps.Time >= start_dates(i) & tic0_temps.Time <= end_dates(i), :);
    tic1_filtered = tic1_temps(tic1_temps.Time >= start_dates(i) & tic1_temps.Time <= end_dates(i), :);

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

    % Create a figure for plotting all thermocouples
    figure('Position', [100, 100, 1400, 800]);
    hold on;

    % Plot each bundle

    % Legacy
    plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
    plot(legacy_time, legacy_filtered.col7, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{2}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0011');
    plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');    
    % TIC 0 
    plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
    plot(tic0_time, tic0_filtered.TC1, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC01');
    plot(tic0_time, tic0_filtered.TC2, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{1},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC02');
    plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
    plot(tic0_time, tic0_filtered.TC4, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC04');
    % TIC 1
    %plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC10');
    plot(tic1_time, tic1_filtered.TC1, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC11');
    plot(tic1_time, tic1_filtered.TC2, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC12');
    plot(tic1_time, tic1_filtered.TC3, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC13');
    plot(tic1_time, tic1_filtered.TC4, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC14');
    ylabel('Temperatures (\circC)')

    yyaxis right;
    plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', baby_blue, 'DisplayName', 'TC10');
    ylabel('Spare TC Temperature (\circC)');
    yyaxis left;
    
    % Plot 1.2 post-swap data

    % Filter data based on time range
    legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_dates(i+1) & legacyTemps.Timestamp <= end_dates(i+1), :);
    tic0_filtered = tic0_temps(tic0_temps.Time >= start_dates(i+1) & tic0_temps.Time <= end_dates(i+1), :);
    tic1_filtered = tic1_temps(tic1_temps.Time >= start_dates(i+1) & tic1_temps.Time <= end_dates(i+1), :);
    
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

    tic1_filtered.TC1 = smoothdata(tic1_filtered.TC1, 'movmedian', 60);
    tic1_filtered.TC1 = smoothdata(tic1_filtered.TC1, 'movmedian', 60);
    tic1_filtered.TC2 = smoothdata(tic1_filtered.TC2, 'movmedian', 60);
    tic1_filtered.TC3 = smoothdata(tic1_filtered.TC3, 'movmedian', 60);
    tic1_filtered.TC4 = smoothdata(tic1_filtered.TC4, 'movmedian', 60);

    % Plot each bundle
    % Legacy
    plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
    plot(legacy_time, legacy_filtered.col7, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{2}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0011');
    plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');
    % TIC 0 
    %plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
    plot(tic0_time, tic0_filtered.TC1, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC01');
    plot(tic0_time, tic0_filtered.TC2, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC02');
    plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
    plot(tic0_time, tic0_filtered.TC4, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC04');
    % TIC 1
    plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC10');
    plot(tic1_time, tic1_filtered.TC1, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC11');
    plot(tic1_time, tic1_filtered.TC2, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC12');
    plot(tic1_time, tic1_filtered.TC3, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC13');
    plot(tic1_time, tic1_filtered.TC4, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC14');
    ylabel('Temperatures (\circC)')
    
    yyaxis right;
    plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', baby_blue, 'DisplayName', 'TC00');
    ylabel('Spare TC Temperature (\circC)');
    yyaxis left;

    % Set plot properties
    legend('show', 'Location', 'best');
    title('Thermocouple Swap Test - Room Temperature', 'FontSize', 16);
    xlabel('Time', 'FontSize', 16);
    set(gca, 'FontSize', 16);

    % Plot 2.1 post-swap data

    % Create a figure for plotting all thermocouples
    figure('Position', [100, 100, 1400, 800]);
    hold on;

    % Plot each bundle
    % Legacy
    plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
    plot(legacy_time, legacy_filtered.col7, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{2}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0011');
    plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');    
    % TIC 0 
    %plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
    plot(tic0_time, tic0_filtered.TC1, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC01');
    plot(tic0_time, tic0_filtered.TC2, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC02');
    plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
    plot(tic0_time, tic0_filtered.TC4, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC04');
    % TIC 1
    plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC10');
    plot(tic1_time, tic1_filtered.TC1, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC11');
    plot(tic1_time, tic1_filtered.TC2, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC12');
    plot(tic1_time, tic1_filtered.TC3, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC13');
    plot(tic1_time, tic1_filtered.TC4, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC14');
    ylabel('Temperatures (\circC)')

    yyaxis right;
    plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', baby_blue, 'DisplayName', 'TC00');
    ylabel('Spare TC Temperature (\circC)');
    yyaxis left;

    % Plot 2.2 swapped back 
    
    % Filter data based on time range
    legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_dates(i+2) & legacyTemps.Timestamp <= end_dates(i+2), :);
    tic0_filtered = tic0_temps(tic0_temps.Time >= start_dates(i+2) & tic0_temps.Time <= end_dates(i+2), :);
    tic1_filtered = tic1_temps(tic1_temps.Time >= start_dates(i+2) & tic1_temps.Time <= end_dates(i+2), :);

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

    % Plot each bundle
    % Legacy
    plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
    plot(legacy_time, legacy_filtered.col7, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{2}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0011');
    plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');
    % TIC 0 
    plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
    plot(tic0_time, tic0_filtered.TC1, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC01');
    plot(tic0_time, tic0_filtered.TC2, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{1},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC02');
    plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
    plot(tic0_time, tic0_filtered.TC4, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC04');  
    % TIC 1
    %plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC10');
    plot(tic1_time, tic1_filtered.TC1, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{2}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC11');
    plot(tic1_time, tic1_filtered.TC2, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{3}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC12');
    plot(tic1_time, tic1_filtered.TC3, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC13');
    plot(tic1_time, tic1_filtered.TC4, 'LineWidth', 2, 'LineStyle', '--', 'Color', new_tc_colors{5}, 'Marker', bundle_markers{1}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic1_time), 'DisplayName', 'TC14');
    ylabel('Temperatures (\circC)')

    yyaxis right;
    plot(tic1_time, tic1_filtered.TC0, 'LineWidth', 2, 'LineStyle', '--', 'Color', baby_blue, 'DisplayName', 'TC10');
    ylabel('Spare TC Temperature (\circC)');
    yyaxis left;

    % Set plot properties
    legend('show', 'Location', 'best');
    title('Thermocouple Swap Test - Room Temperature', 'FontSize', 16);
    xlabel('Time', 'FontSize', 16);
    set(gca, 'FontSize', 16);
end

%% Plot IJB Reported Thermistor Temperatures
start_date = [datetime(2025, 01, 07, 12, 00, 00)];
end_date = [datetime(2025, 01, 17, 00, 00, 00)];

% Filter data based on time range
legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_date(1) & legacyTemps.Timestamp <= end_date(1), :);
tic0_filtered = tic0_temps(tic0_temps.Time >= start_date(1) & tic0_temps.Time <= end_date(1), :);
tic1_filtered = tic1_temps(tic1_temps.Time >= start_date(1) & tic1_temps.Time <= end_date(1), :);
figure;
hold on;

plot(tic0_filtered.Time, tic0_filtered.Therm, '-b', 'LineWidth', 1.5, 'DisplayName', 'TIC0 Thermistor');
plot(tic1_filtered.Time, tic1_filtered.Therm, '-r', 'LineWidth', 1.5, 'DisplayName', 'TIC1 Thermistor');
plot(legacy_filtered.Timestamp, legacy_filtered.therm1, '--k', 'LineWidth', 1.5, 'DisplayName', 'Legacy Thermistor 1');
plot(legacy_filtered.Timestamp, legacy_filtered.therm2, '--g', 'LineWidth', 1.5, 'DisplayName', 'Legacy Thermistor 2');

xlabel('Time (s)', 'FontSize', 12);
ylabel('Temperature (°C)', 'FontSize', 12);
title('Thermistor Temperature Measurements Over Time', 'FontSize', 14);

grid on;
legend('Location', 'best', 'FontSize', 10);

set(gca, 'FontSize', 10);
hold off;

%% Plot TIC4 (shorted)

% Define time range for filtering
start_dates = datetime(2025, 01, 01, 09, 41, 00);
end_dates = datetime(2025, 01, 17, 11, 00, 00);

% Filter data based on the defined time range
tic4_filtered = tic4_temps(tic4_temps.Time >= start_dates & tic4_temps.Time <= end_dates, :);

% Extract filtered time data
tic4_time = tic4_filtered.Time;

% Smooth the temperature data for all channels
tic4_filtered.TC0 = smoothdata(tic4_filtered.TC0, 'movmedian', 60);
tic4_filtered.TC1 = smoothdata(tic4_filtered.TC1, 'movmedian', 60);
tic4_filtered.TC2 = smoothdata(tic4_filtered.TC2, 'movmedian', 60);
tic4_filtered.TC3 = smoothdata(tic4_filtered.TC3, 'movmedian', 60);
tic4_filtered.TC4 = smoothdata(tic4_filtered.TC4, 'movmedian', 60);
tic4_filtered.Therm = smoothdata(tic4_filtered.Therm, 'movmedian', 60);

% Plot temperature data for all thermocouple channels and thermistor
figure;
hold on;

plot(tic4_time, tic4_filtered.TC0, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', new_tc_colors{1}, ...
    'DisplayName', 'TC40');
plot(tic4_time, tic4_filtered.TC1, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', new_tc_colors{2}, ...
    'DisplayName', 'TC41');
plot(tic4_time, tic4_filtered.TC2, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', new_tc_colors{3}, ...
    'DisplayName', 'TC42');
plot(tic4_time, tic4_filtered.TC3, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', new_tc_colors{4}, ...
    'DisplayName', 'TC43');
plot(tic4_time, tic4_filtered.TC4, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', new_tc_colors{5}, ...
    'DisplayName', 'TC44');


xlabel('Time (HH:MM)', 'FontSize', 12);
ylabel('Shorted Thermocouple Temperature (°C)', 'FontSize', 12);

% Add title and legend
title('TIC4 Temperature Data (Shorting plug installed)', 'FontSize', 14);
legend('Location', 'best', 'FontSize', 10);

% Format grid and appearance
grid on;
set(gca, 'FontSize', 10);
hold off;

%% TIC4 (shorted) Simulated Thermistor Temp

figure()
plot(tic4_time, tic4_filtered.Therm, 'LineWidth', 1, 'LineStyle', '--', ...
    'DisplayName', 'IJB Thermistor');

ylabel('Shorted IJB Thermistor Temperature (°C)', 'FontSize', 12);
xlabel('Time (HH:MM)', 'FontSize', 12);

% Add title and legend
title('TIC4 Temperature Data (Shorting plug installed)', 'FontSize', 20);
legend('Location', 'best', 'FontSize', 10);

% Format grid and appearance
grid on;
set(gca, 'FontSize', 16, 'FontWeight', 'bold');
hold off;

%% Plot individually swapped thermocouples
%TC0004 and TC00, TC0014 and TC03

% Define time range for filtering
start_dates = [datetime(2025, 01, 21, 08, 45, 00), datetime(2025, 01, 21, 08, 54, 00) ];
end_dates = [datetime(2025, 01, 21, 8, 52, 00), datetime(2025, 01, 21, 09, 01, 00)];

% Filter data based on time range
legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_dates(1) & legacyTemps.Timestamp <= end_dates(1), :);
tic0_filtered = tic0_temps(tic0_temps.Time >= start_dates(1) & tic0_temps.Time <= end_dates(1), :);
% Extract time data
legacy_time = legacy_filtered.Timestamp;
tic0_time = tic0_filtered.Time;

% Smooth the data
tic0_filtered.TC0 = smoothdata(tic0_filtered.TC0, 'movmedian', 60);
tic0_filtered.TC3 = smoothdata(tic0_filtered.TC3, 'movmedian', 60);

figure();
hold on;
 % Plot each bundle
% Legacy
plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');    
% TIC 0 
plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
ylabel('Temperatures (\circC)')
    
% Plot 1.2 post-swap data
% Filter data based on time range
legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_dates(2) & legacyTemps.Timestamp <= end_dates(2), :);
tic0_filtered = tic0_temps(tic0_temps.Time >= start_dates(2) & tic0_temps.Time <= end_dates(2), :);
% Extract time data
legacy_time = legacy_filtered.Timestamp;
tic0_time = tic0_filtered.Time;

% Smooth the data
tic0_filtered.TC0 = smoothdata(tic0_filtered.TC0, 'movmedian', 60);
tic0_filtered.TC3 = smoothdata(tic0_filtered.TC3, 'movmedian', 60);

% Plot each bundle
% Legacy
plot(legacy_time, legacy_filtered.col4, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0004');
plot(legacy_time, legacy_filtered.col9, 'LineWidth', 2, 'LineStyle', '-', 'Color', legacy_colors{3}, 'Marker', bundle_markers{2},'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'Legacy 0014');
% TIC 0 
plot(tic0_time, tic0_filtered.TC0, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{1}, 'Marker', bundle_markers{3}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC00');
plot(tic0_time, tic0_filtered.TC3, 'LineWidth', 2, 'LineStyle', '-', 'Color', new_tc_colors{4}, 'Marker', bundle_markers{2}, 'MarkerSize', 10, 'MarkerIndices', 1:50:length(tic0_time), 'DisplayName', 'TC03');
ylabel('Temperatures (\circC)')
    
% Set plot properties
legend('show', 'Location', 'best');
title('Thermocouple Swap Test - Room Temperature', 'FontSize', 16);
xlabel('Time', 'FontSize', 16);
set(gca, 'FontSize', 16);