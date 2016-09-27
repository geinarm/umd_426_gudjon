function HDBank = hdbank(s, o)


numS = size(s, 2);
HDBank = cell(numS, o);

for si = 1:numS
    for oi = 0:o-1
        k = s(si);
        [x, y] = meshgrid(-k:k, -k:k);
        y(y>=0) = inf;

        D = x.^2+y.^2;

        deg = 360/o * oi;
        D = imrotate(D, deg, 'nearest', 'crop');

        HDBank{si, oi+1} = (D <= k^2+1);
    end
end