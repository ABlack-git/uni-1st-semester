from sklearn.svm import SVC
import sklearn.datasets as datasets
import sklearn.metrics as metrics
import matplotlib.pyplot as plt


def get_precomputed_set(path):
    data = datasets.load_svmlight_file(path)
    return data[0], data[1]


def plot_errors(y, x):
    plt.plot(x, y)
    plt.xscale('log')
    plt.show()


REG_CONSTS = [0.01, 0.1, 1, 10, 100]
trn_x, trn_true_y = get_precomputed_set('kernels/trn_kernel_mat.svmlight')
val_x, val_true_y = get_precomputed_set('kernels/val_kernel_mat.svmlight')
tst_x, tst_true_y = get_precomputed_set('kernels/tst_kernel_mat.svmlight')
errors = list()
svms = dict()
for c in REG_CONSTS:
    svm = SVC(kernel='linear', C=c)
    svm.fit(trn_x, trn_true_y)
    val_pred_y = svm.predict(val_x)
    err = metrics.zero_one_loss(y_true=val_true_y, y_pred=val_pred_y,
                                normalize=True)
    print(c, err)
    print(svm.support_vectors_.shape)
    # f strings is a feature of python >= 3.6
    svms[f'{c}'] = svm
    errors.append(err)

plot_errors(errors, REG_CONSTS)
svm = svms['1']
tst_pred_y = svm.predict(tst_x)
err = metrics.zero_one_loss(tst_true_y, tst_pred_y, normalize=True)
print(err)
