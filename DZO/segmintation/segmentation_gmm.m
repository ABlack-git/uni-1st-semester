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

end
