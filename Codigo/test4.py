# -*- coding: utf-8 -*-
"""
Created on Wed Dec  2 00:17:04 2020

@author: Ivan
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.metrics import accuracy_score, make_scorer
from sklearn import metrics
from sklearn.metrics import precision_recall_curve
from sklearn.metrics import f1_score
from sklearn.metrics import auc
from matplotlib import pyplot
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
                         shuffle = True
                       )


# Modelo de entrenamiento

from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score, make_scorer

modelo = model = SVC(kernel = 'rbf', gamma = 'auto', probability=(True), C = 10)

modelo.fit(X_train, y_train)
prediccion = modelo.predict(X_test)

y_pred_proba = modelo.predict_proba(X_test)

from sklearn.metrics import roc_auc_score
score = roc_auc_score(y_test,y_pred_proba,multi_class="ovr")

#Correlacion
out =  pd.DataFrame()
out['y'] = y_test
out['yp'] = prediccion
corr=out.corr()
#corr['y'][1]
print('Correlación: %.4f' % corr['y'][1])


#Coeficiente de Determinacion
from sklearn.metrics import r2_score
r2 = r2_score(
        y_true = y_test,
        y_pred = prediccion)

print(f"Valor coeficiente de detertminacion: {r2}")
'''

'''
hyper = pd.DataFrame(clasificador.cv_results_)
#print(clasificador.score(X_test,y_test))


#Validacion Cruzada


from sklearn.model_selection import cross_val_score

cv_scores = cross_val_score(
                estimator = clasificador,
                X         = X_train,
                y         = y_train,
                scoring   = 'neg_root_mean_squared_error',
                cv        = 5
             )

print(f"Métricas validación cruzada: {cv_scores}")
print(f"Média métricas de validación cruzada: {cv_scores.mean()}")
cv_scores = pd.DataFrame(cv_scores)

prediccion = clasificador.predict(X_test)

from yellowbrick.classifier import ROCAUC
visualizer = ROCAUC(clasificador, classes=[0, 1, 2, 3, 4, 5, 6, 7 , 8, 9])

visualizer.fit(X_train, y_train)        # Fit the training data to the visualizer
visualizer.score(X_test, y_test)        # Evaluate the model on the test data
visualizer.show()       


y_pred_proba = clasificador.predict_proba(X_test)

from sklearn.metrics import roc_auc_score
score = roc_auc_score(y_test,y_pred_proba,multi_class="ovr")
'''