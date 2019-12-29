function [img, rgb] = load_rgb(file_path)
% Load grayscale image showing RGB channels vertically stacked. Split the image
% to individual RGB channels.
%
% Input:
%   file_path [string] Path to the input image.
%
% Output:
%   img [3*MxN double] Grayscale image showing RGB channels vertically stacked.
%   rgb [1x3 cell of MxN double] Cell array of individual RGB channels

img = im2double(imread(file_path));
h = floor(size(img, 1) / 3);
rgb = {img(2*h+1:3*h,:), img(h+1:2*h,:), img(1:h,:)};

end
