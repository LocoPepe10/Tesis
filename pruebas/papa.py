

import sklearn.metrics as metrics


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

regressor = GridSearchCV(SVC(gamma='auto',probability=True),{
        'C': [1,10],
        'kernel':['rbf']}, cv=5, return_train_score=False)


regressor.fit(X_train, y_train)


# calculate the fpr and tpr for all thresholds of the classification
probs = regressor.predict_proba(X_test)
preds = probs[:,1]
fpr, tpr, threshold = metrics.roc_curve(y_test, preds)
roc_auc = metrics.auc(fpr, tpr)

# method I: plt
import matplotlib.pyplot as plt
plt.title('Receiver Operating Characteristic')
plt.plot(fpr, tpr, 'b', label = 'AUC = %0.2f' % roc_auc)
plt.legend(loc = 'lower right')
plt.plot([0, 1], [0, 1],'r--')
plt.xlim([0, 1])
plt.ylim([0, 1])
plt.ylabel('True Positive Rate')
plt.xlabel('False Positive Rate')
plt.show()