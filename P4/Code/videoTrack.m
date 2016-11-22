
% Load images if they have not been loaded yet
if (~exist('Imgs', 'var'))
    Imgs = readImages('../Data/Frames1/');
end
m = numel(Imgs);

I = im2double(Imgs{1});
G = rgb2gray(I);

[boxX, boxY, T] = getImgRect(G);
[tHeight, tWidth] = size(T);

[P1, D1] = getFeatures(T, 300);
imshow(I); hold on;
plot(P1(:,1)+boxX, P1(:, 2)+boxY, '+');
hold off;
pause()

for i = 2:m
    I2 = im2double(Imgs{i});
    G2 = rgb2gray(I2);
    T2 = G2(boxY:boxY+tHeight, boxX:boxX+tWidth);
    [P2, D2] = getFeatures(T2, 300);
    [M1, M2] = matchFeatures(P1, D1, P2, D2);

    %Filter matches
    Delta = M2-M1;
    dist = sum(Delta.^2, 2);
    idx_valid = dist <= (mean(dist));
    M1 = M1(idx_valid, :);
    M2 = M2(idx_valid, :);
    move = mean(M2-M1)
    boxX = floor(boxX + move(1));
    boxY = floor(boxY + move(2));
    
    imshow(I2); hold on;
    plot([M1(:,1)+boxX, M2(:,1)+boxX]', [M1(:,2)+boxY, M2(:,2)+boxY]');
    pause(0.3)
    
    P1 = P2;
    D1 = D2;
end