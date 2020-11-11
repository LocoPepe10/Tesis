# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 12:29:53 2020

@author: Ivan
"""
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#Cargado de datos

dataset = pd.read_csv('https://raw.githubusercontent.com/mk-gurucharan/Regression/master/SampleData.csv')

#Variable Independiente -> Horas de estudio
X = dataset.iloc[:, 0].values 
#Variable Dependiente -> Notas
y = dataset.iloc[:, 1].values 

y = np.array(y).reshape(-1,1)


#Estandarizacion (Normalizar)

from sklearn.preprocessing import StandardScaler
sc_X = StandardScaler()
sc_y = StandardScaler()
X = sc_X.fit_transform(X.reshape(-1,1))
y = sc_y.fit_transform(y.reshape(-1,1))


#Separando set Entrenamiento y Prueba (80/20)

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2)

# Entrenamiento de Datos

from sklearn.svm import SVR
regressor = SVR(kernel = 'rbf', gamma='scale', C=1.0, epsilon=0.7,   )
regressor.fit(X_train.reshape(-1,1), y_train.reshape(-1,1))

# Prediccion con Datos de Prueba

y_pred = regressor.predict(X_test)
y_pred = sc_y.inverse_transform(y_pred)

print(regressor.score(X_train,y_train))

#Datos Reales vs Datos Prediccion

df = pd.DataFrame({'Real Values':sc_y.inverse_transform(y_test.reshape(-1)), 'Predicted Values':y_pred})

print(df)

# Visualizacion de Resultados

X_grid = np.arange(min(X), max(X), 0.1)
X_grid = X_grid.reshape((len(X_grid), 1))
plt.scatter(sc_X.inverse_transform(X_test), sc_y.inverse_transform(y_test.reshape(-1)), color = 'red')
plt.scatter(sc_X.inverse_transform(X_test), y_pred, color = 'green')
plt.title('SVR Regression')
plt.xlabel('Position level')
plt.ylabel('Salary')
plt.show()




