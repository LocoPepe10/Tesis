# -*- coding: utf-8 -*-
"""
Created on Thu Nov  5 00:42:10 2020

@author: Ivan
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv('bdtesis.csv')

X = data.iloc[:, 0:7].values
Y = data.iloc[:, 7].values

print(X)

print(Y)


'''
from sklearn.preprocessing import StandardScaler
sc_X = StandardScaler()
sc_Y = StandardScaler()
X = sc_X.fit_transform(X.reshape(-1,1))
Y = sc_Y.fit_transform(Y.reshape(-1,1))




#Separando set Entrenamiento y Prueba (80/20)

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size = 0.2)

# Entrenamiento de Datos

from sklearn.svm import SVR
regressor = SVR(kernel = 'rbf', gamma='scale', C=1.0, epsilon=0.7)
regressor.fit(X_train.reshape(-1,1), y_train.reshape(-1,1))

# Prediccion con Datos de Prueba

y_pred = regressor.predict(X_test)
y_pred = sc_Y.inverse_transform(y_pred)

print(regressor.score(X_train,y_train))

#Datos Reales vs Datos Prediccion

#df = pd.DataFrame({'Real Values':sc_Y.inverse_transform(y_test.reshape(-1)), 'Predicted Values':y_pred})

#print(df)
'''