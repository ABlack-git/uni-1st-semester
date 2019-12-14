function t_optim = estimate_transformation_exhaustive(img, img_ref, ...
	cost_func, t_rng)
% Find the optimal transformation of the input image to the reference image
% by searching the space of all possible transformations exhaustively.
%
% Input:
%   img [MxN double] image for which transformation should estimated
%   img_ref [KxL double] reference image
%   cost_func [@(img1, img2) -> double] function evaluating similarity
%     of two images
%   t_rng [struct] ranges of parameters to be searched
%
% Output:
%   t_optim [struct] estimated transformation

% generate space of all transformations to be searched
t_space = transformation_space_exhaustive(t_rng);

% TODO: Replace with your own implementation.
t_optim = t_space(1);

end
