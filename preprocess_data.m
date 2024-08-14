%% preprocess_data.m
% Preprocess Data
% Code to pre-process data
% Mostly related to selecting data subsets and applying operations to
% clean up the data.

%% Script configuration
% For using subsets of data, we can extract a subset defined by data with
% timestamps corresponding to the time period between time_start and
% time_end

time_start = '2024-07-11 9:30:00';
time_end = '2024-07-14 17:30:00';

%% Load data to workspace variables
legacyTemps_filepath = 'LegacyTemps/LegacyTemps_All.csv';
tic0_filepath = 'NewTemps/TIC0_All.csv';
tic1_filepath = 'NewTemps/TIC1_All.csv';

legacyTemps = readtable(legacyTemps_filepath);
tic0_temps = readtable(tic0_filepath);
tic1_temps = readtable(tic1_filepath);

disp('Loading data from following files:');
disp(legacyTemps_filepath);
disp(tic0_filepath);
disp(tic1_filepath);


%% Plot raw data (Legacy)

% start by plotting data
figure(30);
plot(legacyTemps.Timestamp, legacyTemps.col5) % Legacy TC 0010 (TC0010)
hold on
plot(legacyTemps.Timestamp, legacyTemps.col7) % Legacy TC 0012 (TC0012)
plot(legacyTemps.Timestamp, legacyTemps.col8) % Legacy TC 0013 (TC0013)
title("Legacy Temperatures");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010', 'TC0012', 'TC0013');


%% Select data subset - columns (Legacy)
% a subset of data to test signal processing

column_filter = [1 7 9 10];
legacy_column_subset = legacyTemps(:,column_filter);
clear column_filter


%% Select data subset - rows (Legacy)
% a subset of data to test signal processing

ti = datetime(time_start,'InputFormat','yyyy-MM-dd HH:mm:ss');
tf = datetime(time_end,'InputFormat','yyyy-MM-dd HH:mm:ss');
mask_i = legacy_column_subset.Timestamp >= ti; % && legacyTemps.Timestamp <= tf;
mask_f = legacy_column_subset.Timestamp <= tf;
mask = and(mask_i, mask_f);

legacy_subset = legacy_column_subset(mask,:);

clear mask_i mask_f mask;

%% Plot subset data (Legacy)
% plotting data
figure(31);
plot(legacy_subset.Timestamp, legacy_subset.col5) % Legacy TC 0010 (TC0010)
hold on
plot(legacy_subset.Timestamp, legacy_subset.col7) % Legacy TC 0012 (TC0012)
plot(legacy_subset.Timestamp, legacy_subset.col8) % Legacy TC 0013 (TC0013)
title("Legacy Temperatures from subset");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010', 'TC0012', 'TC0013');


%% Plot raw data (New)

% start by plotting data
% TIC0
figure(35);
plot(tic0_temps.Time, tic0_temps.TC0); % New System - TIC0 TC0 (TC00)
hold on
plot(tic0_temps.Time, tic0_temps.TC1); % New System - TIC0 TC1 (TC01)
plot(tic0_temps.Time, tic0_temps.TC2); % New System - TIC0 TC2 (TC02)
plot(tic0_temps.Time, tic0_temps.TC3); % New System - TIC0 TC3 (TC03)
plot(tic0_temps.Time, tic0_temps.TC4); % New System - TIC0 TC4 (TC04)
plot(tic0_temps.Time, tic0_temps.Therm); % New System - Thermositor (TH)
title("New Temperatures TIC0");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00', 'TC01', 'TC02', 'TC03', 'TC04', 'THERM');
% ylim([20 24])

% TIC1
figure(36);
plot(tic1_temps.Time, tic1_temps.TC1); % New System - TIC1 TC1 (TC11)
hold on
plot(tic1_temps.Time, tic1_temps.TC2); % New System - TIC1 TC2 (TC12)
plot(tic1_temps.Time, tic1_temps.TC3); % New System - TIC1 TC3 (TC13)
plot(tic1_temps.Time, tic1_temps.TC4); % New System - TIC1 TC4 (TC14)
plot(tic1_temps.Time, tic1_temps.Therm); % New System - Thermositor (TH)
title("New Temperatures TIC1");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC11', 'TC12', 'TC13', 'TC14', 'THERM');
% ylim([20 24])


