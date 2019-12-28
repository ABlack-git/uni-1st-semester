function [restoredImage, originalImage, artifactFFT, modifiedFFT] = artifact_removal1()
%% artefact removal using Fourier transform
% output
%  restoredImage    - restored image
%  originalImage    - original image (for showing in gui)
%  artifactFFT      - frequency domain of the image with artifact (for showing in gui)
%  modifiedFFT      - frequency domain of restored image (for showing in gui)
% The task is to find and remove the pattern of the artifacts Frequency
% domain using Fourier transform. The fourier transform and artifact
% removal should be implemented.

% load image and create artifact
im = imread('cameraman.tif');

[h, w] = size(im);
I= zeros(h, w);

I(1:4:h, 1:4:h) = 100;

originalImage = double(im)+double(I);
originalImage = originalImage/max(originalImage(:));

%%  IMPLEMENT ME
% Remove the next three lines after you implement your code
artifactFFT = zeros(1);
modifiedFFT = zeros(1);
restoredImage = originalImage;

% fourier transform

% modify Frequency domain to remove artifact

% restore image using inverse Fourier transform



% This will modify the FFT images so that they can by displayed as an image
modifiedFFT = log(abs(fftshift(modifiedFFT)));
artifactFFT = log(abs(fftshift(artifactFFT)));