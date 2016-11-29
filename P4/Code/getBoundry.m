function [ Mask ] = getBoundry( I, M )

    bb = (regionprops(uint8(M),'BoundingBox'));
    bb = bb.BoundingBox;
    XMin = floor(bb(1)) -10;
    XMax = ceil(XMin + bb(3)) +20;
    YMin = floor(bb(2)) -10;
    YMax = ceil(YMin + bb(4)) +20;
    
    Mask = zeros(size(M));
    I_trim = I(YMin:YMax, XMin:XMax, :);
    M_trim = M(YMin:YMax, XMin:XMax);
    [height, width, ~] = size(I_trim);
    
    LAB = rgb2lab(I_trim);
    Pixels = reshape(LAB, numel(LAB)/3, 3);
    N = zeros(size(Pixels,1), 1);
    for i = 1:size(Pixels,1)
        N(i) = norm(Pixels(i,:));
    end
    Norm = reshape(N, height, width);
    Norm = mat2gray(Norm);    
    
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(Norm, hy, 'replicate');
    Ix = imfilter(Norm, hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
    %imshow(gradmag,[])
    %pause
    
    se = strel('disk', 1);
    Io = imopen(Norm, se);
    %imshow(Io)
    %pause
    
    Iy = imfilter(Io, hy, 'replicate');
    Ix = imfilter(Io, hx, 'replicate');
    gradmag2 = sqrt(Ix.^2 + Iy.^2);
    
    %imshow(gradmag2,[])
    %pause
    
    mblur = imgaussfilt(double(M_trim), 5);
    B = mat2gray(gradmag+gradmag2);
    B = mblur.*B + mblur;
    B = mat2gray(B);
    Mask(YMin:YMax, XMin:XMax) = B;
    
    
    num_bins = 7;
    [Idx, ~] = kmeans(Pixels, num_bins);
    Clustered = reshape(Idx, height, width);
    %imagesc(Clustered), colormap(jet);
    %pause
    %% Generate Half-disk masks
    hd_radius = [1.5, 2.8];
    hd_deg = (180/4) .* (1:4);
    [HDl, HDr] = hdbank(hd_radius, hd_deg);
    TG = chiDist(HDl, HDr, 1:num_bins, Clustered);
    TG = max(TG, [], 3);
    %TG = mean(TG, 3);
    TG = mat2gray(TG);
    %imshow(TG);
    %pause
    
    mblur = imgaussfilt(double(M_trim), 10);
    B = mat2gray(gradmag+gradmag2);
    B = mblur.*TG + mblur;
    B = mat2gray(B);
    Mask(YMin:YMax, XMin:XMax) = B;
    

end

