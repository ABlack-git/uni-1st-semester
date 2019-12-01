function prob = gmm_prob(x, priors, means, covs)
% Compute probabilities of the specified samples in GMM. The probability
% distribution is specified by prior probabilities, mean vectors and
% covariance matrices of individual components.
%
% Input:
%   x [DxN (double)] N data sample vectors of dimension D for which
%     logarithms of likelihood probabilities should be evaluated
%   priors [1xK (double)] prior probabilities of individual GMM components
%   means [DxK (double)] mean vectors of individual GMM components
%   covs [DxDxK (double)] covariance matrices of individual GMM components
%
% Output:
%   prob [1xN (double)] probabilities for all N input data samples given
%     by the specified GMM distribution

% TODO: Replace with your own implementation.

    function p = mnormprob(x, mu, sigma)
        x_t = x';
        x_vec = x_t - repmat(mu', size(x_t,1),1); % NxD - row vector
        inv_mult = x_vec/sigma; % <=> x_vec*inv(sigma)
        exponential =exp(-0.5*inv_mult*x_vec');
        p = (2*pi)^(-size(x,1)/2)*sqrt(1/det(sigma))*exponential;
    end

prob = zeros(size(x, 2),1);
K = size(priors,2);
for k=1:K
%     prob + priors(k)*
    prob = mvnpdf(x',means(:,k)',covs(:,:,k));
end
prob = prob';
end
