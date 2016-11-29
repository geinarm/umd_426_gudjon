function [ P, D ] = getCorners( I, n )
% I should be a grayscale image
% n is maximum number of corners

% P is a 2xn matrix with x y coordinates for each corner

I = imgaussfilt(I);
C = cornermetric(I);

[c,r] = anms(C, n);
D = fdescript(I, r, c);
P = [c, r];

end

