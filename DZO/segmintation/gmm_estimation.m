function [priors, means, covs] = gmm_estimation(x, c)
% Estimate Gaussian mixture model (GMM) by maximizing the likelihood.
% The input is formed by sample vectors split to clusters. Each cluster
% corresponds to one GMM component. The output is formed by estimated prior
% probabilities, mean vectors and covariance matrices for all components.
%
% Input:
%   x [DxN (double)] N data sample vectors of dimension D from which GMM
%     should be estimated
%   c [1xN (double)] identifier of the cluster to which the corresponding
%     sample is assigned; there are totally K = max(c) clusters which are
%     named as 1, 2, ..., k
%
% Output:
%   priors [1xK (double)] prior probabilities of individual GMM components
%   means [DxK (double)] mean vectors of individual GMM components
%   covs [DxDxK (double)] covariance matrices of individual GMM components

% TODO: Replace with your own implementation.

    function [phi, mu, sigma] = estimate(data, num_samples)
        phi = size(data,1)/num_samples;
        mu = mean(data,1);
        sigma = cov(data,1);
    end

K = max(c);
[D,num_samples] = size(x);
priors = zeros(1,K);
means = zeros(D,K);
covs = zeros(D,D,K);
for k=1:K
    [phi, mu, sigma] = estimate(x(:,c==k)', num_samples);
    priors(k) = phi;
    means(:,k) = mu;
    covs(:,:,k) = sigma;
end


% NOTE: You can use function cov(x, 1) as described in the assignment.

end
