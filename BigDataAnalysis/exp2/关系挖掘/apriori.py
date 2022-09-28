import numpy as np
import pandas as pd
import itertools
import time
from functions import combine, reduceFreq, PCY, generateRules

# 超参
debug = False
min_support = 0.005
min_confidence = 0.5
upgrade = True
nBuckets = 1000

# 输入数据
data = pd.read_csv('Groceries.csv')['items']
data = [d.lstrip('{').rstrip('}').split(',') for d in data]
# if debug:
#     data = data[:500]
data_num = len(data)  #记录数

# 求物品个数并编号
items = list(set(list(itertools.chain(*data))))  # set去重
item_num = len(items)

id2item = {}  # id2item : id转化为物品名的字典
for id, item in enumerate(items):
    id2item[id] = item
item2id = {v: k for k, v in id2item.items()}  # item2id : 将物品名转化为id的字典

for i in range(data_num):
    for j in range(len(data[i])):
        data[i][j] = item2id[data[i][j]]  # 将数据中的物品名全部变成标号
    data[i].sort()  # 将数据中的物品id按升序排序

total_start_time = time.time()
# 求一阶频繁项集
print("start rank1")
groups_1 = [i for i in range(item_num)]
support_1 = reduceFreq(groups_1, 1, data, data_num, min_support)
print("rank1 done!")

# 求二阶频繁项集
print("start rank2")
groups_2 = combine(list(support_1.keys()), 2)

start = time.time()
if upgrade:
    support_2 = PCY(list(support_1.keys()), 2, data, data_num, min_support, nBuckets)
else:
    support_2 = reduceFreq(groups_2, 2, data, data_num, min_support)
end = time.time()
print("time", end - start)
print("rank2 done!")

# 求三阶频繁项集
print("start rank3")
groups_3 = combine(list(support_2.keys()), 3)
support_3 = reduceFreq(groups_3, 3, data, data_num, min_support)
print("rank 3 done!")

# 求四阶频繁项集
print("start rank4")
groups_4 = combine(list(support_3.keys()), 4)
support_4 = reduceFreq(groups_4, 4, data, data_num, min_support)
print("rank4 done!")
print('rank 1:%d\nrank 2:%d\nrank 3:%d\nrank 4:%d\n' % (len(support_1), len(support_2), len(support_3), len(support_4)))
print("total:", len(support_1) + len(support_2) + len(support_3) + len(support_4))

# 求关联规则
support = {**support_1, **support_2, **support_3, **support_4}
rules = generateRules(support, min_confidence)
print('rules num after rank 4:', len(rules))

# 输出结果文件
with open('output.txt', 'w') as f:
    # 1阶
    f.write('--------------rank 1: %d------------------\n' % len(support_1))
    for k, v in support_1.items():
        k = id2item[k]
        f.write(k + ' : ' + str(v) + '\n')
    # 2阶
    f.write('\n\n\n--------------rank 2: %d------------------\n' % len(support_2))
    for k, v in support_2.items():
        for i in k:
            f.write(id2item[i] + ', ')
        f.write(' : ' + str(v) + '\n')
    # 3阶
    f.write('\n\n\n--------------rank 3: %d------------------\n' % len(support_3))
    for k, v in support_3.items():
        for i in k:
            f.write(id2item[i] + ', ')
        f.write(' : ' + str(v) + '\n')
    # 4阶
    f.write('\n\n\n--------------rank 4: %d------------------\n' % len(support_4))
    for k, v in support_4.items():
        for i in k:
            f.write(id2item[i] + ', ')
        f.write(' : ' + str(v) + '\n')

    # 关联规则
    f.write('\n\n---------------Rules num: %d------------------\n' % len(rules))
    for k, v in rules.items():
        if type(k[0]) == int:
            f.write(id2item[k[0]])
        else:
            for i in k[0]:
                f.write(id2item[i] + ', ')
        f.write(' -> ')
        if type(k[1]) == int:
            f.write(id2item[k[1]])
        else:
            for i in k[1]:
                f.write(id2item[i] + ', ')
        f.write(' : ' + str(v) + '\n')

total_end_time = time.time()
print('done.')
print("total time:", total_end_time-total_start_time)