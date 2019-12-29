function t_space = combine_parameters(x, y, r, s)
% Create transformation space as all possible combinations of parameters.

% preallocate space of transformations
space_size = numel(x) * numel(y) * numel(r) * numel(s);
t = struct('x', 0, 'y', 0, 'r', 0, 's', 1);
t_space = repmat(t, [1, space_size]);

% generate all combination of parameter values
i = 1;
for xi = 1:numel(x)
	for yi = 1:numel(y)
		for ri = 1:numel(r)
			for si = 1:numel(s)
				t_space(i) = struct('x', x(xi), 'y', y(yi), 'r', r(ri), 's', s(si));
				i = i + 1;
			end
		end
	end
end

end
