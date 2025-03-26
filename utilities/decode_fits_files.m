function decode_fits_files(projectRoot)
    % Wrapper to run the Python script for decoding FITS files
    arg = projectRoot;

    py_script = '../fitsDecoder.py';
    pyrun_arg = strcat(py_script, " '", arg, "'" );

    fits_dir = fullfile('../LegacyTemps', '1_Fits_Files');

    % Check if the directory exists and contains FITS files
    fits_files = dir(fullfile(fits_dir, '*.fits'));
    if isempty(fits_files)
        warning('No FITS files found in %s. Skipping decoding step.', fits_dir);
        return; % Skip processing if no files are found
    end

    % Proceed to run the Python script if files are present
    try
        fprintf('Running Python script: %s\n', py_script);
        pyrunfile(pyrun_arg); % Run Python script
        disp('FITS files decoded successfully.');
    catch ME
        fprintf('An error occurred while running the Python script: %s\n', ME.message);
        rethrow(ME); % Re-throw error to MATLAB for debugging
    end
end
