function process_new_data()
    % Define paths relative to this script's directory
    projectRoot = fileparts(mfilename('fullpath'));
    inputFolder = fullfile(projectRoot, '../NewTemps', '1_Raw_Files');
    outputFolderTIC0 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC0');
    outputFolderTIC1 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC1');
    outputFolderTIC2 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC2');
    outputFolderTIC3 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC3');
    outputFolderTIC4 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC4');
    outputFolderTIC5 = fullfile(projectRoot, '../NewTemps', '2_Matlab_Time', 'TIC5');


    % Ensure output directories exist
    if ~exist(outputFolderTIC0, 'dir')
        mkdir(outputFolderTIC0);
    end
    if ~exist(outputFolderTIC1, 'dir')
        mkdir(outputFolderTIC1);
    end
    if ~exist(outputFolderTIC2, 'dir')
        mkdir(outputFolderTIC2);
    end
    if ~exist(outputFolderTIC3, 'dir')
        mkdir(outputFolderTIC3);
    end
    if ~exist(outputFolderTIC4, 'dir')
        mkdir(outputFolderTIC4);
    end
    if ~exist(outputFolderTIC5, 'dir')
        mkdir(outputFolderTIC5);
    end

    % Process the files
    files = dir(fullfile(inputFolder, '*.csv'));
    if isempty(files)
        warning('No CSV files found in %s. Skipping timestamp conversion.', inputFolder);
    else
        for i = 1:length(files)
            filename = files(i).name;
            filepath = fullfile(inputFolder, filename);

            % Read the data
            data = readtable(filepath);
            unixTimestampsSecs = data{:, 1} / 1000; % Convert Unix timestamps to seconds
            data.Time = datetime(unixTimestampsSecs, 'ConvertFrom', 'posixtime', 'TimeZone', 'MST');

            % Determine the output folder
            if startsWith(filename, 'tic0', 'IgnoreCase', true)
                outputFolder = outputFolderTIC0;
            elseif startsWith(filename, 'tic1', 'IgnoreCase', true)
                outputFolder = outputFolderTIC1;
            elseif startsWith(filename, 'tic2', 'IgnoreCase', true)
                outputFolder = outputFolderTIC1;
            elseif startsWith(filename, 'tic3', 'IgnoreCase', true)
                outputFolder = outputFolderTIC1;
            elseif startsWith(filename, 'tic4', 'IgnoreCase', true)
                outputFolder = outputFolderTIC4;
            elseif startsWith(filename, 'tic5', 'IgnoreCase', true)
                outputFolder = outputFolderTIC1;
            else
                warning('File %s does not match expected naming conventions. Skipping.', filename);
                continue;
            end

            % Save the converted data
            outputFileName = fullfile(outputFolder, [filename(1:end-4) '_matlab.csv']);
            writetable(data, outputFileName);
        end
        disp('New data timestamps converted successfully.');
    end

    % Merge TIC0 data
    tic0Files = dir(fullfile(outputFolderTIC0, '*.csv'));
    if isempty(tic0Files)
        warning('No converted TIC0 files found in %s. Skipping merge step.', outputFolderTIC0);
    else
        merge_csv_files(outputFolderTIC0, fullfile(projectRoot, '../NewTemps', 'TIC0_All.csv'), 'Time');
    end

    % Merge TIC1 data
    tic1Files = dir(fullfile(outputFolderTIC1, '*.csv'));
    if isempty(tic1Files)
        warning('No converted TIC1 files found in %s. Skipping merge step.', outputFolderTIC1);
    else
        merge_csv_files(outputFolderTIC1, fullfile(projectRoot, '../NewTemps', 'TIC1_All.csv'), 'Time');
    end

    % Merge TIC2 data
    tic2Files = dir(fullfile(outputFolderTIC2, '*.csv'));
    if isempty(tic2Files)
        warning('No converted TIC2 files found in %s. Skipping merge step.', outputFolderTIC2);
    else
        merge_csv_files(outputFolderTIC2, fullfile(projectRoot, '../NewTemps', 'TIC2_All.csv'), 'Time');
    end

    % Merge TIC3 data
    tic3Files = dir(fullfile(outputFolderTIC3, '*.csv'));
    if isempty(tic3Files)
        warning('No converted TIC3 files found in %s. Skipping merge step.', outputFolderTIC3);
    else
        merge_csv_files(outputFolderTIC3, fullfile(projectRoot, '../NewTemps', 'TIC3_All.csv'), 'Time');
    end

    % Merge TIC4 data
    tic4Files = dir(fullfile(outputFolderTIC4, '*.csv'));
    if isempty(tic4Files)
        warning('No converted TIC4 files found in %s. Skipping merge step.', outputFolderTIC4);
    else
        merge_csv_files(outputFolderTIC4, fullfile(projectRoot, '../NewTemps', 'TIC4_All.csv'), 'Time');
    end  

    % Merge TIC5 data
    tic5Files = dir(fullfile(outputFolderTIC5, '*.csv'));
    if isempty(tic5Files)
        warning('No converted TIC5 files found in %s. Skipping merge step.', outputFolderTIC5);
    else
        merge_csv_files(outputFolderTIC5, fullfile(projectRoot, '../NewTemps', 'TIC5_All.csv'), 'Time');
    end   
end
