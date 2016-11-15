function [ D ] = fdescript( I, r, c )
    %I is the image
    %r and c is the row/column coord of the points
    %Returns D where each row is a descrition of the point at the corisponding
    %index in r/c

    window_size = 10;

    n = numel(r);

    D = zeros(n, 25);
    I_pad = padarray(I, [window_size/2, window_size/2], 'replicate');

    for i = 1:n
        rows = r(i):(r(i)+window_size);
        cols = c(i):(c(i)+window_size);
        
        %rows
        %cols
        %size(I_pad)
        W = I_pad(rows, cols);
        
        W = imgaussfilt(W, 4); % Blur window
        d = W(1:2:window_size, 1:2:window_size);
        d = (d-mean(d(:))) ./ std(d(:));

        D(i, :) = d(:);
    end

end

