function mi = mutual_information(img1, img2)
% Compute mutual information of two intensity images using 10 bins.
%
% Input:
%   img1 [MxN double] first image
%   img2 [MxN double] second image
%
% Output:
%   mi [double] mutual information

% Notes:
% - Use 10 bins to compute 1D histograms of image intensities, i.e.
%   bin_centers = linspace(0, 1, 10).
% - Use 10x10 bins to compute 2D histogram of intensity pairs from img1, img2.
% - Use functions N = hist(Y, X) and N = hist3(X, CTRS) to compute histograms.

% TODO: Replace with your own implementation.
mi = 1;

end
