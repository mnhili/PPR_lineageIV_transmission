import pymc as pm
import pandas as pd
import numpy as np

def create_model(data):
    with pm.Model() as model:
        # Priors
        p = pm.Beta('p', 1, 1)

        alpha_1 = pm.Uniform('alpha_1', 0, 1)
        alpha_2 = pm.Uniform('alpha_2', 0, 1)

        t0 = pm.Data("t0", data['time_between_0.05_and_0.5m'])
        t1 = pm.Data("t1", data['time_between_0.5_and_1m'])
        t2 = pm.Data("t2", data['time_between_1_and_2m'])

        p_i = 1 - (1 - p)**t0 * (1 - alpha_1 * p)**t1 * (1 - alpha_1* alpha_2 * p)**t2 
        p_i = pm.Deterministic('p_i', p_i)

        # Likelihood
        y_obs = pm.Bernoulli('y_obs', p=p_i, observed=data['infected'])
        init = {'p': 0.001}

    return model

