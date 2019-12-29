function img_cropped = crop_image(img, margin)
% Crop all sides of the image by the relative margin.
%
% Input:
%   img [MxN double] image to be cropped
%   margin [double] relative margin from the interval (0, 0.5)
%
% Output:
%   img_cropped [KxL double] cropped image, where K ~ (1 - 2 * margin) * M and
%     L ~ (1 - 2 * margin) * N

[h, w] = size(img);

ri = ceil(margin*h):floor((1-margin)*h);
rj = ceil(margin*w):floor((1-margin)*w);

img_cropped = img(ri,rj);

end
