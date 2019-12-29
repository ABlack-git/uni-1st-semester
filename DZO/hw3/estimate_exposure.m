function [E, t] = estimate_exposure(Z, w)
%ESTIMATE_EXPOSURE Estimate irradiance and exposure time
%
% [E, t] = estimate_exposure(Z, w)
%
% Estimate irradiance and exposure times from pixel intensities from multiple
% exposures.
% 
% Assume that the response function f is identity.
% (Note that if the response function is known you can transform
% the pixel intensities prior to calling this function.)
% 
% Use eps instead of zero Z values for taking the logarithm to avoid
% infinity.
%
% Input:
%   Z [NxP double] Pixel intensities,
%     Z(i,j) corresponds to the intensity of pixel i in image j.
%   w [NxP double] Weights corresponding to Z.
%
% Output:
%   E [Nx1 double] Irradiance (up to scale).
%   t [1xP double] Exposure times (up to scale),
%     t(1) = 1 (soft constraint).
%

assert(ismatrix(Z));
assert(numel(Z) == numel(w));

[N, P] = size(Z);
% Get pixel and image indices.
[i_E, i_t] = ind2sub(size(Z), (1:numel(Z))');

%% TODO: Implement me!
weights = sqrt(reshape(w,1,N*P));
A=sparse([1:N*P, 1:N*P, N*P+1],[i_E', N+i_t', N+1],[repmat(weights,1,2).*ones(1,2*N*P),1]);
b=[weights.*log(reshape(Z, 1,N*P)+eps),0]';
x= A\b;
E = exp(x(1:N));
t = exp(x(N+1:end));

%%

assert(numel(E) == N);
assert(numel(t) == P);

end
