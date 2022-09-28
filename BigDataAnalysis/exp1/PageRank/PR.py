import numpy as np
import networkx as nx
import csv
import os

def normalize_col_mat(adj_mat=np.zeros_like(0, dtype=float)):
    for j in range(adj_mat.shape[0]):
        col_sum = float(sum(adj_mat[:, j]))
        if col_sum == 0:
            continue
        for i in range(adj_mat.shape[0]):
            adj_mat[i, j] = adj_mat[i, j] / col_sum


def normalize_vec(vec=np.array(0, dtype=float)):
    total = float(sum(vec))
    for i in range(vec.shape[0]):
        vec[i] = vec[i] * 1.0 / total


# create graph
G = nx.DiGraph()
with open("sent_receive.csv", "r") as f:
    data = csv.reader(f)
    next(data)
    for item in data:
        G.add_edge(int(item[1]), int(item[2]))

# relabel node
new_index = 0
mapper = {}
mapper_T = {}
for index in sorted(G.nodes):
    mapper[index] = new_index
    mapper_T[new_index] = index
    new_index += 1
G = nx.relabel_nodes(G, mapper)

# create matrix
adj = np.array(nx.adjacency_matrix(G).toarray(), dtype=float)
adj = adj.T
normalize_col_mat(adj)
print(adj)

tel_vec = np.zeros_like(adj.shape[0], dtype=float)
tel_vec = tel_vec + 1.0 / adj.shape[0]

r_old = np.zeros(adj.shape[0])
r_old = r_old + (1.0 / adj.shape[0])
e = 1
beta = 0.85
k = 0
adj = beta * adj + (1 - beta) / adj.shape[0] * np.ones([adj.shape[0], adj.shape[0]])
while e > 0.00000001:
    r_new = np.matmul(adj, r_old)
    # normalize_vec(r_new)
    e = max(abs(r_new - r_old))
    r_old = r_new
    k += 1
    print("iteration:{} error:{}".format(k, e))

print("PageRank End!")
with open("result.txt", "w") as f:
    for index in range(len(r_old)):
        f.write("node {} PR:{}\n".format(mapper_T[index], r_old[index]))
