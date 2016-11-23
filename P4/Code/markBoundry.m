function [ IB ] = markBoundry( I, M )

B = bwperim(M);
se = strel('disk',1);
B = imdilate(B ,se);

red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

red(B) = 0;
green(B) = 1;
blue(B) = 0;

IB = cat(3, red, green, blue);

end

