


#%% 

X = np.zeros((3531, 1526))
Y = np.zeros((3531, 9))
for i in range(3531):
    # X
    datayuan = np.loadtxt('datatwo\in' + str(i) + '.csv', delimiter=',')
    datapart1 = np.reshape(datayuan[0:150, :],1500)
    datapart2 = datayuan[150:176, 1]
    datapart1.shape,datapart2.shape
    datause = np.append( datapart1 , datapart2)
    X[i, :] = datause

    # Y 
    datayuanY = np.loadtxt('datatwo\out' + str(i) + '.csv', delimiter=',')
    Y[i, :] = datayuanY

np.savetxt('X.csv', X, fmt='%d', delimiter=',')
np.savetxt('Y.csv', Y, fmt='%d', delimiter=',')

# datapart1

# print('finish')
#%% 
from keras.models import Sequential
from keras.layers import Dense
import numpy as np
# fix random seed for reproducibility


def getdataset():
    
    X = np.zeros((3531, 1526))
    Y = np.zeros((3531, 9))
    for i in range(3531): 
        # X
        datayuan = np.loadtxt('datatwo\in' + str(i) + '.csv', delimiter=',')
        datapart1 = np.reshape(datayuan[0:150, :], 1500)
        datapart2 = datayuan[150:176, 1]
        datapart1.shape, datapart2.shape
        datause = np.append(datapart1, datapart2)
        X[i, :] = datause

        # Y
        datayuanY = np.loadtxt('datatwo\out' + str(i) + '.csv', delimiter=',')
        Y[i, :] = datayuanY
    return X,Y




seed = 7
np.random.seed(seed)
# load pima indians dataset
# dataset = numpy.loadtxt("pima-indians-diabetes.csv", delimiter=",")
# split into input (X) and output (Y) variables


X,Y = getdataset()
print(X.shape,Y.shape)

# create model
model = Sequential()
model.add(Dense(3200, input_dim=1526, init='uniform', activation='relu'))
model.add(Dense(320, init='uniform', activation='relu'))
model.add(Dense(32, init='uniform', activation='sigmoid'))
model.add(Dense(9, init='uniform', activation='softmax'))
# Compile model
model.compile(loss='binary_crossentropy',
              optimizer='adam', metrics=['accuracy'])
# Fit the model
model.fit(X, Y, nb_epoch=150, batch_size=10,  verbose=2)
# calculate predictions
predictions = model.predict(X)
# round predictions
rounded = [round(x) for x in predictions]
print(rounded)
