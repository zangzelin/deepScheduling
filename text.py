
#%% 
import numpy as np 
import matplotlib.pyplot as plt 

#%% 读入数据
zzl = 1
data = np.loadtxt('data\in1.csv', delimiter=',')
dataout = np.loadtxt('data\out1.csv', delimiter=',')

#%% 数据分片
l,c = data.shape
l,c

dataonestagein = np.zeros((c - 10, l, 10), dtype=int)
dataonestageout = np.zeros((c - 10, 9, 10), dtype=int)

for i in range(c-10):
    dataonestagein[i, :, :] = data[:, i : i+10]
    dataonestageout[i, :, :] = dataout[:, i: i + 10]


dataonestagein,dataonestageout.shape
for i in range( c - 10 ):
    np.savetxt('datastageone\dataonestagein1'+str(i)+'.csv', dataonestagein[i,:,:])
    np.savetxt('datastageone\dataonestageout1' + str(i) + '.csv',
            dataonestageout[i, :, :], fmt='%d', delimiter=',')


print('finish')
#%% 
for i in range(c - 10):
    line = data[0 : 6, i: i + 10] + 1

    count = 0;
    pic = np.zeros((150,10))
    for j in range(6):
        for k in range(0,j):
            # print(j,k)
            pic[count * 10: count * 10+10, :] = np.dot(np.reshape(
                line[j, :], (10, 1)), np.reshape(line[k, :], (1, 10)))
            count = count +1 
    np.savetxt('datatwo\\1' +
               str(i) + '.csv', pic,fmt = '%d')
    
print(pic.shape)

#%% mix all 
import numpy as np
import matplotlib.pyplot as plt
piccount = 0;

for datap in range(100):
    # 数据读取
    data = np.loadtxt('data\in'+ str(datap+1) +'.csv', delimiter=',')
    dataout = np.loadtxt('data\out'+ str(datap+1) +'.csv', delimiter=',')
    # 数据分片
    l, c = data.shape
    l, c
    
   
    # 数据组合二维化
    for i in range(c - 10):
        line = data[0: 6, i: i + 10] + 1
        picout = dataout[0: 9, i]
        count = 0
        pic = np.zeros((150+26, 10))
        pic[150:176, 0] = data[7:33,0]
        
        for j in range(6):
            for k in range(0, j):
                # print(j,k)
                pic[count * 10: count * 10 + 10, :] = np.dot(np.reshape(
                    line[j, :], (10, 1)), np.reshape(line[k, :], (1, 10)))
                count = count + 1
        np.savetxt('datatwo\\in' +
                str(piccount) + '.csv', pic, fmt='%d',delimiter=',')

        np.savetxt('datatwo\\out' +
                   str(piccount) + '.csv', picout, fmt='%d',delimiter=',')

        piccount = piccount + 1 

print('finish', piccount)
