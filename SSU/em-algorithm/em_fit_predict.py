import os
import cv2
import data
import numpy as np
import matplotlib.pyplot as plt

from em import EMShapeModel
from data import DataLoader


def save_shape_model(shape_model):
    shape_model_im = np.round(255 * shape_model)
    cv2.imwrite(os.path.join('data', 'results', 'shape_model.png'), shape_model_im)


def evaluate(im, t_labels, p_labels, image_shape, save=True):
    assert t_labels.shape == p_labels.shape
    precision_list = []
    for i in range(t_labels.shape[0]):
        precision_list.append(data.precision(p_labels[i, :], t_labels[i, :]))
        if save:
            fig = data.create_segmentation_plot(np.reshape(im[i, :, :], image_shape),
                                                np.reshape(p_labels[i, :], (image_shape[0], image_shape[1])),
                                                np.reshape(t_labels[i, :], (image_shape[0], image_shape[1])))
            data.save_segmentation(fig, os.path.join('data', 'results', f'hand_{i}_result.png'))
            plt.close(fig)

    [print(f'precision of image {i}: {x:.3f}') for i, x in enumerate(precision_list)]
    print(f'average precision: {np.average(precision_list):.3f}')


if __name__ == '__main__':
    data_loader = DataLoader()
    # seg.shape == (n_images, n_pixels)
    images, means, covs, segs, im_shape = data_loader.load_data()
    n_samples, num_pixels, _ = images.shape
    shape_init = data_loader.get_init_shape_model()
    em_shape = EMShapeModel(n_samples, num_pixels, shape_init, means, covs)
    labels = em_shape.fit_predict(images, tolerance=0.01)
    evaluate(images, segs, labels, im_shape)
    shape_model = em_shape._shape_model()
    save_shape_model(np.reshape(shape_model, (im_shape[0], im_shape[1])))
