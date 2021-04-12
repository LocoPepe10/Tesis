# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 00:17:04 2020

@author: Ivan
"""
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, make_scorer
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import roc_auc_score
from sklearn.metrics import confusion_matrix

# Cargando Datos Base de datoS de entrenamiento.
datos = pd.read_csv('bdtesis.csv')
#Renombre de Columnas
datos.columns = ["c1", "c2", "c3", "c4" ,"c5", "c6", "c7","ARI"]


#Cargando Datos Base de datos de validación
datvalid = pd.read_csv('bdvalidacion.csv')
xvalid = datvalid.iloc[:, 0:7].values 
yvalid = datvalid.iloc[:,7].values 

xval = pd.DataFrame(xvalid)
yval = pd.Series(yvalid)
# Definiendo datos de entrenamiento y test
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
                         datos.drop('ARI', axis = 'columns'),
                         datos['ARI'],
                         train_size   = 0.80,
                         shuffle = True
                       )

#Estableciendo modelo y entrenamiento.

modelo = GridSearchCV(SVC(gamma='auto', probability=(True)),{
        'C': [10],
        'kernel':['rbf']}, cv=2, return_train_score=False)






