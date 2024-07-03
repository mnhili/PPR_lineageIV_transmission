import os
import pandas as pd
import numpy as np

directory = r"D:\Approach_ML\DATA"  # Update this path

print(f"Processing directory: {directory}")

if os.path.exists(directory):
    print("Directory exists. Listing files...")
    files = os.listdir(directory)
    print("Files in directory:", files)
else:
    print(f"Directory does not exist: {directory}")


def process_csv(file_path, distance_thresholds):
    print(f"Processing file: {file_path}")
    data = pd.read_csv(file_path)
    print(data.head())

    # Initialize dictionary to store aggregated time for each Cap2 at each distance range
    aggregated_data = {}

    # Get unique Cap1 (seeder)
    seeder = data["Cap1"].unique()[0]

    for _, row in data.iterrows():
        if row["Cap2"] not in aggregated_data:
            aggregated_data[row["Cap2"]] = {
                f"time_between_{distance_thresholds[i]}_and_{distance_thresholds[i+1]}m": 0
                for i in range(len(distance_thresholds) - 1)
            }
            aggregated_data[row["Cap2"]][f"time_above_{distance_thresholds[-1]}m"] = 0

        # Count time in each distance range
        for i in range(len(distance_thresholds) - 1):
            if distance_thresholds[i] < row["Distance"] <= distance_thresholds[i + 1]:
                aggregated_data[row["Cap2"]][
                    f"time_between_{distance_thresholds[i]}_and_{distance_thresholds[i+1]}m"
                ] += 1

        # Count time above the last threshold
        if row["Distance"] > distance_thresholds[-1]:
            aggregated_data[row["Cap2"]][f"time_above_{distance_thresholds[-1]}m"] += 1

    # Convert dictionary to DataFrame
    records = []
    for id2, times in aggregated_data.items():
        record = {"seeder": seeder, "Cap2": id2}
        record.update(times)
        records.append(record)

    result_df = pd.DataFrame(records)

    # Divide all time columns by 60 to convert seconds to minutes
    time_columns = [col for col in result_df.columns if col.startswith("time")]
    result_df[time_columns] = result_df[time_columns] / 60

    return result_df


# Function to process all CSV files in the DATA directory with prefix "experiment"
def process_all_csv_files(directory, distance_thresholds):
    all_data = []

    for filename in os.listdir(directory):
        if filename.startswith("experiment") and filename.endswith(".csv"):
            file_path = os.path.join(directory, filename)
            if os.path.exists(file_path):
                data = process_csv(file_path, distance_thresholds)
                all_data.append(data)
            else:
                print(f"File does not exist: {file_path}")

    return pd.concat(all_data, ignore_index=True) if all_data else pd.DataFrame()


# Define distance thresholds
distance_thresholds = [0.05, 0.5, 1, 2]

# Process all files in the DATA directory
directory = r"D:\Approach_ML\DATA"  # Update this path
print(f"Processing directory: {directory}")

if os.path.exists(directory):
    proximity_data = process_all_csv_files(directory, distance_thresholds)
    print(proximity_data)
else:
    print(f"Directory does not exist: {directory}")


proximity_data.to_csv("D:/Approach_ML/OUTPUT/proximity_data.csv", index=False)

print("saved successfully")
