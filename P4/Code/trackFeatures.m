function [ P, V ] = trackFeatures( I1, I2, M1 )
%I1 is the first frame
%I2 is the second frame
%M1 is a binary mask, features outside the mask are ignored

G1 = rgb2gray(im2double(I1));
G2 = rgb2gray(im2double(I2));

[P1, D1] = getFeatures(G1, 300);
[P2, D2] = getFeatures(G2, 300);

[Pm1, Pm2] = matchFeatures(P1, D1, P2, D2);
V = Pm2 - Pm1;
P = Pm1;

end

