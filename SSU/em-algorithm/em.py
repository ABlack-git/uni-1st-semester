import numpy as np
from scipy.stats import multivariate_normal


class EMShapeModel:

    def __init__(self, num_samples, num_pixels, init_u,
                 init_means, init_covs, num_clusters=2):
        """

        :param init_u: np.array of shape (n_data_points,)
        :param init_means: np.array of shape (n_samples, n_cluster, n_features)
        :param init_covs: np.array of shape (n_samples, n_cluster, n_features,
        n_features)
        """
        self.num_clusters = num_clusters
        self.num_samples = num_samples
        self.num_data_points = num_pixels
        self.__check_assertions(init_u, init_means, init_covs)
        self.u = init_u
        self.means = init_means
        self.covs = init_covs
        self.alphas_s1 = np.zeros((num_samples, num_pixels))
        self.eps = 2.2204e-16

    def __check_assertions(self, init_u, init_means, init_covs):
        assert init_u.size == self.num_data_points, f"size of init_u array " \
            f"{init_u.size} is not equal to number of pixels " \
            f"{self.num_data_points}"
        means_shape = (self.num_samples, self.num_clusters, 3)
        assert init_means.shape == means_shape, f"shape of init_means array " \
            f"{init_means.shape} is not equal to {means_shape}"
        covs_shape = (self.num_samples, self.num_clusters, 3, 3)
        assert init_covs.shape == covs_shape, f"shape of init_covs array " \
            f"{init_covs.shape} is not equal to {covs_shape}"

    def fit(self, x, num_iter=10):
        """

        :param x: shape (n_samples, n_data_points, n_features)
        :return:
        """
        data_shape = (self.num_samples, self.num_data_points, 3)
        assert x.shape == data_shape, f"shape of data is {x.shape}, should " \
            f"be {data_shape}"
        for it in range(num_iter):
            print(f"iteration {it}/{num_iter}")
            self._e_step(x)
            self._m_step(x)
            print(f"log_l: {self.log_likelyhood(x)}")

    def log_likelyhood(self, x):
        log_l = 0
        for n_sample in range(self.num_samples):
            p_x_s0 = self._joint_probability(
                x[n_sample, :, :], self.means[n_sample, 0, :],
                self.covs[n_sample, 0, :, :], s=0
                )
            p_x_s1 = self._joint_probability(
                x[n_sample, :, :], self.means[n_sample, 1, :],
                self.covs[n_sample, 1, :, :],
                s=1
                )
            log_l = log_l + np.sum(np.log(p_x_s0 + p_x_s1))
        return log_l / self.num_samples

    def predict(self, x):
        """

        :param x: shape (n_data_points, n_features, n_samples_to_predict)
        :return:
        """
        pass

    def _e_step(self, x):
        """
        Computes alphas for all images
        :param x: shape (n_samples, n_data_points, n_features)
        :param means: shape (n_clusters, n_samples, n_features)
        :param covs: shape (n_clusters, n_samples, n_features, n_features)
        :return: alpha(s=1)=p(s=1|x) shape: (n_samples, n_data_points)
        """
        for sample_n in range(self.num_samples):
            num = self._joint_probability(
                x[sample_n, :, :],
                self.means[sample_n, 1, :],
                self.covs[sample_n, 1, :, :])
            denum = np.zeros(self.num_data_points)
            for cluster_n in range(self.num_clusters):
                denum = denum + self._joint_probability(
                    x[sample_n, :, :],
                    self.means[sample_n, cluster_n, :],
                    self.covs[sample_n, cluster_n, :, :], s=cluster_n)
            self.alphas_s1[sample_n, :] = num / (denum + self.eps)

    def _m_step(self, x):
        """
        :param x: shape (n_samples, n_data_points, n_features)
        :return:
        """
        # update u
        sum_alpha = np.sum(self.alphas_s1, axis=0) / self.num_samples
        self.u = np.log(sum_alpha / (1 - sum_alpha))
        alpha_s0 = 1 - self.alphas_s1
        # update tau
        for n_sample in range(self.num_samples):
            mu0, cov0 = self._estimate_tau(x[n_sample, :, :],
                alpha_s0[n_sample, :])
            mu1, cov1 = self._estimate_tau(x[n_sample, :, :],
                self.alphas_s1[n_sample, :])
            self.means[n_sample, 0, :] = mu0
            self.means[n_sample, 1, :] = mu1
            self.covs[n_sample, 0, :, :] = cov0
            self.covs[n_sample, 1, :, :] = cov1

    def _estimate_tau(self, x, alphas):
        """

        :param x: shape (n_data_points, n_features)
        :param sample_n:
        :param alphas: (n_data_points)
        :return:
        """
        mu = np.average(x, weights=alphas, axis=0)
        cov = np.cov(x.T, aweights=alphas, ddof=0)
        return [mu, cov]

    def _joint_probability(self, x, mean, cov, s=1):
        """

        :param x: shape (n_data_points, n_features)
        :param mean: shape (n_features,)
        :param cov: shape (n_features, n_features)
        :param s:
        :return: p(x,s) shape (n_data_points,)
        """
        return self._shape_model(s=s) * self._appearence_model(x, mean, cov)

    def _shape_model(self, s=1):
        """

        :param s:
        :return: shape (n_data_points,)
        """
        if s == 1:
            return np.exp(self.u) / (1 + np.exp(self.u))
        else:
            return 1 / (1 + np.exp(self.u))

    def _appearence_model(self, x, mean, cov):
        """

        :param x: (n_data_points, n_features)
        :param mean: (n_features)
        :param cov: (n_features, n_features)
        :return: shape (n_data_points,)
        """

        dist = multivariate_normal(mean, cov)
        p_mean = dist.pdf(mean)
        return dist.pdf(x)
