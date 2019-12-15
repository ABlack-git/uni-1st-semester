function t_optim = estimate_transformation_hierarchical(img, img_ref, ...
	cost_func, num_levels, t_rng)
% Find the optimal transformation of the input image to the reference image
% by searching the space of all possible transformations hierarchically.
%
% Input:
%   img [MxN double] image for which transformation should estimated
%   img_ref [KxL double] reference image
%   cost_func [@(img1, img2) -> double] function evaluating similarity
%     of two images
%   num_levels [int] number of levels of the hierarchy
%   t_rng [struct] ranges of parameters to be searched
%
% Output:
%   t_optim [struct] estimated transformation

[h, w] = size(img);
t_optim = struct();

for level = num_levels:-1:1
	% multiplicative factor for the current level
	mult = 2^(level - 1);
 
	% coordinate grid for the current level
	x = linspace(1, w, ceil(w / mult));
	y = linspace(1, h, ceil(h / mult));
	[x, y] = meshgrid(x, y);
 
	% smooth both template and reference image
	img_smooth = smooth_image(img, mult);
	img_ref_smooth = smooth_image(img_ref, mult);
 
	% subsample the smoothed template image in the grid coordinates
	img_sampled = sample_image(img_smooth, x, y);
%     img_ref_sampled = sample_image(img_ref_smooth, x, y);
 
	% generate space of transformations for the current level using the optimum
	% transformation from the previous level
	t_space = transformation_space_hierarchical(t_optim, level, num_levels, t_rng);
    t_size = size(t_space,2);
    errors = zeros(1,t_size);
    for i=1:t_size
       [xt,yt] = transform_grid(x,y,t_space(i));
       img_t = sample_image(img_ref_smooth, xt,yt);
       errors(i) = cost_func(img_sampled,img_t);
    end
	% find the optimum transformation in t_space and assign it to t_optim
    [~, idx] = min(errors);
	t_optim = t_space(idx);
end

end
