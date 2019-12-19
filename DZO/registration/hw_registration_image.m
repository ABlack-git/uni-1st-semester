close all;
clear;

img_ref = im2double(imread('images/aerial.png'));

% number of levels for hierarchical estimation of transformation
num_levels = 4;

% size of the patch to be cut from the refence image
h = 100;
w = 100;

% transformation of the reference image to be used to obtain the patch
t = struct('x', 160, 'y', 165, 'r', 30, 's', 1);

% take window of the specified size from the reference image and transform it
[x, y] = meshgrid(1:w, 1:h);
[xt, yt] = transform_grid(x, y, t);
img = sample_image(img_ref, xt, yt);

% now try to estimate the transformation by searching the certain space
t_rng = struct(...
	'x_low', t.x - 10, 'x_high', t.x + 10, 'x_step', 1, ...
	'y_low', t.y - 10, 'y_high', t.y + 10, 'y_step', 1, ...
	'r_low', t.r - 4, 'r_high', t.r + 4, 'r_step', 2, ...
	's_low', t.s, 's_high', t.s, 's_step', 0);

t = estimate_transformation_exhaustive(img, img_ref, ...
	@sum_of_squared_differences, t_rng);
% t = estimate_transformation_hierarchical(img, img_ref, ...
% 	@sum_of_squared_differences, num_levels, t_rng);

fprintf('Found transformation:');
display(t);

figure();

subplot(2, 2, 1);
imshow(img_ref);
axis on;
title('Reference image "img\_ref"');

subplot(2, 2, 2);
imshow(img);
axis on;
title('Template image "img"');

[xw, yh] = meshgrid([1 w/2 w], [1 h/2 h]);
[xwt, yht] = transform_grid(xw, yh, t);

subplot(2, 2, 3);
imshow(img_ref);
hold on;
plot(xwt, yht, 'r-', xwt', yht', 'r-');
hold off;
axis on;
title('Estimated transformation');

[xt, yt] = transform_grid(x, y, t);
img_ref_t = sample_image(img_ref, xt, yt);

subplot(2, 2, 4);
imshow(img_ref_t);
axis on;
title('Subimage "img\_ref\_t"');
