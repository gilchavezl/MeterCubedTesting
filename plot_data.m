%% plot_data.m
% Plotting data
% Code to plot data


%% Plot all raw data

legacyTemps_filepath = 'LegacyTemps/LegacyTemps_All.csv';
tic0_filepath = 'NewTemps/TIC0_All.csv';
tic1_filepath = 'NewTemps/TIC1_All.csv';

legacyTemps = readtable(legacyTemps_filepath);
tic0_temps = readtable(tic0_filepath);
tic1_temps = readtable(tic1_filepath);

figure(1);
plot(legacyTemps.Timestamp, legacyTemps.col5) % Legacy TC 0010 (TC0010)
hold on;
plot(tic0_temps.Time, tic0_temps.TC3); % New System - TIC0 TC3 (TC03)
plot(tic0_temps.Time, tic0_temps.TC4); % New System - TIC0 TC4 (TC04)
plot(tic1_temps.Time, tic1_temps.TC3); % New System - TIC1 TC3 (TC13)
title("Raw Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0010', 'New TC03', 'New TC04', 'New TC13');
%%
figure(2);
plot(legacyTemps.Timestamp, legacyTemps.col7) % Legacy TC 0012 (TC0012)
hold on;
plot(tic0_temps.Time, tic0_temps.TC1); % New System - TIC0 TC1 (TC01)
plot(tic0_temps.Time, tic0_temps.TC2); % New System - TIC0 TC2 (TC02)
plot(tic1_temps.Time, tic1_temps.TC1); % New System - TIC1 TC1 (TC11)
title("Raw Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0012', 'New TC01', 'New TC02', 'New TC11');
%%
figure(3);
plot(legacyTemps.Timestamp, legacyTemps.col8) % Legacy TC 0013 (TC0013)
hold on;
plot(tic0_temps.Time, tic0_temps.TC0); % New System - TIC0 TC0 (TC00)
plot(tic1_temps.Time, tic1_temps.TC2); % New System - TIC1 TC2 (TC12)
plot(tic1_temps.Time, tic1_temps.TC4); % New System - TIC1 TC4 (TC14)
title("Raw Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0013', 'New TC00', 'New TC12', 'New TC14');

%% Filter data to isolate equal timestamps accross all devices


tic0_temps.Time = dateshift(tic0_temps.Time, 'start', 'minute');
tic1_temps.Time = dateshift(tic1_temps.Time, 'start', 'minute');

% Find common timestamps between tic 0 and legacy sys.
[common_timestamps, idx1, idx2] = intersect(tic0_temps.Time, legacyTemps.Timestamp);

% Extract corresponding data from tic 0
tic0_filtered = tic0_temps(idx1,:);

% Find common timestamps between tic 0 and tic1.
[common_timestamps, idx1, idx2] = intersect(tic0_filtered.Time, tic1_temps.Time);

% Extract corresponding data from tic0 andn tic1.
tic0_filtered = tic0_filtered(idx1,:);
tic1_filtered = tic1_temps(idx2,:);

% Find common timestamps between tic 0, tic1 and legacy data.
[common_timestamps, idx1, idx2] = intersect(tic0_filtered.Time, legacyTemps.Timestamp);

% Extract corresponding data from legacy data.
legacy_filtered = legacyTemps(idx2,:);
%% Plot filtered data

figure(4);
plot(legacy_filtered.Timestamp, legacy_filtered.col5) % Legacy TC 0010 (TC0010)
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC3); % New System - TIC0 TC3 (TC03)
plot(tic0_filtered.Time, tic0_filtered.TC4); % New System - TIC0 TC4 (TC04)
plot(tic1_filtered.Time, tic1_filtered.TC3); % New System - TIC1 TC3 (TC13)
title("Matching Timestamps - Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0010', 'New TC03', 'New TC04', 'New TC13', 'location', 'best');

figure(5);
plot(legacy_filtered.Timestamp, legacy_filtered.col7) % Legacy TC 0012 (TC0012)
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC1); % New System - TIC0 TC1 (TC01)
plot(tic0_filtered.Time, tic0_filtered.TC2); % New System - TIC0 TC2 (TC02)
plot(tic1_filtered.Time, tic1_filtered.TC1); % New System - TIC1 TC1 (TC11)
title("Matching Timestamps - Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0012', 'New TC01', 'New TC02', 'New TC11', 'location', 'best');

figure(6);
plot(legacy_filtered.Timestamp, legacy_filtered.col8) % Legacy TC 0013 (TC0013)
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC0); % New System - TIC0 TC0 (TC00)
plot(tic1_filtered.Time, tic1_filtered.TC2); % New System - TIC1 TC2 (TC12)
plot(tic1_filtered.Time, tic1_filtered.TC4); % New System - TIC1 TC4 (TC14)
title("Matching Timestamps - Recorded temperatures over time");
xlabel("Datetime");
ylabel("Temperature (C)");
legend('Legacy TC0013', 'New TC00', 'New TC12', 'New TC14', 'location', 'best');

%% Plot Deltas
figure(7);
plot(legacy_filtered.Timestamp, (tic0_filtered.TC3 - legacy_filtered.col5)) % Legacy TC 0010 (TC0010)
hold on;
plot(tic0_filtered.Time, (tic0_filtered.TC4 - legacy_filtered.col5)); % New System - TIC0 TC4 (TC04)
plot(tic1_filtered.Time, (tic1_filtered.TC3 - legacy_filtered.col5)); % New System - TIC1 TC3 (TC13)
title("Temperature Deltas - TC0010 Bundle");
xlabel("Datetime");
ylabel("Temperature Delta (C)");
legend('New TC03', 'New TC04', 'New TC13');

figure(8);
plot(legacy_filtered.Timestamp, tic0_filtered.TC1 - legacy_filtered.col7) % Legacy TC 0012 (TC0012)
hold on;
plot(tic0_filtered.Time, tic0_filtered.TC2 - legacy_filtered.col7); % New System - TIC0 TC2 (TC02)
plot(tic1_filtered.Time, tic1_filtered.TC1 - legacy_filtered.col7); % New System - TIC1 TC1 (TC11)
title("Temperature Deltas - TC0012 Bundle");
xlabel("Datetime");
ylabel("Temperature Delta (C)");
legend('New TC01', 'New TC02', 'New TC11');

figure(9);
plot(legacy_filtered.Timestamp, tic0_filtered.TC0 - legacy_filtered.col8) % Legacy TC 0013 (TC0013)
hold on;
plot(tic1_filtered.Time, tic1_filtered.TC2 - legacy_filtered.col8); % New System - TIC1 TC2 (TC12)
plot(tic1_filtered.Time, tic1_filtered.TC4 - legacy_filtered.col8); % New System - TIC1 TC4 (TC14)
title("Temperature Deltas - TC0013 Bundle");
xlabel("Datetime");
ylabel("Temperature Delta (C)");
legend('New TC00', 'New TC12', 'New TC14');

%% Plot legacy vs new
figure(10);
scatter(legacy_filtered.col5, tic0_filtered.TC3) % Legacy TC 0010 (TC0010)
hold on;
scatter(legacy_filtered.col5, tic0_filtered.TC4); % New System - TIC0 TC4 (TC04)
scatter(legacy_filtered.col5, tic1_filtered.TC3); % New System - TIC1 TC3 (TC13)
title("Legacy Temperature vs. New Temperatures");
xlabel("Legacy System Temp (C)");
ylabel("New System Temp (C)");
legend('New TC03', 'New TC04', 'New TC13');

figure(11);
scatter(legacy_filtered.col7, tic0_filtered.TC1) % Legacy TC 0012 (TC0012)
hold on;
scatter(legacy_filtered.col7, tic0_filtered.TC2); % New System - TIC0 TC2 (TC02)
scatter(legacy_filtered.col7, tic1_filtered.TC1); % New System - TIC1 TC1 (TC11)
title("Legacy Temperature vs. New Temperatures");
xlabel("Legacy System Temp (C)");
ylabel("New System Temp (C)");
legend('New TC01', 'New TC02', 'New TC11');

figure(12);
scatter(legacy_filtered.col8, tic0_filtered.TC0) % Legacy TC 0013 (TC0013)
hold on;
scatter(legacy_filtered.col8, tic1_filtered.TC2); % New System - TIC1 TC2 (TC12)
scatter(legacy_filtered.col8, tic1_filtered.TC4); % New System - TIC1 TC4 (TC14)
title("Legacy Temperature vs. New Temperatures");
xlabel("Legacy System Temp (C)");
ylabel("New System Temp (C)");
legend('New TC00', 'New TC12', 'New TC14');

%%


% 
% figure(11);
% plot(legacyTemps.Timestamp, legacyTemps.col5) % Legacy TC 0010 (TC0010)
% hold on;
% plot(legacyTemps.Timestamp, legacyTemps.col7) % Legacy TC 0012 (TC0012)
% plot(legacyTemps.Timestamp, legacyTemps.col8) % Legacy TC 0013 (TC0013)