%% Select data subset - columns (New)
% a subset of data to test signal processing

column_filter = [1:7];
tic0_column_subset = tic0_temps(:,column_filter);
tic1_column_subset = tic1_temps(:,column_filter);

clear column_filter


%% Select data subset - rows (New)
% a subset of data to test signal processing

% ti = datetime('2024-07-13 00:00:00','InputFormat','yyyy-MM-dd HH:mm:ss');
% tf = datetime('2024-07-14 00:00:00','InputFormat','yyyy-MM-dd HH:mm:ss');
mask_i = tic0_column_subset.Time >= ti; % && legacyTemps.Timestamp <= tf;
mask_f = tic0_column_subset.Time<= tf;
mask = and(mask_i, mask_f);
tic0_subset = tic0_column_subset(mask,:);
mask_i = tic1_column_subset.Time>= ti; % && legacyTemps.Timestamp <= tf;
mask_f = tic1_column_subset.Time<= tf;
mask = and(mask_i, mask_f);
tic1_subset = tic1_column_subset(mask,:);

clear mask_i mask_f mask

%% Plot subset data (New)
% plotting data
figure(40);
plot(tic0_subset.Time, tic0_subset.TC0); % New System - TIC0 TC0 (TC00)
hold on
plot(tic0_subset.Time, tic0_subset.TC1); % New System - TIC0 TC1 (TC01)
plot(tic0_subset.Time, tic0_subset.TC2); % New System - TIC0 TC2 (TC02)
plot(tic0_subset.Time, tic0_subset.TC3); % New System - TIC0 TC3 (TC03)
plot(tic0_subset.Time, tic0_subset.TC4); % New System - TIC0 TC4 (TC04)
plot(tic0_subset.Time, tic0_subset.Therm); % New System - Thermositor (TH)
title("New Temperatures TIC0 from subset");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00', 'TC01', 'TC02', 'TC03', 'TC04', 'THERM');
% ylim([20 24])

% TIC1
figure(41);
plot(tic1_subset.Time, tic1_subset.TC1); % New System - TIC1 TC1 (TC11)
hold on
plot(tic1_subset.Time, tic1_subset.TC2); % New System - TIC1 TC2 (TC12)
plot(tic1_subset.Time, tic1_subset.TC3); % New System - TIC1 TC3 (TC13)
plot(tic1_subset.Time, tic1_subset.TC4); % New System - TIC1 TC4 (TC14)
plot(tic1_subset.Time, tic1_subset.Therm); % New System - Thermositor (TH)
title("New Temperatures TIC1 from subset");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC11', 'TC12', 'TC13', 'TC14', 'THERM');

% Just comparing thermistors
figure(42);
plot(tic0_subset.Time, tic0_subset.Therm); % New System - Thermositor (TH)
hold on
plot(tic1_subset.Time, tic1_subset.Therm); % New System - Thermositor (TH)
title("New TIC Thermistors");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TIC0', 'TIC1');
% ylim([20 24])


%% Clean data
% functions to clean data
% remove outliers and filter/smooth

%% Remove outliers (Legacy)
% first, split into individual table/matrix for each channel

use_subset = true;
if use_subset == true
    leg_tc0010_raw = legacy_subset(:,["Timestamp" "col5"]);
    leg_tc0012_raw = legacy_subset(:,["Timestamp" "col7"]);
    leg_tc0013_raw = legacy_subset(:,["Timestamp" "col8"]);
else
    leg_tc0010_raw = legacyTemps(:,["Timestamp" "col5"]);
    leg_tc0012_raw = legacyTemps(:,["Timestamp" "col7"]);
    leg_tc0013_raw = legacyTemps(:,["Timestamp" "col8"]);
end

% then, apply filter to remove outliers
[~, TFrm ] = rmoutliers(leg_tc0010_raw.col5,"median");
out_filter = not(TFrm);
leg_tc0010_rmo = leg_tc0010_raw(out_filter,:);
[~, TFrm ] = rmoutliers(leg_tc0012_raw.col7,"median");
out_filter = not(TFrm);
leg_tc0012_rmo = leg_tc0012_raw(out_filter,:);
[~, TFrm ] = rmoutliers(leg_tc0013_raw.col8,"median");
out_filter = not(TFrm);
leg_tc0013_rmo = leg_tc0013_raw(out_filter,:);

