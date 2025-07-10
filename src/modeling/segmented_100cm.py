import pymc as pm
import pandas as pd
import numpy as np

def create_model(data):
    with pm.Model() as model:
        # Define priors
        p = pm.Uniform("p", lower=0.0001, upper=0.01)
    
        t = pm.Data("t", data['t_1m'])
        
        # Define likelihood
        probs = pm.Deterministic("probs", 1 - (1 - p) ** t)
        y_obs = pm.Bernoulli('y_obs', p=probs, observed = data['infected'])

    return model