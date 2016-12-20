function [ W_out ] = propogateWindows( I, W_in, P, V )

W_out = cell(size(W_in));

mean_v = mean(V)*5;

for i = 1:numel(W_in)
   w = W_in{i};
   pos = [floor(w.CenterX), floor(w.CenterY)];
   
   dist = P - repmat(pos, [size(P, 1), 1]);
   dist = sum(dist.^2, 2);
   
   %imshow(I); hold on;
   %w.DrawColor('blue');
   %rect = [w.XMin, w.YMin, w.XMax-w.XMin, w.YMax-w.YMin];
   %rectangle('Position', rect, 'EdgeColor', 'blue');
   
   %[d, min_dist_idx] = min(dist);
   %v = V(min_dist_idx, :);
   %p = P(min_dist_idx, :);
   v = mean_v;
   w.XMin = ceil(w.XMin + v(1));
   w.XMax = ceil(w.XMax + v(1));
   w.CenterX = ceil(w.CenterX + v(1));
   w.YMin = ceil(w.YMin + v(2));
   w.YMax = ceil(w.YMax + v(2));
   w.CenterY = ceil(w.CenterY + v(2));
   %w.Sigma = min(10, max(sqrt(d)*0.1, 0.5));
   w.Sigma = 3;
   
   
   %plot(p(1), p(2), '+');
   %w.DrawColor('red');
   %rect = [w.XMin, w.YMin, w.XMax-w.XMin, w.YMax-w.YMin];
   %rectangle('Position', rect, 'EdgeColor', 'red');
   %pause
   
   W_out{i} = w;
end

%hold off;

end