clear out_filter TFrm


%% Plot data after removing outliers (Legacy)
% plot data
figure(50);
plot(leg_tc0010_raw.Timestamp, leg_tc0010_raw.col5) % Legacy TC 0010 (TC0010)
hold on
plot(leg_tc0012_raw.Timestamp, leg_tc0012_raw.col7) % Legacy TC 0012 (TC0012)
plot(leg_tc0013_raw.Timestamp, leg_tc0013_raw.col8) % Legacy TC 0013 (TC0013)
title("Legacy Data Raw");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010','TC0012','TC0013');

figure(51);
plot(leg_tc0010_rmo.Timestamp, leg_tc0010_rmo.col5) % Legacy TC 0010 (TC0010)
% plot(leg_tc0010_out) % Legacy TC 0010 (TC0010)
hold on
plot(leg_tc0012_rmo.Timestamp, leg_tc0012_rmo.col7) % Legacy TC 0012 (TC0012)
plot(leg_tc0013_rmo.Timestamp, leg_tc0013_rmo.col8) % Legacy TC 0013 (TC0013)
title("Legacy Data Outliers Removed");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010','TC0012','TC0013');


%% Remove outliers (New)

% tic0
% first, split into individual table/matrix for each channel
if use_subset == true
    new_tc00_raw = tic0_subset(:,["Time" "TC0"]);
    new_tc01_raw = tic0_subset(:,["Time" "TC1"]);
    new_tc02_raw = tic0_subset(:,["Time" "TC2"]);
    new_tc03_raw = tic0_subset(:,["Time" "TC3"]);
    new_tc04_raw = tic0_subset(:,["Time" "TC4"]);
    new_thr0_raw = tic0_subset(:,["Time" "Therm"]);
else
    new_tc00_raw = tic0_temps(:,["Time" "TC0"]);
    new_tc01_raw = tic0_temps(:,["Time" "TC1"]);
    new_tc02_raw = tic0_temps(:,["Time" "TC2"]);
    new_tc03_raw = tic0_temps(:,["Time" "TC3"]);
    new_tc04_raw = tic0_temps(:,["Time" "TC4"]);    
    new_thr0_raw = tic0_temps(:,["Time" "Therm"]);
end

% then, apply filter to remove outliers
new_tc00_rmo = remove_outliers(new_tc00_raw.TC0,new_tc00_raw);
new_tc01_rmo = remove_outliers(new_tc01_raw.TC1,new_tc01_raw);
new_tc02_rmo = remove_outliers(new_tc02_raw.TC2,new_tc02_raw);
new_tc03_rmo = remove_outliers(new_tc03_raw.TC3,new_tc03_raw);
new_tc04_rmo = remove_outliers(new_tc04_raw.TC4,new_tc04_raw);
new_thr0_rmo = remove_outliers(new_thr0_raw.Therm,new_thr0_raw);

% tic1
% first, split into individual table/matrix for each channel
if use_subset == true
    new_tc10_raw = tic1_subset(:,["Time" "TC0"]);
    new_tc11_raw = tic1_subset(:,["Time" "TC1"]);
    new_tc12_raw = tic1_subset(:,["Time" "TC2"]);
    new_tc13_raw = tic1_subset(:,["Time" "TC3"]);
    new_tc14_raw = tic1_subset(:,["Time" "TC4"]);
    new_thr1_raw = tic1_subset(:,["Time" "Therm"]);
else
    new_tc10_raw = tic1_temps(:,["Time" "TC0"]);
    new_tc11_raw = tic1_temps(:,["Time" "TC1"]);
    new_tc12_raw = tic1_temps(:,["Time" "TC2"]);
    new_tc13_raw = tic1_temps(:,["Time" "TC3"]);
    new_tc14_raw = tic1_temps(:,["Time" "TC4"]);
    new_thr1_raw = tic1_temps(:,["Time" "Therm"]);
end

