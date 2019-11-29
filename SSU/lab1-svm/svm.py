from sklearn.svm import SVC
import sklearn.datasets as datasets
import sklearn.metrics as metrics
import matplotlib.pyplot as plt


def get_precomputed_set(path):
    data = datasets.load_svmlight_file(path)
    return data[0].toarray(), data[1]


REG_CONSTS = [0.01, 0.1, 1, 10, 100]
trn_x, trn_true_y = get_precomputed_set('kernels/trn_kernel_mat.svmlight')
val_x, val_true_y = get_precomputed_set('kernels/val_kernel_mat.svmlight')
tst_x, tst_true_y = get_precomputed_set('kernels/tst_kernel_mat.svmlight')
val_errs = list()
trn_errs = list()
min_loss = float('inf')
min_c = -1
best_svm = None
for c in REG_CONSTS:
    svm = SVC(kernel='precomputed', C=c)
    svm.fit(trn_x, trn_true_y)
    trn_pred_y = svm.predict(trn_x)
    trn_err = metrics.zero_one_loss(y_true=trn_true_y, y_pred=trn_pred_y, normalize=True)
    trn_errs.append(trn_err)
    val_pred_y = svm.predict(val_x)
    val_err = metrics.zero_one_loss(y_true=val_true_y, y_pred=val_pred_y, normalize=True)
    print(f"reg_constant: {c}, val_loss: {val_err:.3f}, trn_loss: {trn_err:.3f},  num_supp_vectors: {len(svm.support_)}")
    val_errs.append(val_err)
    if val_err < min_loss:
        min_loss = val_err
        min_c = c
        best_svm = svm

plt.plot(REG_CONSTS, val_errs, label='Validation error')
plt.plot(REG_CONSTS, trn_errs, label='Train error')
plt.legend()
plt.xscale('log')
plt.xlabel('Regularization constants')
plt.ylabel('Loss')
tst_pred_y = best_svm.predict(tst_x)
val_err = metrics.zero_one_loss(tst_true_y, tst_pred_y, normalize=True)
print(f"min_loss: {min_loss:.3f}, reg_const: {min_c}, num_support_vectors: {len(best_svm.support_)}")
print(f"Test loss: {val_err}")
plt.show()
