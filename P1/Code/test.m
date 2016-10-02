no = 16;
ns = 2;

I = imread('../TestImages/7.jpg');
I = im2double(I);
%I = imgaussfilt(I, 3);
Lab = rgb2lab(I);
Hsv = rgb2hsv(I);
I = rgb2gray(I);
[height, width] = size(I);
imshow(I);

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
clf

K = GFbank{2,1};
Tk = imfilter(I, K, 'replicate');
Tk = Tk ./ max(max(Tk));
imshow(Tk);