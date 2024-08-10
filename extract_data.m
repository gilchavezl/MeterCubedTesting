%% Documentation
% This script extracts data from FITS files containing thermocouple
% measurements from the SOML Casting Oven Legacy System, along with
% thermocouple measurements from the Furnace Upgrade TMS CCHM/TIC hardware
% stored in CSV files.
%
% Origin files should be placed in the following locations:
% - For legacy system files (FITS) place files under:
%   ./LegacyTemps/1_Fits_Files
% - For upgrade system files (CSV) place files under:
%   ./NewTemps/1_Raw_Files
%
% This script creates and relies on intermediate files, make sure the
% following folders exist:
% ./LegacyTemps/2_CSV_Files
% ./LegacyTemps/3_Filtered_Files
% ./NewTemps/2_Matlab_Time
% 
% Data is stored in a single CSV fill for each data source, namely:
% - Legacy System: ./LegacyTemps/LegacyTemps_All.csv
% - Upgrade Hardware TIC0: ./NewTemps/TIC0_All.csv
% - Upgrade Hardware TIC1: ./NewTemps/TIC1_All.csv

%% Set up python environment for .fits file decoding script.
% Only python 3.8 & 3.9 are supported.
% Replace filepath below with filepath to python executable as needed.

% pyenv('Version', 'PATH_TO_PYTHON_EXECUTABLE'); % Set the Python version


%% Please perform the following prior to running this script. 

% 1) Ensure matlab has been set up to run python scripts (see above).

% 2) Ensure *.fits files have been saved into 'LegacyTemps/1_Fits_Files' folder.

% 3) Ensure data files from new system logger have been saved into
%    'NewTemps/1_Raw_Files' folder


%% Processing of Meter Cubed Legacy Data files.

% Run python script to decode fits files located in 'LegacyTemps/1_Fits_Files' 
% Saves decoded files to 'LegacyTemps/2_CSV_Files' folder.
mfiledir = fileparts(mfilename('fullpath'));
fprintf('Root folder is: %s\n',mfiledir);
py_file = "fitsDecoder.py";
arg = mfiledir;
pyrun_arg = strcat(py_file, " '", arg, "'" );
pyrunfile(pyrun_arg)
 
inputFolder = 'LegacyTemps/2_CSV_Files'; % CSV files of raw decoded data from fits files.
outputFolder = 'LegacyTemps/3_Filtered_Files'; % Processed CSV files, timestamps added and null data filtered.

% Get a list of all CSV files in the input folder.
files = dir(fullfile(inputFolder, '*.csv'));

