% main_analysis.m
% Main script for analysis after data processing.

% Determine the project root directory
scriptDir = fileparts(mfilename('fullpath')); % Directory of the current script
projectRoot = fullfile(scriptDir, '..'); % Move up one level to 'MeterCubedTestingDec24'
%cd(projectRoot); % Change the working directory to the project root


% Add utilities folder to path
addpath('../utilities');

% Ensure data files exist; run setup if necessary
required_files = {'../LegacyTemps/LegacyTemps_All.csv', ...
                  '../NewTemps/TIC0_All.csv', ...
                  '../NewTemps/TIC1_All.csv', ...
                  '../NewTemps/TIC4_All.csv'};
files_missing = false;

for i = 1:length(required_files)
    if ~exist(required_files{i}, 'file')
        fprintf('Required file %s is missing.\n', required_files{i});
        files_missing = true;
    end
end

if files_missing
    fprintf('Running setup_data_processing.m to generate required files...\n');
    run('setup_data_processing.m');
end

% Validate files were generated
for i = 1:length(required_files)
    if ~exist(required_files{i}, 'file')
        error('Required file %s is still missing after setup. Check setup_data_processing.m.', required_files{i});
    end
end
%%
% Load data and proceed with analysis
fprintf('Loading processed data...\n');
[legacyTemps, tic0_temps, tic1_temps, tic4_temps] = load_csv_data();

%% Generate Schedule

fprintf('Generating schedule...\n');

start_time_Nov24 = datetime(2024, 11, 20, 11, 00, 0);
schedule_Nov24 = [
    struct('rate',  50, 'duration', hours(13) + minutes(36)); % node a
    struct('rate',  30, 'duration', hours(15) + minutes(30)); % node b
    struct('rate',  00, 'duration', hours(01) + minutes(00)); % node c
    struct('rate', -50, 'duration', hours(09) + minutes(18)); % node d
    struct('rate', -75, 'duration', hours(09) + minutes(04)); % node e 
    struct('rate',  00, 'duration', hours(19) + minutes(21))  % node f
];

start_time_13Dec24 = datetime(2024, 12, 12, 11, 08, 00);
schedule_13Dec24 = [
    struct('rate',  00, 'duration', hours(00) + minutes(00)); % node a
    struct('rate',  15, 'duration', hours(05) + minutes(24)); % node b
    struct('rate',  05, 'duration', hours(01) + minutes(36)); % node c
    struct('rate',  20, 'duration', hours(19) + minutes(48)); % node d
    struct('rate',  20, 'duration', hours(12) + minutes(30)); % node e
    struct('rate',  25, 'duration', hours(06) + minutes(00)); % node f
    struct('rate',  30, 'duration', hours(08) + minutes(50)); % node g
    struct('rate',  00, 'duration', hours(03) + minutes(00)); % node h
    struct('rate', -20, 'duration', hours(13) + minutes(15)); % node i
    struct('rate', -15, 'duration', hours(20) + minutes(00)); % node j
    struct('rate', -12, 'duration', hours(04) + minutes(10)); % node k
    struct('rate', -12, 'duration', hours(01) + minutes(40)); % node l
    struct('rate', -10, 'duration', hours(08) + minutes(00)); % node m
    struct('rate', -10, 'duration', hours(05) + minutes(00)); % node n
    struct('rate', -10, 'duration', hours(01) + minutes(14))  % node o
];


%[sch_time, sch_temperature] = generate_schedule(start_time_13Dec24, 15, schedule_13Dec24);

%% Section 1
% Analyze data
fprintf('Analyzing temperature intervals...\n');
% Example: Define temperature intervals, start, and end dates
temp_intervals = [0, 200;];% 200, 400; 400, 600; 600, 800; 800, 1000; 1000, 1165; 1165, 1165; 1165, 1000; 1000, 800; 800, 700; 700, 500; 500, 300; 300, 0];
start_dates = [datetime(2024, 12, 11, 12, 0, 0)];
end_dates = [datetime(2024, 12, 11, 18, 0, 0)];

% Call the analysis function
%analyze_temperature_intervals(temp_intervals, start_dates, end_dates, sch_time, sch_temperature, legacyTemps, tic0_temps, tic1_temps);

%run('TC_swap_testing.m');

plot_Bundle_Interval(1, datetime(2024, 12, 16, 11, 30, 00), datetime(2024, 12, 29, 00, 00, 00), legacyTemps, tic0_temps, tic1_temps);
plot_Bundle_Interval(2, datetime(2024, 12, 16, 11, 30, 00), datetime(2024, 12, 29, 00, 00, 00), legacyTemps, tic0_temps, tic1_temps);
plot_Bundle_Interval(3, datetime(2024, 12, 16, 11, 30, 00), datetime(2024, 12, 29, 00, 00, 00), legacyTemps, tic0_temps, tic1_temps);

disp('Analysis complete.');
%%
start_date = [datetime(2024, 12, 11, 17, 00, 00)];
end_date = [datetime(2024, 12, 11, 17, 30, 00)];
legacy_filtered = legacyTemps(legacyTemps.Timestamp >= start_date & legacyTemps.Timestamp <= end_date, :);

