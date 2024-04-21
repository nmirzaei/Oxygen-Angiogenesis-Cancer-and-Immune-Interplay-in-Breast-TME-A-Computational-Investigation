import pandas as pd

def delete_columns_from_b(a_csv_file, b_csv_file, c_csv_file):
    # Read tab-delimited CSV files into Pandas DataFrames
    df_a = pd.read_csv(a_csv_file, sep='\t')
    df_b = pd.read_csv(b_csv_file, sep='\t')

    # Find common headers in both DataFrames
    common_headers = set(df_a.columns).intersection(df_b.columns)

    # Delete columns from DataFrame b that have headers present in DataFrame a
    df_b = df_b.drop(columns=common_headers)

    # Save the modified DataFrame to c.csv as tab-delimited
    df_b.to_csv(c_csv_file, sep='\t', index=False)

if __name__ == "__main__":
    a_csv_file = "Insignificant_cell_types.txt"
    b_csv_file = "ImmGen.txt"
    c_csv_file = "ImmGen_filtered.txt"
    delete_columns_from_b(a_csv_file, b_csv_file, c_csv_file)
