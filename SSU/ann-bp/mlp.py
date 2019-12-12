import numpy as np
import matplotlib.pyplot as plt
import data

from layers import LinearLayer, LossCrossEntropy, \
    LossCrossEntropyForSoftmaxLogits, ReLULayer, SoftmaxLayer
from collections import defaultdict
import pickle


class MLP(object):
    def __init__(self, n_inputs, layers, loss, output_layers=None):
        """
        MLP constructor.
        :param n_inputs:
        :param layers: list of layers
        :param loss: loss function layer
        :param output_layers: list of layers appended to "layers" in evaluation phase, parameters of these are not used
        in training phase
        """
        if output_layers is None:
            output_layers = []
        self.n_inputs = n_inputs
        self.layers = layers
        self.output_layers = output_layers
        self.loss = loss
        self.first_param_layer = layers[-1]
        for l in layers:
            if l.has_params():
                self.first_param_layer = l
                break

    def propagate(self, X, output_layers=True, last_layer=None):
        """
        Feedforwad network propagation
        :param X: input data, shape (n_samples, n_inputs)
        :param output_layers: controls whether the self.output_layers are appended to the self.layers in evaluatin
        :param last_layer: if not None, the propagation will stop at layer with this name
        :return: propagated inputs, shape (n_samples, n_units_of_the_last_layer)
        """
        layers = self.layers + (self.output_layers if output_layers else [])
        if last_layer is not None:
            assert isinstance(last_layer, str)  # Python 2 will be dead starting from 1.1.2020
            layer_names = [layer.name for layer in layers]
            layers = layers[0: layer_names.index(last_layer) + 1]
        for layer in layers:
            X = layer.forward(X)
        return X

    def evaluate(self, X, T):
        """
        Computes loss.
        :param X: input data, shape (n_samples, n_inputs)
        :param T: target labels, shape (n_samples, n_outputs)
        :return:
        """
        return self.loss.forward(self.propagate(X, output_layers=False), T)

    def gradient(self, X, T):
        """
        Computes gradient of loss w.r.t. all network parameters.
        :param X: input data, shape (n_samples, n_inputs)
        :param T: target labels, shape (n_samples, n_outputs)
        :return: a dict of records in which key is the layer.name and value the output of grad function
        """
        layer_out = [X]
        grads = dict()
        layer_input = X
        for layer in self.layers:
            layer_input = layer.forward(layer_input)
            layer_out.append(layer_input)

        layer_out.reverse()
        delta = self.loss.delta(layer_out[0], T)

        for i, layer in enumerate(reversed(self.layers)):
            delta_next = None
            if i != len(self.layers) - 1:
                delta_next = layer.delta(layer_out[i], delta)
            if layer.has_params():
                grads[layer.name] = layer.grad(layer_out[i + 1], delta)

            delta = delta_next

        return grads

    def get_weights_mean(self):
        means = dict()
        for layer in self.layers:
            if layer.has_params():
                means[layer.name] = np.abs(np.mean(layer.W))
        return means


# ---------------------------------------
# -------------- TRAINING ---------------
# ---------------------------------------

def accuracy(Y, T):
    p = np.argmax(Y, axis=1)
    t = np.argmax(T, axis=1)
    return np.mean(p == t)


def train(net, X_train, T_train, batch_size=1, n_epochs=2, eta=0.1, X_test=None,
          T_test=None, verbose=False):
    """
    Trains a network using vanilla gradient descent.
    :param net:
    :param X_train:
    :param T_train:
    :param batch_size:
    :param n_epochs:
    :param eta: learning rate
    :param X_test:
    :param T_test:
    :param verbose: prints evaluation for each epoch if True
    :return:
    """
    n_samples = X_train.shape[0]
    assert T_train.shape[0] == n_samples
    assert batch_size <= n_samples
    run_info = defaultdict(list)

    def process_info(epoch):
        loss_test, acc_test = np.nan, np.nan
        Y = net.propagate(X_train)
        loss_train = net.loss.forward(Y, T_train)
        acc_train = accuracy(Y, T_train)
        run_info['loss_train'].append(loss_train)
        run_info['acc_train'].append(acc_train)
        means = net.get_weights_mean()
        run_info['weight_means'].append(means)
        if X_test is not None:
            Y = net.propagate(X_test)
            loss_test = net.loss.forward(Y, T_test)
            acc_test = accuracy(Y, T_test)
            run_info['loss_test'].append(loss_test)
            run_info['acc_test'].append(acc_test)
        if verbose:
            print('epoch: {}, loss: {}/{} accuracy: {}/{}'.format(epoch,
                                                                  np.mean(
                                                                      loss_train),
                                                                  np.nanmean(
                                                                      loss_test),
                                                                  np.nanmean(
                                                                      acc_train),
                                                                  np.nanmean(
                                                                      acc_test)))

    process_info('initial')
    for epoch in range(1, n_epochs + 1):
        offset = 0
        while offset < n_samples:
            last = min(offset + batch_size, n_samples)
            if verbose:
                print('.', end='')
            grads = net.gradient(np.asarray(X_train[offset:last]),
                                 np.asarray(T_train[offset:last]))
            for layer in net.layers:
                if layer.has_params():
                    gs = grads[layer.name]
                    dtheta = [-eta * g for g in gs]
                    layer.update_params(dtheta)

            offset += batch_size
        if verbose:
            print()
        process_info(epoch)
    return run_info


