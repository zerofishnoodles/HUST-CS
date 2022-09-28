import pickle as pkl
import re
from sklearn.model_selection import GridSearchCV
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

train_file = "D:/Documents/course/junior/ML/dataset/train_cases"
train_label_file = "D:/Documents/course/junior/ML/dataset/train_labels"
test_file = "D:/Documents/course/junior/ML/dataset/test_cases"
result_file = "D:/Documents/course/junior/ML/dataset/result.txt"
model = ["NB", "LogReg", "KNN"]

param_NB = {"alpha": [0.005, 0.05, 0.5]}

# 载入数据
with open(train_file, "rb") as f:
    train_corpus = pkl.load(f)
with open(train_label_file, "rb") as f:
    train_labels = pkl.load(f)
with open(test_file, "rb") as f:
    test_corpus = pkl.load(f)



def NB_model():
    NB_pipe = Pipeline([("vec", CountVectorizer(max_features=5000, stop_words='english', lowercase=True)),
                            ("trans", TfidfTransformer()),
                            ("clf", GridSearchCV(MultinomialNB(), param_NB, cv=5, verbose=100))])
    return NB_pipe

def train_predict():
    NB_pipe = NB_model()
    NB_pipe.fit(train_corpus, train_labels)
    result = NB_pipe.predict(test_corpus)
    with open(result, "w") as f:
        for i in result:
            f.write(f'{i}\n')

train_predict

