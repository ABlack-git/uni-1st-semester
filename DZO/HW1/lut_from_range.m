function lut = lut_from_range(x_low, x_high, N)
% function lut = lut_from_range(x_low, x_high, N)
%
% creates LUT with N elements which: 
% 
% =0 for x<=x_low
% =1 for x>=x_high
% goes linearly from 0 to 1 between x_low and x_high

%=======================================================
% remove the following lines and implement the function.
% NOTE: use interp1 for implementing this function.

xq=linspace(0,1,N);
lower_xq = xq(xq<=x_low);
upper_xq= xq(xq>=x_high);
x = [lower_xq, upper_xq];
v = [zeros(size(lower_xq)),ones(size(upper_xq))];
lut = interp1(x,v,xq);