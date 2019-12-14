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
%   img [MxN double] composed image

% Note: You should use the provided function 'sample_image' and the function
% 'transform_grid' implemented by yourself. Remember how to transform the image
% properly using the inverse transformation.

% TODO: Replace with your own implementation.
img = repmat(rgb{1}, [1, 1, 3]);

end
