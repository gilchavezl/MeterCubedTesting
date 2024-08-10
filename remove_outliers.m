function [clean_data] = remove_outliers(raw_data_column, raw_matrix)
%REMOVE_OUTLIERS Takes a vector and removes outliers.
%   Applies rmoutliers function to raw data vector, returns a vector with
%   clean data.

[~, TFrm ] = rmoutliers(raw_data_column,"movmedian",10);
out_filter = not(TFrm);
clean_data = raw_matrix(out_filter,:);

end