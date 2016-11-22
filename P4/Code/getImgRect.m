function [ x, y, T ] = getImgRect( I )
    imshow(I); hold on;
    [X,Y] = ginput(2);
    hold off;

    minX = floor(min(X));
    maxX = floor(max(X));
    minY = floor(min(Y));
    maxY = floor(max(Y));
    
    T = I(minY:maxY, minX:maxX);
    x = minX;
    y = minY;
end

