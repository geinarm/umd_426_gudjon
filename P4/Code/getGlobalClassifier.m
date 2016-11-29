function [ G_fg, G_bg ] = getGlobalClassifier( I, M )

bb = (regionprops(uint8(M),'BoundingBox'));
bb = bb.BoundingBox;
XMin = floor(bb(1));
XMax = ceil(XMin + bb(3));
YMin = floor(bb(2));
YMax = ceil(YMin + bb(4));

Mask = M(YMin:YMax, XMin:XMax);
RGB = I(YMin:YMax, XMin:XMax, :);
LAB = rgb2lab(RGB);
c1 = LAB(:, :, 1);
c2 = LAB(:, :, 2);
c3 = LAB(:, :, 3);

FG = [c1(Mask), c2(Mask), c3(Mask)];
BG = [c1(~Mask), c2(~Mask), c3(~Mask)];

[~, FG_C] = kmeans(FG, 3);
[~, BG_C] = kmeans(BG, 3);

G_fg = FG_C;
G_bg = BG_C;

end

