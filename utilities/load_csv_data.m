function [legacyTemps, tic0_temps, tic1_temps, tic4_temps] = load_csv_data()
    legacyTemps_filepath = '../LegacyTemps/LegacyTemps_All.csv';
    tic0_filepath = '../NewTemps/TIC0_All.csv';
    tic1_filepath = '../NewTemps/TIC1_All.csv';
    tic4_filepath = '../NewTemps/TIC4_All.csv';

    legacyTemps = readtable(legacyTemps_filepath);
    tic0_temps = readtable(tic0_filepath);
    tic1_temps = readtable(tic1_filepath);
    tic4_temps = readtable(tic4_filepath);
end
