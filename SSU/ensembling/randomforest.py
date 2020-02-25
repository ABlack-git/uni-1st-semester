import numpy as np

from ensembling import RegressionTree
from ensembling import Dataset


class RandomForest(object):
    # COMPLETE CODE HERE
    def __init__(self, data, tattr, xattrs=None,
                 n_trees=10,
                 max_depth=np.inf,
                 max_features=lambda n: n,
                 rng=np.random.RandomState(1)):
        """
        Random forest constructor. Constructs the model fitting supplied dataset.
        :param data: Dataset instance
        :param tattr: the name of target attribute column
        :param xattrs: list of names of the input attribute columns
        :param n_trees: number of trees
        :param max_depth: limit on tree depth
        :param max_features: the number of features considered when splitting a node (all by default)
        :param rng: random number generator
        """
        self.data = data
        self.tattr = tattr
        self.xattrs = xattrs
        self.n_trees = n_trees
        self.max_depth = max_depth
        self.max_features = max_features
        self.rng = rng
        self.forest = []
        self._build_forest()

    def _build_forest(self):
        for trees in range(self.n_trees):
            data = self._bootstrap_data()
            self.forest.append(
                RegressionTree(
                    data, self.tattr,
                    self.xattrs, self.max_depth,
                    self.max_features, self.rng))

    def _bootstrap_data(self):
        return Dataset(
            self.data,
            ix=self.rng.choice(len(self.data), len(self.data), replace=True)
            )

    def evaluate(self, x):
        results = np.array([tree.evaluate(x) for tree in self.forest])
        return np.mean(results)
