# src/modeling/main.py

import pymc as pm
import pymc.sampling_jax
from src.utils.data_loader import load_processed_data
from src.modeling.model_factory import get_model, get_envelope

def run_model(data_filename, model_name, **kwargs):
    # Load the processed data
    data = load_processed_data(data_filename)

    # Get the specified model
    model = get_model(model_name, data)

    # Run the model
    with model:
        trace = pm.sampling.jax.sample_blackjax_nuts(**kwargs.get('sampling_params', {}))

    with model:
        pm.compute_log_likelihood(trace)

    return trace


def run_envelope(data_filename1, data_filename2, model_name, **kwargs):
    # Load the processed data
    data1 = load_processed_data(data_filename1)
    data2 = load_processed_data(data_filename2)

    # Get the specified model
    model = get_envelope(model_name, data1, data2)

    # Run the model
    with model:
        trace = pm.sampling.jax.sample_blackjax_nuts(**kwargs.get('sampling_params', {}))

    with model:
        pm.compute_log_likelihood(trace)

    return trace


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Run PPRV modeling")
    parser.add_argument('--data', type=str, required=True, help="Filename of processed data")
    parser.add_argument('--model', type=str, required=True, help="Name of the model to use")
    parser.add_argument('--output', type=str, default='results', help="Output directory")

    args = parser.parse_args()

    trace = run_model(args.data, args.model, output_dir=args.output)
