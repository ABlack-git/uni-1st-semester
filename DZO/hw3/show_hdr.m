function fig = show_hdr(hdr)
%SHOW_HDR Show HDR image using logarithmic colormap.
%
% Input:
%   hdr [HxW or HxWx3 double] Reconstructed HDR image.

% combine RGB channels to single intensity channel
if ndims(hdr) == 3
    if any(isnan(hdr(:)))
        hdr = max(hdr, [], 3);
    else
        hdr = 0.3 * hdr(:,:,1) + 0.6 * hdr(:,:,2) + 0.1 * hdr(:,:,3);
    end
end

% convert to logarithmic scale
hdr = log10(hdr);

fig = figure('Name', 'HDR image');
imagesc(hdr);
axis image off;
colormap('jet');

% make colorbar logarithmic
y = get(colorbar, 'YTick');
colorbar('Ytick', y, 'YTickLabel', 10.^y);

end
