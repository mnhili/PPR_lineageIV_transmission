import pandas as pd
import numpy as np
from src.utils.data_loader import load_probas


def run_predictions(filename, df, N):
    """
    Process Bernoulli simulations from a PyMC trace and original dataframe.
    
    Parameters:
    trace (arviz.InferenceData): The trace from a PyMC model.
    df (pd.DataFrame): Original dataframe with 'experiment', 'duration', and 'infected' columns.
    N (list): List of sample sizes for each experiment.
    
    Returns:
    pd.DataFrame: Processed dataframe with cases per experiment.
    """
    try:
        # Load probability dataframe
        p_list_df = load_probas(filename)
        
        # Perform Bernoulli simulations
        simulations = p_list_df.apply(lambda prob: np.random.binomial(1, prob))
        
        # Combine original data with simulations
        result_df = pd.concat([
            df[["experiment", "duration", "infected"]].reset_index(drop=True),
            simulations.reset_index(drop=True)
        ], axis=1)
        
        # Calculate cases per experiment
        cases_per_exp = result_df.groupby(['experiment', 'duration']).sum().reset_index()
        
        # Add sample sizes and rename columns
        cases_per_exp.insert(2, 'N', N)
        cases_per_exp = cases_per_exp.rename(columns={'infected': 'obs'})

        # Replace 'proba' prefix in column names with 'cases'
        cases_per_exp.columns = cases_per_exp.columns.str.replace('proba', 'cases')
        
        return cases_per_exp
    
    except KeyError as e:
        print(f"Error: Missing expected column in dataframe or trace. {str(e)}")
    except ValueError as e:
        print(f"Error: Mismatch in data shapes or types. {str(e)}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")



