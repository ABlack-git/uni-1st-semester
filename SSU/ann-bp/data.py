import gzip
import os
import urllib
import numpy as np
import matplotlib.pyplot as plt


def load_XOR():
    """
    Loads training data for XOR function. The outputs are encoded using one-hot encoding, so you can check softmax and
    cross-entropy loss function.
    :return: Pair of numpy arrays: (4, 2) training inputs and (4, 2) training labels
    """
    X = np.asarray([
        [0.0, 0.0],
        [0.0, 1.0],
        [1.0, 0.0],
        [1.0, 1.0]], dtype=np.float32)
    T = np.asarray([
        [0.0, 1.0],
        [1.0, 0.0],
        [1.0, 0.0],
        [0.0, 1.0]], dtype=np.float32)
    return X, T


def load_spirals():
    '''
    Loads training and testing data of the spiral dataset. The inputs are standardized and the output labels are one-hot encoded.
    Source based on http://cs231n.github.io/
    :return: Quadruple of numpy arrays (100, 2) training inputs, (100, 3) one-hot encoded training labels,
        (100, 2) testing inputs and (100, 3) one-hot encoded testing labels
    '''

    def generate_points(N):
        K = 3
        X = np.zeros((N * K, 2), dtype=np.float32)
        T = np.zeros((N * K, K), dtype=np.float32)
        for i in range(K):
            r = np.linspace(0.0, 2.5, N)
            t = np.linspace(i * 4, (i + 1) * 4, N) + rng.randn(N) * 0.2
            ix = range(N * i, N * (i + 1))
            X[ix] = np.c_[r * np.sin(t), r * np.cos(t)]
            T[ix, i] = 1.0  # one-hot encoding
        return X, T

    rng = np.random.RandomState(1234)
    X_train, T_train = generate_points(100)
    X_test, T_test = generate_points(100)
    return X_train, T_train, X_test, T_test


def plot_2D_classification(X, T, net):
    """
    Plots a classification for 2D inputs. The call of this function should be followed by plt.show()
    in non-interactive matplotlib session.
    :param X: Input of shape (n_samples, 2)
    :param T: One-hot encoded target labels of shape (n_samples, n_classes)
    :param net: trained network, instance of MLP class
    """
    h = 0.02
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                         np.arange(y_min, y_max, h))
    Z = net.propagate(np.c_[xx.ravel(), yy.ravel()])
    Z = np.argmax(Z, axis=1)
    Z = Z.reshape(xx.shape)
    plt.contourf(xx, yy, Z, cmap=plt.cm.Spectral, alpha=0.8)
    plt.scatter(X[:, 0], X[:, 1], c=np.argmax(T, axis=1), s=40,
                cmap=plt.cm.Spectral)
    plt.xlim(xx.min(), xx.max())
    plt.ylim(yy.min(), yy.max())


def load_MNIST():
    """
    Loads MNIST dataset. If not present locally, the dataset is downloaded from Yann LeCun's site.
    The dataset consists of 60k training and 10k testing samples of 28x28 grayscale images. The inputs are standardized
    and the output labels are one-hot encoded.
    Inspired by https://gist.github.com/ischlag/41d15424e7989b936c1609b53edd1390
    :return: Quadruple of numpy arrays (60000, 784) training inputs, (60000, 10) one-hot encoded training labels,
        (10000, 784) testing inputs and (10000, 10) one-hot encoded testing labels
    """
    IMAGE_SIZE = 28
    N_CLASSES = 10
    files = {
        'X_train': ('train-images-idx3-ubyte.gz', 60000),
        'T_train': ('train-labels-idx1-ubyte.gz', 60000),
        'X_test': ('t10k-images-idx3-ubyte.gz', 10000),
        'T_test': ('t10k-labels-idx1-ubyte.gz', 10000),
    }
    data = {}
    for label, (name, n_images) in files.items():
        if not os.path.exists(name):
            print('downloading: {}'.format(name))
            urllib.urlretrieve(
                'http://yann.lecun.com/exdb/mnist/{}'.format(name), name)
        with gzip.open(name) as bytestream:
            if label.startswith('X'):

                bytestream.read(16)  # header
                data[label] = (np.frombuffer(
                    bytestream.read(IMAGE_SIZE * IMAGE_SIZE * n_images),
                    dtype=np.uint8).astype(np.float32) / 255.0).reshape(
                    n_images, -1)
            else:
                bytestream.read(8)  # header
                classes = np.frombuffer(bytestream.read(n_images),
                                        dtype=np.uint8).astype(np.int64)
                onehot = np.zeros((len(classes), N_CLASSES), dtype=np.float32)
                onehot[np.arange(len(classes)), classes] = 1
                data[label] = onehot

    # standardization
    X_train, T_train, X_test, T_test = [data[label] for label in
                                        ['X_train', 'T_train', 'X_test',
                                         'T_test']]
    m, s = X_train.mean(axis=0), X_train.std(axis=0)
    mask = s > 0.0
    X_train[:, mask] = (X_train[:, mask] - m[mask]) / s[mask]
    X_test[:, mask] = (X_test[:, mask] - m[mask]) / s[mask]

    return X_train, T_train, X_test, T_test


def plot_MNIST(array, n_cols=10):
    """
    Plots table of MNIST characters with defined number of columns. The number of characters divided by the number of
    columns, i.e. the number of rows, must be integer. The call of this function should be followed by plt.show()
    in non-interactive matplotlib session.
    session.
    :param array: input array of shape (number of characters, 784)
    :param n_cols: number of table columns
    """
    n, height, width = array.shape[0], 28, 28
    n_rows = n // n_cols
    assert n == n_rows * n_cols, [n, n_rows * n_cols]
    result = (array.reshape(n_rows, n_cols, height, width)
              .swapaxes(1, 2)
              .reshape(height * n_rows, width * n_cols))
    plt.imshow(result, cmap='gray')
