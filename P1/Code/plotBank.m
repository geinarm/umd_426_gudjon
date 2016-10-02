function [ ] = plotBank( B, r, c )

plotIdx = 1;
for i = 1:r*c
    bi = B{i};
    % Normalize filter for display
    bi_norm = bi + abs(min(bi(:)));
    bi_norm = bi_norm ./ range(bi_norm(:));
    
    subplot(r, c, plotIdx), imshow(bi_norm);
    plotIdx = plotIdx +1;
end

end

