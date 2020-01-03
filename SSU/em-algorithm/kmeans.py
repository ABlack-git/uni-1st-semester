import data
import numpy as np
from data import DataLoader
from sklearn.cluster import KMeans

if __name__ == '__main__':
    data_loader = DataLoader()
    data_generator = data_loader.data_generator()
    for im, t_labels in data_generator:
        h, w, c = im.shape
        f_mask, b_mask = data_loader.get_init_regions()
        f_mean = data.get_region_mean(im, f_mask)
        b_mean = data.get_region_mean(im, b_mask)
        kmeans = KMeans(n_clusters=2, init=np.array([b_mean, f_mean]), n_init=1,
                        random_state=1)
        flat_im = np.reshape(im, (h * w, c))
        p_labels = np.reshape(kmeans.fit_predict(flat_im), (h, w))
        data.show_segmentation(im, p_labels, t_labels)
        print(f"accuracy: {data.accuracy(p_labels, t_labels)}")
