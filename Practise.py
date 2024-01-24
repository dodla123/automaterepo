import pandas as pd

# Step 1: Read the text file
with open('/home/buzzadmin/Documents/invalid_ips.txt', 'r') as file:
    try:
        # Filter out empty lines and non-integer values
        numbers_to_delete = [int(line.strip()) for line in file if line.strip().isdigit()]
    except ValueError as e:
        print(f"Error: {e}")
        print("Make sure all lines in the text file contain valid integer values.")
        numbers_to_delete = []

# Step 2: Read the Excel file into a DataFrame
df = pd.read_excel('/home/buzzadmin/Downloads/Pondicherry-MC_Template1.xls')
# print(df)
# print(df.columns)


# Step 3: Identify rows to delete
rows_to_delete = df[df['IP Number \n(10 Digits)'].isin(numbers_to_delete)].index

# Step 4: Delete identified rows
df.drop(rows_to_delete, inplace=True)

# Step 5: Save the updated DataFrame back to the Excel file
df.to_excel('/home/buzzadmin/Documents/updated.xlsx', index=False)            # in new file
# df.to_excel('/home/buzzadmin/Documents/Practise.xlsx', index=False)             # for saving in the same file

print("Rows with matching IP Numbers deleted successfully.")
print(df)

