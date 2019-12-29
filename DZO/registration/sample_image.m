function img_xy = sample_image(img, x, y)
% Sample the image in the specified points by linear interpolation.
%
% Input:
%   img [MxN double] input image
%   x [KxL double] x coordinates of sampling points
%   y [KxL double] y coordinates of sampling points
%
% Output:
%   img_xy [KXL double] interpolated image

img_xy = interp2(img, x, y, 'linear', 0);

end
