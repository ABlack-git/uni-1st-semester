function vertex_cost = seam_cost_standard(img, mask_delete, mask_protect)
% Compute vertex costs for seam carving task. The vertex costs for
% individual pixels are based on the estimated image gradient.
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
%     on the estimated image gradient and binary masks specifying pixels
%     to be deleted and protected

% estimate partial derivatives and compute vertex_cost
g_img=rgb2gray(img);
dx=[1/8 0 -1/8;1/4,0,-1/4;1/8,0,-1/8];
dy=[1/8,1/4,1/8;0,0,0;-1/8,-1/4,-1/8];
vertex_cost= abs(conv2(g_img,dx,'same'))+abs(conv2(g_img, dy,'same'));
[h,w]=size(g_img);
vertex_num = h*w;
if exist('mask_delete', 'var')
    vertex_cost(mask_delete)=-2*vertex_num;
end

if exist('mask_protect', 'var')
   vertex_cost(mask_protect)=2*vertex_num;
end

end
