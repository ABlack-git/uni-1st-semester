function [xt, yt] = transform_grid(x, y, t)
% Transform MxN grid of 2D points by translation, rotation around their center
% and scaling. It is performed by translating the points to their center,
% scaling them, rotating around the origin, translating them back and finally
% translating them as required.
%
% Input:
%   x [MxN double] x coordinates of points forming the grid
%   y [MxN double] y coordinates of points forming the grid
%   t [struct] transformation to be applied
%
% Output:
%   xt [MxN double] transformed x coordinates
%   yt [MxN double] transformed y coordinates

% Notes:
% - Build transformation matrix by multiplying matrices of the elementary
%   transformations. Create 3x(M*N) matrix of homogenous coordinates. Apply
%   the transformation to all coordinates at once.
% - The rotation angle t.r is in degrees.

% center of the grid to rotate around
mx = mean(x(:));
my = mean(y(:));

% TODO: Replace with your own implementation.
xt = x;
yt = y;

end