% then, apply filter to remove outliers
new_tc10_rmo = remove_outliers(new_tc10_raw.TC0,new_tc10_raw);
new_tc11_rmo = remove_outliers(new_tc11_raw.TC1,new_tc11_raw);
new_tc12_rmo = remove_outliers(new_tc12_raw.TC2,new_tc12_raw);
new_tc13_rmo = remove_outliers(new_tc13_raw.TC3,new_tc13_raw);
new_tc14_rmo = remove_outliers(new_tc14_raw.TC4,new_tc14_raw);
new_thr1_rmo = remove_outliers(new_thr1_raw.Therm,new_thr1_raw);

% clear out_filter TFrm


%% Plot data after removing outliers (New)
% Plot raw data
% TIC0
figure(60);
plot(new_tc00_raw.Time, new_tc00_raw.TC0); % New System - TIC0 TC0 (TC00)
hold on
plot(new_tc01_raw.Time, new_tc01_raw.TC1); % New System - TIC0 TC1 (TC01)
plot(new_tc02_raw.Time, new_tc02_raw.TC2); % New System - TIC0 TC2 (TC02)
plot(new_tc03_raw.Time, new_tc03_raw.TC3); % New System - TIC0 TC3 (TC03)
plot(new_tc04_raw.Time, new_tc04_raw.TC4); % New System - TIC0 TC4 (TC04)
plot(new_thr0_raw.Time, new_thr0_raw.Therm); % New System - Thermositor (TH)
title("New Data Raw - TIC0");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00', 'TC01', 'TC02', 'TC03', 'TC04', 'Therm');
% ylim([20 24])

% tic1
figure(61);
plot(new_tc10_raw.Time, new_tc10_raw.TC0); % New System - TIC1 TC0 (TC10)
hold on
plot(new_tc11_raw.Time, new_tc11_raw.TC1); % New System - TIC1 TC1 (TC11)
plot(new_tc12_raw.Time, new_tc12_raw.TC2); % New System - TIC1 TC2 (TC12)
plot(new_tc13_raw.Time, new_tc13_raw.TC3); % New System - TIC1 TC3 (TC13)
plot(new_tc14_raw.Time, new_tc14_raw.TC4); % New System - TIC1 TC4 (TC14)
plot(new_thr1_raw.Time, new_thr1_raw.Therm); % New System - Thermositor (TH)
title("New Data Raw - TIC1");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC10', 'TC11', 'TC12', 'TC13', 'TC14', 'Therm');
% ylim([20 24])


% Plot data after removing outliers
% TIC0
figure(62);
plot(new_tc00_rmo.Time, new_tc00_rmo.TC0) % New System - TIC0 TC0 (TC00)
% plot(leg_tc0010_out) % Legacy TC 0010 (TC0010)
hold on
plot(new_tc01_rmo.Time, new_tc01_rmo.TC1) % New System - TIC0 TC1 (TC01)
plot(new_tc02_rmo.Time, new_tc02_rmo.TC2) % New System - TIC0 TC2 (TC02)
plot(new_tc03_rmo.Time, new_tc03_rmo.TC3) % New System - TIC0 TC3 (TC03)
plot(new_tc04_rmo.Time, new_tc04_rmo.TC4) % New System - TIC0 TC4 (TC04)
plot(new_thr0_rmo.Time, new_thr0_rmo.Therm); % New System - Thermositor (TH)
title("New Data Outliers Removed - TIC0");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00', 'TC01', 'TC02', 'TC03', 'TC04', 'Therm');

% tic1
figure(63);
plot(new_tc10_rmo.Time, new_tc10_rmo.TC0) % New System - TIC1 TC0 (TC10)
% plot(leg_tc0010_out) % Legacy TC 0010 (TC0010)
hold on
plot(new_tc11_rmo.Time, new_tc11_rmo.TC1) % New System - TIC1 TC1 (TC11)
plot(new_tc12_rmo.Time, new_tc12_rmo.TC2) % New System - TIC1 TC2 (TC12)
plot(new_tc13_rmo.Time, new_tc13_rmo.TC3) % New System - TIC1 TC3 (TC13)
plot(new_tc14_rmo.Time, new_tc14_rmo.TC4) % New System - TIC1 TC4 (TC14)
plot(new_thr1_rmo.Time, new_thr1_rmo.Therm); % New System - Thermositor (TH)
title("New Data Outliers Removed - TIC1");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC10', 'TC11', 'TC12', 'TC13', 'TC14', 'Therm');


