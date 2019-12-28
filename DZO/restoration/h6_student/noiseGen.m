function [ noiseImage ] = noiseGen( dimension, noiseType, varargin )
% Generate "noise image" with the same size as the input image, according
% to the specified noiseType.
%
% Input:
%   dimension
%       EITHER:    [1x2] for gray-scale images ([1x3] for RGB, where the
%       third value is equal to "3"); array of values indicating the size
%       of the output image.
%       OR:        reference image, from wich the output image dimensions
%       shall be extracted.
%   noiseType [1x1 (char)] specifying the type of noise to be generated.
%       Possible values are:
%           'gaussian'      noise with gaussian distribution
%           'salt & pepper' impulse noise
%           'uniform'       noise with uniform distribution
%           'exponential'   noise with exponential distribution
%           'rayleigh'      noise with rayleigh distribution
%   varargin - variable number of arguments, depending on the used type of
%       noise. Evaluation of this input argument and thus initialization of
%       the parameters for individual distributions is already provided.
%   r - number of rows in the image
%   c - number of columns in the image
%   d - number of color channels in the image
%
% Output:
%   noiseImage (double) output image with pixel values generated from the
%       specified distribution.
%   
    extractDim = @(dim) feval(@(x) x{:}, num2cell(dim));
    if numel(dimension) <= 3
        if numel(dimension) <= 2
            [r, c] = extractDim(dimension);
            d = 1;
        else
            [r, c, d] = extractDim(dimension);
        end
    else
        [r, c, d] = size(dimension);
    end
    switch lower(noiseType)
        case 'gaussian'
            if nargin < 3
                gmean = 0;
            else
                gmean = varargin{1};
            end
            if nargin < 4
                gvariance = 0.05;
            else
                gvariance = varargin{2};
            end
            %% EXAMPLE
            % Gaussian noise with mean equal to "gmean" and variance equal
            % to "gvariance". See example "Random Numbers from Normal
            % Distribution with Specific Mean and Variance" from "randn"
            % help for more information.
            noiseImage = gmean + sqrt(gvariance) * squeeze(randn(r, c, d));
        case 'salt & pepper'
            if nargin < 3
                pSalt = 0.05;
            else
                pSalt = varargin{1};
            end
            if nargin < 4
                pPepper = 0.05;
            else
                pPepper = varargin{2};
            end
            assert(pSalt + pPepper <= 1, 'Sum of salt and pepper probabilities must not exceed 1');
            %% TODO
            % Generate noise image with approx. pPepper * (r * c * d)
            % values equal to -1 and approx. pSalt * (r * c * d) values
            % equal to 1.
            
            % Replace the next line with your code
            u_rand=squeeze(rand(r,c,d));
            u_rand(u_rand<=pPepper)=-1;
            u_rand(u_rand>=1-pSalt)=1;
            u_rand(u_rand>pPepper & u_rand<1-pSalt)=0;
            noiseImage = u_rand;
        case 'uniform'
            if nargin < 3
                low = -0.1;
            else
                low = varargin{1};
            end
            if nargin < 4
                high = 0.1;
            else
                high = varargin{2};
            end
            %% TODO
            % Generate image of uniform noise in range <low, high>

            % Replace the next line with your code
            noiseImage = low + (high-low).*squeeze(rand(r,c,d));
        case 'exponential'
            if nargin < 3
                lambda = 10;
            else
                lambda = varargin{1};
            end
            assert(lambda >= 0, 'Lambda must be positive.');
            %% TODO
            % Exponential noise image

            % Replace the next line with your code
            noiseImage = -1/lambda*log(1-squeeze(rand(r,c,d)));
        otherwise
            error('Unknown noise type');
    end
    
end

