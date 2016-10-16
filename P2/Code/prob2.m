I = imread('../Images/Set3/2.jpg');
gray = rgb2gray(im2double(I));

[P, D] = getCorners(gray, 300);

imshow(I); hold on;
plot(P(:, 1), P(:, 2), 'o', 'color', 'red', 'MarkerSize', 5);
hold off;