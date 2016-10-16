I1 = imread('../Images/Set1/1.jpg');
I2 = imread('../Images/Set1/2.jpg');

G1 = rgb2gray(im2double(I1));
G2 = rgb2gray(im2double(I2));

I = {I1, I2};
G = {G1, G2};

[row1, col1, D1] = getCorners(G1, 300);
[row2, col2, D2] = getCorners(G2, 300);

[M1, M2] = matchFeatures([col1, row1], D1, [col2, row2], D2);

showMatched(I1, I2, M1, M2, 'montage');