close all;
clear;

% load input image and split it to RGB channels
[img, rgb_orig] = load_rgb('images/prok3.jpg');

figure();
imshow(img);
title('RGB channels');

% simply overlay RGB channels to single image
img_nonreg = cat(3, rgb_orig{:});

figure();
imshow(img_nonreg);
title('Non-registered image');

% crop borders (10 % from each of four sides)
rgb_cropped = cell(1, 3);
for c = 1:3
	rgb_cropped{c} = crop_image(rgb_orig{c}, 0.1);
end

% channel to be used as image reference (1~red, 2~green, 3~blue)
ref_channel = 1;

% similarity of two images is given by negative mutual information
cost_func = @(im1, im2) -mutual_information(im1, im2);

% number of levels for hierarchical estimation of transformations
num_levels = 4;

% ranges of transformation parameters to be searched
t_rng = struct(...
	'x_low', -15, 'x_high', 15, 'x_step', 1, ...
	'y_low', -15, 'y_high', 15, 'y_step', 1, ...
	'r_low', -6, 'r_high', 6, 'r_step', 2, ...
	's_low', 1, 's_high', 1, 's_step', 0);

% for each channel estimate the optimum transformation to the reference channel
t_rgb = cell(1, 3);
for c = 1:3
	if c == ref_channel
		% identity transformation from the reference channel to itself
		t_rgb{c} = struct('x', 0, 'y', 0, 'r', 0, 's', 1);
	else
% 		 t_rgb{c} = estimate_transformation_exhaustive(rgb_cropped{c}, ...
% 			rgb_cropped{ref_channel}, cost_func, t_rng);
		t_rgb{c} = estimate_transformation_hierarchical(rgb_cropped{c}, ...
 			rgb_cropped{ref_channel}, cost_func, num_levels, t_rng);
	end
end

fprintf('Found transformations:');
celldisp(t_rgb);

% transform individual channels to obtain valid RGB image
img_reg = compose_rgb_image(rgb_orig, t_rgb, ref_channel);

figure();
imshow(img_reg);
title('Registered image');
