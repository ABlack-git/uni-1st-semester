function [ imageOut ] = imdegrade( imageIn, degradationType, varargin )
%NOISEGEN Summary of this function goes here
%   Detailed explanation goes here
    switch lower(degradationType)
        case 'noise'
            noise = varargin{1}; % noise image
            %% TODO
            % Add noise to the input image and clamp all image values
            % to the interval <0, 1>

            % Replace the next line with your code
            noised=noise+imageIn;
            imageOut = min(max(noised,0),1);
        case 'blur'
            if nargin < 3
                bsigma = 0.5;
            else
                bsigma = varargin{1};
            end
            if nargin < 4
                bsize = 2 * ceil(3 * [bsigma bsigma]) + 1;
            else
                bsize = varargin{2};
            end
            %% TODO
            % Blur the image using gaussian convolutional kernel
            % with size "bsize" and sigma "bsigma".  Use the function
            % imfilter to apply the filter.

            % Replace the next line with your code
            imageOut = imfilter(imageIn, fspecial('gaussian',bsize,bsigma), 'replicate');
        otherwise
            error('Unknown degradation method');
    end

end

