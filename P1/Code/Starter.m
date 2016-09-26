%% CMSC 426: Project 1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

%% Generate Oriented Gaussian Filter Bank
% Display all the Gaussian Filter Bank and save image as GaussianFB_ImageName.png,
% use command saveas

k = 20;
sigma = 1.0;

G = zeros(k);
dx = zeros(k);
dy = zeros(k);
cx = floor(k/2);
cy = floor(k/2);

%for r = 1:k
%	for c = 1:k
%		G(c,r) = exp(-((c-cx)^2+(r-cy)^2)/(2*sigma^2));
%		dx(c,r) = -(c-cx)/sigma^2;
%		dy(c,r) = -(r-cy)/sigma^2;
%	end
%end

x = -5:0.1:5;
mu = 0;
%
G = exp(-(x-mu).^2/(2 * sigma^2));
dG = (mu-x) .* exp(-(x-mu).^2/(2 * sigma^2)) / sigma^2;

%% Generate Half-disk masks
% Display all the GHalf-disk masks and save image as HDMasks_ImageName.png,
% use command saveas

%% Generate Texton Map
% Filter image using oriented gaussian filter bank

% Generate texture id's using K-means clustering

% Display texton map and save image as TextonMap_ImageName.png,
% use command saveas

%% Generate Texton Gradient (tg)
% Perform Chi-square calculation on Texton Map

% Display tg and save image as tg_ImageName.png,
% use command saveas

%% Generate Brightness Map
% Perform brightness binning 

% Display brightness map and save image as BrightnessMap_ImageName.png,
% use command saveas

%% Generate Brightness Gradient (bg)
% Perform Chi-square calculation on Brightness Map

% Display bg and save image as bg_ImageName.png,
% use command saveas

%% Get Sobel Baseline
% Uncomment the bottom line
% im is the grayscale version of the original image
% DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
% SobelPb = sobel_pb(im,0.08:0.02:.3);

% Display SobelPb and save image as SobelPb_ImageName.png
% use command saveas

%% Get Canny Baseline
% Uncomment the bottom line
% im is the grayscale version of the original image
% DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
% CannyPb = canny_pb(im,0.1:0.1:.7,1:1:4);

% Display CannyPb and save image as CannyPb_ImageName.png
% use command saveas

%% Combine responses to get pb-lite output
% A simple combination function would be: PbLite = (tg+gb).*(SobelPb+CannyPb)

% Display PbLite and save image as PbLite_ImageName.png
% use command saveas



