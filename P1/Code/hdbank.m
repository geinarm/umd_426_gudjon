function [L, R] = hdbank(k, s, o)

Nscale = size(s, 2);
L = cell(Nscale, o);
R = cell(Nscale, o);

for si = 1:Nscale
    for oi = 0:o-1
        [x, y] = meshgrid(-k:k, -k:k);
        D = (x.^2+y.^2) < s(si)^2;
        D(y>0) = 0;
        
        deg = 360/o * oi;
        Dl = imrotate(D, deg, 'nearest', 'crop');
        Dr = imrotate(D, deg+180, 'nearest', 'crop');

        L{si, oi+1} = Dl;
        R{si, oi+1} = Dr;
    end
end