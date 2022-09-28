import numpy as np
import pandas as pd

filename = 'sent_receive.csv'
data = pd.read_csv(filename)
sent = data['sent_id']
receive = data['receive_id']


# 提取有向边并按入结点排序
edges = []
for row in zip(sent, receive):
    e = (row[0], row[1])
    if e not in edges:  # 不考虑重复边
        edges.append(e)
edges = sorted(edges)
# 提取结点个数
nodes = list(set([node for e in edges for node in e]))#保留node供之后输出
node_num = len(nodes)







# 初始化转移矩阵M
M = np.zeros((node_num, node_num), dtype=float)

for n in nodes:
    end = []
    check = False
    for e in edges:
        if e[0] == n:
            end.append(e[1])
    end_num = len(end)
    for i in end:
        M[nodes.index(n)][nodes.index(i)] = 1.0 / end_num

M = M.T




# 初始化w
value = 1.0 / node_num
w = np.ones(node_num)
w = w*value
w= w.T

# 参数
beta = 0.85
w_org = np.ones((node_num,node_num))/node_num
error = 1
iter = 0

M = beta * M + (1 - beta) * w_org  # 带阻尼系数，阻尼系数为0.85

# 开始迭代训练
while error > 1e-8:
    new_w = np.matmul(M , w)
    error = np.max(abs(new_w - w))
    w = new_w
    iter = iter + 1


# 输出结果
print('After', iter, 'iterations...')
ans = pd.DataFrame({'id': nodes, 'pagerank': w})
ans.to_csv('pagerank.csv', index=False)
print('done.')