import pandas as pd

def read_excel_credentials(file_path, sheet_name):
    try:
        # Read the Excel file into a DataFrame
        df = pd.read_excel(file_path, sheet_name=sheet_name, header=1)
        df = df[["User Name", "PASSWORD"]]
        return df

    except pd.errors.EmptyDataError:
        print(f"No data found in sheet '{sheet_name}'.")
        return None
    except Exception as e:
        print(f"Error reading Excel file: {e}")
        return None

# Specify the path to your Excel file
excel_file_path = '/home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx'

# Specify the sheet name and columns to print
sheet_name = 'Esic Logins'

# Read all credentials from the Excel file
credentials_df = read_excel_credentials(excel_file_path, sheet_name)

# Check if credentials_df is not None
if credentials_df is not None:
    # Iterate over rows and print credentials
    for index, row in credentials_df.iterrows():
        username = row["User Name"]
        password = row["PASSWORD"]
        print(f"{username}, {password}")
else:
    print("No credentials found.")


# def read_excel_credentials(file_path, sheet_name):
#     try:
#         # Open the Excel file
#         wb =.load_workbook(file_path)

        # Select the specified sheet
#         sheet = wb[sheet_name]

#         # Initialize an empty list to store credentials
#         credentials = []

#         # Iterate over rows and append credentials to the list
#         for row in sheet.iter_rows(min_row=2, values_only=True):
#             username, password = row[:2]  # Assuming User Name and PASSWORD are in the first two columns
#             credentials.append((username, password))

#         # Check if any credentials were found
#         if not credentials:
#             print(f"No data found in sheet '{sheet_name}'.")
#             return None

#         # Create a DataFrame-like structure with a list of tuples
#         df = {"User Name": [cred[0] for cred in credentials], "PASSWORD": [cred[1] for cred in credentials]}
#         return df

#     except Exception as e:
#         print(f"Error reading Excel file: {e}")
#         return None
#     finally:
#         # Close the Excel file
#         try:
#             wb.close()
#         except NameError:
#             pass

# # Specify the path to your Excel file
# excel_file_path = '/home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx'

# # Specify the sheet name
# sheet_name = 'Esic Logins'

# # Read all credentials from the Excel file
# credentials_df = read_excel_credentials(excel_file_path, sheet_name)

# # Check if credentials_df is not None
# if credentials_df is not None:
#     # Iterate over rows and print credentials
#     for index, row in credentials_df.items():
#         username, password = row["User Name"], row["PASSWORD"]
#         print(f"{username}, {password}")
# else:
#     print("No credentials found.")
    
