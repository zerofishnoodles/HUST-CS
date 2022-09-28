# %%

import numpy as np
import os
import pandas as pd

work_dir = r'D:\Documents\course\junior\BigDataAna\12-20大作业'
dataset_dir = work_dir + r'\datasets' + '\\'
# print(dataset_dir)

# 获取数据集
train_data = pd.read_csv(dataset_dir + 'train_set.csv')
# train_data.info()
train_data.drop('timestamp', axis=1, inplace=True)
# train_data.info()

# %%
minihash = True
proj_func_num = 100
K = 10
n = 5

# 构建matrix
mat = train_data.pivot_table(index=['userId'], columns=['movieId'], values=['rating'])
mat.fillna(0, inplace=True)
util_mat = np.array(mat.values)
movie_id2index = {mat.columns[i][1]: i for i in range(util_mat.shape[1])}
user_num = util_mat.shape[0]
movie_num = util_mat.shape[1]
if minihash:
    mini_mat = np.array(util_mat)
    mini_mat[util_mat >= 3.0] = 1
    mini_mat[util_mat < 3.0] = 0

# %%

# 构建sim mat
if minihash:
    # 构建哈希签名矩阵
    sig_mat = np.zeros((proj_func_num, user_num))  # 有个问题 用户对所有电影评分都小于3时，数组为全0， 没有第一个为1的位置,是否算其为相似
    for i in range(proj_func_num):
        pai = [j for j in range(movie_num)]
        np.random.shuffle(pai)
        pai_index = np.argsort(pai)  # 找最小的元素的下标且其对应的mini_mat 中的值为1
        for j in range(user_num):
            for index in pai_index:
                if mini_mat[j, pai[index]] == 1:
                    sig_mat[i, j] = pai[index]
                    break

    # 计算jicaard相似度 自己实现
    sig_mat = sig_mat.T  # 用行来算比较快
    sim_mat = np.eye(user_num)
    for i in range(user_num):
        for j in range(i + 1, user_num):
            sim_mat[i, j] = len([sig_mat[i, k] == sig_mat[j, k] for k in range(proj_func_num)]) / proj_func_num


else:
    sim_mat = np.corrcoef(util_mat)
    sim_mat[sim_mat < 0] = 0

# %%
def recommender(mode, userId, util_mat, sim_mat):
    userId = userId - 1  # userID 从1开始，矩阵从0开始
    user_num = util_mat.shape[0]
    movie_num = util_mat.shape[1]
    if mode == 1:  # 1为top k推荐 0为预测评分
        user_rate = np.zeros(util_mat.shape[1])
    else:
        user_rate = util_mat[userId]

    sort_sim_index = np.argsort(sim_mat[userId])[::-1]
    for cur_movie in range(util_mat.shape[1]):
        if util_mat[userId, cur_movie] == 0:
            total = 0
            pred = 0
            rec_num = 0
            for another_user in sort_sim_index:
                another_user_rate = util_mat[another_user, cur_movie]
                if another_user_rate != 0 and rec_num < K:
                    pred += sim_mat[userId, another_user] * another_user_rate
                    total += sim_mat[userId, another_user]
                    rec_num += 1
            user_rate[cur_movie] = pred / total

    if mode == 0:
        return user_rate
    else:
        user_rate[np.isnan(user_rate)] = 0
        rec_index = np.argsort(user_rate)[-n:]
        movie_id_list = list(mat.columns)
        rec = [movie_id_list[i][1] for i in rec_index]
        return rec


recommender(1, 1, util_mat, sim_mat)

# %%

# 读取测试集
test = pd.read_csv(dataset_dir + 'test_set.csv')
test.drop('timestamp', axis=1, inplace=True)
users, movies, ratings = test['userId'], test['movieId'], test['rating']
# test.info()

# %%

# 开始预测
preds = []
pred_cache = {}
for i in range(len(test)):
    print('%d/%d...' % (i + 1, len(test)))
    if users[i] not in pred_cache.keys():
        rates = recommender(0, users[i], util_mat, sim_mat)
        preds.append(rates[movie_id2index[movies[i]]])
        pred_cache[users[i]] = rates
    else:
        rates = pred_cache[users[i]]
        preds.append(rates[movie_id2index[movies[i]]])

SSE = np.sum(np.square(preds - ratings))
print('SSE:', SSE)

# %%
