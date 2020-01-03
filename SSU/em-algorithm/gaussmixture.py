import data
import numpy as np
from data import DataLoader
from sklearn.mixture import GaussianMixture

if __name__ == '__main__':
    data_loader = DataLoader()
    data_generator = data_loader.data_generator()
    for im, t_labels in data_generator:
        h, w, c = im.shape
        f_mask, b_mask = data_loader.get_init_regions()
        f_mean = data.get_region_mean(im, f_mask)
        b_mean = data.get_region_mean(im, b_mask)
        gmm = GaussianMixture(n_components=2,
                              means_init=np.array([b_mean, f_mean]))
        flat_im = np.reshape(im, (h * w, c))
        p_labels = np.reshape(gmm.fit_predict(flat_im), (h, w))
        data.show_segmentation(im, p_labels, t_labels)
        print(f"rms: {data.error(t_labels, p_labels)}")
        print(f"accuracy: {data.accuracy(p_labels, t_labels)}")
