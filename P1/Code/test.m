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