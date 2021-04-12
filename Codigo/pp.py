# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 16:31:23 2020

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
                         random_state = 1234,
                         shuffle = True
                       )
#Modelo SVM Regresion 

from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV

regressorRE = GridSearchCV(SVR(gamma='auto'),{
        'C': [1],
        'kernel':['rbf']}, cv=5, return_train_score=False)

regressorRE.fit(X_train, y_train)


#Modelo SVM Clasificacion
from sklearn.svm import SVC
regressorCL = GridSearchCV(SVC(gamma='auto'),{
        'C': [1],
        'kernel':['rbf']}, cv=5, return_train_score=False)
regressorCL.fit(X_train, y_train)

prediccion1 = regressorRE.predict(X_test)
prediccion2 = regressorCL.predict(X_test)


print(f"Porcentaje de aprendizaje Regresion: {regressorRE.score(X_test,y_test)}")
print(f"Porcentaje de aprendizaje Clasificacion: {regressorCL.score(X_test,y_test)}")



fpr, tpr, thresholds = metrics.roc_curve(y_test, prediccion1, pos_label=2)

fpr2, tpr2, thresholds2 = metrics.roc_curve(y_test, prediccion2, pos_label=2)


test = np.array(y_test)
pre1 = np.array(prediccion1)
pre2 = np.array(prediccion2)


plt.plot(fpr, tpr, color='orange', label='ROC1')
plt.plot(fpr2, tpr2, color='blue', label='ROC2')
plt.plot([0, 1], [0, 1], color='darkblue', linestyle='--')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend()
plt.show()

#Curva de ROC


#print(svr_auc)
#print(svc_auc)



