import pandas as pd

def read_excel_credentials(file_path, sheet_name):
    try:
        # Read the Excel file into a DataFrame
        df = pd.read_excel(file_path, sheet_name=sheet_name, header=0)
        # print("Columns in DataFrame:", df.columns)  # Add this line to print column names
        df = df[["IP Number \n(10 Digits)", "No of Days for which wages paid/payable during the month", "Total Monthly Wages"]]
        # print(df)
        return df

    except pd.errors.EmptyDataError:
        print(f"No data found in sheet '{sheet_name}'.")
        return None
    except Exception as e:
        print(f"Error reading Excel file: {e}")
        return None

# Specify the path to your Excel file
excel_file_path = '/home/buzzadmin/Downloads/Pondicherry-MC_Template1.xls'

# Specify the sheet name and columns to print
sheet_name = 'Sheet1'

# Read all credentials from the Excel file
credentials_df = read_excel_credentials(excel_file_path, sheet_name)

# Check if credentials_df is not None
if credentials_df is not None:
    # Iterate over rows and print credentials
    for index, row in credentials_df.iterrows():
        IP_Number = int(float(row["IP Number \n(10 Digits)"]))
        No_of_Days = int(float(row["No of Days for which wages paid/payable during the month"]))
        Amount = int(float(row["Total Monthly Wages"]))
        print(f"{IP_Number},{No_of_Days},{Amount}")
else:
    print("No credentials found.")