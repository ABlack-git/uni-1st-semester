function lab_out = segmentation_hist(img, lab_in, num_bins, sigma)
% Segment the grayscale image based on various statistical properties
% of the foreground and background pixel intensities. The probability
% distributions of pixel intensities are modeled using histograms.
% The histograms are constructed from the initial partial labeling.
%
% Input:
%   img [HxW (double)] input grayscale image; intensities are from [0, 1]
%   lab_in [HxW (double)] initial labeling of pixels; label 0 denotes
%     unknown pixel, label 1 foregroung, label 2 background
%   num_bins [1x1 (double)] number of histogram bins
%   sigma [1x1 (double)] standard deviation of Gaussian used for histogram
%     smoothing
%
% Output:
%   lab_out [HxW (double)] output labeling of pixels; label 1 denotes
%     foregroung pixel, label 2 background

% TODO: Replace with your own implementation.
[H,W] = size(img);
img_f = img(lab_in == 1);
img_b = img(lab_in == 2);
f_pdf = hist_pdf(img_f, num_bins, sigma);
b_pdf = hist_pdf(img_b, num_bins, sigma);
prob_f=hist_prob(img, f_pdf);
prob_b=hist_prob(img, b_pdf);
f_idx = prob_f > prob_b;
b_idx = prob_b > prob_f;
lab_out=zeros(H,W);
lab_out(f_idx)=1;
lab_out(b_idx)=2;
end
