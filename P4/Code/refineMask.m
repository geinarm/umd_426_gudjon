function [ mask ] = refineMask( I )

    I = im2double(I);
    imshow(I);
    M = roipoly;
   
    bb = (regionprops(M,'BoundingBox'));
    bb = bb.BoundingBox;
    XMin = floor(bb(1));
    XMax = floor(bb(1)+bb(3));
    YMin = floor(bb(2));
    YMax = floor(bb(2)+bb(4));
    
    CropI = I(YMin:YMax, XMin:XMax, :);
    CropM = M(YMin:YMax, XMin:XMax);
    [cropHeight, cropWidth] = size(CropM);
    
    Windows = getWindows(CropI, CropM, 20, 10);
    maskIn = zeros(cropHeight, cropWidth);
    maskOut = zeros(cropHeight, cropWidth);
    
    for i = 1:numel(Windows)
        w = Windows{i};
        %w.Draw();
        
        sample_ratio = sum(w.Mask(:))/numel(w.Mask);
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
    
    %{
    muIn = mean(PIn);
    muOut = mean(POut);
    SIn = cov(PIn);
    SOut = cov(POut);
    
    k_in = 2;
    k_out = 2;
    [~, KIn] = kmeans(PIn, k_in);
    [~, KOut] = kmeans(POut, k_out);
    
    Pixels = reshape(lab, numel(lab)/3, 3);
    maskIn = zeros(cropHeight, cropWidth, k_in);
    maskOut = zeros(cropHeight, cropWidth, k_out);
    for i = 1:k_in
        mask_i = gaussClassify(Pixels, SIn, KIn(i, :));
        mask_i = reshape(mask_i, size(CropM));
        maskIn(:,:, i) = mask_i;
        clear mask_i;
    end
    for i = 1:k_out
        mask_i = gaussClassify(Pixels, SOut, KOut(i, :));
        mask_i = reshape(mask_i, size(CropM));
        maskOut(:,:, i) = mask_i;
        clear mask_i;
    end    

    %maskIn = reshape(maskIn, size(CropM));
    maskIn = max(maskIn, [], 3);
    maskIn = mat2gray(maskIn);
    maskOut = max(maskOut, [], 3);
    
    %}
    
    maskIn = mat2gray(maskIn);
    maskOut = mat2gray(maskOut);
    imshow([maskIn, maskOut]);
    pause
    
    shape = double(CropM);
    shape = imgaussfilt(shape, 10);
    
    imshow(shape);
    pause
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
