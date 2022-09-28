# %%

import numpy as np
import os
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

K = 5
n = 3
minihash = False
proj_func_num = 10

work_dir = r'D:\Documents\course\junior\BigDataAna\12-20大作业'
dataset_dir = work_dir + r'\datasets' + '\\'
# print(dataset_dir)

# 获取数据集
raw_data = pd.read_csv(dataset_dir + 'movies.csv')
# raw_data.info()
# print(raw_data.head())
index2Id = {k: v for k, v in enumerate(raw_data['movieId'])}
Id2index = {v: k for k, v in index2Id.items()}

# %%
genres = raw_data['genres'].values

# %%

train_data = pd.read_csv(dataset_dir + 'train_set.csv')
# train_data.info()
train_data.drop('timestamp', axis=1, inplace=True)
# train_data.info()

# %%


mat = train_data.pivot_table(index=['userId'], columns=['movieId'], values=['rating'])
mat.fillna(0, inplace=True)
util_mat = np.array(mat.values)
movie_id2index = {mat.columns[i][1]: i for i in range(util_mat.shape[1])}
index2movie_id = {v: k for k, v in movie_id2index.items()}
user_num = util_mat.shape[0]
movie_num = util_mat.shape[1]

# %%


# 获取tfidf特征矩阵
vectorizer = TfidfVectorizer()
tfidf_mat = vectorizer.fit_transform(genres).toarray()

# %%

from scipy.spatial.distance import pdist, squareform

if minihash:

    # 构建哈希签名矩阵
    mini_mat = np.array(tfidf_mat)
    mini_mat[mini_mat > 0] = 1
    mini_mat[mini_mat <= 0] = 0
    total_movie_num = mini_mat.shape[0]
    feature_num = mini_mat.shape[1]
    sig_mat = np.zeros((proj_func_num, total_movie_num))
    for i in range(proj_func_num):
        # print("pai%d/%d" % (i + 1, proj_func_num))
        pai = [j for j in range(feature_num)]
        np.random.shuffle(pai)
        pai_index = np.argsort(pai)
        for j in range(total_movie_num):
            for index in pai_index:
                if mini_mat[j, pai[index]] == 1:
                    sig_mat[i, j] = pai[index]
                    break

    # %%

    # 计算jiccard相似度 用scipy库
    print('calc sim mat')
    sig_mat = sig_mat.T  # 用行来算比较快
    sim_mat = 1 - squareform(pdist(sig_mat, 'jaccard'))
    print('sim mat cacl finish')
    sim_mat[np.isnan(sim_mat)] = 0

else:
    # 根据特征矩阵计算相似度矩阵
    sim_mat = cosine_similarity(tfidf_mat)
    sim_mat[sim_mat < 0] = 0


# %%


def recommender(mode, userId, util_mat, sim_mat, movie_id):
    userId = userId - 1  # userID 从1开始，矩阵从0开始
    user_num = util_mat.shape[0]
    movie_num = util_mat.shape[1]
    if mode == 1:  # 1为top k推荐 0为预测评分 2为预测单个movie的评分
        user_rate = np.zeros(util_mat.shape[1])
    else:
        user_rate = np.copy(util_mat[userId])

    rate_movie_index = []
    unrate_movie_index = []

    # 找出评了分和没评分的
    for cur_movie in range(movie_num):
        if util_mat[userId, cur_movie] == 0 and mode != 2:
            unrate_movie_index.append(cur_movie)
        else:
            rate_movie_index.append(cur_movie)

    if mode == 2:
        unrate_movie_index.append(movie_id2index[movie_id])

    for cur_movie in unrate_movie_index:
        total = 0
        pred = 0
        for another_movie in rate_movie_index:
            another_movie_rate = util_mat[userId, another_movie]
            if another_movie_rate != 0:
                cur_movie_in_sim_mat = Id2index[index2movie_id[cur_movie]]
                another_movie_in_sim_mat = Id2index[index2movie_id[another_movie]]
                pred += sim_mat[cur_movie_in_sim_mat, another_movie_in_sim_mat] * another_movie_rate
                total += sim_mat[cur_movie_in_sim_mat, another_movie_in_sim_mat]
        user_rate[cur_movie] = pred / total

    if mode == 0 or mode == 2:
        return user_rate
    else: # top k推荐
        user_rate[np.isnan(user_rate)] = 0
        rec_index = np.argsort(user_rate)[-K:]
        movie_id_list = list(mat.columns)
        rec = [movie_id_list[i][1] for i in rec_index]
        return rec


rec = recommender(1, 4, util_mat, sim_mat, 0)
print('recommend for user 671:', rec)

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
    rates = recommender(2, users[i], util_mat, sim_mat, movie_id=movies[i])
    preds.append(rates[movie_id2index[movies[i]]])

SSE = np.sum(np.square(preds - ratings))
print(SSE)
# %%
