# src/utils/data_loader.py

import pandas as pd
import numpy as np

def load_processed_data(filename):
    """
    Load processed data from a CSV file.
    
    Args:
    filename (str): Name of the file to load from the data/processed/ directory
    
    Returns:
    pd.DataFrame: Loaded data
    """
    filepath = f"D:\ExpInfect_LinIV_PPRV\data\processed3\{filename}"
    return pd.read_csv(filepath)


def load_probas(filename2):
    """
    Load processed data from a CSV file.
    
    Args:
    filename (str): Name of the file to load from the data/processed/ directory
    
    Returns:
    pd.DataFrame: Loaded data
    """
    filepath2 = f"D:/ExpInfect_LinIV_PPRV/results/models3/{filename2}"
    return pd.read_csv(filepath2, index_col=0)

