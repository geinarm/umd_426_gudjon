function GFBank = gfbank( s, o )
%Returns a gaussian filter bank with s scales and o orientations

numS = size(s, 2);
GFBank = cell(numS, o);

for si = 1:numS
    for oi = 0:o-1
        k = s(si);
        sigma = k/3;
        [x, y] = meshgrid(-k:1:k, -k:1:k);

        %G = exp(-((x.^2)+(y.^2))/(2 * sigma^2));
        Gx = x .* exp(-((x.^2)+(y.^2))/(2 * sigma^2)) / sigma^2;
        Gy = y .* exp(-((x.^2)+(y.^2))/(2 * sigma^2)) / sigma^2;

        theta = 2*pi/o * oi;
        Gtheta = cos(theta)*Gx + sin(theta)*Gy;
        GFBank{si, oi+1} = Gtheta + 0.5;
    end
end

end

