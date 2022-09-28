import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import random

def calc_dist(x,y):
    return np.sqrt(np.sum((x - y) ** 2))

max_iter = 120
K = 3
dim = 13

col = ['label']
dim_label = ['dim'+str(i) for i in range(dim)]
col = col+dim_label
data = pd.read_csv("data.csv", names=col)
label = list(data['label'])
del data['label']
data = np.array(data.values)

data_num = len(data)
centroid_choice = np.sort(random.sample(range(data_num), K))
centroid = np.array([data[i] for i in centroid_choice])


res = np.zeros(data_num)
for i in range(K):
    res[centroid_choice[i]] = i+1

is_change = True
iter_num = 0
while is_change:
    is_change = False
    # 聚类
    for i in range(data_num):
        dist = [calc_dist(data[i], centroid[j]) for j in range(K)]
        min_clu = np.argmin(dist) + 1
        if min_clu != res[i]:
            res[i] = min_clu
            is_change = True

    # 重新计算中心 采用质心
    for i in range(K):
        centroid[i] = np.mean([data[j] for j in range(data_num) if res[j] == i+1], axis=0)
    iter_num += 1
    if iter_num > max_iter:
        break

print("end at %d rounds" % iter_num)
acc = np.sum(res == label)/data_num
print("accuracy: %f" % acc)
sse = np.sum([calc_dist(data[i], centroid[int(res[i] - 1)]) for i in range(data_num)])
print("sse: %f" % sse)

# 图形化
first_dim = 'dim5'
second_dim = 'dim6'
fd, sd = data[:,5], data[:,6]
map_dict = {0:'r', 1:'g', 2:'b'} # clusters=3
ans = [map_dict[res[i]-1] for i in range(data_num)]

plt.xlabel(first_dim)
plt.ylabel(second_dim)
plt.title('SSE=%.2f Acc=%.2f' % (float(sse), acc))
plt.scatter(fd, sd, c=ans)
for i in range(K):
    tmp = centroid[i]
    x, y = tmp[int(first_dim[-1])], tmp[int(second_dim[-1])]
    plt.plot(x, y, color=map_dict[i], marker='*', markersize=20)
plt.show()





