function [ W ] = getWindows( I, M, ws, ol )
%Generates a group of overlapping windows
%and a BG/FG color classifier for each window based on the mask M

bb = regionprops(uint8(M),'BoundingBox');
bb = bb.BoundingBox;
[height, width, ~] = size(I);

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
        
        w.RGB = I(w.YMin:w.YMax, w.XMin:w.XMax, :);
        w.Mask = M(w.YMin:w.YMax, w.XMin:w.XMax);
        
        %Get FG/BG pixels
        w.LAB = rgb2lab(w.RGB);
        c1 = w.LAB(:, :, 1);
        c2 = w.LAB(:, :, 2);
        c3 = w.LAB(:, :, 3);

        FG = [c1(w.Mask), c2(w.Mask), c3(w.Mask)];
        BG = [c1(~w.Mask), c2(~w.Mask), c3(~w.Mask)];
        w.FG_Centroid = mean(FG);
        w.BG_Centroid = mean(BG);
        
        w.Draw = @(c) rectangle('Position', w.Rect, 'EdgeColor', c);
        w.Draw = @() rectangle('Position', w.Rect, 'EdgeColor', 'blue');
        
        W{y, x} = w;
   end
end

end

