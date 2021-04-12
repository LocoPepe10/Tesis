# -*- coding: utf-8 -*-
"""
Created on Mon Nov  9 17:09:30 2020

@author: Ivan
"""

import numpy as np
import pandas as pd
from tabulate import tabulate
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
                         train_size   = 0.8,
                         random_state = 1234,
                         shuffle = True
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

regressor = GridSearchCV(SVC(gamma='auto', probability=(True)),{
        'C': [1,10],
        'kernel':['rbf']}, cv=5, return_train_score=False)


from sklearn.preprocessing import StandardScaler
from sklearn import preprocessing
#Estandarizacion de datos(Z-score normalizatio)
st_x = StandardScaler()
st_y = StandardScaler()

x_trainprueba = st_x.fit_transform(X_train)
y_trainprueba = st_y.fit_transform(y_train.values.reshape(-1,1))

lab_enc = preprocessing.LabelEncoder()
training_scores_encoded = lab_enc.fit_transform(y_trainprueba)


st_x2 = StandardScaler()
st_y2 = StandardScaler()
x_testprueba = st_x2.fit_transform(X_test)
y_testprueba = st_y2.fit_transform(y_test.values.reshape(-1,1))

lab_enc = preprocessing.LabelEncoder()
training_scores_encoded2 = lab_enc.fit_transform(y_testprueba)




regressor.fit(x_trainprueba, training_scores_encoded)

prediccion = regressor.predict(X_test)



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

from yellowbrick.classifier import ROCAUC
visualizer = ROCAUC(regressor, classes=[0, 1, 2, 3, 4, 5, 6, 7 , 8, 9])

visualizer.fit(X_train, y_train)        # Fit the training data to the visualizer
visualizer.score(X_test, y_test)        # Evaluate the model on the test data
visualizer.show()       


y_pred_proba = regressor.predict_proba(X_test)

from sklearn.metrics import roc_auc_score
score = roc_auc_score(y_test,y_pred_proba,multi_class="ovr")




