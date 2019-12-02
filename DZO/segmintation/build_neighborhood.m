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
pairs = [1:(h-1); 2:h];
dists = ones(1, h - 1);

    function get_straight_pairs(i)
    % Returns pairs for horizontal and vertical neighbours of node i 
    % that a are on the left from i and below i
    
    end

    function get_diagonal_neighbours(i)
    % Returns pairs of diagonal neighbours of i that are below i
    end

if neighborhood_type == 4
    M = 2*h*w - h - w;
    pairs = zeros(2,M);
    
elseif neighborhood_type == 8
    
else 
    error('Unsupported neighborhood type')
end
    

end
