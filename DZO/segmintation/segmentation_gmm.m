function lab_out = segmentation_gmm(img, lab_in, num_comps, kmeans_iter)
% Segment the RGB image based on various statistical properties
% of the foreground and background pixel colors. The probability
% distributions of RGB colors are modeled using mixture of Gaussians (GMM).
% The GMMs are constructed from the initial partial labeling.
%
% Input:
%   img [HxWx3 (double)] input RGB image; all RGB channels are from [0, 1]
%   lab_in [HxW (double)] initial labeling of pixels; label 0 denotes
%     unknown pixel, label 1 foregroung, label 2 background
%   num_comps [1x1 (double)] number of clusters to be found by k-means
%     algorithm and also number of GMM components
%   kmeans_iter [1x1 (double)] maximum number of k-means iterations
%
% Output:
%   lab_out [HxW (double)] output labeling of pixels; label 1 denotes
%     foregroung pixel, label 2 background

% TODO: Replace with your own implementation.
lab_out = 2 * ones(size(lab_in));
[h, w, c] = size(img);
rgb = reshape(img, [h * w, c])';
rgb_f = rgb(:,lab_in==1);
rgb_b = rgb(:,lab_in==2);

comps_f = kmeans(rgb_f',num_comps, 'MaxIter', kmeans_iter)';
[priors_f, means_f, covs_f] = gmm_estimation(rgb_f, comps_f);
f_prob=gmm_prob(rgb, priors_f, means_f, covs_f);

comps_b = kmeans(rgb_b', num_comps, 'MaxIter', kmeans_iter)';
[priors_b, means_b, covs_b] = gmm_estimation(rgb_b, comps_b);
b_prob = gmm_prob(rgb, priors_b, means_b, covs_b);

f_idx = f_prob > b_prob;
b_idx = b_prob > f_prob;
lab_out(f_idx)=1;
lab_out(b_idx)=2;
end
