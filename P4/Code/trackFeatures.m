function [ P, V ] = trackFeatures( I1, I2, M1 )
%I1 is the first frame
%I2 is the second frame
%M1 is a binary mask, features outside the mask are ignored

bb = (regionprops(uint8(M1),'BoundingBox'));
bb = bb.BoundingBox;
XMin = floor(bb(1)) -10;
XMax = ceil(XMin + bb(3)) +20;
YMin = floor(bb(2)) -10;
YMax = ceil(YMin + bb(4)) +20;
[height, width] = size(M1);

%M2 = false(size(M1));
%M2(YMin:YMax, XMin:XMax) = 1;

G1 = rgb2gray(im2double(I1));
G2 = rgb2gray(im2double(I2));
G1_trim = G1(YMin:YMax, XMin:XMax);
G2_trim = G2(YMin:YMax, XMin:XMax);
M1_trim = M1(YMin:YMax, XMin:XMax);
G1_trim(~M1_trim) = 0;
%G1(~M1) = 0;
%G2(~M2) = 0;

[P1, D1] = getFeatures(G1_trim, 300);
[P2, D2] = getFeatures(G2_trim, 300);
%[P1, D1] = getCorners(G1_trim, 100);
%[P2, D2] = getCorners(G2_trim, 100);
P1(:,1) = P1(:,1) + XMin;
P1(:,2) = P1(:,2) + YMin;
P2(:,1) = P2(:,1) + XMin;
P2(:,2) = P2(:,2) + YMin;

[Pm1, Pm2] = matchFeatures(P1, D1, P2, D2);
V = Pm2 - Pm1;
D = sum(V.^2, 2);

filt = D<50;

V = V(filt, :);
Pm1 = Pm1(filt, :);
Pm2 = Pm2(filt, :);
P = Pm1;

%Pm2_v = Pm2;
%Pm2_v(:,1) = Pm2_v(:,1)+width;

%{
C = imfuse(G1,G2);
imshow(C); hold on;
plot(Pm1(:,1), Pm1(:,2), '+', 'Color', 'red');
plot(Pm2(:,1), Pm2(:,2), '+', 'Color', 'blue');
plot([Pm1(:,1),Pm2(:,1)]', [Pm1(:,2),Pm2(:,2)]', '-');
pause
hold off;
%}

end

