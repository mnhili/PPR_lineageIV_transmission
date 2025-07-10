# src/utils/statistical_utils.py

import pymc as pm
import numpy as np
from scipy import stats
from sklearn.metrics import roc_auc_score
import arviz as az

def calculate_ci(data, confidence=0.95):
    """
    Calculate confidence interval for a sample.
    
    Args:
    data (array-like): Sample data
    confidence (float): Confidence level
    
    Returns:
    tuple: (mean, lower bound, upper bound)
    """
    a = 1.0 * np.array(data)
    n = len(a)
    m, se = np.mean(a), stats.sem(a)
    h = se * stats.t.ppf((1 + confidence) / 2., n-1)
    return m, m-h, m+h


def calculate_waic(trace):
    """Calculate the Widely Applicable Information Criterion."""
    return pm.waic(trace)

def calculate_loo(trace):
    """Calculate the Leave-One-Out cross-validation."""
    return pm.loo(trace)

def calculate_rhat(trace):
    """Calculate the Gelman-Rubin statistic."""
    return pm.rhat(trace)

def calculate_ess(trace):
    """Calculate the Effective Sample Size."""
    return pm.ess(trace)

def waic_comparison(traces, model_names):
    """Compare multiple models using WAIC."""
    comparison = pm.compare({name: trace for name, trace in zip(model_names, traces)}, ic='WAIC')
    return comparison


def calculate_auc(df, y_true):

    auc_values = []

    for col in df.columns:
        y_pred = df[col].values
        auc = roc_auc_score(y_true, y_pred)
        auc_values.append(auc)


    return np.array(auc_values)


def calculate_hdi(array):

    hdi = az.hdi(array, hdi_prob = .95)

    return np.round(hdi, 2)



