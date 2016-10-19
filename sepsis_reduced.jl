using ScikitLearn
using DecisionTree
using DataFrames
using ScikitLearn.CrossValidation: train_test_split
using ScikitLearn.CrossValidation: cross_val_score
using PyCall
using MLBase
@sk_import preprocessing: StandardScaler

df = readtable("C:/Users/Jason/Documents/BCBI/Atom/sepsis_imputed.csv")
