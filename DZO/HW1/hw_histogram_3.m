im = get_image('images/L.jpg'); 
Nbins = 256;

% show the original image:
showim_hist_cdf(im);

% apply histogram equalization: 
[bin_centers, h, cdf] = image_hist_cdf(im, Nbins);
lut_eq = hist_equalization(cdf);
im_eq = transform_by_lut(im, lut_eq);

% show the equalized image:
showim_hist_cdf(im_eq);

% alter the LUT by requiring limit on the slope:
max_slope = 2;
lut_eq_con = constrained_lut(lut_eq, max_slope);

% show it together with the unconstrained one:
figure();
plot(bin_centers, [lut_eq; lut_eq_con]);
ylim([0, 1]);
hlegend = legend('unconstrained slope', 'constrained slope');
set(hlegend, 'Loc', 'southeast');

% apply it:
im_eq_con = transform_by_lut(im, lut_eq_con);
showim_hist_cdf(im_eq_con);
