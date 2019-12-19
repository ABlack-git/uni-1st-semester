function img_smooth = smooth_image(img, sigma)
% Smooth image by convolving it with Gaussian filter with the specified sigma.
%
% Input:
%   img [MxN double] image to be smoothed
%   sigma [double] standard deviation of Gaussian
%
% Output:
%   img_smooth [MxN double] smoothed image

s = ceil(3 * sigma);
if mod(s, 2) == 0
    s = s + 1;
end

gauss = fspecial('gauss', s, sigma);
img_smooth = imfilter(img, gauss, 'replicate', 'same');

end
