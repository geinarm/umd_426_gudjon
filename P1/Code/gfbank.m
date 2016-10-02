function GFBank = gfbank(sigmas, rads)
%Returns a gaussian filter bank with s scales and o orientations

num_s = numel(sigmas);
num_r = numel(rads);
GFBank = cell(num_s, num_r);

Sx = [-1 0 1 ; -2 0 2 ; -1 0 1];
Sy = [1 2 1 ; 0 0 0 ; -1 -2 -1];

for s = 1:num_s
    sigma = sigmas(s);
    k = ceil(sigma*3);
    [x, y] = meshgrid(-k:k, -k:k);

    G = exp(-((x.^2)+(y.^2))/(2 * sigma^2));
    Gx = imfilter(G, Sx);
    Gy = imfilter(G, Sy);
    %Gx = x .* exp(-((x.^2)+(y.^2))/(2 * sigma^2)) / sigma^2;
    %Gy = y .* exp(-((x.^2)+(y.^2))/(2 * sigma^2)) / sigma^2;    
    
    for r = 1:num_r
        theta = rads(r);
        Gtheta = cos(theta)*Gx + sin(theta)*Gy;
        GFBank{s, r} = Gtheta;
    end
end

end

