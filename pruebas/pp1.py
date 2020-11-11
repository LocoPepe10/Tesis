# -*- coding: utf-8 -*-
"""
Created on Tue Nov 10 18:44:16 2020

@author: Ivan
"""

import numpy as np
import pandas as pd
from tabulate import tabulate
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import metrics
from sklearn.metrics import roc_curve, auc
from sklearn.metrics import roc_curve, roc_auc_score
from sklearn.multiclass import OneVsRestClassifier
from sklearn import svm, datasets
from sklearn.metrics import roc_curve, auc
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import label_binarize
from sklearn.multiclass import OneVsRestClassifier
from scipy import interp
from sklearn.metrics import roc_auc_score
# Cargando Datos

datos = pd.read_csv('bdtesis.csv')

#Renombre de Columnas

datos.columns = ["c1", "c2", "c3", "c4" ,"c5", "c6", "c7","ARI"]


# Definiendo datos de entrenamiento y test

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
                         datos.drop('ARI', axis = 'columns'),
                         datos['ARI'],
                         train_size   = 0.8,
                         random_state = 0,
                         shuffle = True
                       )
#Modelo SVM Regresion 

from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV


regressorCL = OneVsRestClassifier(svm.SVC(kernel='linear', probability=True,
                                 random_state=random_state))
y_score = regressorCL.fit(X_train, y_train).decision_function(X_test)
