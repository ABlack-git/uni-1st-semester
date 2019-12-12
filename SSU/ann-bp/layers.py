import numpy as np


class LinearLayer(object):
    def __init__(self, n_inputs, n_units, rng, name):
        """
        Linear (dense, fully-connected) layer.
        :param n_inputs:
        :param n_units:
        :param rng: random number generator used for initialization
        :param name:
        """
        self.n_inputs = n_inputs
        self.n_units = n_units
        self.rng = rng
        self.name = name
        # (n_inputs, n_units)
        self.W = None
        # (n_units)
        self.b = None
        self.initialize()

    def has_params(self):
        return True

    def forward(self, X):
        """
        Forward message.
        :param X: layer inputs, shape (n_samples, n_inputs)
        :return: layer output, shape (n_samples, n_units)
        """
        if len(X.shape) < 2:
            X = np.expand_dims(X, axis=0)
        return np.dot(X, self.W) + self.b

    def delta(self, Y, delta_next):
        """
        Computes delta (dl/d(layer inputs)), based on delta from the following
        layer. The computations involve backward message.
        :param Y: output of this layer (i.e., input of the next),
        shape (n_samples, n_units)
        :param delta_next: delta vector backpropagated from the following layer,
        shape (n_samples, n_units)
        :return: delta vector from this layer, shape (n_samples, n_inputs)
        """
        return np.dot(delta_next, self.W.T)

    def grad(self, X, delta_next):
        """
        Gradient averaged over all samples. The computations involve parameter
        message.
        :param X: layer input, shape (n_samples, n_inputs)
        :param delta_next: delta vector backpropagated from the following layer,
        shape (n_samples, n_units)
        :return: a list of two arrays [dW, db] corresponding to gradients of
        loss w.r.t. weights and biases, the shapes
        of dW and db are the same as the shapes of the actual parameters
        (self.W, self.b)
        """
        dw = np.dot(X.T, delta_next) / delta_next.shape[0]
        db = np.sum(delta_next, axis=0) / delta_next.shape[0]
        return [dw, db]

    def initialize(self):
        """
        Perform He's initialization (https://arxiv.org/pdf/1502.01852.pdf).
        This method is tuned for ReLU activation function. Biases are
        initialized to 1 increasing probability that ReLU is not initially
        turned off.
        """
        scale = np.sqrt(2.0 / self.n_inputs)
        self.W = self.rng.normal(loc=0.0, scale=scale,
                                 size=(self.n_inputs, self.n_units))
        self.b = np.ones(self.n_units)

    def update_params(self, dtheta):
        """
        Updates weighs and biases.
        :param dtheta: contains a two element list of weight and bias updates
        the shapes of which corresponds to self.W
        and self.b
        """
        assert len(dtheta) == 2, len(dtheta)
        dW, db = dtheta
        assert dW.shape == self.W.shape, dW.shape
        assert db.shape == self.b.shape, db.shape
        self.W += dW
        self.b += db


class ReLULayer(object):
    def __init__(self, name):
        self.name = name

    def has_params(self):
        return False

    def forward(self, X):
        if len(X.shape) < 2:
            X = np.expand_dims(X, axis=0)
        return np.maximum(X, 0)

    def delta(self, Y, delta_next):
        """
        da/dz = 1 if Y >0 and 0 otherwise

        :param Y:
        :param delta_next:
        :return:
        """
        delta_this = np.array(delta_next, copy=True)
        delta_this[Y <= 0] = 0
        return delta_this


class SoftmaxLayer(object):
    def __init__(self, name):
        self.name = name

    def has_params(self):
        return False

    @staticmethod
    def forward(X):
        """

        :param X:
        :return: shape (n_samples, n_inputs)
        """
        if len(X.shape) < 2:
            X = np.expand_dims(X, axis=0)
        shift_x = X - np.tile(np.max(X, axis=1), (X.shape[1], 1)).transpose()
        exp_x = np.exp(shift_x)
        norm_factor = np.sum(exp_x, axis=1)
        return np.divide(exp_x, np.tile(norm_factor, (exp_x.shape[1], 1)).transpose())

    def _get_derivative(self, y):
        y_mat = np.tile(y.reshape(y.shape[0], 1), y.shape[0])
        return np.diag(y) - (y_mat * y_mat.transpose())

    def delta(self, Y, delta_next):
        delta = np.zeros((Y.shape[0], Y.shape[1]))
        for n_sample in range(Y.shape[0]):
            delta[n_sample] = np.dot(delta_next[n_sample], self._get_derivative(Y[n_sample]))
        return delta


class LossCrossEntropy(object):
    def __init__(self, name):
        self.name = name

    @staticmethod
    def forward(X, T):
        """
        Forward message.
        :param X: loss inputs (outputs of the previous layer),
        shape (n_samples, n_inputs), n_inputs is the same as
        the number of classes
        :param T: one-hot encoded targets, shape (n_samples, n_inputs)
        :return: layer output, shape (n_samples, 1)
        """
        if len(X.shape) < 2:
            X = np.expand_dims(X, axis=0)
        return -1 * np.sum(T * np.log(X), axis=1)

    def delta(self, X, T):
        """
        Computes delta vector for the output layer.
        :param X: loss inputs (outputs of the previous layer),
        shape (n_samples, n_inputs), n_inputs is the same as
        the number of classes
        :param T: one-hot encoded targets, shape (n_samples, n_inputs)
        :return: delta vector from the loss layer, shape (n_samples, n_inputs)
        """
        # X here is output of softmax
        return -1 * np.divide(T, X)


class LossCrossEntropyForSoftmaxLogits(object):
    def __init__(self, name):
        self.name = name

    def forward(self, X, T):
        return LossCrossEntropy.forward(SoftmaxLayer.forward(X), T)

    def delta(self, X, T):
        # X here is output of linear layer
        return SoftmaxLayer.forward(X) - T
