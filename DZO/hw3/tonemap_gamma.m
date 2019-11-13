function im = tonemap_gamma(hdr, gamma)
%TONEMAP_GAMMA Tonemapping via gamma correction
%
% im = tonemap_gamma(hdr, gamma)
% 
% Input:
%   hdr   [MxNx3 double]  HDR image in the RGB color space, not normalized.
%   gamma [scalar double] Gamma correction factor.
%
% Output:
%   im [MxNx3 double] Tone-mapped image in RGB, normalized to [0, 1].
%

im = hdr - min(hdr(:));
im = im ./ max(im(:));

hsv = rgb2hsv(im);
hsv(:,:,3) = hsv(:,:,3).^gamma;
im = hsv2rgb(hsv);

end
