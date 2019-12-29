function pdf = hist_pdf(x, num_bins, sigma)
% Create histogram of input data samples having the specified number of
% bins, smooth by convolution with Gaussian and normalize to valid PDF.
%
% Input:
%   x [1xN (double)] N input data samples from the interval [0, 1]
%   num_bins [1x1 (double)] number of histogram bins
%   sigma [1x1 (double)] standard deviation of Gaussian used for histogram
%     smoothing
%
% Output:
%   pdf [1xnum_bins (double)] PDF estimated from smoothed and normalized
%     histogram of input data samples

% TODO: Replace with your own implementation.
% pdf = ones(1, num_bins) / num_bins;

histogram = hist(x, num_bins);
filter_size = ceil(5*sigma);
if mod(filter_size,2) == 0
    filter_size=filter_size+1;
end
gaus_filter = fspecial('gaussian', [1, filter_size], sigma);
conv_hist = conv(histogram, gaus_filter, 'same');
pdf = conv_hist/sum(conv_hist);

% NOTE: You are encouraged to use the following functions:
%   linspace(0, 1, b)
%   hist(x, xbins)
%   fspecial('gaussian', hsize, sigma); choose filter size as the smallest
%     odd integer bigger or equal to 5*sigma
%   conv(u, v, 'same')

end
