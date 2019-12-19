function t_inv = inverse_transformation(t)
% Create inverse transformation to the specified similarity transformation.
%
% Input:
%   t [struct] input transformation
%
% Output:
%   t_inv [struct] inverse transformation

t_inv = struct('x', -t.x, 'y', -t.y, 'r', -t.r, 's', 1 / t.s);

end
