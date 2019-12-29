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
[M,N]=size(x);
coord_mat = [reshape(x',1,M*N); reshape(y',1,M*N); ones(1, M*N)];
% TODO: Replace with your own implementation.
trans_to_center = [1 0 -mx; 0 1 -my; 0 0 1];
trans_back = [1 0 mx; 0 1 my; 0 0 1];
phi = deg2rad(t.r);
rot = [cos(phi), sin(phi), 0; -sin(phi) cos(phi), 0; 0, 0, 1];
trans = [1, 0, t.x; 0, 1, t.y; 0, 0, 1];
scale = [t.s, 0, 0; 0, t.s, 0; 0, 0, 1];
centered = trans_to_center*coord_mat;
rot_and_scaled = rot*scale*centered;
transform = trans_back*trans*rot_and_scaled;
xt = reshape(transform(1, :), N, M)';
yt = reshape(transform(2, :), N, M)';
end
