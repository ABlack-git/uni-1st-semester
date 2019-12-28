function [modifiedImage, inputFFT, outputFFT] = HLpassFilter(im, s, lowHIGH)
%% artefact removal using Fourier transform
% input:
%  im               - input image
%  s                - size (perimeter) of the high pass filter
% output
%  modifiedImage    - modifed image
%  inputFFT         - frequency domain of original image (for showing in gui)
%  outputFFT        - frequency domain of modified image (for showing in gui)
% The task is to implement high pass and low pass filter on the image in Frequency domain
% The mask for filter need to be created and appplied in Frequency domain.
% Look out for shift in display of Frequency domain.

% Compute the radius of the filter (to round it to an even number)
if s > 3
    filterRadius = floor(s/4) * 2;
else
    filterRadius = 1;
end

H=fspecial('disk', filterRadius);
filterSize = filterRadius * 2 + 1;
c_row = ceil(size(im,1)/2);
c_col = ceil(size(im,2)/2);
if strcmpi(lowHIGH, 'low')
    mask=zeros(size(im));
    H(H~=0)=1;
    
elseif strcmpi(lowHIGH, 'high')
    mask=ones(size(im));
    H(H==0)=1;
    H(H~=1)=0;
end
row_left=c_row-filterRadius+1;
col_top = c_col-filterRadius+1;
mask(row_left:row_left+filterSize-1, col_top:col_top+filterSize-1)=H;
inputFFT = fft2(im);
outputFFT = ifftshift(fftshift(inputFFT).*mask);
modifiedImage=ifft2(outputFFT);
inputFFT = log(abs(fftshift(inputFFT)));
outputFFT = log(abs(fftshift(outputFFT)));
