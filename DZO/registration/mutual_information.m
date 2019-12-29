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
    function H = entropy(dist)
        dist = reshape(dist,1,[]);
        dist = dist(dist~=0);
        H=-sum(dist.*log(dist));
    end

bin_centers = linspace(0,1,10);
img1_col = reshape(img1, 1, [])';
img2_col = reshape(img2, 1, [])';
hist_1 = hist(img1_col, bin_centers);
hist_1 = hist_1/sum(hist_1);
hist_2 = hist(img2_col, bin_centers);
hist_2 = hist_2/sum(hist_2);
X=[img1_col, img2_col];
hist_mut = hist3(X, {bin_centers bin_centers});
hist_mut = hist_mut/sum(reshape(hist_mut,1,[]));
mi=entropy(hist_1)+entropy(hist_2)-entropy(hist_mut);

end
