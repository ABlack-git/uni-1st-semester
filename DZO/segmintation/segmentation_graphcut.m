function lab_out = segmentation_graphcut(img, lab_in, ...
	num_comps, kmeans_iter, neighborhood_type, lambda1, lambda2)
% Segment the RGB image using the graphcut algorithm. The probability
% distributions (GMMs) of background and foreground colors are constructed
% from the partial input labeling.
%
% Input:
%   img [HxWx3 (double)] input RGB image; all RGB channels are from [0, 1]
%   lab_in [HxW (double)] initial labeling of pixels; label 0 denotes
%     unknown pixel, label 1 foregroung, label 2 background
%   num_comps [1x1 (double)] number of clusters to be found by k-means
%     algorithm and also number of GMM components
%   kmeans_iter [1x1 (double)] maximum number of k-means iterations
%   neighborhood_type [1x1 (double)] type of the pixel neighborhood
%     (4-connected or 8-connected)
%   lambda1 [1x1 (double)] weight of Ising term in pairwise potentials
%   lambda2 [1x1 (double)] weight of dependent term in pairwise potentials
%
% Output:
%   lab_out [HxW (double)] output labeling of pixels; label 1 denotes
%     foregroung pixel, label 2 background

% TODO: Replace with your own implementation.
lab_out = 2 * ones(size(lab_in));

% NOTE: Use provided function lab = graphcut(cost_unary, pairs, cost_pair)
%   in order to find the optimum labeling with respect to the specified
%   unary costs, pixel pairs and their costs.

end
