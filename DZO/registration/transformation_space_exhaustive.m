function t_space = transformation_space_exhaustive(t_rng)
% Generate space of transformations for exhaustive search.
%
% Input:
%   t_rng [struct] ranges of parameters to be searched
%
% Ouput:
%   t_space [cell of struct] generated space of transformations

x = parameter_range(t_rng.x_low, t_rng.x_high, t_rng.x_step);
y = parameter_range(t_rng.y_low, t_rng.y_high, t_rng.y_step);
r = parameter_range(t_rng.r_low, t_rng.r_high, t_rng.r_step);
s = parameter_range(t_rng.s_low, t_rng.s_high, t_rng.s_step);

t_space = combine_parameters(x, y, r, s);

end
