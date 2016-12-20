function [ W ] = getWindows( I, M, ws, ol )
%Generates a group of overlapping windows
%and a BG/FG color classifier for each window based on the mask M

bb = regionprops(uint8(M),'BoundingBox');
bb = bb.BoundingBox;
[height, width, ~] = size(I);

bb(1) = bb(1) -10;
bb(2) = bb(2) -10;
bb(3) = bb(3) +20;
bb(4) = bb(4) +20;

wx = ceil(bb(3)/ws);
wy = ceil(bb(4)/ws);
W = cell(wy, wx);

for x = 1:wx
   for y = 1:wy
        w = struct;
        
        %Define rect
        px = ((x-1) * ws) +floor(bb(1));
        py = ((y-1) * ws) +floor(bb(2));
        w.XMin = max(1, px-ol);
        w.XMax = min(px+ws+ol-1, width);
        w.YMin = max(1, py-ol);
        w.YMax = min(py+ws+ol-1, height);
        w.Rect = [w.XMin, w.YMin, w.XMax-w.XMin+1, w.YMax-w.YMin+1];
        w.CenterX = (w.XMin+w.XMax)/2;
        w.CenterY = (w.YMin+w.YMax)/2;
        
        w.RGB = I(w.YMin:w.YMax, w.XMin:w.XMax, :);
        w.Mask = M(w.YMin:w.YMax, w.XMin:w.XMax);
        w.Sigma = 1;
        
        %Get FG/BG pixels
        w.LAB = rgb2lab(w.RGB);
        c1 = w.LAB(:, :, 1);
        c2 = w.LAB(:, :, 2);
        c3 = w.LAB(:, :, 3);

        FG = [c1(w.Mask), c2(w.Mask), c3(w.Mask)];
        BG = [c1(~w.Mask), c2(~w.Mask), c3(~w.Mask)];
        
        num_fg = size(FG, 1);
        num_bg = size(BG, 1);
        sample_ratio = num_fg/(num_bg+num_fg);
        if sample_ratio > 0.9 || sample_ratio < 0.1
           W{y, x} = [];
           continue; 
        end
        
        w.FG_Centroid = mean(FG);
        w.BG_Centroid = mean(BG);
        
        W{y, x} = w;
   end
end

W = W(~cellfun('isempty',W));

end

