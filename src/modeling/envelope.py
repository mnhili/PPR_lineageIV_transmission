import pymc as pm
import pandas as pd
import numpy as np
import pytensor.tensor as pt

def create_model(data1, data2):

    # Pre-calculate unique combinations of experiment and contact_duration
    unique_combinations = data1[['experiment', 'contact_duration', 'cap_ID']].drop_duplicates()

    # Convert to a list of tuples for iteration
    unique_combinations = [tuple(x) for x in unique_combinations.to_numpy()]

    distances_list = []
    times_list = []

    for e, c, i in unique_combinations:
        df_temp = data1[(data1['experiment'] == e) & (data1['contact_duration'] == c) & (data1['cap_ID'] == i)]
        distances = df_temp['distance'].values
        times = df_temp['time'].values
        distances_list.append(distances)
        times_list.append(times)

    # Convertir les listes en matrices numpy de type object

    distances_matrix = np.array(distances_list, dtype=object)
    times_matrix = np.array(times_list, dtype=object)


    with pm.Model() as model:
        # Priors
        p0 = pm.Beta('p0', alpha=1, beta=1)
        lambda_ = pm.LogNormal('lambda', mu=-1, sigma=0.1)
        
        p_temp_list = [(1 - (p0 * pt.exp(-lambda_ * dist))) ** time for dist, time in zip(distances_matrix, times_matrix)]
        p_prod = pt.stack([pt.prod(p_temp) for p_temp in p_temp_list])

        probs = pm.Deterministic('probs', 1 - p_prod)

        # Likelihood
        y_obs = pm.Bernoulli('y_obs', p=probs, observed=data2['infected'])

    return model
