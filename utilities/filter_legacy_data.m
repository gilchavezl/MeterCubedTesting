function filter_legacy_data(projectRoot)
    % filter_legacy_data
    % Processes legacy data files by adding Timestamps, filtering placeholder values, 
    % and cleaning the data.

    % Define input and output directories relative to the project root
    inputFolder = fullfile(projectRoot, 'LegacyTemps', '2_CSV_Files');
    outputFolder = fullfile(projectRoot, 'LegacyTemps', '3_Filtered_Files');

    % Ensure the output folder exists
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    % Get a list of all CSV files in the input folder
    files = dir(fullfile(inputFolder, '*.csv'));
    if isempty(files)
        warning('No CSV files found in %s. Skipping filtering step.', inputFolder);
        return;
    end

    % Placeholder value in decoded FITS files
    fillerValue = 1.59999998941053e+38;

    % Loop through each file
    for i = 1:length(files)
        filename = files(i).name;

        % Define input and output file paths
        inputFileName = fullfile(inputFolder, filename);
        outputFileName = fullfile(outputFolder, [filename(1:end-4) '_filtered.csv']);

        % Determine file type and process accordingly
        if length(filename) >= 10 && strcmp(filename(1:4), 'ttmp')
            % Process `ttmp` files
            process_legacy_file(inputFileName, outputFileName, fillerValue, 11);
        elseif length(filename) >= 10 && strcmp(filename(1:4), 'jtmp')
            % Process `jtmp` files
            process_legacy_file(inputFileName, outputFileName, fillerValue, 3);
        else
            warning('File %s does not match expected naming conventions. Skipping.', filename);
        end
    end

    disp('Filtering of legacy data complete.');
end

function process_legacy_file(inputFileName, outputFileName, fillerValue, numColumns)
    % Helper function to process a single legacy file

    % Extract the date from the filename
    filename = extractAfter(inputFileName, filesep); % Get the filename only
    dateStr = filename(end-9:end-4);
    formattedDate = [dateStr(3:4) '-' dateStr(5:6) '-20' dateStr(1:2)];
    desiredDate = datetime(formattedDate, 'InputFormat', 'MM-dd-yyyy');

    % Read the input file
    data = readtable(inputFileName);

    % Generate timestamps for each minute of the day
    timestamps = desiredDate + minutes((0:1439)');
    fullTimestamps = cellstr(datestr(timestamps, 'yyyy-mm-dd HH:MM:SS'));

    % Add timestamps to the data
    newData = table(fullTimestamps, 'VariableNames', {'Timestamp'});
    newData = [newData data];

    % Save the updated table to a file
    writetable(newData, outputFileName);

    % Re-read the file to apply filtering logic
    legacy_temps_raw = readtable(outputFileName);

    % Extract only the first `numColumns` columns
    legacy_temps_raw = legacy_temps_raw(:, 1:numColumns);

    % Identify numeric columns
    numericCols = varfun(@isnumeric, legacy_temps_raw, 'OutputFormat', 'uniform');

    % Replace filler values with NaN
    numericData = legacy_temps_raw{:, numericCols};
    numericData(numericData == fillerValue) = NaN;
    legacy_temps_raw{:, numericCols} = numericData;

    % Remove rows with any NaN values
    cleanedData = rmmissing(legacy_temps_raw);

    % Rename columns for `jtmp` files
    nameStr = filename(end-13:end-10);
    if strcmp(nameStr, 'jtmp')
        cleanedData = renamevars(cleanedData, ["col0", "col1"], ["therm1", "therm2"]);
    end

    % Save the filtered data back to the output file
    writetable(cleanedData, outputFileName);
    fprintf('Processed and saved filtered file: %s\n', outputFileName);
end
