# -*- coding: utf-8 -*-
"""
Created on Mon Nov 30 17:52:17 2020

@author: Ivan
"""

import numpy as np
import pandas as pd
import matplotlib as plt

from sklearn.svm import SVC
from sklearn.svm import SVR

from sklearn import datasets
from sklearn.model_selection import train_test_split

X,Y = datasets.load_diabetes(return_X_y=True)

# División de datos en training/testing sets
X_train = X[:-20]
X_test = X[-20:]

# División de datos en training/testing sets
y_train = Y[:-20]
y_test = Y[-20:]

model = SVR(kernel = 'rbf', degree = 5,C = 1000)
# Entrenamos nuestro modelo
model.fit(X_train, y_train)
print(model.score(X_test,y_test))
# Hacemos las predicciones que en definitiva una línea (en este caso, al ser 2D)
y_pred = model.predict(X_train)