import pymc as pm
import pandas as pd
import numpy as np

def create_model(data):
    with pm.Model() as model:
        # Priors
        p = pm.Beta('p', 1, 1)
        alpha_3 = pm.Uniform('alpha_3', 0, 1)    
        
        t2 = pm.Data("t2", data['time_between_1_and_2m'])
        t3 = pm.Data("t3", data['time_above_2m'])

        p_i = 1 - (1 - p)**t2 * (1 - alpha_3*p)**t3
        p_i = pm.Deterministic('p_i', p_i)

        # Likelihood
        y_obs = pm.Bernoulli('y_obs', p=p_i, observed=data['infected'])

        init = {'p': 0.001}

    return model

