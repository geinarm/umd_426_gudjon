%% CMSC 426: Project 1 Starter Code
% Written by: Nitin J. Sanket (nitinsan@terpmail.umd.edu)
% PhD in CS Student at University of Maryland, College Park

%% Generate Oriented Gaussian Filter Bank
gf_s = [1 2 4];
gf_r = (2*pi/8).*(1:8);
GFbank = gfbank(gf_s, gf_r);
% Display all the Gaussian Filter Bank and save image as GaussianFB_ImageName.png,
plotIdx = 1;
for r = 1:numel(gf_s)
    for c = 1:numel(gf_r)
        % Normalize filter for display
        gf_i = GFbank{r,c};
        gf_i = gf_i * 1/(range(gf_i(:))) + 0.5;
        subplot(numel(gf_s), numel(gf_r), plotIdx), imshow(gf_i);
        plotIdx = plotIdx +1;
    end
end
% use command saveas
saveas(gcf, '../Images/GaussianFB.png');
clf;

%% Generate Half-disk masks
hd_radius = [2 5];
hd_deg = [45:45:180];
[HDl, HDr] = hdbank(hd_radius, hd_deg);
% Display all the GHalf-disk masks and save image as HDMasks_ImageName.png,
showImg = true;
plotIdx = 1;
for r = 1:numel(hd_radius)
    for c = 1:numel(hd_deg)
        subplot(numel(hd_radius), numel(hd_deg)*2, plotIdx), imshow(HDl{r,c});
        plotIdx = plotIdx +1;
        subplot(numel(hd_radius), numel(hd_deg)*2, plotIdx), imshow(HDr{r,c});
        plotIdx = plotIdx +1;        
    end
end
saveas(gcf, '../Images/HDMasks.png');
clf;

%%For each test image
num_Img = 3;
for i = 1:num_Img
    imgName = int2str(i);
    disp(['Image ', imgName]);

    I = imread(['../TestImages/', int2str(i), '.jpg']);
    I = im2double(I);
    I = imgaussfilt(I, 2);
    Lab = rgb2lab(I);
    Lab_norm = (Lab + abs(min(Lab(:)))) ./ range(Lab(:));
    Hsv = rgb2hsv(I);
    rgb = I;
    gray = rgb2gray(I);
    [height, width] = size(gray);

    %% Generate Texton Map
    T = zeros(height, width, numel(GFbank));
    % Filter image using oriented gaussian filter bank
    for k = 1:numel(GFbank)
        K = GFbank{k};
        Tk = imfilter(gray, K, 'replicate');
        T(:, :, k) = Tk;
    end

    %Save gauss map
    gauss_map = max(abs(T), [], 3);
    gauss_map = gauss_map + abs(min(gauss_map(:)));
    gauss_map = gauss_map ./ range(gauss_map(:));
    imshow(gauss_map);
    saveas(gcf, ['../Images/GaussMap/',imgName,'.png']);
    
    % Generate texture id's using K-means clustering
    P = reshape(T, width*height, numel(GFbank));
    [Idx, ~] = kmeans(P, 64);
    texton_map = reshape(Idx, height, width);

    % Display texton map and save image as TextonMap_ImageName.png,
    imagesc(texton_map), colormap(jet);
    saveas(gcf, ['../Images/TextonMap/',imgName,'.png']);

    %% Generate Texton Gradient (tg)
    % Perform Chi-square calculation on Texton Map
    num_bins = numel(GFbank);
    TG = chiDist(HDl, HDr, 1:num_bins, texton_map);

    % Display tg and save image as tg_ImageName.png,
    TG = mean(TG, 3);
    TG_norm = TG ./ max(TG(:));
    imshow(TG_norm);
    saveas(gcf, ['../Images/tg/',imgName,'.png']);

    %% Generate Brightness Map
    % Perform brightness binning 
    num_bins = 15;
    B = ceil(Lab_norm(:,:,1) * num_bins);

    % Display brightness map and save image as BrightnessMap_ImageName.png,
    imagesc(B), colormap(jet);
    saveas(gcf, ['../Images/BrightnessMap/',imgName,'.png']);

    %% Generate Brightness Gradient (bg)
    % Perform Chi-square calculation on Brightness Map
    BG = chiDist(HDl, HDr, 1:num_bins, B);

    % Display bg and save image as bg_ImageName.png,
    BG = mean(BG, 3);
    BG_norm = BG ./ max(max(BG));
    imshow(BG_norm);
    saveas(gcf, ['../Images/bg/',imgName,'.png']);

    %% Generate Color Map
    % Perform color binning 
    num_bins = 15;
    %C1 = ceil(Lab_norm(:,:,2) * num_bins);
    %C2 = ceil(Lab_norm(:,:,3) * num_bins);
    
    %%Color Map by running kmeans on color space
    P = reshape(Hsv, width*height, 3);
    [Idx, ~] = kmeans(P, num_bins);
    color_map = reshape(Idx, height, width);
    imagesc(color_map), colormap(jet);
    saveas(gcf, ['../Images/ColorMap/',imgName,'.png']);
    
    %% Generate Color Gradient (CG)
    % Perform Chi-square calculation on Color Map
    CG = chiDist(HDl, HDr, 1:num_bins, color_map);
    %CG1 = chiDist(HDl, HDr, 1:num_bins, C1);
    %CG2 = chiDist(HDl, HDr, 1:num_bins, C2);

    % Display cg and save image as cg_ImageName.png,
    CG = mean(CG, 3);
    CG_norm = CG ./ max(max(CG));
    imshow(CG_norm);
    saveas(gcf, ['../Images/cg/',imgName,'.png']);

    %% Get Sobel Baseline
    % Uncomment the bottom line
    % im is the grayscale version of the original image
    % DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
    SobelPb = sobel_pb(gray,0.08:0.02:.3);

    % Display SobelPb and save image as SobelPb_ImageName.png
    imshow(SobelPb);
    saveas(gcf, ['../Images/SobelPb/',imgName,'.png']);

    %% Get Canny Baseline
    % Uncomment the bottom line
    % im is the grayscale version of the original image
    % DO NOT CHANGE THE VALUES IN THE FOLLOWING FUNCTION!!
    CannyPb = canny_pb(gray,0.1:0.1:.7,1:1:4);

    % Display CannyPb and save image as CannyPb_ImageName.png
    imshow(CannyPb);
    saveas(gcf, ['../Images/CannyPb/',imgName,'.png']);


    %% Combine responses to get pb-lite output
    MyPB = (TG+BG+CG);
    MyPB = MyPB ./ range(MyPB(:));
    %PbLite = PbLite ./ max(max(PbLite));

    % Display PbLite and save image as PbLite_ImageName.png
    imshow(MyPB);
    saveas(gcf, ['../Images/PbLite/',imgName,'.png']);
    
    imwrite(im2bw(MyPB, 0.5),['../data/mypb/',imgName,'.png']);

end