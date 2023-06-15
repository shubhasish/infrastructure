from pandas import read_csv, DataFrame, concat , Series
from matplotlib import pyplot
from sklearn.metrics import mean_squared_error
from sklearn import svm
from statsmodels.tsa.ar_model import AR


series = Series.from_csv('/home/talentica/Downloads/shampoo.csv',header=0)
X = series.values
train, test = X[1:len(X)-7], X[len(X)-7:]
model = AR(train)
model_fit = model.fit()
predictions = model_fit.predict(start=len(train), end=len(train)+len(test)-1, dynamic=False)
error = mean_squared_error(test, predictions)