%% Smooth signal (Legacy)
% test to use function to smooth signal in a similar way as Signal Analyzer
% Legacy Data

leg_tc0010_smo = smoothdata(leg_tc0010_rmo,"movmean",20,"DataVariables","col5");
leg_tc0012_smo = smoothdata(leg_tc0012_rmo,"movmean",20,"DataVariables","col7");
leg_tc0013_smo = smoothdata(leg_tc0013_rmo,"movmean",20,"DataVariables","col8");


% plot data
figure(70);
plot(leg_tc0010_smo.Timestamp, leg_tc0010_smo.col5) % Legacy TC 0010 (TC0010)
hold on
grid on
plot(leg_tc0012_smo.Timestamp, leg_tc0012_smo.col7) % Legacy TC 0012 (TC0012)
plot(leg_tc0013_smo.Timestamp, leg_tc0013_smo.col8) % Legacy TC 0013 (TC0013)
title("Legacy Data Smooth");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010','TC0012','TC0013');


%% Smooth signal (New)
% test to use function to smooth signal in a similar way as Signal Analyzer
% New data

% tic0
new_tc00_smo = smoothdata(new_tc00_rmo,"movmean",20,"DataVariables","TC0");
new_tc01_smo = smoothdata(new_tc01_rmo,"movmean",20,"DataVariables","TC1");
new_tc02_smo = smoothdata(new_tc02_rmo,"movmean",20,"DataVariables","TC2");
new_tc03_smo = smoothdata(new_tc03_rmo,"movmean",20,"DataVariables","TC3");
new_tc04_smo = smoothdata(new_tc04_rmo,"movmean",20,"DataVariables","TC4");
new_thr0_smo = smoothdata(new_thr0_rmo,"movmean",20,"DataVariables","Therm");

% tic1
new_tc10_smo = smoothdata(new_tc10_rmo,"movmean",20,"DataVariables","TC0");
new_tc11_smo = smoothdata(new_tc11_rmo,"movmean",20,"DataVariables","TC1");
new_tc12_smo = smoothdata(new_tc12_rmo,"movmean",20,"DataVariables","TC2");
new_tc13_smo = smoothdata(new_tc13_rmo,"movmean",20,"DataVariables","TC3");
new_tc14_smo = smoothdata(new_tc14_rmo,"movmean",20,"DataVariables","TC4");
new_thr1_smo = smoothdata(new_thr1_rmo,"movmean",20,"DataVariables","Therm");


% Plot data after smoothing
% TIC0
figure(71);
plot(new_tc00_smo.Time, new_tc00_smo.TC0) % New System - TIC0 TC0 (TC00)
% plot(leg_tc0010_out) % Legacy TC 0010 (TC0010)
hold on
plot(new_tc01_smo.Time, new_tc01_smo.TC1) % New System - TIC0 TC1 (TC01)
plot(new_tc02_smo.Time, new_tc02_smo.TC2) % New System - TIC0 TC2 (TC02)
plot(new_tc03_smo.Time, new_tc03_smo.TC3) % New System - TIC0 TC3 (TC03)
plot(new_tc04_smo.Time, new_tc04_smo.TC4) % New System - TIC0 TC4 (TC04)
plot(new_thr0_smo.Time, new_thr0_smo.Therm) % New System - TIC0 Thermistor (Therm)
title("New Data Smoothed - TIC0");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00', 'TC01', 'TC02', 'TC03', 'TC04', 'Therm');

% tic1
figure(72);
plot(new_tc10_smo.Time, new_tc10_smo.TC0) % New System - TIC1 TC0 (TC10)
% plot(leg_tc0010_out) % Legacy TC 0010 (TC0010)
hold on
plot(new_tc11_smo.Time, new_tc11_smo.TC1) % New System - TIC1 TC1 (TC11)
plot(new_tc12_smo.Time, new_tc12_smo.TC2) % New System - TIC1 TC2 (TC12)
plot(new_tc13_smo.Time, new_tc13_smo.TC3) % New System - TIC1 TC3 (TC13)
plot(new_tc14_smo.Time, new_tc14_smo.TC4) % New System - TIC1 TC4 (TC14)
plot(new_thr1_smo.Time, new_thr1_smo.Therm) % New System - TIC1 Thermistor (Therm)
title("New Data Smoothed - TIC1");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC10', 'TC11', 'TC12', 'TC13', 'TC14', 'Therm');



