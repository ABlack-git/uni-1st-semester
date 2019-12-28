function [ restoredImage ] = imrestore( degradedImage, restorationType, varargin )
%IMRESTORE Summary of this function goes here
%   Detailed explanation goes here
num_channels = size(degradedImage,3);
    switch lower(restorationType)
        case 'mean'
            if nargin < 3
                hsize = [3 3];
            else
                hsize = varargin{1};
                if numel(hsize) < 2
                    hsize = [hsize hsize];
                end
            end
            %% EXAMPLE
            % Mean filter
            restoredImage = imfilter(degradedImage, fspecial('average', hsize));
        case 'median'
            if nargin < 3
                hsize = [3 3];
            else
                hsize = varargin{1};
                if numel(hsize) < 2
                    hsize = [hsize hsize];
                end
            end
            %% TODO
            % Median filter
            % Use the function medfilt2 with neighborhood "hsize". Remember
            % that degradedImage can be either gray-scale or RGB image. 
            
            % Replace the next line with your code
            restoredImage = zeros(size(degradedImage));
            for i=1:num_channels
                restoredImage(:,:,i) = medfilt2(degradedImage, hsize);
            end
        case 'min'
            if nargin < 3
                hsize = [3 3];
            else
                hsize = varargin{1};
                if numel(hsize) < 2
                    hsize = [hsize hsize];
                end
            end
            %% TODO
            % Min filter
            % Use imerode with neighborhood of size "hsize". Remember
            % that degradedImage can be either gray-scale or RGB image. 

            % Replace the next line with your code
            restoredImage = zeros(size(degradedImage));
            for i=1:num_channels
                restoredImage(:,:,i)=imerode(degradedImage(:,:,i),ones(hsize));
            end
        case 'max'
            if nargin < 3
                hsize = [3 3];
            else
                hsize = varargin{1};
                if numel(hsize) < 2
                    hsize = [hsize hsize];
                end
            end
            %% TODO
            % Max filter
            % Use imdilate with neighborhood of size "hsize". Remember
            % that degradedImage can be either gray-scale or RGB image. 

            % Replace the next line with your code
            restoredImage = zeros(size(degradedImage));
            for i=1:num_channels
                restoredImage(:,:,i)=imdilate(degradedImage(:,:,i),ones(hsize));
            end
        case 'sharpen'
            if nargin < 3
                alpha = 0.5;    % sharpening strength
            else
                alpha = varargin{1};
            end
            if nargin < 4
                sigma = 5;
            else
                sigma = varargin{2};
            end
            %% TODO
            % Sharpening use the function imfilter with gaussian kernel
            % with 'sigma'. Parameter alpha controls the strength of
            % sharpening.

            % Replace the next line with your code
            hsize = 2*ceil(3*[sigma,sigma])+1;
            blured = imfilter(degradedImage, fspecial('gaussian', hsize,sigma), 'replicate');
            unsharp=degradedImage-blured;
            restoredImage = degradedImage+alpha*unsharp;
        otherwise
            error('Unknown restoration method');
    end

end

