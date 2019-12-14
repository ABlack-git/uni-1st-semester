function param_rng = parameter_range(low, high, step)
% Generate range from low to high using at most the specified step.

if low == high
	param_rng = low;
else
	% use at most the specified step and odd number of steps
	num_steps = ceil((high - low) / step) + 1;
	if mod(num_steps, 2) == 0
		num_steps = num_steps + 1;
	end
	param_rng = linspace(low, high, num_steps);
end

end
