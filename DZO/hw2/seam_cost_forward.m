function [vertex_cost, topleft_cost, top_cost, topright_cost] = ...
    seam_cost_forward(img, mask_delete, mask_protect)
% Compute vertex costs for seam carving task. The edge costs are based on
% potentially carved pixels. The vertex costs ensure deletion or protection
% of the desired pixels.
%
% Input:
%   img [MxNx3 (double)] input RGB image
%   mask_delete [MxN (logical)] matrix specyfing pixels for which vertex
%     cost must be low enough to ensure their priority carving
%   mask_protect [MxN (logical)] matrix specyfing pixels for which vertex
%     cost must be low enough to ensure their priority carving
%
% Output:
%   vertex_cost [MxN (double)] vertex costs for individual pixels based on
%     the deletion and protection masks
%   topleft_cost [MxN (double)] costs of top-left edges
%   top_cost [MxN (double)] costs of top edges
%   topright_cost [MxN (double)] costs of top-right edges

[h, w, ~] = size(img);

% add code for computing topleft_cost, top_cost and topright_cost
i=2:h;
j=2:w-1;
topleft_cost=zeros(h,w);
topleft_cost(i,2:w)=[sqrt(sum((img(i,j+1,:)-img(i,j-1,:)).^2,3))+sqrt(sum((img(i-1,j,:)-img(i,j-1,:)).^2,3)) inf(h-1,1)];
top_cost=zeros(h,w);
top_cost(i,:)=[inf(h-1,1) sqrt(sum((img(i,j+1,:)-img(i,j-1,:)).^2,3)) inf(h-1,1)];
topright_cost=zeros(h,w);
topright_cost(i,1:w-1)=[inf(h-1,1) sqrt(sum((img(i,j+1,:)-img(i,j-1,:)).^2,3))+sqrt(sum((img(i-1,j,:)-img(i,j+1,:)).^2,3))];
% default vertex_cost is zero
vertex_cost = zeros(h, w);

if exist('mask_delete', 'var')
    vertex_cost(mask_delete)=-2*sqrt(3)*(h*w-1);
end

if exist('mask_protect', 'var')
    vertex_cost(mask_protect)=2*sqrt(3)*(h*w-1);
end

end
