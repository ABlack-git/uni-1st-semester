im = get_image('images/CM1.jpg');
im_target = get_image('images/CM2.jpg'); 
Nbins = 256;

% get histograms of both images:
[bin_centers, h, cdf] = image_hist_cdf(im, Nbins);
[~, h_target, cdf_target] = image_hist_cdf(im_target, Nbins);

% match the histograms to find LUT:
lut = match_hists(h, h_target);

% apply LUT on the original image:
im_tr = transform_by_lut(im, lut);

[~, h_tr, cdf_tr] = image_hist_cdf(im_tr, Nbins);

figure();
subplot(2,3,1);
imshow(im);
title('original');
subplot(2,3,4);
plot(bin_centers, cdf);
title('CDF of original');
subplot(2,3,2);
imshow(im_target);
title('target');
subplot(2,3,5);
plot(bin_centers, cdf_target);
title('CDF of target');
subplot(2,3,3);
imshow(im_tr);
title('transformed orig.');
subplot(2,3,6);
plot(bin_centers, cdf_tr);
title('CDF of transformed orig.');
