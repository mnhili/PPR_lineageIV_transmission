import pandas as pd
import numpy as np



def run_predictions(trace, a):
    """
    Process Bernoulli simulations from a PyMC trace and original dataframe.
    
    Parameters:
    trace (arviz.InferenceData): The trace from a PyMC model.
    a (str): it's the name of the deterministic variable used in PyMC models
    
    Returns:
    pd.DataFrame: Processed dataframe with cases per experiment.
    """
    try:
        # Extract posterior samples
        samples = trace.posterior.stack(sample=("chain", "draw"))
        
        # Create probability dataframe
        p_list_df = pd.DataFrame(samples[a].values)
        p_list_df.columns = p_list_df.add_prefix('proba_').columns
        
        
        return p_list_df
    
    except KeyError as e:
        print(f"Error: Missing expected column in dataframe or trace. {str(e)}")
    except ValueError as e:
        print(f"Error: Mismatch in data shapes or types. {str(e)}")
    except Exception as e:
        print(f"An unexpected error occurred: {str(e)}")