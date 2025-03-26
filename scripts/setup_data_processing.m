% setup_data_processing.m
% This script prepares data by decoding FITS files, cleaning, and merging them.
scriptDir = fileparts(mfilename('fullpath')); % Directory of the current script
projectRoot = fullfile(scriptDir, '..'); % Move up one level to 'MeterCubedTestingDec24'
%cd(projectRoot);

% Add the utilities folder to the MATLAB path
addpath('/utilities');

% Step 1: Set up Python environment for FITS decoding
fprintf('Setting up Python environment...\n');
setup_environment();

% Step 2: Process Legacy System Data
fprintf('Processing Legacy System Data...\n');
try
    process_legacy_data(projectRoot); % Handles missing files gracefully
catch ME
    warning('An issue occurred while processing legacy system data: %s', ME.message);
end

% Step 3: Process New System Data
fprintf('Processing New System Data...\n');
try
    process_new_data(); % Handles missing files gracefully
catch ME
    warning('An issue occurred while processing new system data: %s', ME.message);
end

disp('Data processing complete. All required files are ready.');
