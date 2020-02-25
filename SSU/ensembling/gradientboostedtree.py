import numpy as np
import ensembling as ens

from ensembling import RegressionTree


class GradientBoostedTrees(object):
    # COMPLETE CODE HERE
    def __init__(self, data, tattr, xattrs=None,
                 n_trees=10,
                 max_depth=1,
                 beta=0.1,
                 rng=np.random.RandomState(1)):
        """
        Gradient Boosted Trees constructor. Constructs the model fitting supplied dataset.
        :param data: Dataset instance
        :param tattr: the name of target attribute column
        :param xattrs: list of names of the input attribute columns
        :param n_trees: number of trees
        :param max_depth: limit on tree depth
        :param beta: learning rate
        :param rng: random number generator
        """
        self.data = data
        self.tattr = tattr
        self.xattrs = xattrs
        self.n_trees = n_trees
        self.max_depth = max_depth
        self.beta = beta
        self.rng = rng
        self.trees = []
        self._build_trees()

    def _build_trees(self):
        tree_0 = RegressionTree(
            self.data, self.tattr,
            self.xattrs, max_depth=0, rng=self.rng)
        self.trees.append(tree_0)
        out = ens.evaluate_all(tree_0, self.data)
        for i in range(self.n_trees):
            modified_data = self.data.modify_col(
                self.tattr, self.data[self.tattr] - out)
            tree = RegressionTree(
                modified_data, self.tattr,
                self.xattrs, max_depth=self.max_depth, rng=self.rng)
            self.trees.append(tree)
            out = out + self.beta * ens.evaluate_all(tree, self.data)

    def evaluate(self, x):
        res = self.trees[0].evaluate(x)
        for tree in self.trees:
            res = res + self.beta * tree.evaluate(x)
        return res
