function hdr = compose_hdr(im, t, w, finv)
%COMPOSE_HDR Compose HDR image
%
% hdr = compose_hdr(im, t, w, finv)
%
% Input:
%   im   [1xP cell] Cell array of images [MxNxC].
%   t    [1xP double] Exposure times.
%   w    [1xL double] Intensity weights, indexed as w(double(im{i})+1).
%   finv [1xL double] Inverse response function, indexed as finv(double(im{i})+1).
%
% Output:
%   hdr [MxNxC double] HDR image composed from the input images.
%

assert(numel(im) == numel(t));
assert(numel(w) == numel(finv));

hdr = zeros(size(im{1}));

%% TODO: Implement me!


%%

end
