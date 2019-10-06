function inv_lut = inverse_lut(lut)
% function inv_lut = inverse_lut(lut)
%
% returns the inverse of an input LUT.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove these lines and implement the function: 
[~,idx,~]=unique(lut);
intensity=linspace(min(lut(idx)),max(lut(idx)),length(lut));
inv_lut=interp1(lut(idx),intensity(idx), intensity);
