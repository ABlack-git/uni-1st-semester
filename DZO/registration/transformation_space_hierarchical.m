function t_space = transformation_space_hierarchical(t, level, num_levels, t_rng)
% Generate space of transformations for one level of hieararchical estimator,
% using the optimum transformation from coarser level.
%
% Input:
%   t [struct] optimum transformation from the coarser level; it is not used
%     at the corsest level = num_levels
%   level [integer] current level for which the space should be generated
%   num_levels [integer] total number of levels
%   t_rng [struct] ranges of parameters to be searched
%
% Ouput:
%   t_space [cell of struct] generated space of transformations

mult = 2^(level-1);

if level == num_levels
	x = parameter_range(t_rng.x_low, t_rng.x_high, mult * t_rng.x_step);
	y = parameter_range(t_rng.y_low, t_rng.y_high, mult * t_rng.y_step);
	r = parameter_range(t_rng.r_low, t_rng.r_high, mult * t_rng.r_step);
	s = parameter_range(t_rng.s_low, t_rng.s_high, mult * t_rng.s_step);
else
	x = parameter_value(t.x, t_rng.x_step, mult);
	y = parameter_value(t.y, t_rng.y_step, mult);
	r = parameter_value(t.r, t_rng.r_step, mult);
	s = parameter_value(t.s, t_rng.s_step, mult);
end

t_space = combine_parameters(x, y, r, s);

end


function param_rng = parameter_value(value, step, mult)
% Generate range in the vicinity of the value.

if step == 0
	param_rng = value;
else
	param_rng = value + mult * step * [-1, 0, 1];
end

end
