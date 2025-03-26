function setup_environment()
    % Define Python executable path
    python_path = 'C:\Users\nestor212\.pyenv\pyenv-win\versions\3.9.13\python.exe'; % Update to match your system's Python path

    % Check if Python is already configured correctly
    current_pyenv = pyenv();
    if strcmp(current_pyenv.Status, "Loaded") && strcmp(current_pyenv.Version, python_path)
        fprintf('Python environment is already set up with version: %s\n', python_path);
        return;
    end

    % Attempt to set up the Python environment
    try
        pyenv('Version', python_path);
        fprintf('Python environment configured successfully with version: %s\n', python_path);
    catch ME
        error('Python environment setup failed. Ensure the path is correct and Python is installed.\n%s', ME.message);
    end
end