%% Test resampling timetable (Legacy)

data_source = 'smo';
switch data_source
    case 'rmo'
        leg_tc0010_tt = table2timetable(leg_tc0010_rmo);
        leg_tc0012_tt = table2timetable(leg_tc0012_rmo);
        leg_tc0013_tt = table2timetable(leg_tc0013_rmo);
    case 'smo'
        leg_tc0010_tt = table2timetable(leg_tc0010_smo);
        leg_tc0012_tt = table2timetable(leg_tc0012_smo);
        leg_tc0013_tt = table2timetable(leg_tc0013_smo);
    otherwise
        disp("Value for data_source not valid")
end

% tc0010
% leg_tc0010_tt = table2timetable(leg_tc0010_smo);
leg_tc0010_ttreg = retime(leg_tc0010_tt,'regular','linear','TimeStep',minutes(1));
time_sec = seconds(leg_tc0010_ttreg.Timestamp - leg_tc0010_ttreg.Timestamp(1));
row_times = seconds(time_sec);
leg_tc0010_ttsec = timetable(leg_tc0010_ttreg.col5,RowTimes=row_times);

% tc0012
% leg_tc0012_tt = table2timetable(leg_tc0012_smo);
leg_tc0012_ttreg = retime(leg_tc0012_tt,'regular','linear','TimeStep',minutes(1));
time_sec = seconds(leg_tc0012_ttreg.Timestamp - leg_tc0012_ttreg.Timestamp(1));
row_times = seconds(time_sec);
leg_tc0012_ttsec = timetable(leg_tc0012_ttreg.col7,RowTimes=row_times);

% tc0013
% leg_tc0013_tt = table2timetable(leg_tc0013_smo);
leg_tc0013_ttreg = retime(leg_tc0013_tt,'regular','linear','TimeStep',minutes(1));
time_sec = seconds(leg_tc0013_ttreg.Timestamp - leg_tc0013_ttreg.Timestamp(1));
row_times = seconds(time_sec);
leg_tc0013_ttsec = timetable(leg_tc0013_ttreg.col8,RowTimes=row_times);

clear leg_tc0010_tt leg_tc0010_ttreg 
clear leg_tc0012_tt leg_tc0012_ttreg 
clear leg_tc0013_tt leg_tc0013_ttreg 
clear row_times


%% Test resampling timetable (New - TIC0)

% tic0
switch data_source
    case 'rmo'
        new_tc00_tt = table2timetable(new_tc00_rmo);
        new_tc01_tt = table2timetable(new_tc01_rmo);
        new_tc02_tt = table2timetable(new_tc02_rmo);
        new_tc03_tt = table2timetable(new_tc03_rmo);
        new_tc04_tt = table2timetable(new_tc04_rmo);
        new_thr0_tt = table2timetable(new_thr0_rmo);

    case 'smo'
        new_tc00_tt = table2timetable(new_tc00_smo);
        new_tc01_tt = table2timetable(new_tc01_smo);
        new_tc02_tt = table2timetable(new_tc02_smo);
        new_tc03_tt = table2timetable(new_tc03_smo);
        new_tc04_tt = table2timetable(new_tc04_smo);
        new_thr0_tt = table2timetable(new_thr0_smo);
    otherwise
        disp("Value for data_source not valid")
end

