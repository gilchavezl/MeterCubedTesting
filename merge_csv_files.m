function merge_csv_files(inputFolder, outputFileName, datetimeColumnName)
    % Initialize an empty table to hold all data
    mergedData = table();

    % Get a list of all CSV files in the input folder
    files = dir(fullfile(inputFolder, '*.csv'));

    % Loop through each file and append its data to the master table
    for i = 1:length(files)
        % Construct the full file path
        filePath = fullfile(inputFolder, files(i).name);

        % Read the CSV file into a table
        data = readtable(filePath);

        % Append data to the master table
        mergedData = [mergedData; data];
    end

    % Convert the datetime column to datetime type if it's not already
    if ~iscell(mergedData.(datetimeColumnName)) && ~isdatetime(mergedData.(datetimeColumnName))
        mergedData.(datetimeColumnName) = datetime(mergedData.(datetimeColumnName), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
    end

    % Sort the merged data by the datetime column
    mergedData = sortrows(mergedData, datetimeColumnName);

    % Write the merged and sorted table to a new CSV file
    writetable(mergedData, outputFileName);

    disp(['Consolidated data has been written to ' outputFileName]);
end

