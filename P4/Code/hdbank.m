function [L, R] = hdbank(rs, degs)

num_r = numel(rs);
num_d = numel(degs);

L = cell(num_r, num_d);
R = cell(num_r, num_d);

for r = 1:num_r
    radius = rs(r);
    k = ceil(radius);
    [x, y] = meshgrid(-k:k, -k:k);
    D = (x.^2+y.^2) < radius^2;
    %D(y>0) = 0;
    D(ceil(radius)+1:end, :) = 0;
        
    for d = 1:num_d
        deg = degs(d);
        Dl = imrotate(D, deg, 'nearest', 'crop');
        Dr = imrotate(D, deg+180, 'nearest', 'crop');

        L{r, d} = Dl;
        R{r, d} = Dr;
    end
end