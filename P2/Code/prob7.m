I = im2double(imread('../Images/Set1/1.jpg'));
%G = rgb2gray(I);

f = 300;

[height, width, ~] = size(I);
xc = width/2;
yc = height/2;
[x, y] = meshgrid(1:width, 1:height);

dx = (x-xc)/f;
dy = (y-yc)./cos(dx);

xprime = f*tan(dx)+xc;
yprime = dy+yc;
C = zeros(size(I));

for r = 1:height
   for c = 1:width
       rp = floor(yprime(r, c));
       cp = floor(xprime(r, c));
       
       %Ignore out of bounds coordinates
       if(rp < 1 || rp > height) continue; end
       if(cp < 1 || cp > width) continue; end         
       
       C(r, c, :) = I(rp, cp, :);
   end
end

imshow(C);