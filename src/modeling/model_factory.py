# src/modeling/model_factory.py

import pymc as pm
from src.modeling import baseline, baseline2, segmented_100cm, segmented_150cm, segmented_200cm, stratified1, stratified2, stratified3, stratified4, stratified5, envelope

def get_model(model_name, data):
    if model_name == 'baseline':
        return baseline.create_model(data)
    elif model_name == 'baseline2':
        return baseline2.create_model(data)
    
    elif model_name == 'segmented_100cm':
        return segmented_100cm.create_model(data)
    
    elif model_name == 'segmented_150cm':
        return segmented_150cm.create_model(data)
    
    elif model_name == 'segmented_200cm':
        return segmented_200cm.create_model(data)
    
    elif model_name == 'stratified1':
        return stratified1.create_model(data)
    elif model_name == 'stratified2':
        return stratified2.create_model(data)
    elif model_name == 'stratified3':
        return stratified3.create_model(data)
    elif model_name == 'stratified4':
        return stratified4.create_model(data)
    elif model_name == 'stratified5':
        return stratified5.create_model(data)
    else:
        raise ValueError(f"Unknown model: {model_name}")
    

def get_envelope(model_name, data1, data2):
    if model_name == 'envelope':
        return envelope.create_model(data1, data2)
    else:
        raise ValueError(f"Unknown model: {model_name}")
