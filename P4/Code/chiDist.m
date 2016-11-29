function [ D ] = chiDist(Ml, Mr, Bins, I)

[height, width] = size(I);
D = zeros(height, width, numel(Ml));
eps = 1 * 10^-8;

for j = 1:numel(Ml)
    Kl = double(Ml{j}); %left mask kernel
    Kr = double(Mr{j}); %right mask kernel
    Dj=zeros(height, width);
    for b = Bins %for each bin value
        Bi = double(I == b);  %mask for values in bin b
        G = imfilter(Bi, Kl);
        H = imfilter(Bi, Kr);
        chi_sqr = (G-H).^2 ./ (G+H+eps);
        Dj = Dj + 0.5*chi_sqr;
    end
    D(:,:, j) = Dj;
end

end

