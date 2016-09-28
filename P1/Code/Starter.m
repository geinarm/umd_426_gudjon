%% CMSC 426: Project 1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

no = 16;
ns = 2;
showImg = false;

%% Generate Oriented Gaussian Filter Bank
GFbank = gfbank(7,[1.5, 3], no);
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
Norient = 8;
Nscale = 2;
[HDl, HDr] = hdbank(7, [3.5, 7.5], Norient);
% Display all the GHalf-disk masks and save image as HDMasks_ImageName.png,
showImg = true;
if showImg
plotIdx = 1;
for r = 1:Nscale
    for c = 1:Norient
        subplot(Nscale,Norient*2, plotIdx), imshow(HDl{r,c});
        plotIdx = plotIdx +1;
        subplot(Nscale,Norient*2, plotIdx), imshow(HDr{r,c});
        plotIdx = plotIdx +1;        
    end
end
saveas(gcf, '../Images/HDMasks.png');
clf;
end

%%For each test image
%nImages = 10;
%for i = 1:nImages
%I = imread(['../TestImages/', int2str(i), '.jpg']);
%imgName = int2str(i);

I = imread('../TestImages/7.jpg');
I = rgb2gray(I);
I = im2double(I);
[height, width] = size(I);
%% Generate Texton Map
T = zeros(size(I, 1), size(I, 2), ns*no);
% Filter image using oriented gaussian filter bank
for k = 1:ns*no
	K = GFbank{k};
	Tk = imfilter(I, K);
	T(:, :, k) = Tk;
end

% Generate texture id's using K-means clustering
P = reshape(T, width*height, ns*no);
[Idx, C] = kmeans(P, 64);
T = reshape(Idx, height, width);

% Display texton map and save image as TextonMap_ImageName.png,
hold off;
imagesc(T), colormap(jet);
saveas(gcf, '../Images/TextonMap_ImageName.png');


%% Generate Texton Gradient (tg)
% Perform Chi-square calculation on Texton Map
num_bins = ns*no;
TG = zeros(height, width, numel(HDl));
eps = 1 * 10^-8;

for j = 1:numel(HDl)
    Kl = double(HDl{j}); %left disk kernel
    Kr = double(HDr{j}); %right disk kernel
    TGj=zeros(height, width);
    for i = 1:num_bins
        Bi = (T == i);  %mask for values in bin i
        G = imfilter(Bi, Kl);
        H = imfilter(Bi, Kr);
        chi_sqr = (G-H).^2 ./ (G+H+eps);
        TGj = TGj + 0.5*chi_sqr;
    end
    TG(:,:, j) = TGj;
end

% Display tg and save image as tg_ImageName.png,
TG = mean(TG, 3);
TG_norm = TG ./ max(max(TG));
imshow(TG_norm);
saveas(gcf, '../Images/tg/tg_ImageName.png');

%% Generate Brightness Map
% Perform brightness binning 
num_bins = 10;
B = ceil(I * num_bins);

% Display brightness map and save image as BrightnessMap_ImageName.png,
imagesc(B), colormap(jet);
saveas(gcf, '../Images/BrightnessMap/BrightnessMap_ImageName.png');

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
