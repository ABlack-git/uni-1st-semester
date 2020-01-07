import cv2
import data
import numpy as np
import matplotlib.pyplot as plt

from data import DataLoader
from sklearn.mixture import GaussianMixture
from sklearn.cluster import KMeans


def create_segmentation_plot(im, p_labels_km, p_labels_gmm, t_labels):
    fig, (ax1, ax2, ax3, ax4) = plt.subplots(1, 4)
    ax1.imshow(cv2.cvtColor(im, cv2.COLOR_BGR2RGB))
    ax1.set_title('Original image')
    ax2.imshow(t_labels)
    ax2.set_title('Ground truth')
    ax3.imshow(p_labels_km)
    ax3.set_title('k-means')
    ax4.imshow(p_labels_gmm)
    ax4.set_title('gmm')
    return fig


if __name__ == '__main__':
    data_loader = DataLoader()
    data_generator = data_loader.data_generator()
    precision_list_km = []
    precision_list_gmm = []
    for im, t_labels in data_generator:
        h, w, c = im.shape
        f_mask, b_mask = data_loader.get_init_regions()
        f_mean = data.get_region_mean(im, f_mask)
        b_mean = data.get_region_mean(im, b_mask)
        gmm = GaussianMixture(n_components=2,
                              means_init=np.array([b_mean, f_mean]))
        kmeans = KMeans(n_clusters=2, init=np.array([b_mean, f_mean]), n_init=1,
                        random_state=1)
        flat_im = np.reshape(im, (h * w, c))
        p_labels_gmm = np.reshape(gmm.fit_predict(flat_im), (h, w))
        p_labels_km = np.reshape(kmeans.fit_predict(flat_im), (h, w))
        precision_list_gmm.append(data.precision(p_labels_gmm, t_labels))
        precision_list_km.append(data.precision(p_labels_km, t_labels))
        create_segmentation_plot(im, p_labels_km, p_labels_gmm, t_labels)
        plt.show()

    print(f'average precision of gmm: {np.average(precision_list_gmm):.3f}')
    print(f'average precision of km: {np.average(precision_list_km):.3f}')
