I1 = imread('../Images/Set1/1.jpg');
I2 = imread('../Images/Set1/1.jpg');

rgb = im2double(I1);
gray = rgb2gray(I1);
C = cornermetric(gray);

[x,y] = anms(C, 300);

imshow(rgb); hold on;
plot(x, y, 'o', 'color', 'red', 'MarkerSize', 5);
hold off;