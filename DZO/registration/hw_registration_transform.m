close all;
clear;

% choose on of the transformations for testing
% t = struct('x', 1.5, 'y', 0.5, 'r', 0, 's', 1);
% t = struct('x', 0, 'y', 0, 'r', 10, 's', 1);
% t = struct('x', 0, 'y', 0, 'r', 0, 's', 0.75);
t = struct('x', 2, 'y', 1, 'r', 10, 's', 0.75);

ti = inverse_transformation(t);

figure('Name', sprintf('x=%.1f, y=%.1f, r=%.1f, s=%.2f', t.x, t.y, t.r, t.s));

% create uniform grid of the specified size and transform it by the specifed
% transformation and its inverse
SIZE = 5;
[x, y] = meshgrid(1:SIZE, 1:SIZE);
[xt, yt] = transform_grid(x, y, t);
[xti, yti] = transform_grid(x, y, ti);

subplot(1, 3, 1);
hold on;
plot(x(1,1), y(1,1), 'bs-');
plot(xt(1,1), yt(1,1), 'ro-');
plot(xti(1,1), yti(1,1), 'gd-');
plot(x, y, 'bs-', x', y', 'bs-');
plot(xt, yt, 'ro-', xt', yt', 'ro-');
plot(xti, yti, 'gd-', xti', yti', 'gd-');
hold off;
axis image;
set(gca, 'Ydir', 'reverse');
legend({'Original', 'Transformed', 'Inverse'}, 'Location', 'SouthOutside');
title('Grid transformations');

% testing image
img = checkerboard(50);

subplot(1, 3, 2);
imshow(img);
axis on;
title('Original image');

% transform the image
[h, w] = size(img);
[x, y] = meshgrid(1:w, 1:h);
[xt, yt] = transform_grid(x, y, ti);
imgt = sample_image(img, xt, yt);

subplot(1, 3, 3);
imshow(imgt);
axis on;
title('Transformed image');
