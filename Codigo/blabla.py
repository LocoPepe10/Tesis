# -*- coding: utf-8 -*-
"""
Created on Tue Nov 10 20:34:41 2020

@author: Ivan
"""

from sklearn.metrics import roc_curve, auc
from sklearn import datasets
from sklearn.multiclass import OneVsRestClassifier
from sklearn.svm import LinearSVC
from sklearn.preprocessing import label_binarize
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
from sklearn import svm
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import learning_curve, GridSearchCV
from sklearn.model_selection import RandomizedSearchCV
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split


import numpy as np
import pandas as pd

# Cargando Datos

datos = pd.read_csv('bdtesis.csv')

#Renombre de Columnas

datos.columns = ["c1", "c2", "c3", "c4" ,"c5", "c6", "c7","ARI"]



X, y = datos, datos["ARI"]

y = label_binarize(y, classes=[0,1,2,3,4,5,6,7,8,9])
n_classes = 10

# shuffle and split training and test sets
X_train, X_test, y_train, y_test = train_test_split(
                        X, y, test_size=0.20, random_state=0
                        )

# classifier

from sklearn.svm import SVC

regressor = GridSearchCV(SVC(gamma='auto'),{
        'C': [1,10],
        'kernel':['rbf']}, cv=5, return_train_score=False)

regressor.fit(X_train, y_train)
'''
y_score = regressor.fit(X_train, y_train).decision_function(X_test)

prediccion = regressor.predict(X_test)
'''
'''print(regressor.score(X_test,y_test))'''

'''
# Compute ROC curve and ROC area for each class
fpr = dict()
tpr = dict()
roc_auc = dict()
for i in range(n_classes):
    fpr[i], tpr[i], _ = roc_curve(y_test[:, i], y_score[:, i])
    roc_auc[i] = auc(fpr[i], tpr[i])

# Plot of a ROC curve for a specific class
for i in range(n_classes):
    plt.figure()
    plt.plot(fpr[i], tpr[i], label='ARI'+str(i)+' - '+'ROC curve (area = %0.2f)' % roc_auc[i])
    plt.plot([0, 1], [0, 1], 'k--')
    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver operating characteristic example')
    plt.legend(loc="lower right")
    plt.show()'''