# ---------------------------------------
# -------------- EXPERIMENTS ------------
# ---------------------------------------

def plot_convergence(run_info):
    plt.plot(run_info['acc_train'], label='train')
    plt.plot(run_info['acc_test'], label='test')
    plt.xlabel('epoch')
    plt.ylabel('accuracy')
    plt.legend()


def plot_test_accuracy_comparison(run_info_dict):
    keys = sorted(run_info_dict.keys())
    for key in keys:
        plt.plot(run_info_dict[key]['acc_test'], label=key)
    plt.xlabel('epoch')
    plt.ylabel('accuracy')
    plt.legend()


def experiment_XOR():
    X, T = data.load_XOR()
    rng = np.random.RandomState(1234)
    net = MLP(n_inputs=2,
              layers=[
                  LinearLayer(n_inputs=2, n_units=4, rng=rng, name='Linear_1'),
                  ReLULayer(name='ReLU_1'),
                  LinearLayer(n_inputs=4, n_units=2, rng=rng,
                              name='Linear_OUT'),
                  SoftmaxLayer(name='Softmax_OUT')
              ],
              loss=LossCrossEntropy(name='CE'),
              )

    run_info = train(net, X, T, batch_size=4, eta=0.1, n_epochs=100,
                     verbose=False)
    plot_convergence(run_info)
    plt.show()
    print(net.propagate(X))
    data.plot_2D_classification(X, T, net)
    plt.show()
    plot_means(run_info)
    plt.show()


def experiment_spirals():
    X_train, T_train, X_test, T_test = data.load_spirals()
    experiments = (
        ('eta = 0.2', 0.2),
        ('eta = 1', 1.0),
        ('eta = 5', 5.0),
    )
    run_info_dict = {}
    for name, eta in experiments:
        rng = np.random.RandomState(1234)
        net = MLP(n_inputs=2,
                  layers=[
                      LinearLayer(n_inputs=2, n_units=10, rng=rng,
                                  name='Linear_1'),
                      ReLULayer(name='ReLU_1'),
                      LinearLayer(n_inputs=10, n_units=3, rng=rng,
                                  name='Linear_OUT'),
                      SoftmaxLayer(name='Softmax_OUT')
                  ],
                  loss=LossCrossEntropy(name='CE'),
                  )

        run_info = train(net, X_train, T_train, batch_size=len(X_train),
                         eta=eta, X_test=X_test, T_test=T_test,
                         n_epochs=1000, verbose=True)
        run_info_dict[name] = run_info
        # plot_spirals(X_train, T_train, net)
        # plt.show()
        plot_convergence(run_info)
        plt.show()

    plot_test_accuracy_comparison(run_info_dict)
    plt.show()
    with open('spirals_run_info.p', 'wb') as f:
        pickle.dump(run_info, f)

    # plt.savefig('spiral.pdf') # you can instead save figure to file


def experiment_MNIST():
    X_train, T_train, X_test, T_test = data.load_MNIST()
    np.seterr(all='raise', under='warn', over='warn')
    rng = np.random.RandomState(1234)
    net = MLP(n_inputs=28 * 28,
              layers=[
                  LinearLayer(n_inputs=28 * 28, n_units=64, rng=rng,
                              name='Linear_1'),
                  ReLULayer(name='ReLU_1'),
                  LinearLayer(n_inputs=64, n_units=64, rng=rng,
                              name='Linear_2'),
                  ReLULayer(name='ReLU_2'),
                  LinearLayer(n_inputs=64, n_units=64, rng=rng,
                              name='Linear_3'),
                  ReLULayer(name='ReLU_3'),
                  LinearLayer(n_inputs=64, n_units=64, rng=rng,
                              name='Linear_4'),
                  ReLULayer(name='ReLU_4'),
                  LinearLayer(n_inputs=64, n_units=64, rng=rng,
                              name='Linear_5'),
                  ReLULayer(name='ReLU_5'),
                  LinearLayer(n_inputs=64, n_units=10, rng=rng,
                              name='Linear_OUT'),
              ],
              loss=LossCrossEntropyForSoftmaxLogits(name='CE'),
              output_layers=[SoftmaxLayer(name='Softmax_OUT')]
              )

    run_info = train(net, X_train, T_train, batch_size=3000, eta=1e-1,
                     X_test=X_test, T_test=T_test, n_epochs=100,
                     verbose=True)

    plot_convergence(run_info)
    plt.show()
    plot_means(run_info)
    plt.show()

    with open('MNIST_run_info.p', 'wb') as f:
        pickle.dump(run_info, f)


def plot_means(run_info):
    means_lists = defaultdict(list)
    for mean_obj in run_info['weight_means']:
        for key, value in mean_obj.items():
            means_lists[key].append(value)
    for key, value in means_lists.items():
        norm_means = np.array(value) / value[0]
        # norm_means = value
        plt.plot(norm_means, label=key)

    plt.xlabel('epoch')
    plt.ylabel('Weights mean')
    plt.legend()


def load_pickle_and_plot(pickle_path):
    with open(pickle_path, 'rb') as f:
        run_info = pickle.load(f)
        plot_means(run_info)
        plt.show()


if __name__ == '__main__':
    # experiment_XOR()

    # experiment_spirals()

    # experiment_MNIST()

    load_pickle_and_plot('MNIST_run_info.p')
