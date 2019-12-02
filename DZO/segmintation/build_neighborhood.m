function [pairs, dists] = build_neighborhood(h, w, neighborhood_type)
% Build 4-connected or 8-connected neighborhood of pixels and compute
% their spatial distances. The pairs of neighboring pixels are determined
% by pairs of their 1D indices in the image grid.
%
% Input:
%   h [1x1 (double)] image height
%   w [1x1 (double)] image width
%   neighborhood_type [1x1 (double)] type of the neighborhood; it is equal
%     to 4 for 4-connected neighborhood (only vertically or horizontally
%     adjacent pixels are neighbors) or it is equal to 8 for 8-connected
%     neigborhood (also diagonally adjacent pixels are neigbhors)
%
% Output:
%   pairs [2xM (double)] M pairs of 1D indices of neighboring pixels; each
%     index is a number from the set {1, 2, ..., h * w} using the standard
%     Matlab order (all rows of the first column, second column, ...); each
%     pair of neighbors should be included only once, independently on
%     their order, i.e. if pixels t and s are neighbors then pairs should
%     include either the column [t;s] or [s;t], never both of them
%   dists [1xM (double)] M spatial Euclidean distances of neighboring
%     pixels; pair of vertically or horizontally adjacent pixels has
%     distance 1, diagonally adjacent pixels sqrt(2)

% TODO: Replace with your own implementation.

% vertical neighbors from the first column

function filter = get_filter(r,c, h, N)
    indices = (c-1)*h+(r-1)+1;
    filter = ones(1,N);
    filter(indices)= 0;
    filter = logical(filter);
end

N = h*w;
right_filter = get_filter(1:h, w, h, N);
bot_filter = get_filter(h,1:w,h, N);
left_filter = get_filter(1:h, 1, h, N);

right_edges = [1:N; zeros(1,N)];
bot_edges = [1:N; zeros(1,N)];

right_edges = right_edges(:,right_filter);
bot_edges = bot_edges(:,bot_filter);

right_edges(2,:) = right_edges(1,:) + h;
bot_edges(2,:) = bot_edges(1,:) + 1;

pairs = [right_edges, bot_edges];
dists = ones(1, size(pairs,2));
if neighborhood_type == 4
   return;
end

left_diag_e = [1:N; zeros(1,N)];
right_diag_e = [1:N; zeros(1,N)];

left_diag_e = left_diag_e(:, bot_filter & left_filter);
right_diag_e = right_diag_e(:, bot_filter & right_filter);

left_diag_e(2,:) = left_diag_e(1,:) - h + 1;
right_diag_e(2,:) = right_diag_e(1,:) + h +1;

p2 = [left_diag_e, right_diag_e];
d2 = ones(1, size(p2,2))*sqrt(2);

pairs = [pairs, p2];
dists = [dists,d2];



end