% Loop through each file.
for i = 1:length(files)
    filename = files(i).name;
    
    % Make sure filename matches the expected pattern.
    if length(filename) >= 10 && strcmp(filename(1:4), 'ttmp')
        % Extract the part of the filename that contains the date, all
        % files should have the same length and structure.
        dateStr = filename(5:10);
        
        % Rearrange the date to the desired format (MM-DD-YYYY).
        formattedDate = [dateStr(3:4) '-' dateStr(5:6) '-20' dateStr(1:2)];
        
        % Convert the formatted date to a datetime object.
        desiredDate = datetime(formattedDate, 'InputFormat', 'MM-dd-yyyy');
        
        % Define the input and output file names.
        inputFileName = fullfile(inputFolder, filename);
        outputFileName = fullfile(outputFolder, [filename(1:end-4) '_filtered.csv']);
        
        % Read the CSV file into a table.
        data = readtable(inputFileName);
        
        % Create a column of official timestamps for each minute of the day starting from the desired date.
        timestamps = desiredDate + minutes((0:1439)');
      
        % Convert timestamps to datetime strings.
        fullTimestamps = cellstr(datestr(timestamps, 'yyyy-mm-dd HH:MM:SS'));
        
        % Create a new table with the timestamps as the first column
        newData = table(fullTimestamps, 'VariableNames', {'Timestamp'});
        
        % Concatenate the new column with the original data
        newData = [newData data];
        
        % Write the updated table back to a new CSV file
        writetable(newData, outputFileName);
        
        % Filter out placeholder values
        legacy_temps_raw = readtable(outputFileName);

        % Extract only first 11 columns containing datetime & metercubed TC data.
        legacy_temps_raw = legacy_temps_raw(:, 1:11); 
        
        % .fits files are pre-populated with this value.
        fillerValue = 1.59999998941053e+38; 
        
        % Identify numeric columns
        numericCols = varfun(@isnumeric, legacy_temps_raw, 'OutputFormat', 'uniform'); 
        
        % Separate the numeric and non-numeric parts of the table
        numericData = legacy_temps_raw{:, numericCols};     
        nonNumericData = legacy_temps_raw{:, ~numericCols};
        
        % Replace filler values with NaN in numeric data
        numericData(numericData == fillerValue) = NaN; 
        
        % Combine the cleaned numeric data and non-numeric data back into a table
        legacy_temps_clean = [array2table(numericData, 'VariableNames', legacy_temps_raw.Properties.VariableNames(numericCols)), ...
                              legacy_temps_raw(:, ~numericCols)];
        
        % Reorder columns to match the original table
        legacy_temps_clean = legacy_temps_clean(:, legacy_temps_raw.Properties.VariableNames);
        
        % Remove rows that contain any NaN values
        legacy_temps_clean_noNaN = rmmissing(legacy_temps_clean);
        
        % Save the cleaned table to a new file
        writetable(legacy_temps_clean_noNaN, outputFileName);
    end
end

% Merge all Meter Cubed data from multiple CSV files
inputFolder = 'LegacyTemps/3_Filtered_Files';
outputFileName = 'LegacyTemps/LegacyTemps_All.csv';
datetimeColumnName = 'Timestamp'; % Adjust this to the name of your datetime column
merge_csv_files(inputFolder, outputFileName, datetimeColumnName);

disp('Processing of .fits files is complete.');

%% Processing of New System Data files 
% Convert timestamp from Unix to Matlab datetime object for handling

inputFolder = 'NewTemps/1_Raw_Files'; % Define the file path for tic0

% Get a list of all CSV files in the input folder.
files = dir(fullfile(inputFolder, '*.csv'));

% Loop through each file.
for i = 1:length(files)
    filename = files(i).name;
    
    inputFileName = fullfile(inputFolder, filename);
  
    % Read the CSV file into a table.
    data = readtable(inputFileName);

    unixTimestampsSecs = data{:, 1} / 1000; % Convert the first column from Unix timestamps in milliseconds to seconds
    dateTimeColumn = datetime(unixTimestampsSecs, 'ConvertFrom', 'posixtime', 'TimeZone', 'MST'); % Convert the Unix timestamps to MATLAB datetime objects
    data.Time = dateTimeColumn; % Replace the first column with the datetime objects
    
    % Make sure filename matches the expected pattern.
    if strcmp(filename(1:4), 'tic0')
        outputFolder = 'NewTemps/2_Matlab_Time/TIC0/'; % Processed CSV files, timestamps added and null data filtered.
    elseif strcmp(filename(1:4), 'tic1')
        outputFolder = 'NewTemps/2_Matlab_Time/TIC1/'; % Processed CSV files, timestamps added and null data filtered.
    end 

    outputFileName = fullfile(outputFolder, [filename(1:end-4) '_matlab.csv']);
    writetable(data, outputFileName); % Save the updated table back to a file
end

% Merge all new logger CSV files for TIC 0
inputFolder = 'NewTemps/2_Matlab_Time/TIC0';
outputFileName = 'NewTemps/TIC0_All.csv';
datetimeColumnName = 'Time'; % Adjust this to the name of your datetime column
merge_csv_files(inputFolder, outputFileName, datetimeColumnName);

% Merge all new logger CSV files for TIC 1
inputFolder = 'NewTemps/2_Matlab_Time/TIC1';
outputFileName = 'NewTemps/TIC1_All.csv';
datetimeColumnName = 'Time'; % Adjust this to the name of your datetime column
merge_csv_files(inputFolder, outputFileName, datetimeColumnName);

disp('Processing of new TIC 0 & TIC 1 files is complete.');
