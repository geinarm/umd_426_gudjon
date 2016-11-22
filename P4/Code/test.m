
I = Imgs{1};
imshow(I); hold on;
[x,y] = ginput(2);
hold off;

minX = min(x);
maxX = max(x);
minY = min(y);
maxY = max(y);

G = im2double(rgb2gray(I));
T = G(minY:maxY, minX:maxX);

mask = zeros(size(T));
mask(25:end-25,25:end-25) = 1;


%bw = activecontour(T,mask,300);
%bw = activecontour(T, mask, 10, 'edge');
%bw = activecontour(T, mask, 200, 'Chan-Vese');

[FX,FY] = gradient(T);
%bw = edge(T,'sobel',0.01);

imshow(FX);
%imshow(bw);