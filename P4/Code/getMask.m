function [ M, P ] = getMask( I )

    %{
    imshow(I); hold on;
    [X,Y] = ginput(2);
    hold off;

    minX = floor(min(X));
    maxX = floor(max(X));
    minY = floor(min(Y));
    maxY = floor(max(Y));
    
    T = I(minY:maxY, minX:maxX);
    P = [minX, minY];
    %}
    imshow(I); hold on;
    M = roipoly;
    P = [0,0];
    hold off;

end

