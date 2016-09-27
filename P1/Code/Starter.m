%% CMSC 426: Project 1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

no = 16;
ns = 2;
showImg = false;

%% Generate Oriented Gaussian Filter Bank
GFbank = gfbank([3, 5], no);
% Display all the Gaussian Filter Bank and save image as GaussianFB_ImageName.png,
if showImg
for r = 1:ns
    for c = 1:no
        subplot(ns,16,(r-1)*no+c), imshow(GFbank{r,c});
    end
end
% use command saveas
saveas(gcf, '../Images/GaussianFB.png');
end

%% Generate Half-disk masks
HDbank = hdbank([3, 5], no);
% Display all the GHalf-disk masks and save image as HDMasks_ImageName.png,
if showImg
for r = 1:ns
    for c = 1:no
        subplot(ns,16,(r-1)*no+c), imshow(HDbank{r,c});
    end
end
% use command saveas
saveas(gcf, '../Images/HDMasks.png');
end

% use command saveas

%%For each test image
%nImages = 10;
%for i = 1:nImages
%I = imread(['../TestImages/', int2str(i), '.jpg']);
%imgName = int2str(i);

I = imread('../TestImages/1.jpg');
I = rgb2gray(I);
I = im2double(I);
%% Generate Texton Map
T = zeros(size(I, 1), size(I, 2), ns*no);
% Filter image using oriented gaussian filter bank
for k = 1:ns*no
	K = GFbank{k};
	Tk = imfilter(I, K);
	T(:, :, k) = Tk;
end

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
