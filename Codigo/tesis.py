# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 17:09:30 2020
@author: Ivan
"""

import numpy as np
import pandas as pd
#from tabulate import tabulate
import matplotlib.pyplot as plt
import seaborn as sns



# Cargando Datos

datos = pd.read_csv('bdtesis.csv')

#Renombre de Columnas

datos.columns = ["c1", "c2", "c3", "c4" ,"c5", "c6", "c7","ARI"]


# Definiendo datos de entrenamiento y test

from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
                         datos.drop('ARI', axis = 'columns'),
                         datos['ARI'],
                         train_size   = 0.75
                         #random_state = 1234,
                         #shuffle = True
                       )


#Normalizacion de datos
'''
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X_train_array = sc.fit_transform(X_train.values)
X_train = pd.DataFrame(X_train_array, index=X_train.index, columns=X_train.columns)
X_test_array = sc.transform(X_test.values)
X_test = pd.DataFrame(X_test_array, index=X_test.index, columns=X_test.columns)
'''
# Modelo de entrenamiento

from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV

regressor = GridSearchCV(SVC(gamma='auto'),{
        'C': [10,1],
        'kernel':['rbf']}, cv=5, return_train_score=False)


regressor.fit(X_train, y_train)

hyper = pd.DataFrame(regressor.cv_results_)
#print(regressor.score(X_test,y_test))


#Validacion Cruzada


from sklearn.model_selection import cross_val_score
cv_scores = cross_val_score(
                estimator = regressor,
                X         = X_train,
                y         = y_train,
                scoring   = 'neg_root_mean_squared_error',
                cv        = 5
             )
print(f"Métricas validación cruzada: {cv_scores}")
print(f"Média métricas de validación cruzada: {cv_scores.mean()}")
cv_scores = pd.DataFrame(cv_scores)

prediccion = regressor.predict(X_test)



print(regressor.score(X_test,y_test))


df_predicciones = pd.DataFrame({'ARI' : y_test, 'prediccion' : prediccion})
df_predicciones.head()

# Error cuadratico medio

from sklearn.metrics import mean_squared_error

rmse = mean_squared_error(
        y_true = y_test,
        y_pred = prediccion,
        squared = False
       )

print(f"Valor Error cuadratico Medio: {rmse}")


# Correlación 
from sklearn.metrics import matthews_corrcoef
corr = matthews_corrcoef(
        y_true = y_test,
        y_pred= prediccion)
print(f"Valor Correlacion: {corr}")


#Coeficiente de Determinación R^2

from sklearn.metrics import r2_score
r2 = r2_score(
        y_true = y_test,
        y_pred = prediccion)

print(f"Valor coeficiente de detertminacion: {r2}")



plt.plot(prediccion,color='blue')

ar = np.array(y_test)

plt.scatter(y=ar, x=prediccion)




plt.plot(ar,color='blue')
plt.plot(prediccion,color='red')





print("Partición de entrenamento")
print("-----------------------")
print(y_train.describe())
print("Partición de test")
print("-----------------------")
print(y_test.describe())
