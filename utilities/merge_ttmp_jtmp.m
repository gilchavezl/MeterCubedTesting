function merge_ttmp_jtmp(projectRoot)
    % merge_legacy_files
    % Merges `ttmp` and `jtmp` files from filtered data, handling timestamps and merging into one file.

    % Define paths relative to the project root
    inputFolder = fullfile(projectRoot, 'LegacyTemps', '3_Filtered_Files');
    outputFolder = fullfile(projectRoot, 'LegacyTemps', '4_Merged_Files');

    % Ensure the output folder exists
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    % Get a list of all CSV files in the input folder
    files = dir(fullfile(inputFolder, '*.csv'));
    if isempty(files)
        warning('No filtered files found in %s. Skipping merging step.', inputFolder);
        return;
    end

    % Loop through each `ttmp` file
    for i = 1:length(files)
        filename = files(i).name;

        % Check if the file is a `ttmp` file
        if length(filename) >= 10 && strcmp(filename(1:4), 'ttmp')
            % Extract the date from the filename
            dateStr = filename(5:10);

            % Define the corresponding `jtmp` filename
            jtmpFilename = ['jtmp' dateStr '_filtered.csv'];
            jtmpFilepath = fullfile(inputFolder, jtmpFilename);

            % Check if the corresponding `jtmp` file exists
            if exist(jtmpFilepath, 'file')
                % Read the `ttmp` and `jtmp` data
                ttmpData = readtable(fullfile(inputFolder, filename));
                jtmpData = readtable(jtmpFilepath);

                % List of timestamps to remove
                timestampsToRemove = [
                    datetime(2024, 8, 16, 14, 40, 00);
                    datetime(2024, 8, 16, 14, 41, 00);
                    datetime(2024, 8, 16, 14, 44, 00);
                    datetime(2024, 8, 16, 14, 45, 00);
                    datetime(2024, 8, 16, 14, 46, 00)
                ];

                % Remove rows matching specific timestamps from `jtmpData`
                for t = 1:length(timestampsToRemove)
                    rowsToRemove = jtmpData.Timestamp == timestampsToRemove(t);
                    jtmpData(rowsToRemove, :) = [];
                end

                % Merge the `jtmp` data columns into the `ttmp` data
                mergedData = [ttmpData, jtmpData(:, 2:end)]; % Skip the first column (timestamp) in `jtmpData`

                % Save the merged data to a new file
                outputFileName = fullfile(outputFolder, [filename(5:end-4) '.csv']);
                writetable(mergedData, outputFileName);
                fprintf('Merged file saved: %s\n', outputFileName);
            else
                % If no corresponding `jtmp` file, skip merging
                fprintf('No matching `jtmp` file for %s. Skipping merge.\n', filename);
            end
        end
    end

    % Merge all files in the merged folder into one CSV file
    mergedOutputFile = fullfile(projectRoot, 'LegacyTemps', 'LegacyTemps_All.csv');
    datetimeColumnName = 'Timestamp'; % Adjust this if your datetime column name is different
    merge_csv_files(outputFolder, mergedOutputFile, datetimeColumnName);

    disp('Merging of ttmp and jtmp files is complete.');
end
