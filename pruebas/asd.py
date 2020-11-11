# -*- coding: utf-8 -*-
"""
Created on Tue Nov 10 19:15:12 2020

@author: Ivan
"""

import numpy as np
from sklearn.metrics import roc_auc_score
y_true = np.array([0, 0, 1, 1])
y_scores = np.array([0.1, 0.4, 0.35, 0.8])
print(roc_auc_score(y_true, y_scores))
