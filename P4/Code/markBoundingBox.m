function [ BB ] = markBoundingBox( I, M )

bb = (regionprops(uint8(M),'BoundingBox'));
bb = bb.BoundingBox;
minX = floor(bb(1));
maxX = ceil(minX + bb(3));
minY = floor(bb(2));
maxY = ceil(minY + bb(4));

bw = false(size(M));
bw(minY:maxY, minX) = true;
bw(minY:maxY, maxX) = true;
bw(minY, minX:maxX) = true;
bw(maxY, minX:maxX) = true;

se = strel('square',1);
bw = imdilate(bw ,se);

red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

red(bw) = 1;
green(bw) = 0;
blue(bw) = 0;

BB = cat(3, red, green, blue);

end

