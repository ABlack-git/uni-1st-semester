function [path_cost, path_idx] = dp_path_optim(...
    vertex_cost, topleft_cost, top_cost, topright_cost)
% Dynamic programming optimization to find for each vertex of MxN graph the
% shortest vertical path starting in arbitrary first row vertex.
%
% Input:
%   vertex_cost [MxN (double)] vertex_cost(i,j) is cost of the vertex (i,j)
%   topleft_cost [MxN (double)] topleft_cost(i,j) is cost of the edge
%     from the vertex (i-1,j-1) to vertex (i,j)
%   top_cost [MxN (double)] top_cost(i,j) is cost of the edge
%     from the vertex (i-1,j) to vertex (i,j)
%   topright_cost [MxN (double)] topright_cost(i,j) is cost of the edge
%     from the vertex (i-1,j+1) to vertex (i,j)
%
% Output:
%   path_cost [MxN (double)] path_cost(i,j) is the total cost of the
%     shortest vertical path starting in arbitrary first row vertex (1,*)
%     and ending in the vertex (i,j)
%   path_idx [MxN (double)] path_idx(i,j) is the column index of vertex
%     preceding the vertex (i,j) on the shortest vertical path from
%     arbitrary first row vertex (1,*) to the vertex (i,j); path_idx(i,j)
%     for i > 1 is from {j-1,j,j+1}; path_idx(1,j) can be aribtrary

% add your code here
[M,N] = size(vertex_cost);
path_cost = zeros(M,N);
path_cost(1,:)=vertex_cost(1,:);
path_idx=zeros(M,N);
tmp=(1:N)-2;
%iterate over rows and compute costs per row
for i=2:M
    %here we look for cheapest edge that leads to target vertex 
    m = [Inf, path_cost(i-1,1:N-1) + topleft_cost(i,2:N);
        path_cost(i-1,:) + top_cost(i,:);
        path_cost(i-1,2:N) + topright_cost(i,1:N-1), Inf];
    [minVals, idx]=min(m);
    %set path cost and path_idx
    path_cost(i,:)=minVals+vertex_cost(i,:);
    path_idx(i,:) = tmp+idx;
end
end
