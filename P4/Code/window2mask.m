function [ M, S ] = window2mask( I, S, W )

    [height, width] = size(S);
    maskIn = zeros(height, width);
    maskOut = zeros(height, width);
    maskShape = zeros(height, width);
    LAB = rgb2lab(I);
    
    for i = 1:numel(W)
        w = W{i};
        
        w.RGB = I(w.YMin:w.YMax, w.XMin:w.XMax, :);
        w.Mask = S(w.YMin:w.YMax, w.XMin:w.XMax);
        w.LAB = LAB(w.YMin:w.YMax, w.XMin:w.XMax, :);
        
        num_fg = sum(w.Mask(:));
        num_bg = sum(~w.Mask(:));
        sample_ratio = num_fg/(num_bg+num_fg);
        maskIn_curr = maskIn(w.YMin:w.YMax, w.XMin:w.XMax);
        maskOut_curr = maskOut(w.YMin:w.YMax, w.XMin:w.XMax);
        
        if sample_ratio > 0.9 %Mostly FG
           %maskIn(w.YMin:w.YMax, w.XMin:w.XMax) = ones(w.Rect(4), w.Rect(3));
           %shape = zeros(height, width);
           %shape(w.YMin:w.YMax, w.XMin:w.XMax) = w.Mask;
           %maskShape = maskShape + shape;
           continue;
        end
        if sample_ratio < 0.1 %Mostly BG
           %maskIn(w.YMin:w.YMax, w.XMin:w.XMax) = max(maskIn_curr, w.Mask*0.1);
           %shape = zeros(height, width);
           %shape(w.YMin:w.YMax, w.XMin:w.XMax) = w.Mask;
           %maskShape = maskShape + shape;
           continue;
        end        
        
        [pfg, pbg] = windowMask(w);
        
        %imshow([rgb2gray(w.RGB), w.Mask, pfg]);
        %pause
        
        shape = zeros(height, width);
        shape(w.YMin:w.YMax, w.XMin:w.XMax) = w.Mask;
        shape = imgaussfilt(shape, w.Sigma);
        maskShape = maskShape + shape;
        
        maskIn(w.YMin:w.YMax, w.XMin:w.XMax) = max(pfg, maskIn_curr);
        maskOut(w.YMin:w.YMax, w.XMin:w.XMax) = max(pbg, maskOut_curr);
    end
    
    maskIn = mat2gray(maskIn);
    %maskOut = mat2gray(maskOut);
    S = mat2gray(maskShape);
    M = maskIn .* (1-maskOut);
    
    %imshow([maskIn, S, M]);
    %pause

end

%% Generate FG and BG propability mask for a given window
function [ pfg, pbg ] = windowMask( W )
    muIn = W.FG_Centroid; % mean(W.FG);
    muOut = W.BG_Centroid; % mean(W.BG);
    
    %Classify FG / BG
    Pixels = reshape(W.LAB, numel(W.LAB)/3, 3);
    class = clusterLocalEncoding([muIn;muOut], Pixels);

    %maskIn_i = gaussClassify(Pixels, SIn, muIn);
    pfg = class(:, 1);
    pfg = reshape(pfg, W.Rect(4), W.Rect(3));

    %maskOut_i = gaussClassify(Pixels, SOut, muOut);
    pbg = class(:, 2);
    pbg = reshape(pbg, W.Rect(4), W.Rect(3));
end