new_tc00_ttreg = retime(new_tc00_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc00_ttreg.Time - new_tc00_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc00_ttsec = timetable(new_tc00_ttreg.TC0,RowTimes=row_times);

new_tc01_ttreg = retime(new_tc01_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc01_ttreg.Time - new_tc01_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc01_ttsec = timetable(new_tc01_ttreg.TC1,RowTimes=row_times);

new_tc02_ttreg = retime(new_tc02_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc02_ttreg.Time - new_tc02_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc02_ttsec = timetable(new_tc02_ttreg.TC2,RowTimes=row_times);

new_tc03_ttreg = retime(new_tc03_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc03_ttreg.Time - new_tc03_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc03_ttsec = timetable(new_tc03_ttreg.TC3,RowTimes=row_times);

new_tc04_ttreg = retime(new_tc04_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc04_ttreg.Time - new_tc04_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc04_ttsec = timetable(new_tc04_ttreg.TC4,RowTimes=row_times);

new_thr0_ttreg = retime(new_thr0_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_thr0_ttreg.Time - new_thr0_ttreg.Time(1));
row_times = seconds(time_sec);
new_thr0_ttsec = timetable(new_thr0_ttreg.Therm,RowTimes=row_times);

clear new_tc00_tt new_tc00_ttreg new_tc01_tt new_tc01_ttreg
clear new_tc02_tt new_tc02_ttreg new_tc03_tt new_tc03_ttreg
clear new_tc04_tt new_tc04_ttreg new_thr0_tt new_thr0_ttreg
clear row_times


%% Test resampling timetable (New - TIC1)

% tic0
switch data_source
    case 'rmo'
        new_tc10_tt = table2timetable(new_tc10_rmo);
        new_tc11_tt = table2timetable(new_tc11_rmo);
        new_tc12_tt = table2timetable(new_tc12_rmo);
        new_tc13_tt = table2timetable(new_tc13_rmo);
        new_tc14_tt = table2timetable(new_tc14_rmo);
        new_thr1_tt = table2timetable(new_thr1_rmo);

    case 'smo'
        new_tc10_tt = table2timetable(new_tc10_smo);
        new_tc11_tt = table2timetable(new_tc11_smo);
        new_tc12_tt = table2timetable(new_tc12_smo);
        new_tc13_tt = table2timetable(new_tc13_smo);
        new_tc14_tt = table2timetable(new_tc14_smo);
        new_thr1_tt = table2timetable(new_thr1_smo);
    otherwise
        disp("Value for data_source not valid")
end

new_tc10_ttreg = retime(new_tc10_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc10_ttreg.Time - new_tc10_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc10_ttsec = timetable(new_tc10_ttreg.TC0,RowTimes=row_times);

new_tc11_ttreg = retime(new_tc11_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc11_ttreg.Time - new_tc11_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc11_ttsec = timetable(new_tc11_ttreg.TC1,RowTimes=row_times);

new_tc12_ttreg = retime(new_tc12_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc12_ttreg.Time - new_tc12_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc12_ttsec = timetable(new_tc12_ttreg.TC2,RowTimes=row_times);

new_tc13_ttreg = retime(new_tc13_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc13_ttreg.Time - new_tc13_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc13_ttsec = timetable(new_tc13_ttreg.TC3,RowTimes=row_times);

new_tc14_ttreg = retime(new_tc14_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_tc14_ttreg.Time - new_tc14_ttreg.Time(1));
row_times = seconds(time_sec);
new_tc14_ttsec = timetable(new_tc14_ttreg.TC4,RowTimes=row_times);

new_thr1_ttreg = retime(new_thr1_tt,'regular','linear','TimeStep',seconds(60));
time_sec = seconds(new_thr1_ttreg.Time - new_thr1_ttreg.Time(1));
row_times = seconds(time_sec);
new_thr1_ttsec = timetable(new_thr1_ttreg.Therm,RowTimes=row_times);

clear new_tc10_tt new_tc10_ttreg new_tc11_tt new_tc11_ttreg
clear new_tc12_tt new_tc12_ttreg new_tc13_tt new_tc13_ttreg
clear new_tc14_tt new_tc14_ttreg new_thr1_tt new_thr1_ttreg
clear row_times



%% Getting differences

% TC0010 Bundle
tc03_diff = new_tc03_ttsec - leg_tc0010_ttsec;
tc04_diff = new_tc04_ttsec - leg_tc0010_ttsec;

% TC0012 Bundle
tc01_diff = new_tc01_ttsec - leg_tc0012_ttsec;
tc02_diff = new_tc02_ttsec - leg_tc0012_ttsec;

% TC0013 Bundle
tc00_diff = new_tc00_ttsec - leg_tc0013_ttsec;

% Thermistors
therm_diff = new_thr1_ttsec - new_thr0_ttsec;

% TC03 - TC04 Diff
tc03_04_diff = abs(new_tc03_ttsec - new_tc04_ttsec);

% TC01 - TC02 Diff
tc01_02_diff = abs(new_tc01_ttsec - new_tc02_ttsec);



figure(82);
hold on
grid on
plot(tc03_diff.Time, tc03_diff.Var1)
plot(tc04_diff.Time, tc04_diff.Var1)
title("Measurement Differences for TC0010 Bundle");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC03', 'TC04');

figure(83);
hold on
grid on
plot(tc01_diff.Time, tc01_diff.Var1)
plot(tc02_diff.Time, tc02_diff.Var1)
title("Measurement Differences for TC0012 Bundle");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC01', 'TC02');

figure(84);
hold on
grid on
plot(tc00_diff.Time, tc00_diff.Var1)
title("Measurement Differences for TC0013 Bundle");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC00');

figure(85);
hold on
grid on
plot(therm_diff.Time, therm_diff.Var1)
title("Measurement Differences for Thermistors");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Therm TIC1 - Therm TIC0');

figure(86);
hold on
grid on
plot(tc03_04_diff.Time, tc03_04_diff.Var1)
plot(tc01_02_diff.Time, tc01_02_diff.Var1)
title("Measurement Differences for TIC0 Channels");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC03-TC04', 'TC01-TC02');



%%
figure(90);
plot(leg_tc0010_ttsec.Time, leg_tc0010_ttsec.Var1)
hold on
plot(new_tc03_ttsec.Time, new_tc03_ttsec.Var1)
plot(new_tc04_ttsec.Time, new_tc04_ttsec.Var1)
grid on
title("Temperature Readings for Bundle TC0010");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0010', 'TC03', 'TC04');

figure(91);
plot(leg_tc0012_ttsec.Time, leg_tc0012_ttsec.Var1)
hold on
plot(new_tc01_ttsec.Time, new_tc01_ttsec.Var1)
plot(new_tc02_ttsec.Time, new_tc02_ttsec.Var1)
grid on
title("Temperature Readings for Bundle TC0012");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0012', 'TC01', 'TC02');

figure(92);
plot(leg_tc0013_ttsec.Time, leg_tc0013_ttsec.Var1)
hold on
plot(new_tc00_ttsec.Time, new_tc00_ttsec.Var1)
grid on
title("Temperature Readings for Bundle TC0013");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('TC0013', 'TC00');


%% Correlation coefficient
% some tests to calculate correlation coefficientes and create scatter
% plots

% correlation coefficients
disp('Correlation Coefficient for TC0012 and TC01')
R = corrcoef(leg_tc0012_ttsec.Var1, new_tc01_ttsec.Var1);
C = R(2,1)
disp('Correlation Coefficient for TC0012 and TC02')
R = corrcoef(leg_tc0012_ttsec.Var1, new_tc02_ttsec.Var1);
C = R(2,1)
disp('Correlation Coefficient for TC0010 and TC03')
R = corrcoef(leg_tc0010_ttsec.Var1, new_tc03_ttsec.Var1);
C = R(2,1)
disp('Correlation Coefficient for TC0010 and TC04')
R = corrcoef(leg_tc0010_ttsec.Var1, new_tc04_ttsec.Var1);
C = R(2,1)
disp('Correlation Coefficient for TC0013 and TC00')
R = corrcoef(leg_tc0013_ttsec.Var1, new_tc00_ttsec.Var1);
C = R(2,1)
disp('Correlation Coefficient for Therm0 and TC00')
R = corrcoef(new_thr0_ttsec.Var1, new_tc00_ttsec.Var1);
C = R(2,1)


%% scatter plots
figure(100)
sz = 10;
scatter(leg_tc0013_ttsec.Var1, new_tc00_ttsec.Var1, sz, 'b', '*')
grid on
title("Scatter Plot for TC00 versus Reference Temperature TC0013 ");
xlabel("TC0013");
ylabel("TC00");
% legend('TC0013', 'TC00');


%% calculate noise using envelope
% should probably use signals before smoothing operations


[yupper,ylower] = envelope(new_tc00_ttsec.Var1);
env_diff = yupper - ylower;
noise_tc00 = mean(env_diff)

