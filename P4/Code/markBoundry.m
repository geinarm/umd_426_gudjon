function [ IB ] = markBoundry( I, M, color )

if nargin == 2
    color = [0,1,0];
end

B = bwperim(M);
%se = strel('disk',1);
%B = imdilate(B ,se);

red = I(:,:,1);
green = I(:,:,2);
blue = I(:,:,3);

red(B) = color(1);
green(B) = color(2);
blue(B) = color(3);

IB = cat(3, red, green, blue);

end

