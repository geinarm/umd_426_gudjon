function [ W ] = getWindows( I, M, ws, ol )

[height, width, ~] = size(I);

wx = ceil(width/ws);
wy = ceil(height/ws);
W = cell(wy, wx);

for x = 1:wx
   for y = 1:wy
        w = struct;
        
        %Define rect
        px = ((x-1) * ws) +1;
        py = ((y-1) * ws) +1;
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

        w.FG = [c1(w.Mask), c2(w.Mask), c3(w.Mask)];
        w.BG = [c1(~w.Mask), c2(~w.Mask), c3(~w.Mask)];
        
        w.Draw = @(c) rectangle('Position', w.Rect, 'EdgeColor', c);
        w.Draw = @() rectangle('Position', w.Rect, 'EdgeColor', 'blue');
        
        W{y, x} = w;
   end
end

end

