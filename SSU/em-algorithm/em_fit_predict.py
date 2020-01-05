from em import EMShapeModel
from data import DataLoader
import numpy as np
import matplotlib.pyplot as plt


def get_shape_model(p_s, im_shape):
    model = np.round(p_s * 255)
    return np.reshape(model, im_shape)


if __name__ == '__main__':
    data_loader = DataLoader()
    images, means, covs = data_loader.load_data()
    n_samples, num_pixels, _ = images.shape
    shape_init = data_loader.get_init_shape_model()
    em_shape = EMShapeModel(n_samples, num_pixels, shape_init, means, covs)
    shape_model = em_shape._shape_model()
    plt.imshow(np.reshape(shape_model, (250, 289)))
    plt.show()
    em_shape.fit(images, 50)
