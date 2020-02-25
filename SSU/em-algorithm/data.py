import os
import cv2
import glob
import numpy as np
import matplotlib.pyplot as plt


class DataLoader:
    def __init__(self, data_path='data'):
        self.image_paths = sorted(
            glob.glob(os.path.join(data_path, 'hand_[0-9][0-9].png')))
        self.seg_paths = sorted(
            glob.glob(os.path.join(data_path, 'hand_[0-9][0-9]_seg.png')))
        self.im_and_seg_paths = zip(self.image_paths, self.seg_paths)
        self.model_init_path = os.path.join(data_path, 'model_init.png')
        self.foreground_mask = None
        self.background_mask = None

    def _load_segmentation(self, path):
        seg = cv2.imread(path)
        gray = cv2.cvtColor(seg, cv2.COLOR_BGR2GRAY)
        gray[gray == 255] = 1
        return gray

    def data_generator(self):
        for im_path, seg_path in self.im_and_seg_paths:
            im = cv2.imread(im_path)
            seg = self._load_segmentation(seg_path)
            yield im, seg

    def load_data(self):
        shape = None
        images = []
        means = []
        covs = []
        segments = []
        self.get_init_regions()
        for im, seg in self.data_generator():
            if shape is None:
                shape = im.shape
            images.append(np.reshape(im, (im.shape[0] * im.shape[1], 3)))
            mu_0 = get_region_mean(im, self.background_mask)
            mu_1 = get_region_mean(im, self.foreground_mask)
            means.append([mu_0, mu_1])
            cov_0 = get_region_cov(im, self.background_mask)
            cov_1 = get_region_cov(im, self.foreground_mask)
            covs.append([cov_0, cov_1])
            segments.append(np.reshape(seg, (seg.shape[0] * seg.shape[1])))
        return np.array(images), np.array(means), np.array(covs), np.array(segments), shape

    def get_init_regions(self):
        if self.foreground_mask is None or self.background_mask is None:
            self._load_init_regions()
        return self.foreground_mask, self.background_mask

    def get_init_shape_model(self):
        model_init = cv2.imread(self.model_init_path, cv2.IMREAD_GRAYSCALE)
        shape_model = np.reshape(model_init - np.mean(model_init),
                                 (model_init.shape[0] * model_init.shape[1]))
        shape_model = shape_model / np.max(shape_model)
        return shape_model

    def _load_init_regions(self):
        model_init = cv2.imread(self.model_init_path)
        model_init_hsv = cv2.cvtColor(model_init, cv2.COLOR_BGR2HSV)
        max_foreground = np.array([0, 0, 241])
        min_foreground = np.array([0, 0, 206])
        self.foreground_mask = cv2.inRange(model_init_hsv, min_foreground,
                                           max_foreground)
        max_background = np.array([0, 0, 101])
        min_background = np.array([0, 0, 0])
        self.background_mask = cv2.inRange(model_init_hsv, min_background,
                                           max_background)


def get_region_mean(image, region_mask):
    return np.mean(image[region_mask == 255], axis=0)


def get_region_cov(image, region_mask):
    data_points = image[region_mask == 255]
    return np.cov(data_points.T)


def precision(p_labels, t_labels):
    return np.sum(p_labels == t_labels) / t_labels.size


def create_segmentation_plot(im, p_labels, t_labels):
    fig, (ax1, ax2, ax3) = plt.subplots(1, 3)
    ax1.imshow(cv2.cvtColor(im, cv2.COLOR_BGR2RGB))
    ax1.set_title('Original image')
    ax2.imshow(t_labels)
    ax2.set_title('Ground truth')
    ax3.imshow(p_labels)
    ax3.set_title('Predicted')
    return fig


def save_segmentation(fig, path):
    fig.savefig(path)
