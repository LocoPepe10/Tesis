# -*- coding: utf-8 -*-
"""
Created on Tue Oct  6 12:00:11 2020

@author: Ivan
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


#Cargado de datos.

dataset = pd.read_csv('Position_Salaries.csv')

#Variable Dependiente

x = dataset.iloc[:,1:2].values

#Variable Independiente 

y = dataset.iloc[:,2:].values


from sklearn.preprocessing import StandardScaler

#Estandarizacion de datos(Z-score normalizatio)
st_x = StandardScaler()
st_y = StandardScaler()

X = st_x.fit_transform(x)
Y = st_y.fit_transform(y)


fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.scatter(X,Y,color='r')

from sklearn.svm import SVR

#Parametros
regressor = SVR(kernel='rbf', epsilon=0.09, gamma='scale', C=0.95)

regressor.fit(X,Y)

print(regressor.score(X,Y))

plt.scatter(X,Y,color='red')
plt.plot(X,regressor.predict(X),color='blue')