function [ P, D ] = getFeatures( I, n )
% I should be a grayscale image
% n is maximum number of corners

% P is a 2xn matrix with x y coordinates for each corner

I = imgaussfilt(I);
C = cornermetric(I);
M = imregionalmax(C);
[r, c] = find(M);

idx = sub2ind(size(I), r, c);
fVal = C(idx);
[~, sortIdx] = sort(fVal, 1, 'descend');

%Order and pick n best
P = [c, r];
P = P(sortIdx(1:min(n,numel(c))), :);
D = fdescript(I, P(:,2), P(:,1));


end

