function lut_out = constrained_lut(lut_in, max_slope, epsilon)
% function lut_out = constrained_lut(lut_in, max_slope, epsilon)
% 
% for an input LUT 'lut_in', this function computes 'lut_out'
% which:
%
% - has slope which is <= [max_slope * (1+epsilon)] everywhere
% - is close to lut_in
% - lut_in(end) = lut_out(end)
%
% The algorithm works by repeatedly redistributing mass from violating
% slopes to non-violating slopes. The iterations end when no slope 
% higher than [max_slope * (1+epsilon)]
%
% epsilon (>=0) does not have to be specified, in which case
%    epsilon = 0.01 is used as a default. 
%
% If epsilon=0 then the no slope is > max_slope. If epsilon is set
% to a small number (e.g. 0.01) then the algorithm produces almost
% the same result but in much smaller number of iterations. 

if nargin < 3
    epsilon = 0.01; 
end

%=======================================================

function slope = compute_slope(lut)
    N=length(lut);
    slope=zeros(1,N);
    dx=1/(N-1);
    slope(1)=lut(1)/dx;
    for i = 2:N
        slope(i)=(lut(i)-lut(i-1))/dx;
    end
end

function slope_out = limit_slope(slope_in, max_slope, epsilon)
    overshoot_idx=slope_in>max_slope*(1+epsilon);
    delta=sum(slope_in(overshoot_idx)-max_slope)/length(overshoot_idx);
    slope_in(overshoot_idx)=max_slope;
    slope_in(~overshoot_idx)=slope_in(~overshoot_idx)+delta;
    slope_out=slope_in;
end

function lut = slope_to_lut(slope, old_lut)
    N=length(old_lut);
    dx=1/(N-1);
    for i=(N-1):-1:1
        old_lut(i)=old_lut(i+1)-slope(i+1)*dx;
    end
    lut=old_lut;
end

function display_slope(slope)
    plot(linspace(0,1,length(slope)),slope);
    drawnow;
end

lut=lut_in;
slope=compute_slope(lut);
iter=0;
while ~isempty(find(slope>max_slope*(1+epsilon),1))
    slope=limit_slope(slope,max_slope,epsilon);
    lut=slope_to_lut(slope, lut);
    slope=compute_slope(lut);
    iter=iter+1;
    display(iter);
end
lut_out=lut;
% lut_out=slope_to_lut(compute_slope(lut_in),lut_in);
end
