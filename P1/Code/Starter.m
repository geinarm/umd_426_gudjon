%% CMSC 426: Project 1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

no = 16;
ns = 2;

%% Generate Oriented Gaussian Filter Bank
GFbank = gfbank(7,[1.5, 3], no);
% Display all the Gaussian Filter Bank and save image as GaussianFB_ImageName.png,
for r = 1:ns
    for c = 1:no
        subplot(ns,16,(r-1)*no+c), imshow(GFbank{r,c});
    end
end
% use command saveas
saveas(gcf, '../Images/GaussianFB.png');

%% Generate Half-disk masks
Norient = 8;
Nscale = 2;
[HDl, HDr] = hdbank(7, [3.5, 7.5], Norient);
% Display all the GHalf-disk masks and save image as HDMasks_ImageName.png,
showImg = true;
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
[Idx, C] = kmeans(P, 64, 'MaxIter', 5);
T = reshape(Idx, height, width);

% Display texton map and save image as TextonMap_ImageName.png,
imagesc(T), colormap(jet);
saveas(gcf, '../Images/TextonMap/TextonMap_ImageName.png');


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
BG = zeros(height, width, numel(HDl));
eps = 1 * 10^-8;

for j = 1:numel(HDl)
    Kl = double(HDl{j}); %left disk kernel
    Kr = double(HDr{j}); %right disk kernel
    BGj=zeros(height, width);
    for i = 1:num_bins
        Bi = (B == i);  %mask for values in bin i
        G = imfilter(Bi, Kl);
        H = imfilter(Bi, Kr);
        chi_sqr = (G-H).^2 ./ (G+H+eps);
        BGj = BGj + 0.5*chi_sqr;
    end
    BG(:,:, j) = BGj;
end

% Display bg and save image as bg_ImageName.png,
BG = mean(BG, 3);
BG_norm = BG ./ max(max(BG));
imshow(BG_norm);
saveas(gcf, '../Images/bg/bg_ImageName.png');

%% Generate Color Map
% Perform color binning 
num_bins = 10;
C = ceil(hsv(:,:,1) * num_bins);
%imagesc(C), colormap(jet);

%% Generate Color Gradient (CG)
% Perform Chi-square calculation on Color Map
CG = zeros(height, width, numel(HDl));
eps = 1 * 10^-8;

for j = 1:numel(HDl)
    Kl = double(HDl{j}); %left disk kernel
    Kr = double(HDr{j}); %right disk kernel
    CGj=zeros(height, width);
    for i = 1:num_bins
        Bi = (C == i);  %mask for values in bin i
        G = imfilter(Bi, Kl);
        H = imfilter(Bi, Kr);
        chi_sqr = (G-H).^2 ./ (G+H+eps);
        CGj = CGj + 0.5*chi_sqr;
    end
    CG(:,:, j) = CGj;
end

% Display bg and save image as bg_ImageName.png,
CG = max(CG, [], 3);
CG_norm = CG ./ max(max(CG));
%imshow(CG_norm);

%saveas(gcf, '../Images/bg/bg_ImageName.png');
%% Get Sobel Baseline
% Uncomment the bottom line
% im is the grayscale version of the original image
% DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
im = I;
SobelPb = sobel_pb(im,0.08:0.02:.3);

% Display SobelPb and save image as SobelPb_ImageName.png
imshow(SobelPb);
saveas(gcf, '../Images/SobelPb/SobelPb_ImageName.png');

%% Get Canny Baseline
% Uncomment the bottom line
% im is the grayscale version of the original image
% DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
im = I;
CannyPb = canny_pb(im,0.1:0.1:.7,1:1:4);

% Display CannyPb and save image as CannyPb_ImageName.png
imshow(CannyPb);
saveas(gcf, '../Images/CannyPb/CannyPb_ImageName.png');


%% Combine responses to get pb-lite output
% A simple combination function would be: PbLite = (tg+gb).*(SobelPb+CannyPb)
PbLite = (TG+BG).*(SobelPb+CannyPb)
PbLite = PbLite ./ max(max(PbLite));

% Display PbLite and save image as PbLite_ImageName.png
imshow(PbLite);
saveas(gcf, '../Images/PbLite/PbLite_ImageName.png');
