function im = tonemap_histeq(hdr)
%TONEMAP_HISTEQ Tonemapping via histogram equalization
%
% im = tonemap_histeq(hdr)
% 
% Input:
%   hdr   [MxNx3 double]  HDR image in the RGB color space, not normalized.
%
% Output:
%   im [MxNx3 double] Tone-mapped image in RGB, normalized to [0, 1].
%

im = hdr - min(hdr(:));
im = im ./ max(im(:));

%% TODO: Implement me!
hsv = rgb2hsv(im);
hsv(:,:,3) = histeq(hsv(:,:,3));
im = hsv2rgb(hsv);

%%

end
