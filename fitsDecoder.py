import astropy.io.fits as fits
from astropy.table import Table
import os, sys
import glob
from pathlib import Path

arg_path = sys.argv[1]

def inspect_fits(fits_file_path):
    # Expand the tilde to the full path
    fits_file_path = os.path.expanduser(fits_file_path)
    
    # Open the FITS file and inspect its contents
    with fits.open(fits_file_path) as hdul:
        hdul.info()

def read_fits_to_table(fits_file_path, hdu_index=0):
    # Expand the tilde to the full path
    fits_file_path = os.path.expanduser(fits_file_path)
    
    # Open the FITS file
    with fits.open(fits_file_path) as hdul:
        # Access the specified HDU
        data = hdul[hdu_index].data
        if data is None:
            raise ValueError(f"No data found in HDU {hdu_index}")
        
        # Convert the FITS data to an Astropy Table
        table = Table(data)
    return table

def save_table_to_csv(table, csv_file_path):
    table.write(csv_file_path, format='csv', overwrite=True)

def process_fits_files(input_folder, output_folder):
    # Expand the tilde to the full path
    input_folder = os.path.expanduser(input_folder)
    output_folder = os.path.expanduser(output_folder)
    
    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)
    
    # Get a list of all FITS files in the input folder
    fits_files = glob.glob(os.path.join(input_folder, '*.fits'))
    
    for fits_file in fits_files:
        try:
            # Inspect the FITS file to determine the correct HDU index
            inspect_fits(fits_file)
            
            # The data is in the PRIMARY HDU (index 0)
            hdu_index = 0  # As identified by inspection
            
            # Read the FITS file into a table
            table = read_fits_to_table(fits_file, hdu_index)
            
            # Define the CSV file path in the output folder
            base_name = os.path.basename(fits_file)
            csv_file_path = os.path.join(output_folder, os.path.splitext(base_name)[0] + '.csv')
            
            # Save the table to a CSV file
            save_table_to_csv(table, csv_file_path)
            print(f"CSV file saved to: {csv_file_path}")
        except Exception as e:
            print(f"Failed to process {fits_file}: {e}")

def main():
    # # input_folder = '~/Desktop/MeterCubedTesting/LegacyTemps/1_Fits_Files'
    # input_folder = 'C:/Users/Gilberto/Documents/SO - ETS/ETS Projects/RFCML Casting Furnace Upgrade/TMS/TIP Chassis M3 Furnace Testing/MeterCubedTesting/LegacyTemps/1_Fits_Files'
    # # output_folder = '~/Desktop/MeterCubedTesting/LegacyTemps/2_CSV_Files'
    # output_folder = 'C:/Users/Gilberto/Documents/SO - ETS/ETS Projects/RFCML Casting Furnace Upgrade/TMS/TIP Chassis M3 Furnace Testing/MeterCubedTesting/LegacyTemps/2_CSV_Files'    
    # process_fits_files(input_folder, output_folder)
    # folder_path = os.path.dirname(__file__)
    # input_subfolder = 'LegacyTemps\1_Fits_Files'
    # output_subfolder = 'LegacyTemps\2_CSV_Files'
    # input_folder = os.path.join(folder_path, input_subfolder)
    # output_folder = os.path.join(folder_path, output_subfolder)
    # print(f'INPUT FOLDER: {input_folder}')
    # print(f'OUTPUT FOLDER: {output_folder}')

    folder_path = arg_path
    print(folder_path)
    str_path = folder_path
    path = Path(str_path)
    input_subfolder = "LegacyTemps\\1_Fits_Files"
    output_subfolder = "LegacyTemps\\2_CSV_Files"
    input_folder = os.path.join(path, input_subfolder)
    output_folder = os.path.join(path, output_subfolder)
    print(f'INPUT FOLDER: {input_folder}')
    print(f'OUTPUT FOLDER: {output_folder}')
    process_fits_files(input_folder, output_folder)
    

if __name__ == '__main__':
    main()

    