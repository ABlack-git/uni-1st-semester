function [restoredImage, originalImage, artifactFFT, modifiedFFT] = artifact_removal2()
%% artefact removal using Fourier transform
% output
%  restoredImage    - restored image
%  originalImage    - original image (for showing in gui)
%  artifactFFT      - frequency domain of the image with artifact (for showing in gui)
%  modifiedFFT      - frequency domain of restored image (for showing in gui)
% The task is to find and remove artifact's frequencies in the Frequency
% domain using Fourier transform.
% Look out for symmetry in the Frequency domain!

% load image
originalImage = imread('images/freqdist.png');

%% IMPLEMENT ME
% Remove the next three lines after you implement your code
artifactFFT = zeros(1);
modifiedFFT = zeros(1);
restoredImage = originalImage;
% fourier transform

% create mask and modify Frequency domain to remove artifact using created
% mask

% restore image using inverse Fourier transform



% This will modify the FFT images so that they can by displayed as an image
artifactFFT = log(abs(fftshift(artifactFFT)));
modifiedFFT = log(abs(fftshift(modifiedFFT)));