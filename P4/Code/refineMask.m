function [ mask ] = refineMask( I, M )
 
    [height, width] = size(M);

    Windows = getWindows(I, M, 20, 10);
    maskIn = zeros(height, width);
    maskOut = zeros(height, width);
    
    for i = 1:numel(Windows)
        w = Windows{i};
        %w.Draw();
        
        %ratio of FG pixels to total pixels
        num_fg = sum(w.Mask(:));
        num_bg = sum(~w.Mask(:));
        sample_ratio = num_fg/(num_bg+num_fg);
        %imshow([rgb2gray(w.RGB), w.Mask]);
        %pause
        
        if(numel(w.FG) == 0)
            continue;
        end
        if(numel(w.BG) == 0)
           maskIn(w.YMin:w.YMax, w.XMin:w.XMax) = ones(w.Rect(4), w.Rect(3))*max(maskIn(:));
           continue;
        end
        if sample_ratio > 0.9 || sample_ratio < 0.1
           continue;
        end
        
        [pfg, pbg] = windowMask(w);
        maskIn_curr = maskIn(w.YMin:w.YMax, w.XMin:w.XMax);
        maskIn(w.YMin:w.YMax, w.XMin:w.XMax) = max(pfg, maskIn_curr);
        
        maskOut_curr = maskOut(w.YMin:w.YMax, w.XMin:w.XMax);
        maskOut(w.YMin:w.YMax, w.XMin:w.XMax) = max(pbg, maskOut_curr);
    end
    
    maskIn = mat2gray(maskIn);
    maskOut = mat2gray(maskOut);
    imshow([maskIn, maskOut]);
    pause
    
    shape = double(M);
    shape = imgaussfilt(shape, 10);

    mask = maskIn .* (1-maskOut) .* shape;
    imshow(mask);
end

%% Generate FG and BG propability mask for a given window
function [ pfg, pbg ] = windowMask( W )
    muIn = mean(W.FG);
    muOut = mean(W.BG);
    %SIn = cov(w.FG);
    %SOut = cov(w.BG);

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
