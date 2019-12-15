function img = compose_rgb_image(rgb, t_rgb, ref_channel)
% Compose image from RGB channels and corresponding transformations to the
% reference channel.
%
% Input:
%   rgb [1x3 cell of MxN double] cell array containg 2D matrices corresponding
%     to individual RGB channels to be composed to single image
%   t_rgb [1x3 cell of struct] transformations for individual channels
%   ref_channel [integer] number of the reference channel
%
% Output:
%   img [MxNx3 double] composed image

% Note: You should use the provided function 'sample_image' and the function
% 'transform_grid' implemented by yourself. Remember how to transform the image
% properly using the inverse transformation.

% TODO: Replace with your own implementation.
[h,w] = size(rgb{1});
[x,y] = meshgrid(1:w, 1:h);
img = zeros(h,w,3);
for i=1:3
    ti = inverse_transformation(t_rgb{i});
    [xt,yt] = transform_grid(x,y,ti);
    img(:,:,i) = sample_image(rgb{i}, xt, yt); 
end