figure();
plot(legacy_filtered.Timestamp, legacy_filtered.col0, 'LineWidth', 1.5);
hold on;
plot(legacy_filtered.Timestamp, legacy_filtered.col1, 'LineWidth', 1.5);
plot(legacy_filtered.Timestamp, legacy_filtered.col2, 'LineWidth', 1.5);
plot(legacy_filtered.Timestamp, legacy_filtered.col3, 'LineWidth', 1.5);
plot(legacy_filtered.Timestamp, legacy_filtered.col4, 'LineWidth', 1.5);
plot(legacy_filtered.Timestamp, legacy_filtered.col5, 'LineWidth', 1.5, 'LineStyle', '--');
plot(legacy_filtered.Timestamp, legacy_filtered.col7, 'LineWidth', 1.5, 'LineStyle', '--');
plot(legacy_filtered.Timestamp, legacy_filtered.col6, 'LineWidth', 1.5, 'LineStyle', '--');
plot(legacy_filtered.Timestamp, legacy_filtered.col8, 'LineWidth', 1.5, 'LineStyle', '--');
plot(legacy_filtered.Timestamp, legacy_filtered.col9, 'LineWidth', 1.5, 'LineStyle', '--');

legend('0000', '0001', '0002','0003', '0004', '0010', '0011', '0012', '0013', '0014');

%% December 2024
start_date = [datetime(2024, 12, 16, 12, 00, 00)];
end_date = [datetime(2024, 12, 29, 00, 00, 00)];
tic0_filtered = tic0_temps(tic0_temps.Time >= start_date & tic0_temps.Time <= end_date, :);
tic1_filtered = tic1_temps(tic1_temps.Time >= start_date & tic1_temps.Time <= end_date, :);
tic4_filtered = tic4_temps(tic4_temps.Time >= start_date & tic4_temps.Time <= end_date, :);

%tic1_filtered = tic1_temps;
%tic0_filtered = tic0_temps;
figure();
plot(tic0_filtered.Time, tic0_filtered.TC0, 'LineWidth', 1.5, 'LineStyle', '-');
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC1, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC2, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC3, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC4, 'LineWidth', 1.5, 'LineStyle', '-');
yyaxis right;
plot(tic0_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);

figure();
plot(tic1_filtered.Time, tic1_filtered.TC0, 'LineWidth', 1.5);
hold on;
plot(tic1_filtered.Time, tic1_filtered.TC1, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC2, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC3, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC4, 'LineWidth', 1.5);
yyaxis right;
plot(tic1_filtered.Time, tic1_filtered.Therm, 'LineWidth', 1.5);



legend('10', '11', '12', '13', '14');

figure();
plot(tic4_filtered.Time, tic4_filtered.TC0, 'LineWidth', 1.5);
hold on;
plot(tic4_filtered.Time, tic4_filtered.TC1, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC2, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC3, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC4, 'LineWidth', 1.5);
yyaxis right;
plot(tic4_filtered.Time, tic4_filtered.Therm, 'LineWidth', 1.5);

figure()
plot(tic0_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);
hold on;
plot(tic1_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);


%% January 2025

start_date = [datetime(2025, 01, 02, 12, 00, 00)];
end_date = [datetime(2025, 01, 20, 00, 00, 00)];
tic0_filtered = tic0_temps(tic0_temps.Time >= start_date & tic0_temps.Time <= end_date, :);
tic1_filtered = tic1_temps(tic1_temps.Time >= start_date & tic1_temps.Time <= end_date, :);
tic4_filtered = tic4_temps(tic4_temps.Time >= start_date & tic4_temps.Time <= end_date, :);

%tic1_filtered = tic1_temps;
%tic0_filtered = tic0_temps;
figure();
plot(tic0_filtered.Time, tic0_filtered.TC0, 'LineWidth', 1.5, 'LineStyle', '-');
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC1, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC2, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC3, 'LineWidth', 1.5, 'LineStyle', '-');
plot(tic0_filtered.Time, tic0_filtered.TC4, 'LineWidth', 1.5, 'LineStyle', '-');
yyaxis right;
plot(tic0_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);

figure();
plot(tic1_filtered.Time, tic1_filtered.TC0, 'LineWidth', 1.5);
hold on;
plot(tic1_filtered.Time, tic1_filtered.TC1, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC2, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC3, 'LineWidth', 1.5);
plot(tic1_filtered.Time, tic1_filtered.TC4, 'LineWidth', 1.5);
yyaxis right;
plot(tic1_filtered.Time, tic1_filtered.Therm, 'LineWidth', 1.5);



legend('10', '11', '12', '13', '14');

figure();
plot(tic4_filtered.Time, tic4_filtered.TC0, 'LineWidth', 1.5);
hold on;
plot(tic4_filtered.Time, tic4_filtered.TC1, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC2, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC3, 'LineWidth', 1.5);
plot(tic4_filtered.Time, tic4_filtered.TC4, 'LineWidth', 1.5);
yyaxis right;
plot(tic4_filtered.Time, tic4_filtered.Therm, 'LineWidth', 1.5);

figure()
plot(tic0_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);
hold on;
plot(tic1_filtered.Time, tic0_filtered.Therm, 'LineWidth', 1.5);