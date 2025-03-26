function process_legacy_data(projectRoot)
    % Process legacy data: decode FITS, filter, and merge into one file.
    inputFolder = '../LegacyTemps/2_CSV_Files';
    filteredFolder = '../LegacyTemps/3_Filtered_Files';
    mergedFolder = '../LegacyTemps/4_Merged_Files';


    % Step 1: Decode FITS files, if present
    decode_fits_files(projectRoot);

    % Step 2: Check for decoded CSV files to filter
    csvFiles = dir(fullfile(inputFolder, '*.csv'));
    if isempty(csvFiles)
        warning('No CSV files found in %s. Skipping filtering step.', inputFolder);
    else
        filter_legacy_data(projectRoot); % Proceed to filter data
        merge_ttmp_jtmp(projectRoot);
    end

    % Step 3: Check for filtered files to merge
    filteredFiles = dir(fullfile(filteredFolder, '*.csv'));
    if isempty(filteredFiles)
        warning('No filtered files found in %s. Skipping merging step.', filteredFolder);
    else
        % Merge filtered files into one
        merge_csv_files(mergedFolder, '../LegacyTemps/LegacyTemps_All.csv', 'Timestamp');
    end
end
