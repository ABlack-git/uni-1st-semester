function [E, finv] = estimate_response(Z, t, w, lambda)
%ESTIMATE_EXPOSURE Estimate irradiance and response function
%
% [E, finv] = estimate_exposure(Z, t, w, lambda)
%
% Estimate irradiance and the inverse response function from pixel intensities
% from multiple exposures.
%
% Input:
%   Z [NxP double] Pixel intensities.
%     Z(i,j) is the intensity of pixel i in image j.
%   t [1xP double] Exposure times, t > 0.
%   w [NxP double] Weights.
%   lambda [1x1 double] Smoothness violation penalty.
%
% Output:
%   E    [Nx1 double] Irradiance (up to scale).
%   finv [Lx1 double] Inverse response function (up to scale),
%     finv(round(L/2)+1) = 1 (soft constraint).
%

assert(ismatrix(Z));
assert(numel(Z) == numel(w));
assert(size(Z, 2) == numel(t));
assert(all(t(:) > 0));

[N, P] = size(Z);
L = max(Z(:)) + 1;
% Get pixel and image indices.
[i_E, i_t] = ind2sub(size(Z), (1:numel(Z))');

%% TODO: Implement me!
NP=N*P;
weights = sqrt(reshape(w, 1, NP));
i = [1:NP, 1:NP, NP+1, reshape(repmat(NP+2:NP+L-1, [3,1]), 1, 3*(L-2))];
smooth_j = zeros(L-2, 3);
smooth_j(1,:)=[1 2 3];
for k=1:L-3
    smooth_j(k+1,:)=smooth_j(k,:)+1;
end
smooth_j=reshape(smooth_j', 1, 3*(L-2));
j = [reshape(Z, 1, NP)+1, L+i_E', floor(L/2+0.5)+1, smooth_j];
s = [weights.*ones(1, NP), -weights.*ones(1,NP), 1, sqrt(lambda)*repmat([1, -2, 1], [1, L-2])];
A = sparse(i,j,s);
b = [weights.*reshape(repmat(log(t),[N,1]), [1,NP]), 0, zeros(1,L-2)]';
x=A\b;
finv = exp(x(1:L));
E = exp(x(L+1:end));
%%
assert(numel(finv) == L);
assert(numel(E) == N);
end
