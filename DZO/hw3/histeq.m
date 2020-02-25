function x_eq = histeq(x)
%HISTEQ Histogram equalization
%
% x_eq = histeq(x)
%
% Input:
%   x [any double] Array of values.
%
% Output:
%   x_eq [size(x) double] Array with values x_eq(i) = CDF(x(i)),
%     with CDF approximated by the normalized cumulative histogram of x.
%     The unique values of x are used as bin centers.
%

[c, ~, ic] = unique(x);
h = hist(x(:), c);
h = cumsum(h);
h = h ./ h(end);
x_eq = reshape(h(ic), size(x));

end
